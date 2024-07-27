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
  Pixel frame_data[`H_FRAME_HT-1: 0][`V_FRAME_HT-1: 0];

  task update_pixel(int row, int col, Pixel pixel_in);
    frame_data[row][col] = pixel_in;
  endtask

  task get_pixel(int row, int col, Pixel pixel_out);
    pixel_out = frame_data[row][col];
  endtask
endinterface

`endif // STRUCTURES