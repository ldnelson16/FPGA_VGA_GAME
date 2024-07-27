`ifndef MAIN
`define MAIN

`include "VGA_driver/vga_controller.sv"
`include "Clocking/VGA_clock.v"
`include "Clocking/refresh_clock.sv"
`include "VGA_driver/structures.sv"

module main(
  input wire MAX10_CLK1_50, 
  output reg[3:0] VGA_R, VGA_G, VGA_B, // RGB
  output reg VGA_HS, VGA_VS
);
  // // PLL for 147.14 MHz clock
  // wire VGA_clk;
  // VGA_clock VGA_CLOCK (
  //   .inclk0(MAX10_CLK1_50),
  //   .c0(VGA_clk)
  // );

  // Counter for Refresh Rate 60 Hz clock
  wire refresh;
  refresh_clock REFRESH_CLOCK (
    .clk_50(MAX10_CLK1_50),
    .refresh_clock(refresh)
  );

  // Frame frame_a();
  // Frame frame_b();

  // // vga controller
  // vga_controller VGA_CONTROLLER (
  //   .clk(VGA_clock),
  //   .refresh(refresh),
  //   .frame_a(frame_a),
  //   .frame_b(frame_b),
  //   .hsync(VGA_HS),
  //   .vsync(VGA_VS),
  //   .red({VGA_R[0], VGA_R[1], VGA_R[2], VGA_R[3]}),
  //   .green({VGA_G[0], VGA_G[1], VGA_G[2], VGA_G[3]}),
  //   .blue({VGA_B[0], VGA_B[1], VGA_B[2], VGA_B[3]})
  // );
endmodule 

`endif // MAIN