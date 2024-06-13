module hazard_unit( 
	rst,
 	RegWriteM,
	RegWriteW,
	ResultsrcE0, 
	PcsrcE, 
	RD_M, 
	RD_W,
	Rs1_E, 
	Rs2_E, 
	Rs_1D, 
	Rs_2D, 
	RDE, 
	Stall_F, 
	Stall_D, 
	Flush_E, 
	Flush_D, 
	ForwardAE, 
	ForwardBE 
	);

input rst;
input RegWriteM;
input RegWriteW;
input ResultsrcE0; 
input PcsrcE;
input [4:0] RD_M;
input [4:0] RD_W; 
input [4:0] Rs1_E; 
input [4:0] Rs2_E; 
input [4:0] Rs_1D; 
input [4:0] Rs_2D; 
input [4:0] RDE;

output Stall_F;
output Stall_D; 
output Flush_E; 
output Flush_D;
output [1:0] ForwardAE;
output [1:0] ForwardBE;

wire lw_stall ;
    
    assign ForwardAE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs1_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs1_E)) ? 2'b01 : 2'b00;
                       
    assign ForwardBE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs2_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs2_E)) ? 2'b01 : 2'b00;

    assign lw_stall = (ResultsrcE0 & ((Rs_1D == RDE) | (Rs_2D == RDE)));
    assign Stall_F = lw_stall ;
    assign Stall_D = lw_stall ; 
    assign Flush_D = PcsrcE ;
    assign Flush_E = lw_stall | PcsrcE ;

endmodule 