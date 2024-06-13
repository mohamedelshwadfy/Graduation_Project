
module MUX_3 #(parameter WIDTH = 32) (
		select,
		A,
		B,
		C,
		OUT
	);

input [ 1 : 0 ]select;
input [ WIDTH - 1 : 0 ] A;
input [ WIDTH - 1 : 0 ] B;
input [ WIDTH - 1 : 0 ] C;

output reg [ WIDTH - 1 : 0 ] OUT;

always @(*) begin
	case(select)
		2'b00 : OUT = A;
		2'b01 : OUT = B;
		2'b10 : OUT = C;
		default : OUT = 32'h0000_0000;
	endcase
end

endmodule