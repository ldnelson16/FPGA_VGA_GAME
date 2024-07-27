`ifndef REFRESH_CLOCK
`define REFRESH_CLOCK

`include "../../parameters/clocking.sv"

module refresh_clock(
  input wire clk_50,
  output refresh_clock
);
  reg[21:0] refresh_counter; // counter
  always @ (posedge clk_50) begin
    refresh_counter <= (refresh_counter == `REFRESH_MAX) ? 0 : (refresh_counter + 1);
  end
  assign refresh_clock = (refresh_counter == `REFRESH_MAX);
endmodule

`endif // REFRESH_CLOCK