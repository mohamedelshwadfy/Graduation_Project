module SIGN_EXTEND #(parameter WIDTH = 32 ) (
		INSTRUCTION,
		immsrc,
		OUTPUT_EXTENDED
	);

input  [ WIDTH - 1 : 7] INSTRUCTION;
input  [ 1 : 0 ] immsrc;

output  reg [ WIDTH - 1 : 0 ] OUTPUT_EXTENDED;

always @(*) begin
 	case(immsrc)
 		// I?type
 		2'b00: 
			OUTPUT_EXTENDED = {{20{INSTRUCTION[31]}}, INSTRUCTION[31:20]};
 		// S?type (stores)
 		2'b01: 
			OUTPUT_EXTENDED = {{20{INSTRUCTION[31]}}, INSTRUCTION[31:25], INSTRUCTION[ 11 : 7]};
		 // B?type (branches)
		 2'b10: 
			OUTPUT_EXTENDED = {{20{INSTRUCTION[31]}}, INSTRUCTION[7],
								INSTRUCTION[30:25],INSTRUCTION[11:8], 1'b0}; 
 		// J?type (jal)
 		2'b11: 
			OUTPUT_EXTENDED = {{12{INSTRUCTION[31]}}, INSTRUCTION[19:12],
								 INSTRUCTION[20], INSTRUCTION[30:21], 1'b0};

		 default: 
			OUTPUT_EXTENDED = 32'hxxxx_xxxx; // undefined
 	endcase
end

endmodule
