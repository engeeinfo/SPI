`timescale 1ns / 1ps
module spi_top #(parameter data=8, address=3)(
    input wire PRESETn,               // Active Low RESET
    input wire PCLK,                  // Peripheral Clock
    input wire PENABLE,               // Data Transmission ENABLE 
    input wire PSEL,                  // Select SPI 
    input wire [address-1:0] PADDR,  // Configuration Bits
    input wire PWRITE,               // Enable Read/Write Operation
    input wire [data-1:0] PWDATA,    // Data Input, APB Slave To SPI MOSI
    input wire miso,                 // Data Input, SPI Master To APB Slave

    output wire PREADY,              // APB Slave Output 
    output wire [data-1:0] PRDATA,   // APB Slave Output, From SPI MISO
    output wire ss0,                 // Slave 0
    output wire ss1,                 // Slave 1
    output wire sclk,                // Slave CLK
    output wire mosi                 // Output Of SPI Master
);

    // Internal wires
    wire clk;
    wire SPE, MSTR, ctrl_control, master_control;
    wire master_wr_rd, TXC, SPTEF, SPTIE, SPISWAI;
    wire [data-1:0] reg_wdata, reg_rdata, m_wdata, m_rdata;
    wire [address-1:0] reg_addr, m_addr;
    
    // Clock divider for baud rate generation
    clkdiv #(.DIV(4)) clkdivider (
        .clock(PCLK),
        .reset(PRESETn),
        .clk(clk)
    );

    // APB Slave Module (external definition required)
    APB_Slave apbslave (
        .PRESETn(PRESETn),
        .PCLK(PCLK),
        .PENABLE(PENABLE),
        .PSEL(PSEL),
        .PADDR(PADDR),
        .PWRITE(PWRITE),
        .PWDATA(PWDATA),
        .SPE(SPE),
        .reg_addr(reg_addr),
        .reg_wdata(reg_wdata),
        .PRDATA(PRDATA),
        .MSTR(MSTR),
        .p_ready(PREADY),
        .reg_rdata(reg_rdata),
        .SPISWAI(SPISWAI),
        .SPTIE(SPTIE),
        .ctrl_control(ctrl_control)
    );

    // SPI Controller
    SPI_Controller #(.data(data), .address(address)) spicontroller (
        .PRESETn(PRESETn),
        .CLK(clk),
        .reg_addr(reg_addr),
        .reg_wdata(reg_wdata),
        .MSTR(MSTR),
        .SPE(SPE),
        .m_rdata(m_rdata),
        .reg_rdata(reg_rdata),
        .master_wr_rd(master_wr_rd),
        .spe(spe),
        .m_addr(m_addr),
        .m_wdata(m_wdata),
        .SPISWAI(SPISWAI),
        .TXC(TXC),
        .SPTEF(SPTEF),
        .SPTIE(SPTIE),
        .master_control(master_control),
        .ctrl_control(ctrl_control)
    );

    // SPI Master
    spi_master #(.data(data)) spimaster (
        .m_wr_rdbar(master_wr_rd),
        .spe(spe),
        .clk(clk),
        .presetn(PRESETn),
        .m_wdata(m_wdata),
        .m_addr(m_addr),
        .m_rdata(m_rdata),
        .ss0(ss0),
        .ss1(ss1),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .TXC(TXC),
        .SPTEF(SPTEF),
        .master_control(master_control)
    );

endmodule
