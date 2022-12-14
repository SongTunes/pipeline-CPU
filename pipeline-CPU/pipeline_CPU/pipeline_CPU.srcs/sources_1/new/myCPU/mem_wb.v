// module MEM_WB
/*
In MEM_WB, we pass the result in MEM to
WB module after a clk cycle.
*/
`include "defines.v"

module mem_wb(
    input wire                      clk,
    input wire                      rst,

    // result in MEM
    input wire[4:0]                 mem_wd,
    input wire                      mem_wreg,
    input wire[31:0]                mem_wdata,
    input wire[5:0]                 stall,
    // info we will pass to WB
    output reg[4:0]                 wb_wd,
    output reg                      wb_wreg,
    output reg[31:0]                wb_wdata

);

    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            wb_wd <= 5'b00000;
            wb_wreg <= `WriteDisable;
            wb_wdata <= `ZeroWord;
        end
        else if (stall[4] == `StallEnable && stall[5] == `StallDisable) begin
			wb_wd <= 5'b00000;
			wb_wreg <= `WriteDisable;
			wb_wdata <= `ZeroWord;

		end
		else if (stall[4] == `StallDisable) begin
            wb_wd <= mem_wd;
            wb_wreg <= mem_wreg;
            wb_wdata <= mem_wdata;
        end
    end



endmodule