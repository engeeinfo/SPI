module SPI_Controller #(parameter data=8, address=3)(
    input wire PRESETn,
    input wire CLK,
    input wire [address-1:0] reg_addr,
    input wire [data-1:0] reg_wdata,
    input wire MSTR,
    input wire SPE,
    input wire [data-1:0] m_rdata,
    input wire TXC,
    input wire SPTEF,
    input wire ctrl_control,

    output reg [data-1:0] reg_rdata = 0,
    output reg master_wr_rd = 0,
    output reg spe = 0,
    output reg [address-1:0] m_addr = 0,
    output reg [data-1:0] m_wdata = 0,
    output reg SPISWAI = 0,
    output reg SPTIE = 0,
    output reg master_control = 0
);
    parameter IDLE = 2'b00, SETUP = 2'b01, WRITE_DATA = 2'b10, COMPLETE = 2'b11;
    reg [1:0] current_state = IDLE, next_state = IDLE;

    always @(posedge CLK or negedge PRESETn) begin
        if (!PRESETn)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(posedge CLK or negedge PRESETn) begin
        if (!PRESETn) begin
            reg_rdata <= 0;
            spe <= 0;
            master_wr_rd <= 0;
            m_addr <= 0;
            m_wdata <= 0;
            SPISWAI <= 0;
            SPTIE <= 0;
            master_control <= 0;
            next_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (SPE) begin
                        spe <= 1;
                        next_state <= SETUP;
                    end else begin
                        next_state <= IDLE;
                    end
                end

                SETUP: begin
                    SPISWAI <= TXC;
                    m_addr <= reg_addr;
                    if (MSTR && ctrl_control && SPTEF) begin
                        SPTIE <= 1;
                        next_state <= WRITE_DATA;
                    end else if (!MSTR && !ctrl_control) begin
                        next_state <= COMPLETE;
                    end else if (!SPE) begin
                        spe <= 0;
                        next_state <= IDLE;
                    end
                end

                WRITE_DATA: begin
                    if (MSTR && SPE) begin
                        master_wr_rd <= 1;
                        master_control <= 1;
                        m_wdata <= reg_wdata;
                        reg_rdata <= m_rdata;
                    end
                    if (TXC) begin
                        SPISWAI <= TXC;
                        master_control <= 0;
                        next_state <= SETUP;
                    end else if (!SPE) begin
                        spe <= 0;
                        next_state <= IDLE;
                    end
                end

                COMPLETE: begin
                    if (!MSTR && SPE) begin
                        master_wr_rd <= 0;
                        master_control <= 0;
                        next_state <= IDLE;
                    end
                end

                default: next_state <= IDLE;
            endcase
        end
    end
endmodule