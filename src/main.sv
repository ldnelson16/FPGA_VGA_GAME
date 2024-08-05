`ifndef MAIN
`define MAIN

`include "VGA_driver/vga_controller.sv"
`include "Clocking/VGA_clock.v"
`include "Clocking/refresh_clock.sv"
`include "VGA_driver/structures.sv"
`include "Graphics/graphics_driver.sv"

module main(
  input wire MAX10_CLK1_50, 
  input wire KEY[0], // must determine this input
  output reg[3:0] VGA_R, VGA_G, VGA_B, // RGB
  output reg VGA_HS, VGA_VS,
  output[9:0] LEDR
);
  // rst signal
  wire rst;
  assign rst = ~KEY[0];

  // PLL for 147.14 MHz clock
  wire VGA_clk;
  VGA_clock VGA_CLOCK (
    .inclk0(MAX10_CLK1_50),
    .c0(VGA_clk)
  );

  // Counter for Refresh Rate 60 Hz clock
  wire refresh;
  refresh_clock REFRESH_CLOCK (
    .clk_50(MAX10_CLK1_50),
    .refresh_clock(refresh)
  );

  // Frame object signals
  Frame frame_a();
  Frame frame_b();
  wire active_frame; // to keep track of which frame is actively being displayed (only the other frame can be modified safely)

  // graphics driver, determines what is in frame_a/b
  graphics_driver GRAPHICS_DRIVER (
    .clk(VGA_clk),
    .refresh(refresh),
    .rst(rst),
    .active_frame(active_frame),
    .frame_a(frame_a),
    .frame_b(frame_b)
  );

  // vga controller
  vga_controller VGA_CONTROLLER (
    .clk(VGA_clk),
    .refresh(refresh),
    .frame_a(frame_a),
    .frame_b(frame_b),
    .hsync(VGA_HS),
    .vsync(VGA_VS),
    .red({VGA_R[3], VGA_R[2], VGA_R[1], VGA_R[0]}),
    .green({VGA_G[3], VGA_G[2], VGA_G[1], VGA_G[0]}),
    .blue({VGA_B[3], VGA_B[2], VGA_B[1], VGA_B[0]}),
    .active_frame(active_frame)
  );

  assign LEDR[9:8] = frame_b.frame_data[0][0].g[1:0];
  assign LEDR[7:4] = frame_b.frame_data[20][20].g;
endmodule 

`endif // MAIN