module aesa_brain (
    input wire clk, input wire rst, input wire load, input wire [3:0] ant_idx,
    input wire [5:0] phase_in, input wire start_tx,
    output reg sclk, output reg mosi, output reg cs_n, output reg done
);
    reg [5:0] phase_mem [0:15];
    localparam IDLE = 3'b000, SPI_START = 3'b001, SPI_WAIT = 3'b010, FINISH = 3'b011;
    reg [2:0] state; reg [3:0] current_ant; reg [23:0] spi_data; reg spi_start; wire spi_done; integer i;
    spi_master my_spi (.clk(clk), .rst(rst), .start(spi_start), .data(spi_data), .sclk(sclk), .mosi(mosi), .cs_n(cs_n), .done(spi_done));
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE; current_ant <= 0; done <= 0; spi_start <= 0;
            for (i = 0; i < 16; i = i + 1) phase_mem[i] <= 6'b000000;
        end else begin
            case (state)
                IDLE: begin done <= 0; if (load) phase_mem[ant_idx] <= phase_in; else if (start_tx) begin current_ant <= 0; state <= SPI_START; end end
                SPI_START: begin spi_data <= {14'b0, current_ant, phase_mem[current_ant]}; spi_start <= 1; state <= SPI_WAIT; end
                SPI_WAIT: begin
                    spi_start <= 0;
                    if (spi_done) begin if (current_ant == 15) state <= FINISH; else begin current_ant <= current_ant + 1; state <= SPI_START; end end
                end
                FINISH: begin done <= 1; state <= IDLE; end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
