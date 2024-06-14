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
module DATA_MEMORY #(parameter WIDTH = 32 , MEM_DEPTH = 256 )(
		CLK,
		ADDRESS,
		WRITE_READ,
		WRITE_DATA,
		READ_DATA
	);

input                    CLK;
input                    WRITE_READ;
input  [ WIDTH - 1 : 0 ] ADDRESS;
input  [ WIDTH - 1 : 0 ] WRITE_DATA;

output [ WIDTH - 1 : 0 ] READ_DATA;

reg    [ WIDTH - 1 : 0 ] DATA [ 0 : MEM_DEPTH - 1];

integer i;
// the synchronuos write 
always @(posedge CLK) begin
/*
	if(~RESET) // synchronus reset
	    for(i = 0 ; i < MEM_DEPTH ; i = i + 1 )
		  DATA[i] <= { WIDTH{1'b0} };

	else begin
	    if (WRITE_READ) // write opearation
	        DATA[ADDRESS] <= WRITE_DATA;
	end
	*/
	if (WRITE_READ) // write opearation
        DATA[ADDRESS] <= WRITE_DATA;
end

assign READ_DATA = (WRITE_READ) ? 32'h0000_0000 : DATA[ADDRESS]; // read opearation
initial begin
for(i = 0 ; i < MEM_DEPTH ; i = i + 1 )
		  DATA[i] <= { WIDTH{1'b0} };
 end
endmodule 
