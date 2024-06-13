module mcu_top_module #(
    parameter WIDTH = 32 ,DVSR = 26,UART_D_S_R = 32'h0000_0500 ,
    UART_B = 32'h0000_0501, UART_W_D = 32'h0000_0502,UART_DUMB = 32'h0000_0503)(
	CLOCK,
	RESET,
	serial_in,
	serial_out
);

input CLOCK;
input RESET;
input serial_in;
output serial_out;

wire [ WIDTH - 1 : 0 ]       rom_data;
wire [ WIDTH - 1 : 0 ]       ram_r_data;
wire [ WIDTH - 1 : 0 ]       rom_address;
wire [ WIDTH - 1 : 0 ]       ram_address;
wire [ WIDTH - 1 : 0 ]       ram_w_data;
wire [ WIDTH - 1 : 0 ]       muxed_read_data;
wire [ WIDTH - 1 : 0 ]       uart_r_data;
wire uart_wen;
wire uart_ren;
wire ram_w_r_en;
wire read_Write_ram_en;
wire CS ;


RISC_V_TOP_MODULE core (
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
assign uart_ren = (ram_address == UART_D_S_R ) & ~read_Write_ram_en ;
assign ram_w_r_en = (ram_address != UART_D_S_R && ram_address != UART_B && ram_address != UART_W_D && ram_address != UART_DUMB) & read_Write_ram_en ;
assign muxed_read_data = (ram_address == UART_D_S_R ) ?  uart_r_data : ram_r_data;
assign CS = uart_wen  | uart_ren;

(* KEEP = "true" *) INSTRUCTION_MEMORY rom (
			.ADDRESS(rom_address),
			.INSTRUCTION(rom_data)
	);

DATA_MEMORY ram (
		.CLK(CLOCK),
		.ADDRESS(ram_address),
		.WRITE_READ(ram_w_r_en),
		.WRITE_DATA(ram_w_data), 
		.READ_DATA(ram_r_data) 
	);

chu_uart #(.FIFO_DEPTH_BIT(8) )
    UART
   (
    .clk(CLOCK),
    .reset(~RESET),
    // slot interface
    .cs(CS),
    .read(uart_ren),
    .write(uart_wen),
    .addr(ram_address[4:0]),
    .wr_data(ram_w_data),
    .rd_data(uart_r_data),
    .tx(serial_out),
    .rx(serial_in)    
   );
/*
uart UART (
		.clk(~CLOCK),
		.reset(~RESET),
     	 .rd_uart(uart_ren),
		.wr_uart(uart_wen),
		.rx(serial_in),
    	.w_data(ram_w_data[7:0]),
    	.dvsr(DVSR),
     	.tx_full(),
		.rx_empty(),
		.tx(serial_out),
    	.r_data(uart_r_data)
);
*/
endmodule