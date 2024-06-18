// Module: mux3
// Description: 3-to-1 multiplexer
// Inputs: select - 2-bit control signal; a, b, c - 32-bit inputs
// Outputs: out - 32-bit output

module mux3 #(parameter WIDTH = 32) (
    input [1:0] select,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    output reg [WIDTH-1:0] out
);

    always @(*) begin
        case(select)
            2'b00 : out = a;
            2'b01 : out = b;
            2'b10 : out = c;
            default : out = 32'h00000000;
        endcase
    end

endmodule
