// Module: MUX
// Description: 2-to-1 multiplexer
// Inputs: select - control signal; A, B - 32-bit inputs
// Outputs: OUT - 32-bit output

module MUX #(parameter WIDTH = 32) (
    input  select,
    input  [WIDTH - 1 : 0] A,
    input  [WIDTH - 1 : 0] B,
    output [WIDTH - 1 : 0] OUT
);

assign OUT = (select) ? A : B;

endmodule
