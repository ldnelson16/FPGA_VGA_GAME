`ifndef MAIN
`define MAIN

`include "vga_controller.sv"
`include "Clocking/PLL.v"
`include "Clocking/refresh_clock.sv"

module main(
  input wire MAX10_CLK1_50, 
  input wire left_button, right_button, jump; // input buttons
  output reg[3:0] VGA_R, VGA_G, VGA_B, // RGB
  output reg VGA_HS, VGA_VS,
  output reg[9:0] LEDR
);
  // PLL for 110 MHz clock
  wire VGA_clock;
  VGA_clock VGA_clock (
    .inclk0(MAX10_CLK1_50),
    .c0(VGA_clock)
  );

  // Counter for Refresh Rate 60 Hz clock
  wire refresh;
  refresh_clock refresh_clock (
    .clk0(MAX10_CLK1_50),
    .refresh_clock(refresh)
  );

  // test PLL with 1Hz signal
  parameter MAX = 147140000;
  reg[31:0] counter; 
  initial begin
    counter <= 0;
  end
  always @(posedge VGA_clock) begin
    if (counter >= MAX) begin
      counter <= 0; LEDR[0] <= 1;
    end else begin
      counter <= (counter + 1); 
      if (counter > (MAX / 4)) begin
        LEDR[0] <= 0;
      end
    end
  end

  // input handler / driver 
  

  // vga controller
  vga_controller VGA_CONTROLLER (
    .clk(VGA_clock),
    .pps(LEDR[0]),
    .hsync(VGA_HS),
    .vsync(VGA_VS),
    .red({VGA_R[0], VGA_R[1], VGA_R[2], VGA_R[3]}),
    .green({VGA_G[0], VGA_G[1], VGA_G[2], VGA_G[3]}),
    .blue({VGA_B[0], VGA_B[1], VGA_B[2], VGA_B[3]})
  );
endmodule 

`endif // MAIN