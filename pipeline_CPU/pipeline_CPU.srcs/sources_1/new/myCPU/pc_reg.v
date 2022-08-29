// module PC

`include "defines.v"
module pc_reg(
	input wire					clk,
	input wire					rst,
	
	// info from ID
	input wire					branch_flag_i, 
	input wire[31:0] 			branch_target_addr_i,
	input wire[5:0]             stall,
	input wire 					flush,
	input wire[31:0]			    new_pc,
	output reg[31:0]            pc
);
    
    always @(posedge clk)begin
    	if(rst==`RstEnable)begin
    		pc<=32'h00000000;
    	end
    	else if(branch_flag_i == `Branch)begin
    		pc <= branch_target_addr_i;
    	end
    	else if (stall[0] == `StallDisable) begin
    		pc<=pc+4'h4;
    	end
    end
    
/*    always @(posedge clk) begin
        if (flush == `Flush) begin
            pc <= new_pc;
        end
	end*/
endmodule