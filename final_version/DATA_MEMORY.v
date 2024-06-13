/*
	module name : DATA_MEMORY
	module inputs : 
				- CLK : the global clock of the system
				- RESET : the global reset of the system
				- ADDRESS : 32-bit address line 
				- WRITE_READ : control signal to read or write enable
				- WRITE_DATA : 32-bit data pass 
				
	module outputs :
				- READ_DATA : 32-bit data pass
	module function : 
				- it is a RAM . it have control signal to allowing write or read from it 
				  the write opearation is synchronized with the clock and the read
				  opearation is combinationally logic 
*/
module DATA_MEMORY #(parameter DATA_WIDTH = 32,ADD_WIDTH = 16 , MEM_DEPTH = 512 )(
		CLK,
		ADDRESS,
		WRITE_READ,
		WRITE_DATA,
		READ_DATA
	);

input                    CLK;
input                    WRITE_READ;
input  [ ADD_WIDTH - 1 : 0 ] ADDRESS;
input  [ DATA_WIDTH - 1 : 0 ] WRITE_DATA;

output [ DATA_WIDTH - 1 : 0 ] READ_DATA;

reg    [ DATA_WIDTH - 1 : 0 ] DATA [ 0 : MEM_DEPTH - 1];

integer i;
// the synchronuos write 
always @(posedge CLK) begin
	if (WRITE_READ) // write opearation
        DATA[ADDRESS] <= WRITE_DATA;
end

assign READ_DATA = (WRITE_READ) ? 32'h0000_0000 : DATA[ADDRESS]; // read opearation

endmodule 