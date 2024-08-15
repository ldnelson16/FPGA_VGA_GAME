`ifndef TB_REFRESH_CLOCK
`define TB_REFRESH_CLOCK

`include "../../src/Clocking/refresh_clock.sv"
`include "../../parameters/clocking.sv"

`timescale 1ns/1ns

/*
 Goal: verify that refresh rate goes at desired output frequency
 Input frequency: parameters/clocking.sv:INPUT_CLOCK_SPEED
 Expected output frequency: parameters/clocking.sv:REFRESH_RATE
*/

module TestBench_refresh_clock (); 
  reg clk;
  wire output_clock;
  int output_counter = -1;

  initial begin
    clk <= 1;
    forever #(1000000000/(2*`INPUT_CLOCK_SPEED)) clk <= ~clk;
  end

  refresh_clock refresh_clock_inst (
    .clk_50(clk),
    .refresh_clock(output_clock)
  );

  initial begin
    forever begin
      @(posedge output_clock); output_counter = (output_counter + 1); 
    end
  end

  initial begin
    #1000000000;
    if (output_counter != `REFRESH_RATE) begin
      $display("Test failed: Output_clock frequency is %d Hz, not %d Hz.", $output_counter, `REFRESH_RATE);
    end else if (output_clock != 1) begin
      $display("Test failed: Output_clock didn't wrap around back to high at exactly 1 second.");
      $fatal;
    end else begin
      $display("Test refresh_clock passed.");
      $finish;
    end
  end
endmodule

`endif // TB_REFRESH_CLOCK