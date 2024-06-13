module uart_rx
   #(
    parameter DBIT = 8,     // number of data bits
              SB_TICK = 16  // number of ticks for stop bits
   )
   (
    input clk,
    input reset,
    input rx,
    input s_tick,
    output reg rx_done_tick,
    output [7:0] dout
   );

   // fsm state type
   localparam idle = 2'b00;
   localparam start = 2'b01;
   localparam data = 2'b10;
   localparam stop = 2'b11;
   
   //state_type
    reg [1:0] state_reg, state_next;

   // signal declaration
   reg [3:0] s_reg, s_next;
   reg [2:0] n_reg, n_next;
   reg [7:0] b_reg, b_next;

   // FSMD state & data registers
   always @(posedge clk , posedge reset)
      if (reset) begin
         state_reg <= idle;
         s_reg <= 4'b0;
         n_reg <= 3'b0;
         b_reg <= 8'b0;
      end
      else begin
         state_reg <= state_next;
         s_reg <= s_next;
         n_reg <= n_next;
         b_reg <= b_next;
      end

   // FSMD next-state logic
   always @(*) begin
      state_next = state_reg;
      rx_done_tick = 1'b0;
      s_next = s_reg;
      n_next = n_reg;
      b_next = b_reg;

      case (state_reg)
         idle: begin
            if (~rx) begin
               state_next = start;
               s_next = 4'b0;
            end
         end
         start: begin
            if (s_tick) begin
               if (s_reg == 7) begin
                  state_next = data;
                  s_next = 0;
                  n_next = 0;
               end
               else
                  s_next = s_reg + 1;
            end
         end
         data: begin
            if (s_tick) begin
               if (s_reg == 15) begin
                  s_next = 0;
                  b_next = {rx, b_reg[7:1]};
                  if (n_reg == (DBIT-1))
                     state_next = stop;
                  else
                     n_next = n_reg + 1;
               end
               else
                  s_next = s_reg + 1;
            end
         end
         stop: begin
            if (s_tick) begin
               if (s_reg == (SB_TICK-1)) begin
                  state_next = idle;
                  rx_done_tick = 1'b1;
               end
               else
                  s_next = s_reg + 1;
            end
         end
      endcase
   end

   // output
   assign dout = b_reg;

endmodule