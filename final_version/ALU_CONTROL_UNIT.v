/*
	module name : ALU_CONTROL_UNIT
	module inputs : 
				- ALUOp : the alu opearation that came from main control unit 2-bit
				- funct3 : function code from instruction 3-bit
				- funct7 : function code from instruction 7-bit
				- op : the operation code from instruction 7-bit
				
	module outputs :
				- ALUControl : the control lines to the alu unit  3-bit
	module function : 
				- this module generate the alu control lines to the alu unit due to the instruction 
*/
module ALU_CONTROL_UNIT(
		ALUOp,
		funct3,
		funct7,
		op,
		ALUControl
	);
// input declaration	
input [1:0]ALUOp;
input [2:0]funct3;
input funct7,op; //bit5
// output declaration
output [2:0]ALUControl;

assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :
                        (ALUOp == 2'b01) ? 3'b001 :
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ( {op,funct7} == 2'b11)) ? 3'b001 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ( {op,funct7} != 2'b11)) ? 3'b000 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? 3'b011 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? 3'b010 : 
                                                                  3'b000 ;
endmodule
