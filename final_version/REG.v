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
          if( rst == 1'b0 )	
		out <=  0;

        else if ( clr == 1'b1 )	
		out <=  0;
	
	else
           if (~en)
		out<= in; 

end

endmodule
