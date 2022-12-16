`timescale 1ns / 1ps
module SPI_Controller #(parameter data=8,address=3)(
input PRESETn,// Active Low RESET
input CLK,//Divider Output Clk
input [address-1:0] reg_addr,//Configuration Bits
input [data-1:0] reg_wdata,//Data Input,Spi Controller To Spi Mosi
input MSTR,//Master Or Slave Mode Reg
input SPE,//Spi Module Enable Reg
input [data-1:0] m_rdata,//Receive Data From Spi Master Miso
input TXC,//Transffer Compelet Reg
input SPTEF,//Buffer Empty Reg
input ctrl_control,

output reg [data-1:0] reg_rdata=0,//Controller Output ,Provide Miso Readed Data
output reg master_wr_rd,//Read/Write State Select Pin
output reg spe,//Spi Module Enable Reg
output reg [address-1:0] m_addr,//Carry Configuration Bits To Next Module
output reg [data-1:0] m_wdata,//Carry reg_wdata To Next Module
output reg SPISWAI=0,//Wait State Reg
output reg SPTIE=0,//Buffer Empty Reg
output reg master_control
);
//Parameter For State Transaction
parameter IDLE = 2'b00, SETUP = 2'b01, WRITE_DATA = 2'b10, complet = 2'b11;
//State Store Reg
reg[1:0] next_state, current_state;

always@(posedge CLK,negedge PRESETn)
begin
if(!PRESETn)
begin
current_state <= IDLE;
end
else
begin
current_state <= next_state;
end
end

always@(posedge CLK)
begin
                                                                                         
case(current_state)

IDLE://Idle State No Operation
begin
if(SPE)
begin
spe = 1'b1;
next_state <= SETUP;
end
else
begin
next_state <= IDLE;
end
end

SETUP://Setup State Send Configuration
begin
SPISWAI=TXC;//Reg Value Sending
m_addr = reg_addr;
if(MSTR == 1'b1 && ctrl_control==1'b1 && SPTEF==1'b1)
begin
SPTIE=SPTEF;//Reg Value Sending
next_state <= WRITE_DATA;
end
else if(MSTR == 1'b0 && ctrl_control==1'b0)
begin
next_state <= complet;
end
else if(SPE==0)
begin
spe=1'b0;
next_state <= IDLE;
end
end

complet:// Complet State
begin
if(MSTR== 1'b0 && SPE == 1'b1)
begin
master_wr_rd = 1'b0;
master_control=1'b0;
next_state <= IDLE;
end
end

WRITE_DATA://Write_Data Perform Read/Write Operation
begin
if(MSTR== 1'b1 && SPE == 1'b1)
begin
SPTIE=1'b0;
master_wr_rd = 1'b1;
master_control=1'b1;
m_wdata = reg_wdata;//Data Transmitted
reg_rdata = m_rdata;//Data Received
end
if (TXC==1)//Waiting For Complete Data Transfer
begin
SPISWAI=TXC;
master_control=1'b0;
next_state <= SETUP;
end
else if(SPE==0)//Reg SPE Is Zero Disabled Module
begin
spe=1'b0;
next_state <= IDLE;
end
end

default:
begin
next_state<= IDLE;
end

endcase
end

endmodule
