`ifndef MAIN
`define MAIN

`include "vga_controller.sv"
`include "PLL/PLL.v"

module main(
  input wire MAX10_CLK1_50, 
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
  parameter REFRESH_MAX = (50000000 / 60);
  reg[19:0] refresh_counter; // counter
  always @ (posedge MAX10_CLK1_50) begin
    refresh_counter <= (refresh_counter == REFRESH_MAX) ? 0 : (refresh_counter + 1);
  end; assign wire = (refresh_counter == REFRESH_MAX);

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