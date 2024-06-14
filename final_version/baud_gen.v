module baud_gen (
    input wire clk,
    input wire reset,
    input wire [10:0] dvsr,
    output wire tick
);

    // Signal declaration
    reg [10:0] r_reg;
    wire [10:0] r_next;

    // Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            r_reg <= 11'b00000000000;
        else
            r_reg <= r_next;
    end

    // Next-state logic
    assign r_next = (r_reg == dvsr) ? 11'b00000000000 : r_reg + 1;

    // Output logic
    assign tick = (r_reg == 1);

endmodule
