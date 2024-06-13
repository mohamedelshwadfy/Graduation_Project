/*
	Module name : ADDER
	Inputs : 
			- A : 16-bit line
			- B : 16-bit line
	output : 
			- Y : 16-bit line
	Parameters :
			- N : line WIDTH , default 16-bit
	Function :
			- it adds two numbers and ignore the carry out 
	Made by : 
			-Omar Hany Elsayed
*/
//module name and ports declaration
module ADDER #(parameter WIDTH = 32) (
	A,
	B,
	OUTPUT
);
// input-output ports
input [ WIDTH - 1 : 0 ] A,B;
output reg [ WIDTH - 1 : 0 ] OUTPUT;

// code body
always @(*) begin
	OUTPUT = A + B;
end

endmodule 