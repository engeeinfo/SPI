# SPI Real-World Protocol Interface

# SPI Master Interface

This project implements a Verilog SPI master with a small APB register bridge,
programmable clock division, and full-duplex MOSI/MISO signals.

It consists of the following modules:

- `spi_top`: Top-level module integrating APB Slave, SPI Controller, SPI Master, and Clock Divider.
- `spi_master`: Handles full-duplex SPI data transmission.
- `SPI_Controller`: Controls the SPI state machine for master/slave coordination.
- `APB_Slave`: Connects SPI with APB protocol interface.
- `clkdiv`: Divides peripheral clock to match baud rate requirements.
- `spi_rom`: Sample ROM for slave-side testing.

---

## 🧩 Block Diagram

```
 +-----------------+       +----------------+       +---------------+
 |   APB_Slave     | <---> | SPI_Controller | <---> |   spi_master  |
 |-----------------|       |----------------|       |---------------|
 |  APB Interface  |       |  SPI Logic     |       | SPI Signals   |
 +--------+--------+       +--------+-------+       +-------+-------+
          |                         |                       |
          |                         |                       |
          V                         V                       V
     [PADDR, PWDATA]         [Control Logic]        [MOSI, SCLK, SSx]
                              ^                \
                              |                 +--> ROM / Real Device
                         [Baud Clock]
                              ^
                              |
                        +-----+-----+
                        |   clkdiv  |
                        +-----------+
```

---

## ⚙️ Features

- ✅ Fully synthesizable SPI Master with programmable clock divider
- ✅ Supports **CPOL** and **CPHA** configuration
- ✅ Works with **APB-compliant systems** for configuration
- ✅ Full **duplex transmission** using MOSI and MISO
- ✅ Modular and extensible design for any SPI slave
- ✅ Simulates both master-side and test ROM as slave

---

## 🌀 CPOL / CPHA Modes Explained

SPI supports 4 clocking modes based on CPOL and CPHA:

| Mode | CPOL | CPHA | Description                       |
| ---- | ---- | ---- | --------------------------------- |
| 0    | 0    | 0    | Idle low, sample on rising edge   |
| 1    | 0    | 1    | Idle low, sample on falling edge  |
| 2    | 1    | 0    | Idle high, sample on falling edge |
| 3    | 1    | 1    | Idle high, sample on rising edge  |

Mode selection is configurable via `m_addr[1:0]` bits from APB.

---

## 🎬 Simulation Animation (Conceptual)

```
[APB WRITE] ---> [SPI Controller FSM] ---> [MOSI] ---> [Slave]
                                  ^             |
                                  |             v
                            [READ MISO] <-------+
```

### Example: Master sends `0xA5`, receives `0x5A`

```
MOSI: 10100101  ->
MISO: <- 01011010
```

---

## 🔍 Output Example

```
MOSI: 0xA5
MISO: 0x5A
PRDATA: 0x5A (captured by APB)
```

---

## 📁 Directory Structure

```
/spi_top.v
/spi_master.v
/SPI_Controller.v
/APB_Slave.v
/clkdiv.v
/spi_rom.v
/readme.md  <-- you are here
```

---

## Verification

```sh
make test
```

The current self-checking smoke test validates reset and top-level signal
elaboration. Loopback, CPOL/CPHA, and baud-rate coverage remain follow-up
tests.

## Structure

- `spi_top.v` integrates the APB bridge, controller, master, and clock divider.
- `APB_Slave.v` maps APB transactions to SPI control/data registers.
- `spi_control.v` sequences controller state.
- `spi_master.v` shifts SPI data.
- `clkdiv.v` generates the SPI clock.
- `spi_top_tb.v` is the top-level simulation testbench.
- `docs/ARCHITECTURE.md` and `docs/MODERNIZATION.md` document design and audit.

## 🎥 SPI Protocol Demo Videos

<table>
  <tr>
    <td><b>🔰 Introduction</b></td>
    <td><b>📖 Read Operation</b></td>
    <td><b>✍️ Write Operation</b></td>
  </tr>
  <tr>
    <td>
      <a href="https://1drv.ms/v/s!An_wDAIxFSnErC-NKmMsYHEP8d7s" target="_blank">
        <img src="https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg" width="220px" alt="Intro Video" />
      </a>
    </td>
    <td>
      <a href="https://1drv.ms/v/s!An_wDAIxFSnErC6mHV7AN0Iom1q0" target="_blank">
        <img src="https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg" width="220px" alt="Read Video" />
      </a>
    </td>
    <td>
      <a href="https://1drv.ms/v/s!An_wDAIxFSnErDDa2JN0CMva-oFM" target="_blank">
        <img src="https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg" width="220px" alt="Write Video" />
      </a>
    </td>
  </tr>
</table>
