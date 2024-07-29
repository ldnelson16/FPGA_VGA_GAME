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
  // Initial frame data // no longer necessary, done by VGA_driver
  initial begin
    frame_a.init_frame();
    frame_b.init_frame();
  end

  // Structures for items on screen

  // Frame Modifications

endmodule

`endif // GRAPHICS_DRIVER