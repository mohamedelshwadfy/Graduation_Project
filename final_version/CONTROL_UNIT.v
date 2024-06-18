/* Module: ControlUnit
   Description: Main control unit
   Inputs: op - 7-bit opcode; funct3 - 3-bit function code; funct7 - 1-bit function code
   Outputs: RegWrite - Register write enable; ALUSrc - ALU source select; MemWrite - Memory write enable
            ImmSrc - Immediate source select; ResultSrc - Result source select; Branch - Branch signal; Jump - Jump signal
            ALUControl - ALU control signals
*/
module ControlUnit ( op , funct7 , funct3 , reg_write , alu_src , mem_write , imm_src , result_src , alu_control , branch , jump );
   input  [6:0]  op;
    input         funct7;
    input  [2:0]  funct3;
    output        reg_write;
    output        alu_src;
    output        mem_write;
    output [1:0]  imm_src;
    output [1:0]  result_src;
    output [2:0]  alu_control;
    output        branch;
    output        jump;

    wire   [1:0]  alu_op;

    //instantiation of Main Control Unit module
    MainControlUnit mainControl (
        .op(op),
        .reg_write(Reg_write),
        .imm_src(imm_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .jump(jump)
    );

    //instantiation of ALU Control Unit module
    ALUControlUnit aluControl (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .op(op[5]),
        .alu_control(alu_control)
    );

endmodule
