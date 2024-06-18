/* Module: register_file
   Description: 32x32-bit register file with dual read and single write functionality
   Inputs: clk - clock signal; reset - reset signal; write_enable - write enable signal;
         address_1 - read address 1; address_2 - read address 2; address_3 - write address;
         write_data - data to write
   Outputs: read_data_1 - data read from address 1; read_data_2 - data read from address 2
*/
module register_file #(parameter WIDTH = 32, parameter ADD_WIDTH = 5, parameter NU_REG = 32) (
    input                      clk,
    input                      reset,
    input                      write_enable,
    input      [ADD_WIDTH-1:0] address_1,
    input      [ADD_WIDTH-1:0] address_2,
    input      [ADD_WIDTH-1:0] address_3,
    input      [WIDTH-1:0]     write_data,
    output reg [WIDTH-1:0]     read_data_1,
    output reg [WIDTH-1:0]     read_data_2
);

    reg [WIDTH-1:0] rf[NU_REG-1:0]; // 32 registers, 32-bit wide each
    integer i;

    // Synchronous write
    always @(posedge clk or negedge reset) begin
        rf[0] <= 32'h00000000;
        if (~reset) begin
            for (i = 0; i < 32; i = i + 1)
                rf[i] <= 32'h00000000;
        end else if (write_enable && address_3 != 5'b0) begin
            rf[address_3] <= write_data;
        end
    end

    // Asynchronous read
    always @(*) begin
        if (write_enable && (address_3 == address_1)) begin
            read_data_1 = write_data; // Combinational output
        end else begin
            read_data_1 = rf[address_1];
        end
        if (write_enable && (address_3 == address_2)) begin
            read_data_2 = write_data; // Combinational output
        end else begin
            read_data_2 = rf[address_2];
        end
    end

endmodule
