`ifndef MONITOR_PARAMETERS
`define MONITOR_PARAMETERS

// designed for 1680x1050 @ 60Hz Vga monitor

`define H_VISIBLE 1680
`define H_FRONT_PORCH 104
`define H_SYNC_PULSE 184
`define H_BACK_PORCH 288
`define H_TOTAL (`H_VISIBLE + `H_FRONT_PORCH + `H_SYNC_PULSE + `H_BACK_PORCH)

`define FRACTIONAL_RESOLUTION 2 // %
`define H_FRAME_HT (`FRACTIONAL_RESOLUTION * `H_VISIBLE) / 100
`define V_FRAME_HT (`FRACTIONAL_RESOLUTION * `V_VISIBLE) / 100

`define V_VISIBLE 1050
`define V_FRONT_PORCH 1
`define V_SYNC_PULSE 3
`define V_BACK_PORCH 33
`define V_TOTAL (`V_VISIBLE + `V_FRONT_PORCH + `V_SYNC_PULSE + `V_BACK_PORCH)

`endif // MONITOR_PARAMETERS