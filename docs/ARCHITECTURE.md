# Architecture

```text
APB host
   ↓
APB_Slave
   ↓
SPI_Controller ──> spi_master
                       ↑
                    clkdiv
```

`APB_Slave` owns APB timing and the control/data register boundary.
`SPI_Controller` sequences transfers. `spi_master` owns serial shifting and
chip-select outputs. `clkdiv` generates the transfer clock from `PCLK`.

Board wrappers should connect the APB and SPI pins without changing these
protocol boundaries.
