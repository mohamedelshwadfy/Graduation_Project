// Module: ControlUnit
// Description: Main control unit
// Inputs: op - 7-bit opcode; funct3 - 3-bit function code; funct7 - 1-bit function code
// Outputs: RegWrite - Register write enable; ALUSrc - ALU source select; MemWrite - Memory write enable
//          ImmSrc - Immediate source select; ResultSrc - Result source select; Branch - Branch signal; Jump - Jump signal
//          ALUControl - ALU control signals

module ControlUnit (
    input  [6:0] op,
    input        funct7,
    input  [2:0] funct3,
    output       RegWrite,
    output       ALUSrc,
    output       MemWrite,
    output [1:0] ImmSrc,
    output [1:0] ResultSrc,
    output [2:0] ALUControl,
    output       Branch,
    output       Jump
);

    wire [1:0] ALUOp;

    MainControlUnit mainControl (
        .op(op),
        .regWrite(RegWrite),
        .immSrc(ImmSrc),
        .memWrite(MemWrite),
        .resultSrc(ResultSrc),
        .branch(Branch),
        .aluSrc(ALUSrc),
        .aluOp(ALUOp),
        .jump(Jump)
    );

    ALUControlUnit aluControl (
        .aluOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(op[5]),
        .aluControl(ALUControl)
    );

endmodule
