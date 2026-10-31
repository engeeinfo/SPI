# SPI Real-World Protocol Interface

## Project Overview

This project implements a **Verilog-based SPI Master Interface** designed to work in real-world embedded systems with baud rate configuration, CPOL/CPHA control, and APB compatibility.

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

## Simulation Flow (Conceptual)

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

## 🧪 Test Ideas

- [ ] Loopback testing by connecting MOSI to MISO
- [ ] ROM response testing with known byte patterns
- [ ] Baud rate sweep simulation

## Simulation

The repository includes `spi_top_tb.v`. Run it with the simulator used by your
target flow; Icarus Verilog can be used for a quick smoke test:

```bash
iverilog -o spi_top_tb spi_top.v spi_master.v spi_control.v APB_Slave.v clkdiv.v spi_top_tb.v
vvp spi_top_tb
```

If your checkout uses a different controller filename, include the matching
controller source listed by `ls *.v`.
