//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2024 07:13:55 PM
// Design Name: 
// Module Name: chu_uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module chu_uart#(parameter  FIFO_DEPTH_BIT = 8)  // # addr bits of FIFO
   (
    input  wire clk,
    input  wire reset,
    // slot interface
    input  wire cs,
    input  wire read,
    input  wire write,
    input  wire [4:0] addr,
    input  wire [31:0] wr_data,
    output wire [31:0] rd_data,
    output wire tx,
    input  wire rx    
   );

   // signal declaration
   wire wr_uart, rd_uart, wr_dvsr ;
   wire tx_full, rx_empty;
   reg [10:0] dvsr_reg;
   wire [7:0] r_data;
   wire ctrl_reg;

   // body
   // instantiate uart
   uart #(.DBIT(8), .SB_TICK(16), .FIFO_W(FIFO_DEPTH_BIT)) uart_unit    
   (
        .clk(clk),
        .reset(reset),
        .rd_uart(rd_uart),
        .wr_uart(wr_uart),
        .rx(rx),
        .w_data(wr_data[7:0]),
        .dvsr(dvsr_reg),
        .tx_full(tx_full),
        .rx_empty(rx_empty),
        .tx(tx),
        .r_data(r_data)
   );
   // dvsr register
   always @(posedge clk, posedge reset)
      if (reset)
         dvsr_reg <= 0;
      else   
         if (wr_dvsr)
            dvsr_reg <= wr_data[10:0];
   // decoding logic
   assign wr_dvsr = (write && cs && (addr[1:0]==2'b01));
   assign wr_uart = (write && cs && (addr[1:0]==2'b10));
   assign rd_uart = (write && cs && (addr[1:0]==2'b11));
   // slot read interface
   assign rd_data = {22'h000000, tx_full,  rx_empty, r_data};
endmodule
