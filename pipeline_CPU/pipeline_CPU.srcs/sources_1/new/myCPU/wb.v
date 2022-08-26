// module WB

`include "defines.v"
module wb(
	input wire					  	rst,
	
	// info from EX	
	input wire[4:0]      			mem_wd,
	input wire                   	mem_wreg,
	input wire[31:0]			  	mem_wdata,
	
	// info to Regfile
	output reg[4:0]      			wb_wd,
	output reg                   	wb_wreg,
	output reg[31:0]			 	wb_wdata
);
	always @ (*) begin
		if(rst == `RstEnable) begin
			wb_wd <= 5'b00000;
			wb_wreg <= `WriteDisable;
		  	wb_wdata <= `ZeroWord;
		end else begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
		end
	end
endmodule