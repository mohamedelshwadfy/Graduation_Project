/* Module: reg_file
   Description: Register file with synchronous write and asynchronous read
   Inputs: clk - Clock signal; reset - Reset signal; wr_en - Write enable; w_addr - Write address; r_addr - Read address; w_data - Write data
   Outputs: r_data - Read data
*/
module reg_file #(
    parameter DATA_WIDTH = 8, // Number of bits
    parameter ADDR_WIDTH = 2  // Number of address bits
) (
    input                    clk,
    input                    reset,
    input                    wr_en,
    input   [ADDR_WIDTH-1:0] w_addr,
    input   [ADDR_WIDTH-1:0] r_addr,
    input   [DATA_WIDTH-1:0] w_data,
    output  [DATA_WIDTH-1:0] r_data
);

    // Signal declaration
    reg [DATA_WIDTH-1:0] array_reg [0:2**ADDR_WIDTH-1];

    // Write operation
    integer i;
   always @(posedge clk , negedge reset) begin
      if (~reset) begin
            for (i = 0; i < (2**ADDR_WIDTH); i = i + 1)
                array_reg[i] <= 8'h00;
      end else if (wr_en) begin
            array_reg[w_addr] <= w_data;
        end
    end

    // Read operation
    assign r_data = array_reg[r_addr];

endmodule
