`ifndef GRAPHICS_DRIVER
`define GRAPHICS_DRIVER

`include "../VGA_driver/structures.sv"

module graphics_driver (
  // signal inputs
  input wire clk,
  input wire refresh,
  input wire rst,
  // handheld controller inputs

  // outputs
  Frame frame_a,
  Frame frame_b
);
  // Initial frame data
  initial begin
    Pixel black_pixel;
    black_pixel.r = 0;
    black_pixel.g = 0;
    black_pixel.b = 0;
    for (int i=0; i<`V_FRAME_HT; ++i) begin
      for (int j=0; j<`H_FRAME_HT; ++j) begin
        frame_a.update_pixel(i,j,black_pixel); // set all pixels black initially
      end
    end
  end

  // Structures for items on screen

  // Frame Modifications

endmodule

`endif // GRAPHICS_DRIVER