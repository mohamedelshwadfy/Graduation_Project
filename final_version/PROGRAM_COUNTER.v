// Module: ProgramCounter
// Description: Program counter
// Inputs: CLK - clock signal; Reset - reset signal; PC_next - 32-bit next program counter value; En - enable signal
// Outputs: PC - 32-bit program counter

module ProgramCounter #(parameter WIDTH = 32) (
    input  CLK,
    input  Reset,
    input  En,
    input  [WIDTH - 1 : 0] PC_next,
    output reg [WIDTH - 1 : 0] PC
);

always @(posedge CLK or negedge Reset) begin
    if(~Reset) begin
        PC <= 32'h00000000;
    end else if (~En) begin
        PC <= PC_next;
    end
end

endmodule
