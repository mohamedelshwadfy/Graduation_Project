/* Module: program_counter
   Description: Program counter
   Inputs: clk - clock signal; reset - reset signal; pc_next - 32-bit next program counter value; en - enable signal
   Outputs: pc - 32-bit program counter
*/
module program_counter #(parameter WIDTH = 32) (
    input                  clk,
    input                  reset,
    input                  en,
    input      [WIDTH-1:0] pc_next,
    output reg [WIDTH-1:0] pc
);

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            pc <= 32'h00000000;
        end else if (~en) begin
            pc <= pc_next;
        end
    end

endmodule
