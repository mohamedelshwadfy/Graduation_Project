/* Module: ALU
   Description: Arithmetic and Logic Unit (ALU) for the processor
   Parameters: WIDTH - Data width, default 32-bit; CTRL_WIDTH - Control width, default 3-bit
   Inputs: aluControl - 3-bit control line; a, b - 32-bit source lines
   Outputs: aluResult - 32-bit result; carry - Carry flag; overflow - Overflow flag; zero - Zero flag
*/   

module ALU #(parameter WIDTH = 32, parameter CTRL_WIDTH = 3) (
    input  [CTRL_WIDTH-1:0]  alu_control,
    input  [WIDTH-1:0]       a,
    input  [WIDTH-1:0]       b,
    output [WIDTH-1:0]       alu_result,
    output                   carry,
    output                   over_flow,
    output                   zero
);

    wire   [WIDTH-1:0]       alu_result_temp;
    wire                     carry_temp;
    reg                      mode;

    CarryLookAheadAdder #(.WIDTH(WIDTH)) adder (
        .a(a),
        .b(b),
        .cin(mode),
        .sum(alu_result_temp),
        .cout(carry_temp)
    );

    always @(*) begin
        case (alu_control)         //alu control signal decoding
            3'b000: begin         // ADD
                mode = 1'b0;
                alu_result = alu_result_temp;
                carry = carry_temp;
            end
            3'b001: begin         // SUB
                mode = 1'b1;
                alu_result = alu_result_temp;
                carry = carry_temp;
            end
            3'b010: begin         // AND
                mode = 1'b0;
                alu_result = a & b;
                carry = 1'b0;
            end
            3'b011: begin         // OR
                mode = 1'b0;
                alu_result = a | b;
                carry = 1'b0;
            end
            3'b100: begin         // XOR
                mode = 1'b0;
                alu_result = a ^ b;
                carry = 1'b0;
            end
            3'b101: begin         // SLT
                mode = 1'b0;
                alu_result = (a < b) ? 32'h00000001 : 32'h00000000;
                carry = 1'b0;
            end
            3'b110: begin         // SLL
                mode = 1'b0;
                alu_result = a << b;
                carry = 1'b0;
            end
            3'b111: begin         // SRL
                mode = 1'b0;
                alu_result = a >> b;
                carry = 1'b0;
            end
            default: begin
                mode = 1'b0;
                alu_result = 32'hxxxx_xxxx;
                carry = 1'bx;
            end
        endcase
    end

    assign over_flow = ((alu_result[31] ^ a[31]) & (~(alu_control[0] ^ b[31] ^ a[31])) & (~alu_control[1]));
    assign zero = &(~alu_result);

endmodule
