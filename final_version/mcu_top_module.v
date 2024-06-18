// Module: mcu_top
// Description: Top-level module for the MCU
// Parameters: WIDTH - Data width; DVSR - Baud rate divisor; UART_D_S_R - UART data status register address
//             UART_B - UART base address; UART_W_D - UART write data address; UART_DUMB - UART dummy address
// Inputs: clock - Clock signal; reset - Reset signal; serial_in - Serial input
// Outputs: serial_out - Serial output

module mcu_top #(
    parameter WIDTH = 32,
    parameter DVSR = 26,
    parameter UART_D_S_R = 32'h0000_0500,
    parameter UART_B = 32'h0000_0501,
    parameter UART_W_D = 32'h0000_0502,
    parameter UART_DUMB = 32'h0000_0503
) (
    input clock,
    input reset,
    input serial_in,
    output serial_out
);

    wire [WIDTH-1:0] rom_data;
    wire [WIDTH-1:0] ram_r_data;
    wire [WIDTH-1:0] rom_address;
    wire [WIDTH-1:0] ram_address;
    wire [WIDTH-1:0] ram_w_data;
    wire [WIDTH-1:0] muxed_read_data;
    wire [WIDTH-1:0] uart_r_data;
    wire uart_wen;
    wire uart_ren;
    wire ram_w_r_en;
    wire read_write_ram_en;
    wire cs;

    // Instantiate RISC-V Core
    risc_v_core core (
        .clock(clock),
        .reset(reset),
        .rom_data(rom_data),
        .ram_r_data(muxed_read_data),
        .rom_address(rom_address),
        .ram_address(ram_address),
        .ram_w_data(ram_w_data),
        .read_write_ram_en(read_write_ram_en)
    );

    assign uart_wen = (ram_address == UART_B || ram_address == UART_W_D || ram_address == UART_DUMB) & read_write_ram_en;
    assign uart_ren = (ram_address == UART_D_S_R) & ~read_write_ram_en;
    assign ram_w_r_en = (ram_address != UART_D_S_R && ram_address != UART_B && ram_address != UART_W_D && ram_address != UART_DUMB) & read_write_ram_en;
    assign muxed_read_data = (ram_address == UART_D_S_R) ? uart_r_data : ram_r_data;
    assign cs = uart_wen | uart_ren;

    // Instantiate ROM (Instruction Memory)
    instruction_memory rom (
        .address(rom_address),
        .instruction(rom_data)
    );

    // Instantiate RAM (Data Memory)
    data_memory ram (
        .clk(clock),
        .address(ram_address[15:0]),
        .write_read(ram_w_r_en),
        .write_data(ram_w_data),
        .read_data(ram_r_data)
    );

    // Instantiate UART
    chu_uart #(.FIFO_DEPTH_BIT(8)) uart (
        .clk(clock),
        .reset(~reset),
        .cs(cs),
        .read(uart_ren),
        .write(uart_wen),
        .addr(ram_address[1:0]),
        .wr_data(ram_w_data[7:0]),
        .rd_data(uart_r_data),
        .tx(serial_out),
        .rx(serial_in)
    );

endmodule
