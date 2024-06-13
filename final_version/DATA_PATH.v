/*
	module name : DATA_PATH
	module inputs : 
				- CLOCK : the global clock signal system
				- RESET : the global reset signal system
				- PCSrc : 1-bit control signal
				- RegWrite : 1-bit control signal
				- immsrc : 2-bit control signal
				- ALUSrc : 1-bit control signal
				- MemWrite : 1-bit control signal
				- ALUControl : 3-bit control signal
				- ResultSrc : 3-bit control signal
				
	module outputs :
				- Op : the operation code of the type  7-bit
				- funct3 : the function bits 3-bit
				- funct7 : the function bits 7-bit
				- Zero : the zero flage
	module function : 
				- this module is contains the whole data path elements 
*/
module DATA_PATH #(parameter WIDTH = 32 )(
		CLOCK,
		RESET,
		Branch,
		Jump,
		RegWrite,
		immsrc,
		ALUSrc,
		MemWrite,
		ALUControl,
		ResultSrc,
		Op,
		funct3,
		funct7,
		rom_data,
		ram_r_data,
		rom_address,
		ram_address,
		ram_w_data,
		Read_Write_ram_en
	);

// input declaration

input CLOCK;
input RESET;
input Branch;
input Jump;
input RegWrite;
input [1:0] immsrc;
input ALUSrc;
input MemWrite;
input[ 2 : 0 ] ALUControl;
input [ 1  : 0 ] ResultSrc;
input [ WIDTH - 1 : 0 ] rom_data;
input [ WIDTH - 1 : 0 ] ram_r_data;
//output declaration

output [ 6  : 0  ] Op;
output [ 14 : 12 ] funct3;
output  funct7;//1bit
output [ WIDTH - 1 : 0  ] rom_address;
output [ WIDTH - 1 : 0  ] ram_address;
output [ WIDTH - 1 : 0  ] ram_w_data;
output Read_Write_ram_en;

//Internal Signals

wire [ WIDTH - 1 : 0] PCTarget;
wire [ WIDTH - 1 : 0] PCPlus4;
wire [ WIDTH - 1 : 0] PC_next;
//wire [ WIDTH - 1 : 0] PC;
//wire [ WIDTH - 1 : 0] INSTRUCTION;
wire [ WIDTH - 1 : 0] PC_ID;
wire [ WIDTH - 1 : 0] INSTRUCTION_ID;
wire [ WIDTH - 1 : 0] PCPlus4_ID;
wire [ WIDTH - 1 : 0] ImmExt;
wire [ WIDTH - 1 : 0] Result;
wire [ WIDTH - 1 : 0] SrcA;
wire [ WIDTH - 1 : 0] READ_DATA_2;
wire [ WIDTH - 1 : 0] SrcA_EX;
wire [ WIDTH - 1 : 0] READ_DATA_2_EX;
wire [ WIDTH - 1 : 0] PC_EX;
wire [ WIDTH - 1 : 0] ImmExt_EX;
wire [ WIDTH - 1 : 0] PCPlus4_EX;
wire [ WIDTH - 1 : 0] SrcB;
wire [ WIDTH - 1 : 0] ALUResult;
//wire [ WIDTH - 1 : 0] ALUResult_M;
wire [ WIDTH - 1 : 0] READ_DATA_WB;
//wire [ WIDTH - 1 : 0] READ_DATA_2_M;
wire [ WIDTH - 1 : 0] PCPlus4_M;
//wire [ WIDTH - 1 : 0] READ_DATA;
wire [ WIDTH - 1 : 0] ALUResult_WB;
wire [ WIDTH - 1 : 0] PCPlus4_WB;
wire [ WIDTH - 1 : 0] READ_DATA_1_EX;
wire [ WIDTH - 1 : 0] READ_DATA_2_EX_mux;
wire [ 11 : 7 ] Rd_EX;
wire [ 11 : 7 ] Rd_M;
wire [ 11 : 7 ] Rd_WB;
wire [ 24 : 20 ] Rs2E;
wire [ 19 : 15 ] Rs1E;
wire [ 2 : 0 ] ALUControl_EX;
wire [ 1 : 0 ] ResultSrc_EX;
wire [ 1 : 0 ] ResultSrc_M;
wire [ 1 : 0 ] ResultSrc_WB;
wire [ 1 : 0 ] ForwardAE;
wire [ 1 : 0 ] ForwardBE;
wire Stall_F;
wire Stall_D;
wire Flush_D;
wire Flush_E;
//wire MemWrite_M;
wire RegWrite_WB;
wire RegWrite_EX;
wire PCSrc;
wire RegWrite;
wire MemWrite;
wire MemWrite_EX;
wire Jump;
wire Jump_EX;
wire Branch;
wire Branch_EX;
wire ALUSrc;
wire ALUSrc_EX;
wire Zero;
wire RegWrite_M;

