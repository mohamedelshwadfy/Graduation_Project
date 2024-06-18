/* Module: instruction_memory
   Description: Instruction memory (ROM)
   Inputs: address - 32-bit address line
   Outputs: instruction - 32-bit instruction line
*/
module instruction_memory #(parameter WIDTH = 32, parameter MEM_DEPTH = 256) (
    input      [WIDTH-1:0] address,
    output reg [WIDTH-1:0] instruction
);

    always @(*) begin
        case(address >> 2)
            32'h0000_0000 : instruction = 32'h01a00093;
            32'h0000_0001 : instruction = 32'h501020a3;
            32'h0000_0002 : instruction = 32'h00500593;
            32'h0000_0003 : instruction = 32'h50002383;
            32'h0000_0004 : instruction = 32'h2003f413;
            32'h0000_0005 : instruction = 32'h20000493;
            32'h0000_0006 : instruction = 32'hfe940ae3;
            32'h0000_0007 : instruction = 32'h50b02123;
            32'h0000_0008 : instruction = 32'h00158593;
            32'h0000_0009 : instruction = 32'h50002103;
            32'h0000_000a : instruction = 32'h10017193;
            32'h0000_000b : instruction = 32'h10000213;
            32'h0000_000c : instruction = 32'hfe418ae3;
            32'h0000_000d : instruction = 32'h50002283;
            32'h0000_000e : instruction = 32'h0ff2f313;
            32'h0000_000f : instruction = 32'h50002103;
            32'h0000_0010 : instruction = 32'h10017193;
            32'h0000_0011 : instruction = 32'h10000213;
            32'h0000_0012 : instruction = 32'hfe418ae3;
            32'h0000_0013 : instruction = 32'h503021a3;
            32'h0000_0014 : instruction = 32'hfa000ee3;
            default : instruction = 32'h00000013;
        endcase
    end

endmodule
