// Module: MCUTop
// Description: Top-level module for the MCU
// Inputs: CLOCK - clock signal; RESET - reset signal; serial_in - serial input
// Outputs: serial_out - serial output

module MCUTop #(
    parameter WIDTH = 32,
    parameter DVSR = 26,
    parameter UART_D_S_R = 32'h0000_0500,
    parameter UART_B = 32'h0000_0501,
    parameter UART_W_D = 32'h0000_0502,
    parameter UART_DUMB = 32'h0000_0503
) (
    input CLOCK,
    input RESET,
    input serial_in,
    output serial_out
);

wire [WIDTH - 1 : 0] rom_data;
wire [WIDTH - 1 : 0] ram_r_data;
wire [WIDTH - 1 : 0] rom_address;
wire [WIDTH - 1 : 0] ram_address;
wire [WIDTH - 1 : 0] ram_w_data;
wire [WIDTH - 1 : 0] muxed_read_data;
wire [WIDTH - 1 : 0] uart_r_data;
wire uart_wen;
wire uart_ren;
wire ram_w_r_en;
wire read_Write_ram_en;
wire CS;

RiscVCore core (
    .CLOCK(CLOCK),
    .RESET(RESET),
    .rom_data(rom_data),
    .ram_r_data(muxed_read_data),
    .rom_address(rom_address),
    .ram_address(ram_address),
    .ram_w_data(ram_w_data),
    .Read_Write_ram_en(read_Write_ram_en)
);

assign uart_wen = (ram_address == UART_B || ram_address == UART_W_D || ram_address == UART_DUMB) & read_Write_ram_en;
assign uart_ren = (ram_address == UART_D_S_R) & ~read_Write_ram_en;
assign ram_w_r_en = (ram_address != UART_D_S_R && ram_address != UART_B && ram_address != UART_W_D && ram_address != UART_DUMB) & read_Write_ram_en;
assign muxed_read_data = (ram_address == UART_D_S_R) ? uart_r_data : ram_r_data;
assign CS = uart_wen | uart_ren;

InstructionMemory rom (
    .ADDRESS(rom_address),
    .INSTRUCTION(rom_data)
);

DataMemory ram (
    .CLK(CLOCK),
    .ADDRESS(ram_address[15:0]),
    .WRITE_READ(ram_w_r_en),
    .WRITE_DATA(ram_w_data),
    .READ_DATA(ram_r_data)
);

ChuUart #(.FIFO_DEPTH_BIT(8)) UART (
    .clk(CLOCK),
    .reset(~RESET),
    .cs(CS),
    .read(uart_ren),
    .write(uart_wen),
    .addr(ram_address[1:0]),
    .wr_data(ram_w_data[7:0]),
    .rd_data(uart_r_data),
    .tx(serial_out),
    .rx(serial_in)
);

endmodule
