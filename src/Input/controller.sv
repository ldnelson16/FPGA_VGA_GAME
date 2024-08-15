`ifndef INPUT_CONTROLLER
`define INPUT_CONTROLLER

module input_controller (
    input wire L, 
    input wire R, 
    input wire jump,
    output[1:0] wire hori, 
    output[1:0] wire vert
);
    assign hori = (L ~^ R) ? 2'b01 : 
                    (L) ? 2'b00 : 2'b10;

    assign vert = (jump) ? 2'b10 : 2'b01;
endmodule

`ENDIF // INPUT_CONTROLLER