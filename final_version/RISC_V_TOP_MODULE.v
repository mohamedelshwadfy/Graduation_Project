// Module: RiscVCore
// Description: RISC-V core top-level module
// Inputs: CLOCK - clock signal; RESET - reset signal; rom_data - ROM data; ram_r_data - RAM read data
// Outputs: rom_address - ROM address; ram_address - RAM address; ram_w_data - RAM write data; Read_Write_ram_en - RAM enable signal

module RiscVCore #(parameter WIDTH = 32) (
    input CLOCK,
    input RESET,
    input [WIDTH - 1 : 0] rom_data,
    input [WIDTH - 1 : 0] ram_r_data,
    output [WIDTH - 1 : 0] rom_address,
    output [WIDTH - 1 : 0] ram_address,
    output [WIDTH - 1 : 0] ram_w_data,
    output Read_Write_ram_en
);

wire [6 : 0] op;
wire RegWrite;
wire [1 : 0] ImmSrc;
wire ALUSrc;
wire MemWrite;
wire [1 : 0] ResultSrc;
wire [2 : 0] funct3;
wire funct7; // 1 bit
wire [2 : 0] ALUControl;
wire Branch;
wire Jump;

ControlUnit control_unit (
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

DataPath data_path (
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
