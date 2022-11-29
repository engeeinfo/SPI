module spi_master #(parameter data=8,address=3,counter=4,buffer=8,
countval=8)(
input m_wr_rdbar,
input spe,
input miso,
input clk,
input presetn,
input [data-1:0] m_wdata,
input [address-1:0] m_addr,


output reg[data-1:0] m_rdata=0,
output reg ss0=1,
output reg ss1=1,
output reg sclk=0,
output reg  mosi=0,
output reg TXC=0,
output reg SPTEF=0
);
reg[counter-1:0]count1=0;
parameter idle=3'b000,setup=3'b001,write_fifo=3'b010,complet=3'b011,load=3'b101;
reg[2:0] next_state, current_state;

reg[buffer-1:0] bufferwrt=0,bufferread=0;
reg cphase;
reg  cpole;
reg clken;

always@(posedge clk or negedge clk)
begin
if(clken)
sclk=~sclk;
else if(cpole==1'b0 && cphase==1'b0)
sclk=1'b0;
else if(cpole==1'b1 && cphase==1'b0)
sclk=1'b1;
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

//idel
idle:
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

load:
begin
count1<=0;
cpole <=m_addr[0];
cphase <=m_addr[1];
TXC=1'b0;
ss0=1'b1;
ss1=1'b1;
clken=1'b0;
bufferread<=0;
if(bufferwrt==0)
begin
SPTEF=1'b1;
end
else
begin
SPTEF=1'b0;
end
next_state<=setup;
end

//setup
setup:
begin
if(m_addr[2]==1'b0)
begin
ss0=1'b0;
end
else if(m_addr[2]==1'b1)
begin
ss1=1'b0;
end
if( m_wr_rdbar==1'b1 )
begin
bufferwrt<=m_wdata;
next_state<=write_fifo;
end
else if(  m_wr_rdbar==1'b0 )begin
next_state<=complet;end
else if(spe==1'b0) begin
next_state <= idle; end
 
end


//complet
complet:
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
clken=1'b1;
SPTEF=1'b0;
bufferread<={bufferread[buffer-2:0],miso};
m_rdata<=bufferread;
mosi<=bufferwrt[0];
bufferwrt<={1'b0,bufferwrt[buffer-1:1]};
count1<=count1+1'b1;
end
if(count1==countval) begin
TXC=1'b1;
clken=1'b0;
next_state <= load; end
end
else if(spe==1'b0) begin
next_state <= idle; end
end


default:
begin
 next_state<=idle;
end

endcase
end

endmodule
