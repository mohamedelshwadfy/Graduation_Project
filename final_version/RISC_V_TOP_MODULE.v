// Module: risc_v_core
// Description: RISC-V core top-level module
// Inputs: clock - clock signal; reset - reset signal; rom_data - ROM data; ram_r_data - RAM read data
// Outputs: rom_address - ROM address; ram_address - RAM address; ram_w_data - RAM write data; read_write_ram_en - RAM enable signal

module risc_v_core #(parameter WIDTH = 32) (
    input clock,
    input reset,
    input [WIDTH-1:0] rom_data,
    input [WIDTH-1:0] ram_r_data,
    output [WIDTH-1:0] rom_address,
    output [WIDTH-1:0] ram_address,
    output [WIDTH-1:0] ram_w_data,
    output read_write_ram_en
);

    wire [6:0] op;
    wire reg_write;
    wire [1:0] imm_src;
    wire alu_src;
    wire mem_write;
    wire [1:0] result_src;
    wire [2:0] funct3;
    wire funct7; // 1 bit
    wire [2:0] alu_control;
    wire branch;
    wire jump;

    control_unit control_unit (
        .op(op),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control)
    );

    data_path data_path (
        .clock(clock),
        .reset(reset),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .alu_control(alu_control),
        .result_src(result_src),
        .op(op),
        .funct3(funct3),
        .funct7(funct7),
        .jump(jump),
        .branch(branch),
        .rom_data(rom_data),
        .ram_r_data(ram_r_data),
        .rom_address(rom_address),
        .ram_address(ram_address),
        .ram_w_data(ram_w_data),
        .read_write_ram_en(read_write_ram_en)
    );

endmodule
