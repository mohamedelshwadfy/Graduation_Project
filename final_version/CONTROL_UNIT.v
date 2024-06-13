module CONTROL_UNIT (
		op,
		RegWrite,
		ImmSrc,
		ALUSrc,
		MemWrite,
		ResultSrc,
		Branch,
		Jump,
		funct3,
		funct7,
		ALUControl
		
	);

    input [6:0]op;
    input funct7; //1bit - 5
    input [2:0]funct3;

    output RegWrite,ALUSrc,MemWrite;
    output [1:0]ImmSrc,ResultSrc;
    output [2:0]ALUControl;
    output Branch;
    output Jump;

    wire [1:0]ALUOp;
    wire Jump , Branch;
    Main_CONTROL_UNIT MAIN_CONTROL_UNIT(
                .Op(op),
                .RegWrite(RegWrite),
                .ImmSrc(ImmSrc),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .Branch(Branch),
                .ALUSrc(ALUSrc),
                .ALUOp(ALUOp),
		        .Jump(Jump)
    );

    ALU_CONTROL_UNIT ALU_CONTROL_UNIT(
                .ALUOp(ALUOp),
                .funct3(funct3),
                .funct7(funct7),
                .op(op[5]),
                .ALUControl(ALUControl)
    );

//assign PCSrc = (Branch & Zero) | Jump;
endmodule
