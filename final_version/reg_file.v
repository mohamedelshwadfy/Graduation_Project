module reg_file #(
    parameter DATA_WIDTH = 8, // Number of bits
    parameter ADDR_WIDTH = 2  // Number of address bits
) (
    input wire clk,
    input wire reset,
    input wire wr_en,
    input wire [ADDR_WIDTH-1:0] w_addr,
    input wire [ADDR_WIDTH-1:0] r_addr,
    input wire [DATA_WIDTH-1:0] w_data,
    output wire [DATA_WIDTH-1:0] r_data
);

    // Signal declaration
    reg [DATA_WIDTH-1:0] array_reg [0:2**ADDR_WIDTH-1];

    // Write operation
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < (2**ADDR_WIDTH); i = i + 1)
                array_reg[i] = 8'h00;
        end else if (wr_en) begin
            array_reg[w_addr] <= w_data;
        end
    end

    // Read operation
    assign r_data = array_reg[r_addr];

endmodule
