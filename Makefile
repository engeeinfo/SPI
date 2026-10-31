.PHONY: build lint test

IVERILOG ?= iverilog
VVP ?= vvp
BUILD_DIR := build
SIM := $(BUILD_DIR)/spi
SOURCES := APB_Slave.v clkdiv.v spi_control.v spi_master.v spi_top.v spi_top_tb.v

build:
	@mkdir -p $(BUILD_DIR)
	$(IVERILOG) -g2012 -Wall -s spi_top_tb -o $(SIM) $(SOURCES)

lint: build
	@echo "Icarus warning check completed during build."

test: build
	$(VVP) $(SIM)
