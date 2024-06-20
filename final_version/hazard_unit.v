/* Module: hazard_unit
   Description: Hazard detection unit
   Inputs: rst - Reset signal; reg_write_m - Register write enable from MEM stage; reg_write_w - Register write enable from WB stage
           result_src_e0 - Result source signal from EX stage; pc_src_e - PC source signal from EX stage; rd_m - Destination register from MEM stage
           rd_w - Destination register from WB stage; rs1_e - Source register 1 from EX stage; rs2_e - Source register 2 from EX stage
           rs1_d - Source register 1 from ID stage; rs2_d - Source register 2 from ID stage; rd_e - Destination register from EX stage
   Outputs: stall_f - Stall signal for IF stage; stall_d - Stall signal for ID stage; flush_e - Flush signal for EX stage
            flush_d - Flush signal for ID stage; forward_a_e - Forward signal for ALU source A; forward_b_e - Forward signal for ALU source B
*/
module hazard_unit (
    input             rst,
    input             reg_write_m,
    input             reg_write_w,
    input             result_src_e0,
    input             pc_src_e,
    input      [4:0]  rd_m,
    input      [4:0]  rd_w,
    input      [4:0]  rs1_e,
    input      [4:0]  rs2_e,
    input      [4:0]  rs1_d,
    input      [4:0]  rs2_d,
    input      [4:0]  rd_e,
    output            stall_f,
    output            stall_d,
    output            flush_e,
    output            flush_d,
    output     [1:0]  forward_a_e,
    output     [1:0]  forward_b_e
);

    wire lw_stall;

    assign forward_a_e = (rst == 1'b0) ? 2'b00 :
       ((reg_write_m == 1'b1) && (rd_m != 5'h00) && (rd_m == rs1_e)) ? 2'b10 :// forward from memory stage.
       ((reg_write_w == 1'b1) && (rd_w != 5'h00) && (rd_w == rs1_e)) ? 2'b01 : 2'b00; //forward from write back stage.

    assign forward_b_e = (rst == 1'b0) ? 2'b00 :
       ((reg_write_m == 1'b1) && (rd_m != 5'h00) && (rd_m == rs2_e)) ? 2'b10 : // forward from memory stage.
       ((reg_write_w == 1'b1) && (rd_w != 5'h00) && (rd_w == rs2_e)) ? 2'b01 : 2'b00; //forward from write back stage.

    assign lw_stall = (result_src_e0 && ((rs1_d == rd_e) || (rs2_d == rd_e)));
    assign stall_f = lw_stall;
    assign stall_d = lw_stall;
    assign flush_d = pc_src_e;
    assign flush_e = lw_stall || pc_src_e;

endmodule
