// Module: ALUControlUnit
// Description: Generates ALU control lines based on instruction
// Inputs: aluOp - 2-bit operation from main control unit; funct3 - 3-bit function code; funct7 - 1-bit function code; op - 1-bit operation code
// Outputs: aluControl - 3-bit control line to ALU unit

module ALUControlUnit (
    input  [1:0] aluOp,
    input  [2:0] funct3,
    input        funct7,
    input        op,
    output [2:0] aluControl
);

    assign aluControl = (aluOp == 2'b00) ? 3'b000 :
                        (aluOp == 2'b01) ? 3'b001 :
                        ((aluOp == 2'b10) & (funct3 == 3'b000) & ({op, funct7} == 2'b11)) ? 3'b001 :
                        ((aluOp == 2'b10) & (funct3 == 3'b000) & ({op, funct7} != 2'b11)) ? 3'b000 :
                        ((aluOp == 2'b10) & (funct3 == 3'b010)) ? 3'b101 :
                        ((aluOp == 2'b10) & (funct3 == 3'b110)) ? 3'b011 :
                        ((aluOp == 2'b10) & (funct3 == 3'b111)) ? 3'b010 :
                        3'b000;

endmodule
