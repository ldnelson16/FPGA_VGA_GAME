`ifndef REFRESH_CLOCK
`define REFRESH_CLOCK

`include "../../parameters/clocking.sv"

module refresh_clock(
  input wire clk_50,
  output refresh_clock
);
  localparam rmax = `REFRESH_MAX;
  localparam MISSED_CYCLES = `INPUT_CLOCK_SPEED - (`REFRESH_RATE * `REFRESH_MAX);
  reg[$clog2(`REFRESH_RATE):0] refresh_count = 0; // counter of refreshes (resets every second)
  reg[21:0] refresh_counter = 0; // counter
  always @ (posedge clk_50) begin
    if (refresh_count < MISSED_CYCLES) begin
      if (refresh_counter == (`REFRESH_MAX)) begin
        refresh_counter <= 0;
        refresh_count <= (refresh_count == (`REFRESH_RATE-1)) ? 0 : (refresh_count + 1);
      end else begin
        refresh_counter <= (refresh_counter + 1);
      end
    end else begin
      if (refresh_counter == (`REFRESH_MAX-1)) begin
        refresh_counter <= 0;
        refresh_count <= (refresh_count == (`REFRESH_RATE-1)) ? 0 : (refresh_count + 1);
      end else begin
        refresh_counter <= (refresh_counter + 1);
      end
    end
  end
  assign refresh_clock = (refresh_counter == 0);
endmodule

`endif // REFRESH_CLOCK