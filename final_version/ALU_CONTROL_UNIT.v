/* Module: ALUControlUnit
   Description: Generates ALU control lines based on instruction
   Inputs: aluOp - 2-bit operation from main control unit; funct3 - 3-bit function code; funct7 - 1-bit function code; op - 1-bit operation code
   Outputs: aluControl - 3-bit control line to ALU unit 
*/
module ALUControlUnit (
   input  [1:0]  alu_op,
   input  [2:0]  funct3,
   input         funct7,
   input         op,
   output [2:0]  alu_control
);

   assign alu_control = (alu_op == 2'b00) ? 3'b000 : //ADD
      (alu_op == 2'b01) ? 3'b001 :  //SUB
      ((alu_op == 2'b10) & (funct3 == 3'b000) & ({op, funct7} == 2'b11)) ? 3'b001 : //SUB
      ((alu_op == 2'b10) & (funct3 == 3'b000) & ({op, funct7} != 2'b11)) ? 3'b000 : //ADD
      ((alu_op == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : //SLT
      ((alu_op == 2'b10) & (funct3 == 3'b110)) ? 3'b011 : //OR 
      ((alu_op == 2'b10) & (funct3 == 3'b111)) ? 3'b010 : //AND
      ((alu_op == 2'b10) & (funct3 == 3'b100)) ? 3'b100 : //XOR
      ((alu_op == 2'b10) & (funct3 == 3'b001)) ? 3'b110 : //SLL
      ((alu_op == 2'b10) & (funct3 == 3'b101)) ? 3'b111 : //SRL
                         3'b000;

endmodule
