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
    Pixel blue_pixel; Pixel green_pixel; Pixel yellow_pixel;
    blue_pixel.r = 4'b0000; blue_pixel.g = 4'b1111; blue_pixel.b = 4'b1111;
    green_pixel.r = 4'b0000; green_pixel.g = 4'b1111; green_pixel.b = 4'b0000;
    yellow_pixel.r = 4'b1111; yellow_pixel.g = 4'b1111; yellow_pixel.b = 4'b0000;
    for (int row = 0; row < `V_FRAME_HT; ++row) begin
      for (int col = 0; col < `H_FRAME_HT; ++col) begin
        if ((col > ((`H_FRAME_HT * 80) / 100)) && (row < ((`H_FRAME_HT * 20) / 100))) begin
          frame_data[row][col] = yellow_pixel;
        end
        else if (row < (`V_FRAME_HT * (100 - `GRASS_PERCENTAGE) / 100)) begin // sky
          frame_data[row][col] = blue_pixel;
        end else begin // grass
          frame_data[row][col] = green_pixel;
        end
      end
    end
  endtask

  task update_frame(input Player player_in);
    Pixel red_pixel;
    red_pixel.r = 4'b1111; red_pixel.g = 4'b0000; red_pixel.b = 4'b0000;
    // initialize frame
    init_frame();
    // Do player info stuff
    frame_data[player_in.y][player_in.x] = red_pixel; 
  endtask

  task move_player(input Player player_in, input wire[1:0] move_x, input wire[1:0] move_y);
    // do nothing yet
  endtask
endinterface

typedef struct {
  /* position (bounded by Frame) */
  logic[$clog2(`H_FRAME_HT-1):0] x; 
  logic[$clog2(`V_FRAME_HT-1):0] y; 
} Player;

`endif // STRUCTURES