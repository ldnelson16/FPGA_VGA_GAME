`ifndef GRAPHICS_DRIVER
`define GRAPHICS_DRIVER

`include "../VGA_driver/structures.sv"
`include "../../parameters/graphics.sv"

module graphics_driver (
  // signal inputs
  input wire clk,
  input wire refresh,
  input wire rst,
  input wire active_frame, // 0 == frame_a, 1 == frame_b
  // handheld controller inputs
  input wire[1:0] x_move, // x_move == 0 : move left, x_move == 1 : stay, x_move == 2 : move right
  input wire[1:0] y_move, // x_move == 0 : move down, x_move == 1 : stay, x_move == 2 : move up
  // outputs
  Frame frame_a,
  Frame frame_b
);
  // previous active frame (previous clock cycle) (to know when the frame has switched)
  reg prev_frame = 0;
  always_ff @ (posedge clk) begin
    prev_frame <= active_frame;
  end

  // Initial frame data 
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      // initialize frames
      frame_a.init_frame();
      frame_b.init_frame();
    end else begin
      // render info
      if (active_frame) begin // Frame B rendering
        if (~prev_frame) begin
          // must update all info that changed while frame was being rendered
          frame_a.update_frame(player);
        end
        else if (
          ((x_move == 2'b00) && (has_moved_x != 2'b00)) || // move right
          ((x_move == 2'b10) && (has_moved_x != 2'b10)) // move left
          ) begin
          // limit/stop player's movement until frae switches
          frame_a.move_player(player, x_move, y_move);
        end
      end else begin // Frame A rendering
        if (prev_frame) begin
          // must update all info that changed while frame was being rendered
          frame_b.update_frame(player);
        end
        else if (
          ((x_move == 2'b00) && (has_moved_x != 2'b00)) || // move right
          ((x_move == 2'b10) && (has_moved_x != 2'b10)) // move left
          ) begin
          // limit/stop player's movement until frae switches
          frame_b.move_player(player, x_move, y_move);
        end
      end
    end
  end

  /* Structures for items on screen */
  // Player data
  Player player;
  reg[1:0] has_moved_x = 2'b01; // has_moved_x == 0 : move left, has_moved_x == 1 : stay, has_moved_x == 2 : move right
  reg[1:0] has_moved_y = 2'b01; // has_moved_y == 0 : move down, has_moved_y == 1 : stay, has_moved_y == 2 : move up
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      player.x <= (`H_FRAME_HT) / 2;
      player.y <= (`V_FRAME_HT) / 2;
      has_moved_x <= 0;
      has_moved_y <= 0;
    end else begin
      // Horizontal
        // check if need to move right
        if ((x_move[1:0] == 2'b10) && (has_moved_x != 2'b10)) begin
          if (has_moved_x == 2'b00) begin // was moved left
            has_moved_x <= 2'b01;
          end else begin
            has_moved_x <= 2'b10;
          end
          // move player to right (if possible)
          if ((player.x + (`PLAYER_WIDTH / 2)) < (`H_FRAME_HT - 1)) begin
            player.x <= (player.x + 1);
          end
        end /* check if need to move left */ else if ((x_move[1:0] == 2'b00) && (has_moved_x != 2'b00)) begin
          if (has_moved_x == 2'b01) begin // was moved right
            has_moved_x <= 2'b00;
          end else begin
            has_moved_x <= 2'b01;
          end
          // move player to left (if possible)
          if ((player.x - (`PLAYER_WIDTH / 2)) > 0) begin
            player.x <= (player.x - 1);
          end
        end
    end
  end

  // Frame Modifications

endmodule

`endif // GRAPHICS_DRIVER