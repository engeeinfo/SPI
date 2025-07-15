module APB_Slave #(parameter data=8, addr=3)(
    input wire [addr-1:0] address,
    input wire clk,
    output reg [data-1:0] dout
);
    reg [data-1:0] rom [0:(1<<addr)-1];

    initial begin
        rom[0] = 8'h55;
        rom[1] = 8'hAA;
        rom[2] = 8'h0F;
        rom[3] = 8'hF0;
        rom[4] = 8'hA5;
        rom[5] = 8'h5A;
        rom[6] = 8'h3C;
        rom[7] = 8'hC3;
    end

    always @(posedge clk) begin
        dout <= rom[address];
    end
endmodule