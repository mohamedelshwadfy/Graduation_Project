/*
	module name : REGISTER_FILE
	module inputs : 
				- CLK : the global clock of the system
				- RESET : the global reset of the system
				- WRITE_ENABLE : the enable signal for write data into register
				- ADDRESS_1 : read address one and its value appear on the output [READ_DATA_1]
				- ADDRESS_2 : read address two and its value appear on the output [READ_DATA_2]
				- ADDRESS_3 : the address of the register that will be wiritten on it 
				- WRITE_DATA : the data that will be written into the register
	module outputs :
				- READ_DATA_1 : the output data read from the register
				- READ_DATA_2 : the output data read from the register
	module function : 
				- it contains 32 registers each of them are 32-bit wide
				  it has 7 inputs 3 of them are address line to read or write the registers.
				  it holds the value of the operands 
*/
module REGISTER_FILE #(parameter WIDTH = 32 , ADD_WIDTH = 5 , NU_REG = 32 )(
		CLK,
		RESET,
		WRITE_ENABLE,
		ADDRESS_1,
		ADDRESS_2,
		ADDRESS_3,
		WRITE_DATA,
		READ_DATA_1,
		READ_DATA_2
	);
// inputs declaration
input wire CLK;
input wire RESET;
input wire WRITE_ENABLE;
input wire [ ADD_WIDTH - 1 :  0] ADDRESS_1;
input wire [ ADD_WIDTH - 1 :  0] ADDRESS_2;
input wire [ ADD_WIDTH - 1 :  0] ADDRESS_3;
input wire [ WIDTH - 1 : 0]      WRITE_DATA;
//outputs declaration
output reg [ WIDTH - 1 : 0 ] READ_DATA_1;
output reg [ WIDTH - 1 : 0 ] READ_DATA_2;

reg [ WIDTH - 1 : 0 ] RF [ NU_REG - 1 : 0 ]; // the 32 registers withe 32-bit wide for each of them

integer i;
//the synchronuous write to prevent destroing the data
    
always @(posedge CLK , negedge RESET) begin
    RF[0] <= 32'h0000_0000;
    if(~RESET)
        for(i = 0 ; i <32 ; i = i+1)
                RF[i] <= 32'h0000_0000;
    else if (WRITE_ENABLE && ADDRESS_3 != 5'b0)
        RF[ADDRESS_3] <= WRITE_DATA;
end

always @(*) begin
    if(WRITE_ENABLE && (ADDRESS_3 == ADDRESS_1 ))
        READ_DATA_1 =  WRITE_DATA; // combinational output
    else
        READ_DATA_1 = RF[ADDRESS_1] ;
    if(WRITE_ENABLE && (ADDRESS_3 == ADDRESS_2 ))
        READ_DATA_2 =  WRITE_DATA; // combinational output
    else
        READ_DATA_2 = RF[ADDRESS_2] ;
end


endmodule
