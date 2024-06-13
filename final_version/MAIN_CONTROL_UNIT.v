module Main_CONTROL_UNIT(
		Op,
		RegWrite,
		ImmSrc,
		ALUSrc,
		MemWrite,
		ResultSrc,
		Branch,
		ALUOp,
		Jump
	);
input [6:0]Op;
output RegWrite;
output ALUSrc;
output MemWrite;
output Branch;
output [1:0] ImmSrc;
output [1:0] ALUOp;
output [ 1 : 0 ] ResultSrc;
output Jump;
/*
reg [10:0] controls;
assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
ResultSrc, Branch, ALUOp, Jump} = controls;
always @(*) 
case(Op)
// RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
7'b0000011: controls = 11'b1_00_1_0_01_0_00_0; // lw
7'b0100011: controls = 11'b0_01_1_1_00_0_00_0; // sw
7'b0110011: controls = 11'b1_xx_0_0_00_0_10_0; // R–type
7'b1100011: controls = 11'b0_10_0_0_00_1_01_0; // beq
7'b0010011: controls = 11'b1_00_1_0_00_0_10_0; // I–type ALU
7'b1101111: controls = 11'b1_11_0_0_10_0_00_1; // jal
default: controls = 11'bx_xx_x_x_xx_x_xx_x; // ???
endcase
*/
    assign RegWrite = (Op == 7'b0000011 | Op == 7'b0110011 | Op == 7'b0010011 | Op == 7'b1101111) ? 1'b1 :
                                                              1'b0 ;
    assign ImmSrc = (Op == 7'b0100011) ? 2'b01 : 
                   	      (Op == 7'b1100011) ? 2'b10 : 
		              (Op == 7'b1101111) ? 2'b11 :   
                                         2'b00 ;
    assign ALUSrc = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011) ? 1'b1 :
                                                            1'b0 ;
    assign MemWrite = (Op == 7'b0100011) ? 1'b1 : 1'b0 ;

    assign ResultSrc = (Op == 7'b0000011 ) ? 2'b01 :
				 (Op == 7'b1101111 ) ? 2'b10 :
                                            2'b00 ;
    assign Branch = (Op == 7'b1100011) ? 1'b1 :
                                         1'b0 ;
    assign ALUOp = (Op == 7'b0110011 | Op == 7'b0010011) ? 2'b10 :
                   (Op == 7'b1100011) ? 2'b01 :
                                        2'b00 ;
   assign Jump = (Op == 7'b1101111) ? 1'b1 : 1'b0 ;

endmodule