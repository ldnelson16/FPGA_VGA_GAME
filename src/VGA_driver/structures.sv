typedef struct {
  logic r;
  logic g;
  logic b;
} Pixel;

class Frame;
  // variables
  Pixel frame_data[H_VISIBLE: 0][V_VISIBLE: 0];

  // ctor
  function void new();
    for (int i=0; i<V_VISIBLE; i++) begin
      for (int j=0; j<H_VISIBLE; j++) begin
        frame_data[i][j] = '{r:0, g:0, b:0};
      end
    end
  endfunction

  function void update_pixel(int row, int col, bit r_in, bit g_in, bit b_in);
    frame_data[row][col] = '{r:r_in, g:g_in, b:b_in};
  endfunction

  function Pixel get_pixel(int row, int col);
    return frame_data[row][col];
  endfunction
endclass