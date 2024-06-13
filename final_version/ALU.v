/*
	module name : ALU
	module inputs : 
				- ALUControl : the control lines 3-bit 
				- A : the source one 32-bit
				- B : the source two 32-bit
				
	module outputs :
				- ALUResult : the result of the alu 32-bit
				- C : the carry flage 1-bit
				- O : the overflow flage 1-bit
				- Z : the zero flage 1-bit
	module function : 
				- the arithmatic and logic core in the processor 
*/
module ALU #(parameter WIDTH = 32 , CTRL_W = 3) (
		ALUControl ,
		A,
		B,
		ALUResult,
		C,
		O,
		Z
	);

// the input declaration
input [ CTRL_W - 1 : 0] ALUControl;
input [ WIDTH  - 1 : 0] A , B;

// the output declaration
output reg [ WIDTH - 1 : 0] ALUResult;
output reg C ;
output O , Z;

wire [WIDTH - 1 : 0 ] ALUResult_temp;
wire C_temp;
reg M;

// look-ahead carry adder instantiation
CARRY_LOOK_AHEAD_ADDER adder1(
								.a(A),
								.b(B),
								.cin(M),
								.sum(ALUResult_temp),
								.cout(C_temp),
								.M(M)
							);
always @(*)
	begin
		case(ALUControl)
			//ADD
			3'b000 : begin
						M = 1'b0;
						ALUResult = ALUResult_temp;
						C = C_temp;
					end
			//SUB
			3'b001 :  begin
						M = 1'b1;
						ALUResult = ALUResult_temp;
						C = C_temp;
					end
			//AND
			3'b010 : begin
			             M = 1'b0;
						 ALUResult = A & B;
						C = 1'b0;
					end
			//OR
			3'b011 : begin
			             M = 1'b0;
						ALUResult  = A | B  ;
						C = 1'b0;
					end
			//slt
			3'b101 : begin
			             M = 1'b0;
				ALUResult = (A < B) ? 32'h00000001 : 32'h00000000 ;
					C = 1'b0;
				end
			//XOR
			3'b100:begin
			         M = 1'b0;
				ALUResult  = A ^ B  ;
				C = 1'b0;
				  end
			//SLL
			3'b110: begin
				M = 1'b0;
				ALUResult  = A << B  ;
				C = 1'b0;
				end
			//SRL
			3'b111: begin
				M = 1'b0;
				ALUResult  = A >> B  ;
				C = 1'b0;
				end
			default :  begin
			             M = 1'b0;
						ALUResult = 32'hxxxx_xxxx ;
						C = 1'bx;
					end
		endcase
	end

assign O = ((ALUResult[31] ^ A[31]) & (~(ALUControl[0] ^ B[31] ^ A[31])) & (~ALUControl[1])) ;

assign Z = &(~ALUResult) ;

endmodule 
