`include "defines.v"

module ctrl (
	input wire				rst,
	input wire				stallreq_from_id,
    output reg[5:0]			stall,
	output reg[31:0]		    new_pc,
	output reg 				flush
);

	always @(*) begin
		if (rst == `RstEnable) begin
		    stall <= 6'b000000;
			//new_pc <= `ZeroWord;
			//flush <= `NotFlush;
		end
		else if (stallreq_from_id == `StallEnable) begin
		    stall <= 6'b000111;
			//flush <= `NotFlush;
		end
		else begin
		    stall <= 6'b000000;
			//flush <= `NotFlush;
			//new_pc <= `ZeroWord;
		end
	end

endmodule