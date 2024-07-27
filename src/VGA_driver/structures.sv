`ifndef STRUCTURES
`define STRUCTURES

`include "../../parameters/monitor.sv"

typedef struct {
  logic[3:0] r;
  logic[3:0] g;
  logic[3:0] b;
} Pixel;

interface Frame();
  // variables
  Pixel frame_data[`V_FRAME_HT-1: 0][`H_FRAME_HT-1: 0];

  task update_pixel(input int row, input int col, input Pixel pixel_in);
    frame_data[row][col] = pixel_in;
  endtask

  task get_pixel(input int row, input int col, output Pixel pixel_out);
    pixel_out = frame_data[row][col];
  endtask
endinterface

`endif // STRUCTURES