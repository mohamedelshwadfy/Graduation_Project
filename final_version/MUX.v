/* Module: mux
   Description: 2-to-1 multiplexer
   Inputs: select - control signal; a, b - 32-bit inputs
   Outputs: out - 32-bit output
*/
module mux #(parameter WIDTH = 32) (
    input              select,
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out
);

    assign out = (select) ? a : b;

endmodule
