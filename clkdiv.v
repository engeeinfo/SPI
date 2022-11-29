module clkdiv(clock,reset,clk);
input clock;
input reset;
output reg clk=1'b0;
reg [1:0] count=2'b11;

always@(posedge clock or negedge reset or negedge clock)
begin

if(!reset)
begin
clk=1'b0;
end

else if(count==1)
begin
count=2'b00;
clk=~clk;
end

else
begin
count=count+1'b1;
end

end

endmodule
