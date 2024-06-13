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
        
        32'h0000_0000 : (* KEEP = "true" *)INSTRUCTION = 32'h01a00093;
        32'h0000_0001 : (* KEEP = "true" *)INSTRUCTION = 32'h501020a3;
        32'h0000_0002 : (* KEEP = "true" *)INSTRUCTION = 32'h00500593;
        32'h0000_0003 : (* KEEP = "true" *)INSTRUCTION = 32'h50002383;
        32'h0000_0004 : (* KEEP = "true" *)INSTRUCTION = 32'h2003f413;
        32'h0000_0005 : (* KEEP = "true" *)INSTRUCTION = 32'h20000493;
        32'h0000_0006 : (* KEEP = "true" *)INSTRUCTION = 32'hfe940ae3;
        32'h0000_0007 : (* KEEP = "true" *)INSTRUCTION = 32'h50b02123;
        32'h0000_0008 : (* KEEP = "true" *)INSTRUCTION = 32'h00158593;
        32'h0000_0009 : (* KEEP = "true" *)INSTRUCTION = 32'h50002103;
        32'h0000_000a : (* KEEP = "true" *)INSTRUCTION = 32'h10017193;
        32'h0000_000b : (* KEEP = "true" *)INSTRUCTION = 32'h10000213;
        32'h0000_000c : (* KEEP = "true" *)INSTRUCTION = 32'hfe418ae3;
        32'h0000_000d : (* KEEP = "true" *)INSTRUCTION = 32'h50002283;
        32'h0000_000e : (* KEEP = "true" *)INSTRUCTION = 32'h0ff2f313;
        32'h0000_000f : (* KEEP = "true" *)INSTRUCTION = 32'h50002103;
        32'h0000_0010 : (* KEEP = "true" *)INSTRUCTION = 32'h10017193;
        32'h0000_0011 : (* KEEP = "true" *)INSTRUCTION = 32'h10000213;
        32'h0000_0012 : (* KEEP = "true" *)INSTRUCTION = 32'hfe418ae3;
        32'h0000_0013 : (* KEEP = "true" *)INSTRUCTION = 32'h503021a3;
        32'h0000_0014 : (* KEEP = "true" *)INSTRUCTION = 32'hfa000ee3;
    
    
    
        /*
        //SW -> -> SW -> SW
        32'h0000_0000 : (* KEEP = "true" *)INSTRUCTION = 32'h01a00093;
        32'h0000_0001 : (* KEEP = "true" *)INSTRUCTION = 32'h501020a3;
        32'h0000_0002 : (* KEEP = "true" *)INSTRUCTION = 32'h00500293;
        32'h0000_0003 : (* KEEP = "true" *)INSTRUCTION = 32'h50002103;
        32'h0000_0004 : (* KEEP = "true" *)INSTRUCTION = 32'h20017193;
        32'h0000_0005 : (* KEEP = "true" *)INSTRUCTION = 32'h20000213;
        32'h0000_0006 : (* KEEP = "true" *)INSTRUCTION = 32'hfe418ae3;
        32'h0000_0007 : (* KEEP = "true" *)INSTRUCTION = 32'h50502123;
        32'h0000_0008 : (* KEEP = "true" *)INSTRUCTION = 32'h00128293;
        32'h0000_0009 : (* KEEP = "true" *)INSTRUCTION = 32'hfe0004e3 ;
        */
        /*
        //LW -> LW -> LW
        32'h0000_0000 : (* KEEP = "true" *)INSTRUCTION = 32'h01a00093;
        32'h0000_0001 : (* KEEP = "true" *)INSTRUCTION = 32'h501020a3;
        32'h0000_0002 : (* KEEP = "true" *)INSTRUCTION = 32'h50002103;
        32'h0000_0003 : (* KEEP = "true" *)INSTRUCTION = 32'h10017193;
        32'h0000_0004 : (* KEEP = "true" *)INSTRUCTION = 32'h10000213;
        32'h0000_0005 : (* KEEP = "true" *)INSTRUCTION = 32'hfe418ae3;
        32'h0000_0006 : (* KEEP = "true" *)INSTRUCTION = 32'h50002283;
        32'h0000_0007 : (* KEEP = "true" *)INSTRUCTION = 32'h0ff2f313;
        32'h0000_0008 : (* KEEP = "true" *)INSTRUCTION = 32'h503021a3;
        32'h0000_0009 : (* KEEP = "true" *)INSTRUCTION = 32'hfe0004e3;
        */
        default : INSTRUCTION = 32'h0000_0013;
    
    endcase
end


//assign INSTRUCTION = MEM[ADDRESS >> 2]; // the ouput is combinational assignment 


endmodule
