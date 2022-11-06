`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:01:39 08/12/2022 
// Design Name: 
// Module Name:    APB_Slave 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module APB_Slave #(parameter data=32,address=3)(
   input PRESETn,
	input PCLK,
	input PENABLE,
	input PSEL,
	input [address-1:0] PADDR,
	input PWRITE,
	input [data-1:0] PWDATA,
	input [data-1:0] reg_rdata,
	input SPISWAI,
	input SPTIE,

	output reg SPE,
	output reg  [address-1:0] reg_addr,
	output reg  [data-1:0] reg_wdata,
	output reg [data-1:0] PRDATA=0,
	output reg MSTR,
	output reg p_ready=0,
output reg ctrl_control
 );   
parameter idle=2'b00,setup=2'b01,write_fifo=2'b10,read_fifo=2'b11;
reg[1:0] next_state,current_state;
always@(posedge PCLK,negedge PRESETn)
begin
if(!PRESETn)
begin
current_state<=idle;
end
else
begin
current_state<=next_state;
end
end


always@(posedge PCLK)begin

case(current_state)

idle:
begin
if(PSEL)
begin
SPE=1'b1;
next_state<=setup;
end
else
begin
next_state<=idle;
end
end

setup:
begin
p_ready = 1'b0;
reg_addr = PADDR;
if(PSEL == 1'b1 && PENABLE ==1'b0)
if(PWRITE == 1'b1)
begin
next_state<=write_fifo;
end
else
begin
next_state<=read_fifo;
end
else if(PSEL==0)
begin
SPE=1'b0;
next_state <= idle;
end
end

read_fifo:
begin
if(PSEL == 1'b1 && PWRITE==1'b0 && PENABLE == 1'b1)
begin
MSTR = 1'b0;
ctrl_control=1'b0;
PRDATA = reg_rdata;
end
if(SPISWAI==1) begin 
p_ready = 1'b1;
ctrl_control=1'b1;
next_state <= setup;
end
else if(PSEL==0)
begin
SPE=1'b0;
next_state <= idle;
end
end

write_fifo:
begin
if(PSEL == 1'b1 && PWRITE==1'b1 && PENABLE == 1'b1)
begin
MSTR = 1'b1;
ctrl_control=1'b1;
if(SPTIE==1'b1)begin
reg_wdata = PWDATA;end
end
if(SPISWAI==1)begin
p_ready = 1'b1;
ctrl_control=1'b0;
next_state <= setup;
end
else if(PSEL==1'b0)
begin
SPE=1'b0;
next_state <= idle;
end
end

default:
begin
 next_state<=idle;
end

endcase
end

endmodule
