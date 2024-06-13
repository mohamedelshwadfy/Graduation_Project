module baud_gen (
    input clk,
    input reset,
    input [10:0] dvsr,
    output tick
);

    // declaration
    reg [10:0] r_reg;
    wire [10:0] r_next;

    // body
    // register
    always @(posedge clk or posedge reset) begin
      if (reset)
         r_reg <= 11'b00000000000;
      else
         r_reg <= r_next;
     end
    // next-state logic
    
    assign r_next = (r_reg==dvsr) ? 11'b00000000000 : r_reg + 1;

    // output logic
    assign tick = (r_reg == 1);

endmodule