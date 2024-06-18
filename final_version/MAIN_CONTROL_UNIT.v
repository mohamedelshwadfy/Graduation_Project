// Module: main_control_unit
// Description: Generates control signals based on instruction opcode
// Inputs: op - 7-bit operation code
// Outputs: reg_write, alu_src, mem_write, branch, jump - control signals
//          imm_src, alu_op, result_src - 2-bit control lines

module main_control_unit (
    input  [6:0] op,
    output       reg_write,
    output       alu_src,
    output       mem_write,
    output       branch,
    output       jump,
    output [1:0] imm_src,
    output [1:0] alu_op,
    output [1:0] result_src
);

    assign reg_write = (op == 7'b0000011 || op == 7'b0110011 || op == 7'b0010011 || op == 7'b1101111) ? 1'b1 : 1'b0;
    assign imm_src = (op == 7'b0100011) ? 2'b01 : 
                     (op == 7'b1100011) ? 2'b10 : 
                     (op == 7'b1101111) ? 2'b11 : 2'b00;
    assign alu_src = (op == 7'b0000011 || op == 7'b0100011 || op == 7'b0010011) ? 1'b1 : 1'b0;
    assign mem_write = (op == 7'b0100011) ? 1'b1 : 1'b0;
    assign result_src = (op == 7'b0000011) ? 2'b01 : 
                        (op == 7'b1101111) ? 2'b10 : 2'b00;
    assign branch = (op == 7'b1100011) ? 1'b1 : 1'b0;
    assign alu_op = (op == 7'b0110011 || op == 7'b0010011) ? 2'b10 : 
                    (op == 7'b1100011) ? 2'b01 : 2'b00;
    assign jump = (op == 7'b1101111) ? 1'b1 : 1'b0;

endmodule
