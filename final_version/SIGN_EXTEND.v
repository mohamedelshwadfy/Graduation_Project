// Module: sign_extend
// Description: Sign extends the immediate field based on the instruction type
// Inputs: instruction - input instruction; immsrc - immediate source
// Outputs: output_extended - sign-extended output

module sign_extend #(parameter WIDTH = 32) (
    input [WIDTH-1:7] instruction,
    input [1:0] immsrc,
    output reg [WIDTH-1:0] output_extended
);

    always @(*) begin
        case (immsrc)
            // I-type
            2'b00: output_extended = {{20{instruction[31]}}, instruction[31:20]};
            // S-type (stores)
            2'b01: output_extended = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            // B-type (branches)
            2'b10: output_extended = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            // J-type (jal)
            2'b11: output_extended = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            default: output_extended = 32'hxxxx_xxxx; // undefined
        endcase
    end

endmodule
