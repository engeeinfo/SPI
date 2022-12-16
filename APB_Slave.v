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
module APB_Slave #(parameter data=8,address=3)(
   input PRESETn,// Active Low RESET
	input PCLK,//Peripheral Clock
	input PENABLE,//Data Transmission ENABLE
	input PSEL,//Select Spi 
	input [address-1:0] PADDR,//Configuration Bits
	input PWRITE,//Enable Read Write Operation
	input [data-1:0] PWDATA,//Data Input,Apb Slave To Spi Mosi
	input [data-1:0] reg_rdata,//Data Input,Spi Master To Apb Slave
	input SPISWAI,//Wait State Reg
	input SPTIE,//Buffer Empty Reg

	output reg SPE,//Spi Module Enable Reg
	output reg  [address-1:0] reg_addr,//Configuration Bits Output
	output reg  [data-1:0] reg_wdata,//Data Output
	output reg [data-1:0] PRDATA=0,//Apb Slave Output,From Spi Miso
	output reg MSTR,//Master Or Slave Mode Reg
	output reg p_ready=0,//Apb Slave Output
output reg ctrl_control 
 );   
//Parameter For State Transaction
parameter idle=2'b00,setup=2'b01,write_fifo=2'b10,complet=2'b11;
//State Store Reg
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

idle://Idle State No Operation
begin
if(PSEL)
begin
SPE=1'b1;//Keep Next Module Idle
next_state<=setup;
end
else
begin
next_state<=idle;
end
end

setup://Setup State Send Configuration 
begin
p_ready = 1'b0;//Initial Value
reg_addr = PADDR;
if(PSEL == 1'b1 && PENABLE ==1'b0)
if(PWRITE == 1'b1)
begin
next_state<=write_fifo;
end
else
next_state<=complet;
else if(PSEL==0)
begin
SPE=1'b0;
next_state <= idle;
end
end

complet:// Complet State 
begin
if(PSEL == 1'b1 && PWRITE==1'b0 && PENABLE == 1'b1)
begin
MSTR = 1'b0;
next_state <= idle;
end
end

write_fifo://Write Fifo Perform Read/Write Operation
begin
if(PSEL == 1'b1 && PWRITE==1'b1 && PENABLE == 1'b1)
begin
MSTR = 1'b1;
ctrl_control=1'b1;
PRDATA = reg_rdata;
if(SPTIE==1'b1)//Checking Buffer Empty
begin
reg_wdata = PWDATA;//Data Transmitted
end
end
if(SPISWAI==1)begin//Waiting For Complete Data Transfer
p_ready = 1'b1;
ctrl_control=1'b0;
next_state <= setup;
end
else if(PSEL==1'b0)//PSEL Is Zero Diselected Module
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
