module APB_Slave #(parameter data=8, address=3)(
    input wire PRESETn,
    input wire PCLK,
    input wire PENABLE,
    input wire PSEL,
    input wire [address-1:0] PADDR,
    input wire PWRITE,
    input wire [data-1:0] PWDATA,
    input wire [data-1:0] reg_rdata,
    output reg SPE,
    output reg [address-1:0] reg_addr,
    output reg [data-1:0] reg_wdata,
    output reg [data-1:0] PRDATA,
    output reg MSTR,
    output wire p_ready,
    output reg SPISWAI,
    output reg SPTIE,
    output reg ctrl_control
);
    assign p_ready = PSEL && PENABLE;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            SPE <= 1'b0;
            MSTR <= 1'b0;
            SPISWAI <= 1'b0;
            SPTIE <= 1'b0;
            ctrl_control <= 1'b0;
            reg_addr <= {address{1'b0}};
            reg_wdata <= {data{1'b0}};
            PRDATA <= {data{1'b0}};
        end else begin
            if (PSEL && PENABLE && PWRITE) begin
                reg_addr <= PADDR;
                reg_wdata <= PWDATA;
                case (PADDR)
                    3'd0: begin
                        SPE <= PWDATA[0];
                        MSTR <= PWDATA[1];
                        ctrl_control <= PWDATA[2];
                        SPISWAI <= PWDATA[3];
                        SPTIE <= PWDATA[4];
                    end
                    default: begin
                        reg_addr <= PADDR;
                    end
                endcase
            end
            if (PSEL && PENABLE && !PWRITE)
                PRDATA <= reg_rdata;
        end
    end
endmodule
