`ifndef STRUCTURES
`define STRUCTURES

`include "../../parameters/monitor.sv"
`include "../../parameters/graphics.sv"

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

  task init_frame();
    Pixel blue_pixel; Pixel green_pixel;
    blue_pixel.r = 4'b0000; blue_pixel.g = 4'b0000; blue_pixel.b = 4'b1111;
    green_pixel.r = 4'b0000; green_pixel.g = 4'b1111; green_pixel.b = 4'b0000;
    for (int row = 0; row < `V_FRAME_HT; ++row) begin
      for (int col = 0; col < `H_FRAME_HT; ++col) begin
        if (row > (`V_FRAME_HT * `GRASS_PERCENTAGE / 100)) begin // sky
          update_pixel(row, col, blue_pixel);
        end else begin // grass
          update_pixel(row, col, green_pixel);
        end
      end
    end
  endtask
endinterface

`endif // STRUCTURES