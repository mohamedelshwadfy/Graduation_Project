// Module: data_path
// Description: Contains the whole data path elements
// Inputs: clock - global clock signal system; reset - global reset signal system; pc_src - 1-bit control signal
//         reg_write - 1-bit control signal; imm_src - 2-bit control signal; alu_src - 1-bit control signal
//         mem_write - 1-bit control signal; alu_control - 3-bit control signal; result_src - 2-bit control signal
//         rom_data - ROM data; ram_r_data - RAM read data
// Outputs: op - operation code of the type; funct3 - function bits; funct7 - function bit; zero - zero flag
//          rom_address - ROM address; ram_address - RAM address; ram_w_data - RAM write data; read_write_ram_en - RAM enable signal

module data_path #(parameter WIDTH = 32) (
    input              clock,
    input              reset,
    input              branch,
    input              jump,
    input              reg_write,
    input  [1:0]       imm_src,
    input              alu_src,
    input              mem_write,
    input  [2:0]       alu_control,
    input  [1:0]       result_src,
    input  [WIDTH-1:0] rom_data,
    input  [WIDTH-1:0] ram_r_data,
    output [6:0]       op,
    output [2:0]       funct3,
    output             funct7,
    output [WIDTH-1:0] rom_address,
    output [WIDTH-1:0] ram_address,
    output [WIDTH-1:0] ram_w_data,
    output             read_write_ram_en
);

    // Internal signals
    wire [WIDTH-1:0] pc_target;
    wire [WIDTH-1:0] pc_plus4;
    wire [WIDTH-1:0] pc_next;
    wire [WIDTH-1:0] pc_id;
    wire [WIDTH-1:0] instruction_id;
    wire [WIDTH-1:0] pc_plus4_id;
    wire [WIDTH-1:0] imm_ext;
    wire [WIDTH-1:0] result;
    wire [WIDTH-1:0] src_a;
    wire [WIDTH-1:0] read_data_2;
    wire [WIDTH-1:0] src_a_ex;
    wire [WIDTH-1:0] read_data_2_ex;
    wire [WIDTH-1:0] pc_ex;
    wire [WIDTH-1:0] imm_ext_ex;
    wire [WIDTH-1:0] pc_plus4_ex;
    wire [WIDTH-1:0] src_b;
    wire [WIDTH-1:0] alu_result;
    wire [WIDTH-1:0] read_data_wb;
    wire [WIDTH-1:0] pc_plus4_m;
    wire [WIDTH-1:0] alu_result_wb;
    wire [WIDTH-1:0] pc_plus4_wb;
    wire [WIDTH-1:0] read_data_1_ex;
    wire [WIDTH-1:0] read_data_2_ex_mux;
    wire [4:0]       rd_ex;
    wire [4:0]       rd_m;
    wire [4:0]       rd_wb;
    wire [4:0]       rs2e;
    wire [4:0]       rs1e;
    wire [2:0]       alu_control_ex;
    wire [1:0]       result_src_ex;
    wire [1:0]       result_src_m;
    wire [1:0]       result_src_wb;
    wire [1:0]       forward_ae;
    wire [1:0]       forward_be;
    wire             stall_f;
    wire             stall_d;
    wire             flush_d;
    wire             flush_e;
    wire             reg_write_wb;
    wire             reg_write_ex;
    wire             pc_src;
    wire             mem_write_ex;
    wire             jump_ex;
    wire             branch_ex;
    wire             alu_src_ex;
    wire             zero;
    wire             reg_write_m;

    // Instruction Fetch stage (IF)
    mux mux0 (
        .select(pc_src),
        .a(pc_target),
        .b(pc_plus4),
        .out(pc_next)
    );

    program_counter program_counter (
        .clk(clock),
        .reset(reset),
        .pc_next(pc_next),
        .pc(rom_address),
        .en(stall_f)
    );

    adder adder0 (
        .a(rom_address),
        .b(32'h00000004),
        .y(pc_plus4)
    );

    // IF/ID Registers
    register #(.WIDTH(WIDTH)) pc_if_id (.rst(reset), .clk(clock), .in(rom_address), .out(pc_id), .en(stall_d), .clr(flush_d));
    register #(.WIDTH(WIDTH)) inst_if_id (.rst(reset), .clk(clock), .in(rom_data), .out(instruction_id), .en(stall_d), .clr(flush_d));
    register #(.WIDTH(WIDTH)) pc_plus4_if_id (.rst(reset), .clk(clock), .in(pc_plus4), .out(pc_plus4_id), .en(stall_d), .clr(flush_d));

    // Instruction Decode stage (ID)
    register_file register_file (
        .clk(clock),
        .reset(reset),
        .write_enable(reg_write_wb),
        .address_1(instruction_id[19:15]),
        .address_2(instruction_id[24:20]),
        .address_3(rd_wb),
        .write_data(result),
        .read_data_1(src_a),
        .read_data_2(read_data_2)
    );

    sign_extend sign_extend (
        .instruction(instruction_id[31:7]),
        .immsrc(imm_src),
        .output_extended(imm_ext)
    );

    assign op = instruction_id[6:0];
    assign funct3 = instruction_id[14:12];
    assign funct7 = instruction_id[30];

    // ID/EX Registers
    register #(.WIDTH(1)) reg_write_id_ex (.rst(reset), .clk(clock), .in(reg_write), .out(reg_write_ex), .en(1'b0), .clr(flush_e));
    register #(.WIDTH(2)) result_src_id_ex (.rst(reset), .clk(clock), .in(result_src), .out(result_src_ex), .en(1'b0), .clr(flush_e));
    register #(.WIDTH(1)) mem_write_id_ex (.rst(reset), .clk(clock), .in(mem_write), .out(mem_write_ex), .en(1'b0), .clr(flush_e));
    register #(.WIDTH(1)) jump_id_ex (.rst(reset), .clk(clock), .in(jump), .out(jump_ex), .en(1'b0), .clr(flush_e));
    register #(.WIDTH(1)) branch_id_ex (.rst(reset), .clk(clock), .in(branch), .out(branch_ex), .en(1'b0), .clr(flush_e));
    register #(.WIDTH(3)) alu_control_id_ex (.rst(reset), .clk(clock), .in(alu_control), .out(alu_control_ex), .en(1'b0), .clr(flush_e));
    register #(.WIDTH(1)) alu_src_id_ex (.rst(reset), .clk(clock), .in(alu_src), .out(alu_src_ex), .en(1'b0), .clr(flush_e));
    register src_a_id_ex (.rst(reset), .clk(clock), .in(src_a), .out(read_data_1_ex), .en(1'b0), .clr(flush_e));
    register read_data_2_id_ex (.rst(reset), .clk(clock), .in(read_data_2), .out(read_data_2_ex), .en(1'b0), .clr(flush_e));
    register pc_id_ex (.rst(reset), .clk(clock), .in(pc_id), .out(pc_ex), .en(1'b0), .clr(flush_e));
    register #(.WIDTH(5)) rd_id_ex (.rst(reset), .clk(clock), .in(instruction_id[11:7]), .out(rd_ex), .en(1'b0), .clr(flush_e));
    register imm_ext_id_ex (.rst(reset), .clk(clock), .in(imm_ext), .out(imm_ext_ex), .en(1'b0), .clr(flush_e));
    register pc_plus4_id_ex (.rst(reset), .clk(clock), .in(pc_plus4_id), .out(pc_plus4_ex), .en(1'b0), .clr(flush_e));
    register #(.WIDTH(5)) instruction_id1 (.rst(reset), .clk(clock), .in(instruction_id[19:15]), .out(rs1e), .en(1'b0), .clr(flush_e));
    register #(.WIDTH(5)) instruction_id2 (.rst(reset), .clk(clock), .in(instruction_id[24:20]), .out(rs2e), .en(1'b0), .clr(flush_e));

    // Instruction Execute stage (EX)
    mux_3 mux6 (
        .select(forward_ae),
        .a(read_data_1_ex),
        .b(result),
        .c(ram_address),
        .out(src_a_ex)
    );

    mux_3 mux7 (
        .select(forward_be),
        .a(read_data_2_ex),
        .b(result),
        .c(ram_address),
        .out(read_data_2_ex_mux)
    );

    adder adder1 (
        .a(pc_ex),
        .b(imm_ext_ex),
        .y(pc_target)
    );

    mux mux1 (
        .select(alu_src_ex),
        .a(imm_ext_ex),
        .b(read_data_2_ex_mux),
        .out(src_b)
    );

    alu alu (
        .alu_control(alu_control_ex),
        .a(src_a_ex),
        .b(src_b),
        .alu_result(alu_result),
        .c(),
        .o(),
        .z(zero)
    );

    assign pc_src = (branch_ex & zero) | jump_ex;

    // EX/MEM Registers
    register #(.WIDTH(1)) reg_write_ex_m (.rst(reset), .clk(clock), .in(reg_write_ex), .out(reg_write_m), .en(1'b0), .clr(1'b0));
    register #(.WIDTH(2)) result_src_ex_m (.rst(reset), .clk(clock), .in(result_src_ex), .out(result_src_m), .en(1'b0), .clr(1'b0));
    register #(.WIDTH(1)) mem_write_ex_m (.rst(reset), .clk(clock), .in(mem_write_ex), .out(read_write_ram_en), .en(1'b0), .clr(1'b0));
    register alu_result_ex_m (.rst(reset), .clk(clock), .in(alu_result), .out(ram_address), .en(1'b0), .clr(1'b0));
    register read_data_2_ex_m (.rst(reset), .clk(clock), .in(read_data_2_ex_mux), .out(ram_w_data), .en(1'b0), .clr(1'b0));
    register #(.WIDTH(5)) rd_ex_m (.rst(reset), .clk(clock), .in(rd_ex), .out(rd_m), .en(1'b0), .clr(1'b0));
    register pc_plus4_ex_m (.rst(reset), .clk(clock), .in(pc_plus4_ex), .out(pc_plus4_m), .en(1'b0), .clr(1'b0));

    // Memory stage
    // We will use external data memory

    // MEM/WB Registers
    register #(.WIDTH(1)) reg_write_m_wb (.rst(reset), .clk(clock), .in(reg_write_m), .out(reg_write_wb), .en(1'b0), .clr(1'b0));
    register #(.WIDTH(2)) result_src_m_wb (.rst(reset), .clk(clock), .in(result_src_m), .out(result_src_wb), .en(1'b0), .clr(1'b0));
    register alu_result_m_wb (.rst(reset), .clk(clock), .in(ram_address), .out(alu_result_wb), .en(1'b0), .clr(1'b0));
    register read_data_m_wb (.rst(reset), .clk(clock), .in(ram_r_data), .out(read_data_wb), .en(1'b0), .clr(1'b0));
    register #(.WIDTH(5)) rd_m_wb (.rst(reset), .clk(clock), .in(rd_m), .out(rd_wb), .en(1'b0), .clr(1'b0));
    register pc_plus4_m_wb (.rst(reset), .clk(clock), .in(pc_plus4_m), .out(pc_plus4_wb), .en(1'b0), .clr(1'b0));

    // WriteBack stage (WB)
    mux_3 mux_3 (
        .select(result_src_wb),
        .a(alu_result_wb),
        .b(read_data_wb),
        .c(pc_plus4_wb),
        .out(result)
    );

    // Hazard unit
    hazard_unit hazard (
        .rst(reset),
        .reg_write_m(reg_write_m),
        .reg_write_w(reg_write_wb),
        .result_src_e0(result_src_ex[0]),
        .pc_src_e(pc_src),
        .rd_m(rd_m),
        .rd_w(rd_wb),
        .rs1_e(rs1e),
        .rs2_e(rs2e),
        .rs_1d(instruction_id[19:15]),
        .rs_2d(instruction_id[24:20]),
        .rde(rd_ex),
        .stall_f(stall_f),
        .stall_d(stall_d),
        .flush_e(flush_e),
        .flush_d(flush_d),
        .forward_ae(forward_ae),
        .forward_be(forward_be)
    );

endmodule
