`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:00:28 09/06/2022
// Design Name:   spi_top
// Module Name:   C:/Users/Computer/Desktop/IRP/Controllermaster/spi_top_tb.v
// Project Name:  Controllermaster
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additi onal Comments:
// 
///////////////////////////////////////////////////////////////////////////////

module spi_top_tb;

	// Inputs
	reg PRESETn;
	reg PCLK;
	reg PENABLE;
	reg PSEL;
	reg [2:0] PADDR;
	reg PWRITE;
	reg [7:0] PWDATA;
	reg miso;

	// Outputs
	
	wire PREADY;
	wire [7:0] PRDATA;
	wire ss0;
	wire ss1;
	wire sclk;
	wire mosi;

	// Instantiate the Unit Under Test (UUT)
	spi_top uut (
		.PRESETn(PRESETn), 
		.PCLK(PCLK), 
		.PENABLE(PENABLE), 
		.PSEL(PSEL), 
		.PADDR(PADDR), 
		.PWRITE(PWRITE), 
		.PWDATA(PWDATA),  
		.miso(miso),  
		.PREADY(PREADY), 
		.PRDATA(PRDATA), 
		.ss0(ss0), 
		.ss1(ss1), 
		.sclk(sclk), 
		.mosi(mosi)
	);

initial
begin
PCLK=1;
forever #1 PCLK=~PCLK;
end
integer i;
integer val=100;
initial 
begin
PRESETn=0;
PADDR = 0;
PWDATA =0;
PSEL=0;
PENABLE = 0;
PWRITE = 0;
miso=0;
#4
PRESETn=1;
#2
for(i=0;i<=val;i=i+1) begin
PADDR = i;
PWDATA =i+100;
miso=i;
#2
PSEL=1;
PENABLE = 0;
PWRITE = 1;
#6
PSEL=1;
PENABLE = 1;
PWRITE = 1;

#78
$finish;
	end
end 
    
endmodule

