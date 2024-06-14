// Module: RegisterFile
// Description: 32x32-bit register file with dual read and single write functionality
// Inputs: CLK - clock signal; RESET - reset signal; WRITE_ENABLE - write enable signal;
//         ADDRESS_1 - read address 1; ADDRESS_2 - read address 2; ADDRESS_3 - write address;
//         WRITE_DATA - data to write
// Outputs: READ_DATA_1 - data read from address 1; READ_DATA_2 - data read from address 2

module RegisterFile #(parameter WIDTH = 32, ADD_WIDTH = 5, NU_REG = 32) (
    input CLK,
    input RESET,
    input WRITE_ENABLE,
    input [ADD_WIDTH - 1 : 0] ADDRESS_1,
    input [ADD_WIDTH - 1 : 0] ADDRESS_2,
    input [ADD_WIDTH - 1 : 0] ADDRESS_3,
    input [WIDTH - 1 : 0] WRITE_DATA,
    output reg [WIDTH - 1 : 0] READ_DATA_1,
    output reg [WIDTH - 1 : 0] READ_DATA_2
);

reg [WIDTH - 1 : 0] RF [NU_REG - 1 : 0]; // 32 registers, 32-bit wide each
integer i;

// Synchronous write
always @(posedge CLK or negedge RESET) begin
    RF[0] <= 32'h0000_0000;
    if (~RESET) begin
        for (i = 0; i < 32; i = i + 1)
            RF[i] <= 32'h0000_0000;
    end else if (WRITE_ENABLE && ADDRESS_3 != 5'b0) begin
        RF[ADDRESS_3] <= WRITE_DATA;
    end
end

// Asynchronous read
always @(*) begin
    if (WRITE_ENABLE && (ADDRESS_3 == ADDRESS_1)) begin
        READ_DATA_1 = WRITE_DATA; // Combinational output
    end else begin
        READ_DATA_1 = RF[ADDRESS_1];
    end
    if (WRITE_ENABLE && (ADDRESS_3 == ADDRESS_2)) begin
        READ_DATA_2 = WRITE_DATA; // Combinational output
    end else begin
        READ_DATA_2 = RF[ADDRESS_2];
    end
end

endmodule
