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
  output Frame frame_a,
  output Frame frame_b
);
  // Initial frame data
  initial begin
    for (int i=0; i<`V_FRAME_HT; ++i) begin
      for (int j=0; j<`H_FRAME_HT; ++j) begin
        frame_a.update_pixel(i,j,`{r:0,g:0,b:0});
      end
    end
  end

  // Structures for items on screen

  // Frame Modifications

endmodule

`endif // GRAPHICS_DRIVER