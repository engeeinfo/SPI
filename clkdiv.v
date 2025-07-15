module clkdiv #(parameter DIV = 4)(
    input wire clock,
    input wire reset,
    output reg clk = 0
);
    reg [$clog2(DIV)-1:0] count = 0;

    always @(posedge clock or negedge reset) begin
        if (!reset) begin
            count <= 0;
            clk <= 0;
        end else begin
            if (count == DIV - 1) begin
                count <= 0;
                clk <= ~clk;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule