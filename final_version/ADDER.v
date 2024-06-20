/* Module: Adder
   Description: Adds two numbers and ignores the carry out
   Parameters: WIDTH - Line width, default 32-bit
   Inputs: a, b - 32-bit lines
   Outputs: y - 32-bit line
*/
module adder #(parameter WIDTH = 32) ( 
   input  [WIDTH-1:0] a,
   input  [WIDTH-1:0] b,
   output [WIDTH-1:0] y
);
    assign y = a + b;

endmodule
