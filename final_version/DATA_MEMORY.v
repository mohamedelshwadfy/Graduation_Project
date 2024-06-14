/*
	module: DATA_MEMORY
        Description:  it is a RAM . it have control signal to allowing write or read from it 
			   the write opearation is synchronized with the clock and the read
		           opearation is combinationally logic 
        inputs: CLK : the global clock of the system , RESET : the global reset of the system , ADDRESS : 32-bit address line 
		 WRITE_READ : control signal to read or write enable , WRITE_DATA : 32-bit data pass 
	outputs: READ_DATA : 32-bit data pass
*/
module DATA_MEMORY #(parameter WIDTH = 32 , MEM_DEPTH = 256 )(
		clk,
		address,
		write_read,
		write_data,
		read_data
	);

input                     clk;
input                     write_read;
input  [ WIDTH - 1 : 0 ]  address;
input  [ WIDTH - 1 : 0 ]  write_data;
output [ WIDTH - 1 : 0 ]  read_data;

reg    [ WIDTH - 1 : 0 ] DATA [ 0 : MEM_DEPTH - 1];

integer i;
	
// the synchronuos write 
always @(posedge clk) begin
	
/*
	if(~RESET) // synchronus reset
	    for(i = 0 ; i < MEM_DEPTH ; i = i + 1 )
		  DATA[i] <= { WIDTH{1'b0} };

	else begin
	    if (WRITE_READ) // write opearation
	        DATA[ADDRESS] <= WRITE_DATA;
	end
*/
	
	if (write_read)                                                       // write opearation
		DATA[address] <= write_data;
end
assign read_data = (write_read) ? 32'h0000_0000 : DATA[address];              // read opearation

initial begin
for(i = 0 ; i < MEM_DEPTH ; i = i + 1 )
		  DATA[i] <= { WIDTH{1'b0} };
end
endmodule 
