module spi_master (
    input wire clk, input wire rst, input wire start, input wire [23:0] data,
    output reg sclk, output reg mosi, output reg cs_n, output reg done
);
    localparam IDLE = 2'b00, SEND = 2'b01, FINISH = 2'b10;
    reg [1:0] state; reg [4:0] bit_counter; reg [23:0] shift_reg; reg [3:0] clk_div;
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE; sclk <= 0; mosi <= 0; cs_n <= 1; done <= 0; bit_counter <= 0; clk_div <= 0;
        end else begin
            case (state)
                IDLE: begin done <= 0; sclk <= 0; cs_n <= 1; if (start) begin shift_reg <= data; bit_counter <= 24; cs_n <= 0; state <= SEND; end end
                SEND: begin
                    if (clk_div == 4) begin
                        clk_div <= 0; sclk <= ~sclk;
                        if (sclk == 0) begin mosi <= shift_reg[23]; shift_reg <= {shift_reg[22:0], 1'b0}; bit_counter <= bit_counter - 1; end
                        else begin if (bit_counter == 0) state <= FINISH; end
                    end else clk_div <= clk_div + 1;
                end
                FINISH: begin cs_n <= 1; sclk <= 0; done <= 1; state <= IDLE; end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
