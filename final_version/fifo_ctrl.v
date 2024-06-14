module fifo_ctrl #(
    parameter ADDR_WIDTH = 4  // Number of address bits
) (
    input wire clk,
    input wire reset,
    input wire rd,
    input wire wr,
    output reg empty,
    output reg full,
    output reg [ADDR_WIDTH-1:0] w_addr,
    output reg [ADDR_WIDTH-1:0] r_addr
);

    // Signal declaration
    reg [ADDR_WIDTH-1:0] w_ptr_logic, w_ptr_next, w_ptr_succ;
    reg [ADDR_WIDTH-1:0] r_ptr_logic, r_ptr_next, r_ptr_succ;
    reg full_logic, empty_logic, full_next, empty_next;

    // Registers for status and read/write pointers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w_ptr_logic <= 0;
            r_ptr_logic <= 0;
            full_logic <= 1'b0;
            empty_logic <= 1'b1;
        end else begin
            w_ptr_logic <= w_ptr_next;
            r_ptr_logic <= r_ptr_next;
            full_logic <= full_next;
            empty_logic <= empty_next;
        end
    end

    // Next-state logic for read and write pointers
    always @(*) begin
        // Successive pointer values
        w_ptr_succ = w_ptr_logic + 1;
        r_ptr_succ = r_ptr_logic + 1;
        // Default: keep old values
        w_ptr_next = w_ptr_logic;
        r_ptr_next = r_ptr_logic;
        full_next = full_logic;
        empty_next = empty_logic;

        case ({wr, rd})
            2'b01: // Read
                if (~empty_logic) begin
                    r_ptr_next = r_ptr_succ;
                    full_next = 1'b0;
                    if (r_ptr_succ == w_ptr_logic)
                        empty_next = 1'b1;
                end
            2'b10: // Write
                if (~full_logic) begin
                    w_ptr_next = w_ptr_succ;
                    empty_next = 1'b0;
                    if (w_ptr_succ == r_ptr_logic)
                        full_next = 1'b1;
                end
            2'b11: // Write and read
                begin
                    w_ptr_next = w_ptr_succ;
                    r_ptr_next = r_ptr_succ;
                end
            default: ; // 2'b00; null statement; no operation
        endcase
    end

    // Output
    always @(*) begin
        w_addr = w_ptr_logic;
        r_addr = r_ptr_logic;
        full = full_logic;
        empty = empty_logic;
    end
endmodule
