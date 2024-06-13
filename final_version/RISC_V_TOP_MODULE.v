module RISC_V_TOP_MODULE #(parameter WIDTH = 32) (
		CLOCK,
		RESET,
		rom_data,
		ram_r_data,
		rom_address,
		ram_address,
		ram_w_data,
		Read_Write_ram_en
	);

input CLOCK;
input RESET;
input  [ WIDTH - 1 : 0 ] rom_data;
input  [ WIDTH - 1 : 0 ] ram_r_data;

output [ WIDTH - 1 : 0 ] rom_address;
output [ WIDTH - 1 : 0 ] ram_address;
output [ WIDTH - 1 : 0 ] ram_w_data;
output Read_Write_ram_en;

wire [ 6 : 0 ] op;
wire RegWrite;
wire [1 : 0] ImmSrc;
wire ALUSrc;
wire MemWrite;
wire [ 1 : 0 ]ResultSrc;
wire [ 2 : 0 ] funct3;
wire funct7; //1bit
wire [ 2 : 0]ALUControl;
wire Branch;
wire Jump;

CONTROL_UNIT  CONTROL_UNIT(
		.op(op),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.MemWrite(MemWrite),
		.ResultSrc(ResultSrc),
		.Branch(Branch),
		.Jump(Jump),
		.funct3(funct3),
		.funct7(funct7),
		.ALUControl(ALUControl)
		
	);

DATA_PATH DATA_PATH (
		.CLOCK(CLOCK),
		.RESET(RESET),
		.RegWrite(RegWrite),
		.immsrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.MemWrite(MemWrite),
		.ALUControl(ALUControl),
		.ResultSrc(ResultSrc),
		.Op(op),
		.funct3(funct3),
		.funct7(funct7),
		.Jump(Jump),
		.Branch(Branch),
		.rom_data(rom_data),
		.ram_r_data(ram_r_data),
		.rom_address(rom_address),
		.ram_address(ram_address),
		.ram_w_data(ram_w_data),
		.Read_Write_ram_en(Read_Write_ram_en)
	);
	
endmodule 