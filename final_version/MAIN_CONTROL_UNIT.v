// Module: MainControlUnit
// Description: Generates control signals based on instruction opcode
// Inputs: op - 7-bit operation code
// Outputs: RegWrite, ALUSrc, MemWrite, Branch, Jump - control signals
//          ImmSrc, ALUOp, ResultSrc - 2-bit control lines

module MainControlUnit(
    input  [6:0] op,
    output       RegWrite,
    output       ALUSrc,
    output       MemWrite,
    output       Branch,
    output       Jump,
    output [1:0] ImmSrc,
    output [1:0] ALUOp,
    output [1:0] ResultSrc
);

    assign RegWrite = (op == 7'b0000011 | op == 7'b0110011 | op == 7'b0010011 | op == 7'b1101111) ? 1'b1 : 1'b0;
    assign ImmSrc = (op == 7'b0100011) ? 2'b01 : 
                    (op == 7'b1100011) ? 2'b10 : 
                    (op == 7'b1101111) ? 2'b11 : 2'b00;
    assign ALUSrc = (op == 7'b0000011 | op == 7'b0100011 | op == 7'b0010011) ? 1'b1 : 1'b0;
    assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0;
    assign ResultSrc = (op == 7'b0000011) ? 2'b01 : 
                       (op == 7'b1101111) ? 2'b10 : 2'b00;
    assign Branch = (op == 7'b1100011) ? 1'b1 : 1'b0;
    assign ALUOp = (op == 7'b0110011 | op == 7'b0010011) ? 2'b10 : 
                   (op == 7'b1100011) ? 2'b01 : 2'b00;
    assign Jump = (op == 7'b1101111) ? 1'b1 : 1'b0;

endmodule
