// Module: Register
// Description: General-purpose register with enable and clear functionality
// Inputs: clk - clock signal; rst - reset signal; INPUT - input data; EN - enable signal; CLR - clear signal
// Outputs: OUT - output data

module Register #(parameter WIDTH = 32) (
    input clk,
    input rst,
    input EN,
    input CLR,
    input [WIDTH - 1 : 0] INPUT,
    output reg [WIDTH - 1 : 0] OUT
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        OUT <= {WIDTH{1'b0}};
    end else begin
        if (CLR) begin
            OUT <= {WIDTH{1'b0}};
        end else if (~EN) begin
            OUT <= INPUT;
        end
    end 
end

endmodule
