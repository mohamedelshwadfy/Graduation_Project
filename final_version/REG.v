module REG #(parameter WIDTH = 32 ) (
		clk,
		rst,
		INPUT,
		OUT,
        EN,
        CLR
	);

input clk,rst,EN,CLR;
input  [ WIDTH - 1 : 0 ]  INPUT;

(* KEEP = "true" *) output reg [ WIDTH - 1 : 0 ]  OUT;

always @(posedge clk,negedge rst) begin
	if(~rst) begin
		OUT <=  {WIDTH{1'b0}};
	end
	
    else begin
        if (CLR)	
            OUT <=  {WIDTH{1'b0} };
        else if (~EN)
            OUT <= INPUT;
         
    end 
end

endmodule 