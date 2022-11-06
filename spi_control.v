`timescale 1ns / 1ps
module SPI_Controller #(parameter data=32,address=3)(
input PRESETn,
input CLK,
input [address-1:0] reg_addr,
input [data-1:0] reg_wdata,
input MSTR,
input SPE,
input [data-1:0] m_rdata,
input TXC,
input SPTEF,
input ctrl_control,

output reg [data-1:0] reg_rdata=0,
output reg master_wr_rd,
output reg spe,
output reg [address-1:0] m_addr,
output reg [data-1:0] m_wdata,
output reg SPISWAI=0,
output reg SPTIE=0,
output reg master_control

);

parameter IDLE = 2'b00, SETUP = 2'b01, WRITE_DATA = 2'b10, READ_DATA = 2'b11;

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

IDLE:
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

SETUP:
begin
SPISWAI=TXC;
m_addr = reg_addr;
if(MSTR == 1'b1 && ctrl_control==1'b1 && SPTEF==1'b1)
begin
SPTIE=SPTEF;
next_state <= WRITE_DATA;
end
else if(MSTR == 1'b0 && ctrl_control==1'b0)
begin
next_state <= READ_DATA;
end
else if(SPE==0)
begin
spe=1'b0;
next_state <= IDLE;
end
end

READ_DATA:
begin
if(MSTR== 1'b0 && SPE == 1'b1)
begin
master_wr_rd = 1'b0;
master_control=1'b0;
reg_rdata = m_rdata;
end
if (TXC==1) begin
SPISWAI=TXC;
master_control=1'b1;
next_state <= SETUP;
end
else if(SPE==0)
begin
spe=1'b0;
next_state <= IDLE;
end
end

WRITE_DATA:
begin
if(MSTR== 1'b1 && SPE == 1'b1)
begin
SPTIE=1'b0;
master_wr_rd = 1'b1;
master_control=1'b1;
m_wdata = reg_wdata;
end
if (TXC==1) begin
SPISWAI=TXC;
master_control=1'b0;
next_state <= SETUP;
end
else if(SPE==0)
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
