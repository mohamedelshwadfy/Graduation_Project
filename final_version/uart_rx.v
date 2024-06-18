// Module: uart_rx
// Description: UART receiver
// Parameters: DBIT - Number of data bits; SB_TICK - Number of ticks for stop bits
// Inputs: clk - Clock signal; reset - Reset signal; rx - Receive data; s_tick - Tick signal
// Outputs: rx_done_tick - Receive done tick; dout - Output data

module uart_rx #(
    parameter DBIT = 8,     // Number of data bits
    parameter SB_TICK = 16  // Number of ticks for stop bits
) (
    input wire clk,
    input wire reset,
    input wire rx,
    input wire s_tick,
    output reg rx_done_tick,
    output wire [7:0] dout
);

    // FSM state type
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    // State register
    reg [1:0] state_reg, state_next;

    // Signal declaration
    reg [3:0] s_reg, s_next;
    reg [2:0] n_reg, n_next;
    reg [7:0] b_reg, b_next;

    // FSMD state & data registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
            s_reg <= 4'b0;
            n_reg <= 3'b0;
            b_reg <= 8'b0;
        end else begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end
    end

    // FSMD next-state logic
    always @* begin
        state_next = state_reg;
        rx_done_tick = 1'b0;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;

        case (state_reg)
            IDLE: begin
                if (~rx) begin
                    state_next = START;
                    s_next = 4'b0;
                end
            end
            START: begin
                if (s_tick) begin
                    if (s_reg == 7) begin
                        state_next = DATA;
                        s_next = 0;
                        n_next = 0;
                    end else
                        s_next = s_reg + 1;
                end
            end
            DATA: begin
                if (s_tick) begin
                    if (s_reg == 15) begin
                        s_next = 0;
                        b_next = {rx, b_reg[7:1]};
                        if (n_reg == (DBIT-1))
                            state_next = STOP;
                        else
                            n_next = n_reg + 1;
                    end else
                        s_next = s_reg + 1;
                end
            end
            STOP: begin
                if (s_tick) begin
                    if (s_reg == (SB_TICK-1)) begin
                        state_next = IDLE;
                        rx_done_tick = 1'b1;
                    end else
                        s_next = s_reg + 1;
                end
            end
        endcase
    end

    // Output
    assign dout = b_reg;

endmodule
