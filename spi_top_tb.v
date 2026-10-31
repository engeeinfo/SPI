`timescale 1ns / 1ps

module spi_top_tb;
    reg PRESETn;
    reg PCLK;
    reg PENABLE;
    reg PSEL;
    reg [2:0] PADDR;
    reg PWRITE;
    reg [7:0] PWDATA;
    reg miso;
    wire PREADY;
    wire [7:0] PRDATA;
    wire ss0, ss1, sclk, mosi;

    spi_top uut (
        .PRESETn(PRESETn), .PCLK(PCLK), .PENABLE(PENABLE), .PSEL(PSEL),
        .PADDR(PADDR), .PWRITE(PWRITE), .PWDATA(PWDATA), .miso(miso),
        .PREADY(PREADY), .PRDATA(PRDATA), .ss0(ss0), .ss1(ss1),
        .sclk(sclk), .mosi(mosi)
    );

    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

    initial begin
        PRESETn = 0;
        PENABLE = 0;
        PSEL = 0;
        PADDR = 0;
        PWRITE = 0;
        PWDATA = 0;
        miso = 0;
        #20;
        PRESETn = 1;
        #20;
        if (PREADY !== 1'b0 && PREADY !== 1'b1) begin
            $display("FAIL: APB ready signal is unknown after reset");
            $finish(1);
        end
        $display("PASS: SPI top-level reset smoke test");
        $finish(0);
    end
endmodule
