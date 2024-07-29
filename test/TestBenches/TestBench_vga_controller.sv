`ifndef TB_VGA_CONTROLLER
`define TB_VGA_CONTROLLER

`include "../../parameters/clocking.sv"
`include "../../parameters/monitor.sv"
`include "../../src/VGA_driver/vga_controller.sv"
`include "../../src/VGA_driver/structures.sv"

`timescale 1ns/1ns

/*
 Goal: verify that the VGA controller module correctly displays the input is given via frames A and B and at the proper refresh rate with proper HSYNC and VSYNC signals.
*/

module TestBench_vga_controller(); 
  reg clk, refresh;

  initial begin // define clock
    clk <= 1;
    forever #(1000000000/(2*`INPUT_CLOCK_SPEED)) clk <= ~clk;
  end

  initial begin // define refresh rate
    refresh <= 1;
    forever #(1000000000/(2*`REFRESH_RATE)) refresh <= ~refresh;
  end

  Frame frame_a();
  Frame frame_b(); 

  initial begin
    frame_a.init_frame();
    frame_b.init_frame();
  end

  wire hsync,vsync;
  wire[3:0] red,green,blue;

  vga_controller vga_controller_inst(
    .clk(clk),           // clock
    .refresh(refresh),           // Refresh Rate signal
    .frame_a(frame_a), // frame A
    .frame_b(frame_b), // frame B
    .hsync(hsync),         // Horizontal sync signal
    .vsync(vsync),         // Vertical sync signal
    .red(red),     // 4-bit red color signal
    .green(green),   // 4-bit green color signal
    .blue(blue)     // 4-bit blue color signal
  );
endmodule

`endif // TB_VGA_CONTROLLER