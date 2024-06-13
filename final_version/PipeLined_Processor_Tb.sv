`timescale 1ns/100ps
module PipeLined_Processor_TB ();
    
    reg clk=1'b1,rst,serial_in;
    wire serial_out;
    mcu_top_module Single_Cycle_Top(
                                .CLOCK(clk),
                                .RESET(rst),
				.serial_in(serial_in),
				.serial_out(serial_out)
    );

    initial begin
        $dumpfile("Single Cycle.vcd");
        $dumpvars(0);
    end

    always 
    begin
        #10 clk = ~ clk;
    end
    
    initial begin
        serial_in = 1;
        rst = 1'b0;
        #40;
        rst =1'b1;
        
        rx_byte(8'h05);
        rx_byte(8'h0a);
        rx_byte(8'h0c);
        
        #10000;
        $stop;
    end
    
    task rx_byte(input [7:0] data);
      integer i;
      localparam DVSR = 26;
      begin
        // Start bit
        serial_in = 0;
        #(DVSR * 16 * 20); // Adjust for baud rate
        // Data bits
        for (i = 0; i < 8; i = i + 1) begin
          serial_in = data[i];
          #(DVSR * 16 * 20); // Adjust for baud rate
        end
        // Stop bit
        serial_in = 1;
        #(DVSR * 16 * 20); // Adjust for baud rate
      end
    endtask

endmodule