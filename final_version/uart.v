/* Module: uart
   Description: Universal Asynchronous Receiver Transmitter (UART) with FIFO buffer
   Inputs: clk - Clock signal; reset - Reset signal; rd_uart - Read enable for UART; wr_uart - Write enable for UART; rx - Receive data
           w_data - Write data; dvsr - Divider value
   Outputs: tx_full - Transmitter full flag; rx_empty - Receiver empty flag; tx - Transmit data; r_data - Read data
*/
module uart #(
    parameter DBIT = 8,     // Number of data bits
    parameter SB_TICK = 16, // Number of ticks for 1 stop bit
    parameter FIFO_W = 2    // Address bits of FIFO
) (
    input         clk,
    input         reset,
    input         rd_uart,
    input         wr_uart,
    input         rx,
    input  [7:0]  w_data,
    input  [10:0] dvsr,
    output        tx_full,
    output        rx_empty,
    output        tx,
    output [7:0]  r_data
);

    // Signal declaration
    wire       tick, rx_done_tick, tx_done_tick;
    wire       tx_empty, tx_fifo_not_empty;
    wire [7:0] tx_fifo_out, rx_data_out;

    // Instantiate baud generator
    baud_gen baud_gen_unit (
        .clk(clk),
        .reset(reset),
        .dvsr(dvsr),
        .tick(tick)
    );

    // Instantiate UART receiver
    uart_rx #(
        .DBIT(DBIT),
        .SB_TICK(SB_TICK)
    ) uart_rx_unit (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .s_tick(tick),
        .rx_done_tick(rx_done_tick),
        .dout(rx_data_out)
    );

    // Instantiate UART transmitter
    uart_tx #(
        .DBIT(DBIT),
        .SB_TICK(SB_TICK)
    ) uart_tx_unit (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_fifo_not_empty),
        .s_tick(tick),
        .din(tx_fifo_out),
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );

    // Instantiate FIFO for receiver
    fifo #(
        .DATA_WIDTH(DBIT),
        .ADDR_WIDTH(FIFO_W)
    ) fifo_rx_unit (
        .clk(clk),
        .reset(reset),
        .rd(rd_uart),
        .wr(rx_done_tick),
        .w_data(rx_data_out),
        .empty(rx_empty),
        .full(),
        .r_data(r_data)
    );

    // Instantiate FIFO for transmitter
    fifo #(
        .DATA_WIDTH(DBIT),
        .ADDR_WIDTH(FIFO_W)
    ) fifo_tx_unit (
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
