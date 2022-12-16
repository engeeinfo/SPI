module clkdiv(clock,reset,clk);
input clock;//Clk Input 
input reset;//Active Low Reset
output reg clk=1'b0;//Clk Output
reg [1:0] count=2'b11;//Counter For Divide Clk
always@(posedge clock or negedge reset or negedge clock)
begin
//Clk Reset
if(!reset)
begin
clk=1'b0;
end
// Clock Generation
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
