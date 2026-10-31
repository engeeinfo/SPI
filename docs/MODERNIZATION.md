# Modernization record

## Baseline

Baseline captured on 2026-10-31 from `main`.

| Area | Result | Notes |
| --- | --- | --- |
| Stack | Verilog | SPI integration and module-level sources. |
| Build | Failed | `APB_Slave.v` was an incompatible ROM while `spi_top.v` expected an APB slave; the testbench duplicated `spi_top`. |
| Tests | Missing | No actual testbench stimulus or assertions existed. |
| Lint | Missing | No HDL quality gate existed. |
| License | Missing | Added MIT license. |
| CI | Missing | Added simulation workflow. |

## Audit findings

1. **Critical — integration blocker:** APB slave module ports did not match
   the top-level integration contract.
2. **High — invalid testbench:** `spi_top_tb.v` declared a second `spi_top`
   module instead of a testbench.
3. **Medium — implicit signal:** `spe` was connected without a declaration in
   `spi_top.v`.
4. **Medium — weak verification:** no reset or transfer assertions existed.

No secrets or dependency vulnerabilities were found.

## Changes

- Implemented the APB register bridge expected by `spi_top` and
  `SPI_Controller`.
- Replaced the duplicate module with a self-checking reset smoke test.
- Declared the missing `spe` wire.
- Added documentation, Makefile, CI, license, and ignore rules.

The APB bridge is a required integration fix; its register semantics are
documented in code and should receive loopback/CPOL/CPHA regressions next.
