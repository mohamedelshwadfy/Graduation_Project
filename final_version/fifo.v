module fifo
   #(
    parameter DATA_WIDTH=8, // number of bits in a word
              ADDR_WIDTH=4  // number of address bits
   )
   (
    input clk,
    input reset,
    input rd,
    input wr,
    input [DATA_WIDTH-1:0] w_data,
    output empty,
    output full,
    output [DATA_WIDTH-1:0] r_data
   );

   //signal declaration
   wire [ADDR_WIDTH-1:0] w_addr, r_addr;
   wire wr_en, full_tmp;

   // body
   // write enabled only when FIFO is not full
   assign wr_en = wr & ~full_tmp;
   assign full = full_tmp;

   // instantiate fifo control unit
   fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH)) c_unit (
      .clk(clk),
      .reset(reset),
      .rd(rd),
      .wr(wr),
      .w_addr(w_addr),
      .r_addr(r_addr),
      .empty(empty),
      .full(full_tmp)
   );

   // instantiate register file
   reg_file 
      #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) f_unit (
      .clk(clk),
      .reset(reset),
      .w_data(w_data),
      .w_addr(w_addr),
      .r_addr(r_addr),
      .wr_en(wr_en),
      .r_data(r_data)
   );
endmodule