`ifndef PLL_TESTBENCH
`define PLL_TESTBENCH

`include "../src/vga_controller.sv"

`timescale 1ns/1ns

module TestBench ();
  reg light;
  reg[31:0] counter;
  reg clk;

  initial begin
    clk <= 0;
    forever #(500/147.16) clk <= ~clk;
  end

  wire[3:0] VGA_R, VGA_G, VGA_B;
  wire VGA_HS, VGA_VS;
  wire[9:0] random;

  vga_controller VGA_CONTROLLER (
    .clk(clk),
    .hsync(VGA_HS),
    .vsync(VGA_VS),
    .red(VGA_R),
    .green(VGA_G),
    .blue(VGA_B)
  );
endmodule

`endif // PLL_TESTBENCH