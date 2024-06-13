/*
	module name : INSTRUCTION_MEMORY
	module inputs : 
				- ADDRESS : is a 32-bit address line
	module outputs :
				- INSTRUCTION : is a 32-bit instruction line
	module function : 
				- simply it is a memory [ROM],
				  it gets their input from the PC [the address of the instruction]
				  and the output is the instruction that stored in it
*/
module INSTRUCTION_MEMORY #(parameter WIDTH = 32 , MEM_DEPTH = 256) (
			ADDRESS,
			INSTRUCTION
		);

(* KEEP = "true" *)input [ WIDTH - 1 : 0 ] ADDRESS; // the address line
	
(* KEEP = "true" *)output reg [ WIDTH - 1 : 0 ] INSTRUCTION; // the instruction line

//(* KEEP = "true" *) reg [ WIDTH - 1 : 0 ] MEM [ 0 : MEM_DEPTH - 1 ]; // the memory [ROM]
/*
integer i;
always @(*) begin
    for(i = 0 ; i < MEM_DEPTH ; i = i + 1 ) begin
        MEM[i] = i;
    end
end
*/

always @(*) begin
    case(ADDRESS >> 2)  
        /*
        32'h0000_0000 : (* KEEP = "true" *)INSTRUCTION = 32'h01a00113;
        32'h0000_0001 : (* KEEP = "true" *)INSTRUCTION = 32'h04100413;
        32'h0000_0002 : (* KEEP = "true" *)INSTRUCTION = 32'h502020a3;
        32'h0000_0003 : (* KEEP = "true" *)INSTRUCTION = 32'h50002083;
        32'h0000_0004 : (* KEEP = "true" *)INSTRUCTION = 32'h2000f193;
        32'h0000_0005 : (* KEEP = "true" *)INSTRUCTION = 32'h1000f313;
        32'h0000_0006 : (* KEEP = "true" *)INSTRUCTION = 32'h20000213;
        32'h0000_0007 : (* KEEP = "true" *)INSTRUCTION = 32'h10000293;
        32'h0000_0008 : (* KEEP = "true" *)INSTRUCTION = 32'hfe4180e3;
        32'h0000_0009 : (* KEEP = "true" *)INSTRUCTION = 32'h50802123;
        32'h0000_000a : (* KEEP = "true" *)INSTRUCTION = 32'h00140413;
        32'h0000_000b : (* KEEP = "true" *)INSTRUCTION = 32'hfe0000e3;
        */
        
        32'h0000_0000 : (* KEEP = "true" *)INSTRUCTION = 32'h02600093;
        32'h0000_0001 : (* KEEP = "true" *)INSTRUCTION = 32'h501020a3;
        32'h0000_0002 : (* KEEP = "true" *)INSTRUCTION = 32'h50002183;
        32'h0000_0003 : (* KEEP = "true" *)INSTRUCTION = 32'h1001f213;
        32'h0000_0004 : (* KEEP = "true" *)INSTRUCTION = 32'h10000093;
        32'h0000_0005 : (* KEEP = "true" *)INSTRUCTION = 32'hfe120ae3;
        32'h0000_0006 : (* KEEP = "true" *)INSTRUCTION = 32'h501021a3;
        32'h0000_0007 : (* KEEP = "true" *)INSTRUCTION = 32'h50002283;
        /*
        32'h0000_0008 : (* KEEP = "true" *)INSTRUCTION = 32'h0ff2f313;
        32'h0000_0009 : (* KEEP = "true" *)INSTRUCTION = 32'h50002383;
        32'h0000_000a : (* KEEP = "true" *)INSTRUCTION = 32'h0ff3f413;
        32'h0000_000b : (* KEEP = "true" *)INSTRUCTION = 32'h20000093;
        32'h0000_000c : (* KEEP = "true" *)INSTRUCTION = 32'hfe140ae3;
        32'h0000_000d : (* KEEP = "true" *)INSTRUCTION = 32'h50602123;
        32'h0000_000e : (* KEEP = "true" *)INSTRUCTION = 32'hfc0008e3;
        */
    /*
    32'h0000_0000 : (* KEEP = "true" *)INSTRUCTION = 32'h01a00113;
    32'h0000_0001 : (* KEEP = "true" *)INSTRUCTION = 32'h00a00413;
    32'h0000_0002 : (* KEEP = "true" *)INSTRUCTION = 32'h502020a3;
    32'h0000_0003 : (* KEEP = "true" *)INSTRUCTION = 32'h50802123;
    32'h0000_0004 : (* KEEP = "true" *)INSTRUCTION = 32'h502020a3;
    */
        default : INSTRUCTION = 32'h0000_0013;
    
    endcase
end


//assign INSTRUCTION = MEM[ADDRESS >> 2]; // the ouput is combinational assignment 


endmodule
