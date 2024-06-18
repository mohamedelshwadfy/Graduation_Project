/* Module: CarryLookAheadAdder
   Description: 32-bit Carry Look-Ahead Adder
   Parameters: WIDTH - Data width, default 32-bit
   Inputs: a, b - 32-bit input lines; cin - Carry input; mode - Mode (used for XOR with b)
   Outputs: sum - 32-bit sum; cout - Carry output
*/
module CarryLookAheadAdder #(parameter WIDTH = 32) (
    input  [WIDTH-1:0]  a,
    input  [WIDTH-1:0]  b,
    input               cin,
    input               mode,
    output [WIDTH-1:0]  sum,
    output              cout
);
    wire   [WIDTH-1:0]  b_xor;
    wire                c1;
    wire                c2;
    wire                c3;
    wire                c4;
    wire                c5;
    wire                c6;
    wire                c7;

    assign b_xor = b ^ {WIDTH{mode}};
    
    //instantiation of 4-bit carry look _ahead adders
    CarryLookAhead4Bit cla1 (.a(a[3:0]),   .b(b_xor[3:0]),   .cin(cin), .sum(sum[3:0]),   .cout(c1));
    CarryLookAhead4Bit cla2 (.a(a[7:4]),   .b(b_xor[7:4]),   .cin(c1),  .sum(sum[7:4]),   .cout(c2));
    CarryLookAhead4Bit cla3 (.a(a[11:8]),  .b(b_xor[11:8]),  .cin(c2),  .sum(sum[11:8]),  .cout(c3));
    CarryLookAhead4Bit cla4 (.a(a[15:12]), .b(b_xor[15:12]), .cin(c3),  .sum(sum[15:12]), .cout(c4));
    CarryLookAhead4Bit cla5 (.a(a[19:16]), .b(b_xor[19:16]), .cin(c4),  .sum(sum[19:16]), .cout(c5));
    CarryLookAhead4Bit cla6 (.a(a[23:20]), .b(b_xor[23:20]), .cin(c5),  .sum(sum[23:20]), .cout(c6));
    CarryLookAhead4Bit cla7 (.a(a[27:24]), .b(b_xor[27:24]), .cin(c6),  .sum(sum[27:24]), .cout(c7));
    CarryLookAhead4Bit cla8 (.a(a[31:28]), .b(b_xor[31:28]), .cin(c7),  .sum(sum[31:28]), .cout(cout));

endmodule
