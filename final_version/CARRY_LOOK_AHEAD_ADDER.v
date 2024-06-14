// Module: CarryLookAheadAdder
// Description: 32-bit Carry Look-Ahead Adder
// Parameters: WIDTH - Data width, default 32-bit
// Inputs: a, b - 32-bit input lines; cin - Carry input; mode - Mode (used for XOR with b)
// Outputs: sum - 32-bit sum; cout - Carry output

module CarryLookAheadAdder #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    input              mode,
    output [WIDTH-1:0] sum,
    output             cout
);

    wire [WIDTH-1:0] bXor;
    wire c1, c2, c3, c4, c5, c6, c7;

    assign bXor = b ^ {WIDTH{mode}};

    CarryLookAhead4Bit cla1 (.a(a[3:0]),   .b(bXor[3:0]),   .cin(cin), .sum(sum[3:0]),   .cout(c1));
    CarryLookAhead4Bit cla2 (.a(a[7:4]),   .b(bXor[7:4]),   .cin(c1),  .sum(sum[7:4]),   .cout(c2));
    CarryLookAhead4Bit cla3 (.a(a[11:8]),  .b(bXor[11:8]),  .cin(c2),  .sum(sum[11:8]),  .cout(c3));
    CarryLookAhead4Bit cla4 (.a(a[15:12]), .b(bXor[15:12]), .cin(c3),  .sum(sum[15:12]), .cout(c4));
    CarryLookAhead4Bit cla5 (.a(a[19:16]), .b(bXor[19:16]), .cin(c4),  .sum(sum[19:16]), .cout(c5));
    CarryLookAhead4Bit cla6 (.a(a[23:20]), .b(bXor[23:20]), .cin(c5),  .sum(sum[23:20]), .cout(c6));
    CarryLookAhead4Bit cla7 (.a(a[27:24]), .b(bXor[27:24]), .cin(c6),  .sum(sum[27:24]), .cout(c7));
    CarryLookAhead4Bit cla8 (.a(a[31:28]), .b(bXor[31:28]), .cin(c7),  .sum(sum[31:28]), .cout(cout));

endmodule
