`timescale 1ns / 1ps
module spi_top #(parameter data=8,address=3)(
 input wire PRESETn,
	input wire PCLK,
	input wire PENABLE,
	input wire PSEL,
	input wire [address-1:0] PADDR,
	input wire PWRITE,
	input wire [data-1:0] PWDATA,
	input wire miso,
	

	output wire PREADY,
	output wire [data-1:0] PRDATA,
	output wire ss0,
	output wire ss1,
	output wire sclk,
	output wire mosi
);
wire spe,master_wr_rd,reg_write,TXC,SPISWAI;
wire[data-1:0] m_wdata,m_rdata,reg_wdata,reg_rdata;
wire [address-1:0] reg_addr,m_addr;
clkdiv clkdivider(.clock(PCLK),.reset(PRESETn),.clk(clk));
APB_Slave apbslave(
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
		//extra io
		.SPISWAI(SPISWAI),
		.SPTIE(SPTIE)
		
	);
	
SPI_Controller spicontroller(
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
		//extraio
		.SPISWAI(SPISWAI),
		.TXC(TXC),
		.SPTEF(SPTEF),
		.SPTIE(SPTIE)
	); 

spi_master spimaster(
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
//extra io
.TXC(TXC),
.SPTEF(SPTEF)
);

endmodule