//assign rom_address = PC;
//assign INSTRUCTION = rom_data;
//assign ram_address = ALUResult_M;
//assign Read_Write_ram_en = MemWrite_M;
//assign ram_w_data = READ_DATA_2_M;
//assign READ_DATA = ram_r_data;

// Instruction Fetch stage ( IF )

 MUX MUX0 (
		.select(PCSrc),
		.A(PCTarget),
		.B(PCPlus4),
		.OUT(PC_next)
	);


(* KEEP = "true" *)PROGRAM_COUNTER PROGRAM_COUNTER (
		.CLK(CLOCK),
		.Reset(RESET),
		.PC_next(PC_next),
		.PC(rom_address),
        .En(Stall_F)
	);
// we will use an external memroy
/* 
INSTRUCTION_MEMORY INSTRUCTION_MEMORY (
			.ADDRESS(PC),
			.INSTRUCTION(INSTRUCTION)
	);
*/

ADDER ADDER0 (
		.A(rom_address),
		.B(32'h0000_0004),
		.OUTPUT(PCPlus4)
	);

// IF / ID Registers 

(* KEEP = "true" *) REG PC_IF_ID ( .rst( RESET ) , .clk( CLOCK ), .INPUT( rom_address ) , .OUT( PC_ID ) , .EN( Stall_D ) , .CLR( Flush_D ) );
(* KEEP = "true" *) REG INST_IF_ID ( .rst( RESET ) , .clk( CLOCK ), .INPUT( rom_data ) , .OUT( INSTRUCTION_ID ) , .EN( Stall_D ) , .CLR( Flush_D ) );
(* KEEP = "true" *) REG PCPlus4_IF_ID ( .rst( RESET ) , .clk( CLOCK ), .INPUT( PCPlus4 ) , .OUT( PCPlus4_ID ) , .EN( Stall_D ) , .CLR( Flush_D ) );

// Instruction Decod Stage ( ID )

(* KEEP = "true" *) REGISTER_FILE REGISTER_FILE (
		.CLK(CLOCK),
		.RESET(RESET),
		.WRITE_ENABLE(RegWrite_WB),//come from WB
		.ADDRESS_1(INSTRUCTION_ID[ 19 : 15 ]),
		.ADDRESS_2(INSTRUCTION_ID[ 24 : 20 ]),
		.ADDRESS_3(Rd_WB), // come from WB
		.WRITE_DATA(Result), //come from WB
		.READ_DATA_1(SrcA),
		.READ_DATA_2(READ_DATA_2)
	);

SIGN_EXTEND  SIGN_EXTEND (
		.INSTRUCTION(INSTRUCTION_ID[ 31 : 7 ] ),
		.immsrc(immsrc),
		.OUTPUT_EXTENDED(ImmExt)
	);

assign Op = INSTRUCTION_ID [ 6 : 0 ];

assign funct3 = INSTRUCTION_ID [ 14 : 12 ];

assign funct7 = INSTRUCTION_ID [30];


// ID/EX Registers

REG #(.WIDTH(1) ) RigWrite_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(RegWrite) , .OUT(RegWrite_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(2) ) ResultScr_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(ResultSrc) , .OUT(ResultSrc_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(1) ) MemWrite_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(MemWrite) , .OUT(MemWrite_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(1) ) Jump_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(Jump) , .OUT(Jump_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(1) ) Branch_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(Branch) , .OUT(Branch_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(3) ) ALUControl_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(ALUControl) , .OUT(ALUControl_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(1) ) ALUSrc_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(ALUSrc) , .OUT(ALUSrc_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG SrcA_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(SrcA) , .OUT(READ_DATA_1_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG READ_DATA_2_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(READ_DATA_2) , .OUT(READ_DATA_2_EX) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG PC_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(PC_ID) , .OUT(PC_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(5) ) Rd_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(INSTRUCTION_ID[ 11 : 7]) , .OUT(Rd_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG ImmExt_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(ImmExt) , .OUT(ImmExt_EX ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG PCPlus4_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(PCPlus4_ID) , .OUT(PCPlus4_EX) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(5) ) INSTRUCTION_ID1 (.rst(RESET) , .clk(CLOCK), .INPUT(INSTRUCTION_ID[ 19 : 15 ]) , .OUT(Rs1E) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(5) ) INSTRUCTION_ID2 (.rst(RESET) , .clk(CLOCK), .INPUT(INSTRUCTION_ID[ 24 : 20 ]) , .OUT(Rs2E) , .EN( 1'b0 ) , .CLR( Flush_E ) );
/*
REG #(.WIDTH(3) ) ForwardAE_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(MemWrite) , .OUT(ForwardAE ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
REG #(.WIDTH(3) ) ForwardBE_ID_EX (.rst(RESET) , .clk(CLOCK), .INPUT(MemWrite) , .OUT(ForwardBE ) , .EN( 1'b0 ) , .CLR( Flush_E ) );
*/

// Instruction Excute Stage ( EX )

MUX_3 MUX6 (
		.select(ForwardAE),
		.A(READ_DATA_1_EX),
		.B(Result),
		.C(ram_address),
		.OUT(SrcA_EX)
	);


MUX_3 MUX7 (
		.select(ForwardBE),
		.A(READ_DATA_2_EX),
		.B(Result),
		.C(ram_address),
		.OUT(READ_DATA_2_EX_mux)
	);


ADDER ADDER1 (
		.A(PC_EX),
		.B(ImmExt_EX),
		.OUTPUT(PCTarget)
	);


MUX MUX1 (
		.select(ALUSrc_EX),
		.A(ImmExt_EX),
		.B(READ_DATA_2_EX_mux),
		.OUT(SrcB)
	);



ALU ALU (
		.ALUControl(ALUControl_EX),
		.A(SrcA_EX),
		.B(SrcB),
		.ALUResult(ALUResult),
		.C(),
		.O(),
		.Z(Zero)
	);

assign PCSrc = ( Branch_EX & Zero ) | Jump_EX ;

// EX/M Registers 

REG #(.WIDTH(1) ) RigWrite_EX_M (.rst(RESET) , .clk(CLOCK), .INPUT(RegWrite_EX) , .OUT(RegWrite_M) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG #(.WIDTH(2) ) ResultScr_EX_M (.rst(RESET) , .clk(CLOCK), .INPUT(ResultSrc_EX) , .OUT(ResultSrc_M) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG #(.WIDTH(1) ) MemWrite_EX_M (.rst(RESET) , .clk(CLOCK), .INPUT(MemWrite_EX) , .OUT(Read_Write_ram_en) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG ALUResult_EX_M (.rst(RESET) , .clk(CLOCK), .INPUT(ALUResult) , .OUT(ram_address) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG READ_DATA_2_EX_M (.rst(RESET) , .clk(CLOCK), .INPUT(READ_DATA_2_EX_mux) , .OUT(ram_w_data) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG #(.WIDTH(5) ) Rd_EX_M (.rst(RESET) , .clk(CLOCK), .INPUT(Rd_EX) , .OUT(Rd_M ) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG PCPlus4_EX_M (.rst(RESET) , .clk(CLOCK), .INPUT(PCPlus4_EX) , .OUT(PCPlus4_M ) , .EN( 1'b0 ) , .CLR( 1'b0 ) );

// Memory Stage

// we will use external data memory
/*
DATA_MEMORY DATA_MEMORY(
		.CLK(CLOCK),
		.RESET(RESET),
		.ADDRESS(ALUResult_M),
		.WRITE_READ(MemWrite_M),
		.WRITE_DATA(READ_DATA_2_M), 
		.READ_DATA(READ_DATA) 
	);
*/

// M/WB Registers 

REG #(.WIDTH(1) ) RigWrite_M_WB (.rst(RESET) , .clk(CLOCK), .INPUT(RegWrite_M) , .OUT(RegWrite_WB) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG #(.WIDTH(2) ) ResultScr_M_WB (.rst(RESET) , .clk(CLOCK), .INPUT(ResultSrc_M) , .OUT(ResultSrc_WB) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG ALUResult_M_WB (.rst(RESET) , .clk(CLOCK), .INPUT(ram_address) , .OUT(ALUResult_WB) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG READ_DATA_M_WB (.rst(RESET) , .clk(CLOCK), .INPUT(ram_r_data) , .OUT(READ_DATA_WB) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG #(.WIDTH(5) ) Rd_M_WB (.rst(RESET) , .clk(CLOCK), .INPUT(Rd_M) , .OUT(Rd_WB ) , .EN( 1'b0 ) , .CLR( 1'b0 ) );
REG PCPlus4_M_WB (.rst(RESET) , .clk(CLOCK), .INPUT(PCPlus4_M) , .OUT(PCPlus4_WB ) , .EN( 1'b0 ) , .CLR( 1'b0 ) );


// WriteBack stage (WB)

MUX_3 MUX_3 (
		.select(ResultSrc_WB),
		.A(ALUResult_WB),
		.B(READ_DATA_WB),
		.C(PCPlus4_WB),
		.OUT(Result)
	);
// hazard unit

hazard_unit hazard (
                      .rst(RESET),
                      .RegWriteM(RegWrite_M),
                      .RegWriteW(RegWrite_WB),
                      .ResultsrcE0(ResultSrc_EX[0]),
                      .PcsrcE(PCSrc),
                      .RD_M(Rd_M),
                      .RD_W(Rd_WB),
                      .Rs1_E(Rs1E),
                      .Rs2_E(Rs2E),
                      .Rs_1D(INSTRUCTION_ID[ 19 : 15 ]),
                      .Rs_2D(INSTRUCTION_ID[ 24 : 20 ]),
                      .RDE(Rd_EX),
                      .Stall_F(Stall_F),
                      .Stall_D(Stall_D),
                      .Flush_E(Flush_E),
                      .Flush_D(Flush_D),
                      .ForwardAE(ForwardAE),
                      .ForwardBE(ForwardBE)
                   );
endmodule 