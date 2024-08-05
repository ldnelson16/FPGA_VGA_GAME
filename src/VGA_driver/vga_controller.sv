`ifndef VGA_CONTROLLER
`define VGA_CONTROLLER

`include "../../parameters/monitor.sv"
`include "structures.sv"

module vga_controller(
    input wire clk,           // 25 MHz clock
    input wire refresh,           // 60 Hz Refresh Rate signal
    Frame frame_a, // frame A
    Frame frame_b, // frame B
    output reg hsync,         // Horizontal sync signal
    output reg vsync,         // Vertical sync signal
    output reg [3:0] red,     // 4-bit red color signal
    output reg [3:0] green,   // 4-bit green color signal
    output reg [3:0] blue,     // 4-bit blue color signal
    output active_frame // 0 == frame_a, 1 == frame_b
);

    // Counters
    reg [15:0] h_count = 0;
    reg [15:0] v_count = 0;

    // HSYNC and VSYNC signals
    always @(posedge clk) begin
        if (h_count < `H_TOTAL) begin
            h_count <= h_count + 1;
        end else begin
            h_count <= 0;
            if (v_count < `V_TOTAL) begin
                v_count <= v_count + 1;
            end else begin
                v_count <= 0;
            end
        end
    end

    // Toggle state to display the two different frames
    reg TOGGLE_STATE = 0; // 0 == frame_a, 1 == frame_b
    always @ (posedge refresh) begin
        TOGGLE_STATE <= ~TOGGLE_STATE; // toggle every refresh rate
    end
    assign active_frame = TOGGLE_STATE;

    // Update hsync pulse
    always @(posedge clk) begin
        if (h_count >= (`H_VISIBLE + `H_FRONT_PORCH) && h_count < (`H_VISIBLE + `H_FRONT_PORCH + `H_SYNC_PULSE)) begin
            hsync <= 0;  // HSYNC pulse (active low)
        end else begin
            hsync <= 1;  // HSYNC inactive (high)
        end
    end

    // Update vsync pulse
    always @(posedge clk) begin
        if (v_count >= (`V_VISIBLE + `V_FRONT_PORCH) && v_count < (`V_VISIBLE + `V_FRONT_PORCH + `V_SYNC_PULSE)) begin
            vsync <= 0;  // VSYNC pulse (active low)
        end else begin
            vsync <= 1;  // VSYNC inactive (high)
        end
    end

    // Pixel data 
    always @(posedge clk) begin
        if (h_count < `H_VISIBLE && v_count < `V_VISIBLE) begin
            // temp signals
            Pixel pixel_a, pixel_b;
            frame_a.get_pixel(((v_count * `FRACTIONAL_RESOLUTION) / 100), ((h_count * `FRACTIONAL_RESOLUTION) / 100), pixel_a);
            frame_b.get_pixel(((v_count * `FRACTIONAL_RESOLUTION) / 100), ((h_count * `FRACTIONAL_RESOLUTION) / 100), pixel_b);
            red <= TOGGLE_STATE ? pixel_b.r : pixel_a.r; 
            green <= TOGGLE_STATE ? pixel_b.g : pixel_a.g; 
            blue <= TOGGLE_STATE ? pixel_b.b : pixel_a.b;   
        end else begin
            red <= 4'h0; 
            green <= 4'h0; 
            blue <= 4'h0;  // these don't matter since this is on the porches / sync of the frame
        end
    end

endmodule

`endif // VGA_CONTROLLER