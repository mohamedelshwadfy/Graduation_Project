/* Module: register
   Description: General-purpose register with enable and clear functionality
   Inputs: clk - clock signal; rst - reset signal; input - input data; en - enable signal; clr - clear signal
   Outputs: out - output data
*/
module register #(parameter WIDTH = 32) (
    input                  clk,
    input                  rst,
    input                  en,
    input                  clr,
    input      [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            out <= {WIDTH{1'b0}};
        end else begin
            if (clr) begin
                out <= {WIDTH{1'b0}};
            } else if (~en) begin
                out <= input;
            end
        end
    end

endmodule
