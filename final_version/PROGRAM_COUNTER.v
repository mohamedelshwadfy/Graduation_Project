module PROGRAM_COUNTER #(parameter WIDTH = 32 )(
		CLK,
		Reset,
		PC_next,
		PC, 
	    En
           );

input Reset;
input CLK;
input En;
input [ WIDTH - 1 : 0 ] PC_next;

output reg [ WIDTH - 1 : 0 ] PC;

always@(posedge CLK, negedge Reset) begin
	if(~Reset) begin
		PC <= 32'h0000_0000;
	end
	else begin
	   if (~En)
	       PC <= PC_next;
	end
end

endmodule
