module tt_um_aesa_brain (
    input  wire [7:0] ui_in, output wire [7:0] uo_out,
    input  wire [7:0] uio_in, output wire [7:0] uio_out,
    output wire [7:0] uio_oe, input wire ena, input wire clk, input wire rst_n
);
    wire load = ui_in[0]; wire start_tx = ui_in[1]; wire [3:0] ant_idx = ui_in[5:2];
    wire [5:0] phase_in = uio_in[5:0]; wire sclk, mosi, cs_n, done;
    assign uo_out[0] = sclk; assign uo_out[1] = mosi; assign uo_out[2] = cs_n; assign uo_out[3] = done;
    assign uio_oe = 8'b00000000; assign uio_out = 8'b00000000; assign uo_out[7:4] = 4'b0000;
    aesa_brain brain (.clk(clk), .rst(!rst_n), .load(load), .ant_idx(ant_idx), .phase_in(phase_in), .start_tx(start_tx), .sclk(sclk), .mosi(mosi), .cs_n(cs_n), .done(done));
endmodule
