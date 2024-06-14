module fifo #(
    parameter DATA_WIDTH = 8, // Number of bits in a word
    parameter ADDR_WIDTH = 4  // Number of address bits
) (
    input wire clk,
    input wire reset,
    input wire rd,
    input wire wr,
    input wire [DATA_WIDTH-1:0] w_data,
    output wire empty,
    output wire full,
    output wire [DATA_WIDTH-1:0] r_data
);

    // Signal declaration
    wire [ADDR_WIDTH-1:0] w_addr, r_addr;
    wire wr_en, full_tmp;

    // Write enabled only when FIFO is not full
    assign wr_en = wr & ~full_tmp;
    assign full = full_tmp;

    // Instantiate FIFO control unit
    fifo_ctrl #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) c_unit (
        .clk(clk),
        .reset(reset),
        .rd(rd),
        .wr(wr),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .empty(empty),
        .full(full_tmp)
    );

    // Instantiate register file
    reg_file #(
        .DATA_WIDTH(DATA_WIDTH), 
        .ADDR_WIDTH(ADDR_WIDTH)
    ) f_unit (
        .clk(clk),
        .reset(reset),
        .w_data(w_data),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .wr_en(wr_en),
        .r_data(r_data)
    );
endmodule
