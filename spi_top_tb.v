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
// Additional Comments:
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
	reg [31:0] PWDATA;
	reg miso;

	// Outputs
	
	wire PREADY;
	wire [31:0] PRDATA;
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
PADDR = 3'b100;
PWDATA =32'b10101010101010101111101011101011;
PSEL=1;
PENABLE = 0;
PWRITE = 1;
#6
PSEL=1;
PENABLE = 1;
PWRITE = 1;
#172
PSEL=1;
PENABLE = 0;
PWRITE = 0;
#4
PSEL=1;
PENABLE = 1;
PWRITE = 0;
#22
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1; 
#4
miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#4miso=1'b0; 
#4miso=1'b1; 
#10
PADDR = 8'b010;
PWDATA =32'hf0f0f0f0;
PSEL=1;
PENABLE = 0;
PWRITE = 1;
#6
PSEL=1;
PENABLE = 1;
PWRITE = 1;
#158
PSEL=1;
PENABLE = 0;
PWRITE = 0;
#6
PSEL=1;
PENABLE = 1;
PWRITE = 0;
#20
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#4
miso=1'b0;
#4
miso=1'b1;
#10
PSEL=0;
PENABLE = 0;
PWRITE = 0;
#100
$finish;
	
end 
    
endmodule

