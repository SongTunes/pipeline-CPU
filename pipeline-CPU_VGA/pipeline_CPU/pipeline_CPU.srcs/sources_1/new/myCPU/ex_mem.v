// module EX_MEM
/*
In EX_MEM, we pass the info(calculate result)
to MEM module after a clk cycle.

*/
`include "defines.v"

module ex_mem(

    input wire clk,
    input wire rst,

    // info from EX
    input wire[4:0]         ex_wd,
    input wire              ex_wreg,
    input wire[31:0]        ex_wdata,
    
    input wire[4:0]         ex_aluop,
    input wire[31:0]        ex_mem_addr,
    input wire[31:0]        ex_reg2,
    input wire[5:0]         stall,
    input wire 			    ex_is_in_delayslot,

    // info we will pass to MEM
    output reg[4:0]         mem_wd,
    output reg              mem_wreg,
    output reg[31:0]        mem_wdata,

    output reg[4:0]         mem_aluop,
    output reg[31:0]        mem_mem_addr,
    output reg[31:0]        mem_reg2,
    output reg 				mem_is_in_delayslot

);

    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            mem_wd <= 5'b00000;
            mem_wreg <= `WriteDisable;
            mem_wdata <= `ZeroWord;
            mem_aluop <= 5'b00000;
            mem_mem_addr <= `ZeroWord;
            mem_reg2 <= `ZeroWord;
            mem_is_in_delayslot <= `NotInDelaySlot;
        end
        else if (stall[3] == `StallEnable && stall[4] == `StallDisable) begin
			mem_wd <= 5'b00000;
			mem_wreg <= `WriteDisable;
			mem_wdata <= `ZeroWord;
			mem_aluop <= 5'b00000;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
			mem_is_in_delayslot <= `NotInDelaySlot;
		end
        else if (stall[3] == `StallDisable) begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
            mem_aluop <= ex_aluop;
            mem_mem_addr <= ex_mem_addr;
            mem_reg2 <= ex_reg2;
            mem_is_in_delayslot <= ex_is_in_delayslot;
        end
    end
endmodule