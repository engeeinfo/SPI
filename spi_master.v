module spi_master #(parameter data=8,address=3,counter=4,buffer=8,
countval=8)(
input m_wr_rdbar,//Read/Write State Select Pin
input spe,//Spi Module Enable Reg
input miso,//Master In Slave Out Pin
input clk,//Divider Clk Output
input presetn,// Active Low RESET
input [data-1:0] m_wdata,//Data Input
input [address-1:0] m_addr,//Configuration Bits
input master_control,

output reg[data-1:0] m_rdata=0,//Send Data From Spi Master Miso Pin
output reg ss0=1,//Slave 0
output reg ss1=1,//Slave 1
output reg sclk=0,//Slave Clock
output reg  mosi=0,//Master Out Slave In
output reg TXC=0,//Transfer Complet Reg
output reg SPTEF=0//Buffer Empty Reg
);
//counter,For data bit Count 
reg[counter-1:0]count1=0;

//Parameter For State Transaction
parameter idle=3'b000,setup=3'b001,write_fifo=3'b010,complet=3'b011,load=3'b101;
//State Store Reg
reg[2:0] next_state, current_state;
//Buffer To Store R/W Data
reg[buffer-1:0] bufferwrt=0,bufferread=0;
//Cphole and Cphase For Spi Clk Mode Operation
reg cphase;
reg  cpole;
//Sclk Enable Bit
reg clken;

always@(posedge clk or negedge clk)//Sclock Generation Based On Cphase And Cpole
begin
if(clken)
sclk=~sclk;
else if(cpole==1'b0 && cphase==1'b0)
sclk=1'b0;//Sclk idle value
else if(cpole==1'b1 && cphase==1'b0)
sclk=1'b1;//Sclk idle value
else
sclk=1'b0;
end

always@(posedge clk,negedge presetn)
begin
if(!presetn)
begin
current_state<=idle;
end
else
begin
current_state<=next_state;
end
end


always@(posedge clk)
begin

case(current_state)


idle:// Idel State
begin
if(spe)
begin
next_state<=load;
end
else
begin
next_state<=idle;
end
end

load://Load State 
begin
count1<=0;//Reset Counter Value
cpole <=m_addr[0];//Assigning Configuration Bit
cphase <=m_addr[1];//Assigning Configuration Bit
TXC=1'b0;//Reset TXC Reg
ss0=1'b1;//Reset Slave Select Value
ss1=1'b1;//Reset Slave Select Value
clken=1'b0;//Reset clken Bit
bufferread<=0;//Buffer Cleared
if(bufferwrt==0)//Checking Write Buffer Empty 
begin
SPTEF=1'b1;
end
else
begin
SPTEF=1'b0;
end
next_state<=setup;
end

setup:// Setup State
begin
if(m_addr[2]==1'b0)//Slave Slecting
begin
ss0=1'b0;
end
else if(m_addr[2]==1'b1)//Slave Slecting
begin
ss1=1'b0;
end
if( m_wr_rdbar==1'b1 && master_control==1'b1)//Changing State 
begin
bufferwrt<=m_wdata;//Storing Input Data To Buffer
next_state<=write_fifo;
end
else if(  m_wr_rdbar==1'b0 && master_control==1'b0)
begin
next_state<=complet;
end
else if(spe==1'b0)//Reg SPE Is Zero Disabled Module 
begin
next_state <= idle;
end
end


complet://Complet State
begin
if(m_wr_rdbar==1'b0)
next_state <= idle; 
end


//write
write_fifo:
begin
if(m_wr_rdbar==1'b1)
begin
if(count1<=countval)
begin
clken=1'b1;//Sclk Enable
SPTEF=1'b0;//Buffer empty reg 
bufferread<={bufferread[buffer-2:0],miso};//Data Sampling
m_rdata<=bufferread;//MISO
mosi<=bufferwrt[0];//MOSI
bufferwrt<={1'b0,bufferwrt[buffer-1:1]};//Data Sampling
count1<=count1+1'b1;//Counter Count One Bit At A Time
end
if(count1==countval)
begin//Checking Data Transmission Complet Or Not
TXC=1'b1;//Transfer Complet 
clken=1'b0;//Reset Clken 
next_state <= load; 
end
end
else if(spe==1'b0) 
begin
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
