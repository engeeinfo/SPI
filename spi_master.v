module spi_master #(parameter data=8)(
    input wire clk,
    input wire presetn,
    input wire spe,
    input wire [data-1:0] m_wdata,
    input wire [2:0] m_addr, // {CPOL, CPHA, SlaveID}
    input wire m_wr_rdbar,
    input wire miso,
    input wire master_control,

    output reg [data-1:0] m_rdata = 0,
    output reg ss0 = 1,
    output reg ss1 = 1,
    output reg sclk = 0,
    output reg mosi = 0,
    output reg TXC = 0,
    output reg SPTEF = 0
);
    reg [2:0] count = 0;
    reg [7:0] shift_reg_out;
    reg [7:0] shift_reg_in;
    wire CPOL = m_addr[2];
    wire CPHA = m_addr[1];
    wire slave_sel = m_addr[0];

    always @(posedge clk or negedge presetn) begin
        if (!presetn) begin
            count <= 0;
            TXC <= 0;
            SPTEF <= 0;
            ss0 <= 1;
            ss1 <= 1;
            sclk <= CPOL;
            shift_reg_out <= 0;
            shift_reg_in <= 0;
        end else if (spe && master_control) begin
            ss0 <= (slave_sel == 0) ? 0 : 1;
            ss1 <= (slave_sel == 1) ? 0 : 1;

            if (count == 0) begin
                shift_reg_out <= m_wdata;
                shift_reg_in <= 0;
                TXC <= 0;
                SPTEF <= 0;
                count <= count + 1;
            end else if (count < 9) begin
                if (CPHA == 0) begin
                    mosi <= shift_reg_out[7];
                    shift_reg_out <= {shift_reg_out[6:0], 1'b0};
                    sclk <= ~sclk;
                    if (sclk == ~CPOL)
                        shift_reg_in <= {shift_reg_in[6:0], miso};
                end else begin
                    sclk <= ~sclk;
                    if (sclk == CPOL) begin
                        mosi <= shift_reg_out[7];
                        shift_reg_out <= {shift_reg_out[6:0], 1'b0};
                        shift_reg_in <= {shift_reg_in[6:0], miso};
                    end
                end
                count <= count + 1;
            end else begin
                TXC <= 1;
                SPTEF <= 1;
                m_rdata <= shift_reg_in;
                ss0 <= 1;
                ss1 <= 1;
                sclk <= CPOL;
                count <= 0;
            end
        end else begin
            sclk <= CPOL;
        end
    end
endmodule
