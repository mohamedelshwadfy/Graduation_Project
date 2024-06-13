module uart
   #(
    parameter DBIT = 8,      // number of data bits
              SB_TICK = 16,  // number of ticks for 1 stop bit
              FIFO_W = 2     // address bits of FIFO
   )
   (
    input clk,
    input reset,
    input rd_uart,
    input wr_uart,
    input rx,
    input [7:0] w_data,
    input [10:0] dvsr,
    output tx_full,
    output rx_empty,
    output tx,
    output [7:0] r_data
   );

   // signal declaration
   wire tick, rx_done_tick, tx_done_tick;
   wire tx_empty, tx_fifo_not_empty;
   wire [7:0] tx_fifo_out, rx_data_out;

   // body
   baud_gen baud_gen_unit (
      .clk(clk),
      .reset(reset),
      .dvsr(dvsr),
      .tick(tick)
   );

   uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit (
      .clk(clk),
      .reset(reset),
      .rx(rx),
      .s_tick(tick),
      .rx_done_tick(rx_done_tick),
      .dout(rx_data_out)
   );

   uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit (
      .clk(clk),
      .reset(reset),
      .tx(tx),
      .s_tick(tick),
      .tx_start(tx_fifo_not_empty),
      .din(tx_fifo_out),
      .tx_done_tick(tx_done_tick)
   );

   fifo #(.DATA_WIDTH(DBIT), .ADDR_WIDTH(FIFO_W)) fifo_rx_unit (
      .clk(clk),
      .reset(reset),
      .rd(rd_uart),
      .wr(rx_done_tick),
      .w_data(rx_data_out),
      .empty(rx_empty),
      .full(),
      .r_data(r_data)
   );

   fifo #(.DATA_WIDTH(DBIT), .ADDR_WIDTH(FIFO_W)) fifo_tx_unit (
      .clk(clk),
      .reset(reset),
      .rd(tx_done_tick),
      .wr(wr_uart),
      .w_data(w_data),
      .empty(tx_empty),
      .full(tx_full),
      .r_data(tx_fifo_out)
   );

   assign tx_fifo_not_empty = ~tx_empty;

endmodule