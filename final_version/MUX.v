module MUX #(parameter WIDTH = 32) (
		select,
		A,
		B,
		OUT
	);

input select;
input [ WIDTH - 1 : 0 ] A;
input [ WIDTH - 1 : 0 ] B;

output [ WIDTH - 1 : 0 ] OUT;

assign OUT = (select) ? A : B;

endmodule
