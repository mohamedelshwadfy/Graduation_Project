// Module: MUX3
// Description: 3-to-1 multiplexer
// Inputs: select - 2-bit control signal; A, B, C - 32-bit inputs
// Outputs: OUT - 32-bit output

module MUX3 #(parameter WIDTH = 32) (
    input  [1:0] select,
    input  [WIDTH - 1 : 0] A,
    input  [WIDTH - 1 : 0] B,
    input  [WIDTH - 1 : 0] C,
    output reg [WIDTH - 1 : 0] OUT
);

always @(*) begin
    case(select)
        2'b00 : OUT = A;
        2'b01 : OUT = B;
        2'b10 : OUT = C;
        default : OUT = 32'h00000000;
    endcase
end

endmodule
