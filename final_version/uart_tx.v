// Module: uart_tx
// Description: UART transmitter
// Parameters: DBIT - Number of data bits; SB_TICK - Number of ticks for 1 stop bit
// Inputs: clk - Clock signal; reset - Reset signal; tx_start - Transmit start signal; s_tick - Tick signal; din - Input data
// Outputs: tx_done_tick - Transmit done tick; tx - Transmit data

module uart_tx #(
    parameter DBIT = 8,     // Number of data bits
    parameter SB_TICK = 16  // Number of ticks for 1 stop bit
) (
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire s_tick,
    input wire [7:0] din,
    output reg tx_done_tick,
    output wire tx
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
    reg tx_reg, tx_next;

    // FSMD state & data registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
            tx_reg <= 1'b1;
        end else begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
            tx_reg <= tx_next;
        end
    end

    // FSMD next-state logic & functional units
    always @* begin
        state_next = state_reg;
        tx_done_tick = 1'b0;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;
        tx_next = tx_reg;

        case (state_reg)
            IDLE: begin
                tx_next = 1'b1;
                if (tx_start) begin
                    state_next = START;
                    s_next = 0;
                    b_next = din;
                end
            end
            START: begin
                tx_next = 1'b0;
                if (s_tick) begin
                    if (s_reg == 15) begin
                        state_next = DATA;
                        s_next = 0;
                        n_next = 0;
                    end else
                        s_next = s_reg + 1;
                end
            end
            DATA: begin
                tx_next = b_reg[0];
                if (s_tick) begin
                    if (s_reg == 15) begin
                        s_next = 0;
                        b_next = b_reg >> 1;
                        if (n_reg == (DBIT-1))
                            state_next = STOP;
                        else
                            n_next = n_reg + 1;
                    end else
                        s_next = s_reg + 1;
                end
            end
            STOP: begin
                tx_next = 1'b1;
                if (s_tick) begin
                    if (s_reg == (SB_TICK-1)) begin
                        state_next = IDLE;
                        tx_done_tick = 1'b1;
                    end else
                        s_next = s_reg + 1;
                end
            end
        endcase
    end

    // Output
    assign tx = tx_reg;

endmodule
