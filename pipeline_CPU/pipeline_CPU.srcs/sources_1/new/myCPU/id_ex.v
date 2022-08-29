// module ID_EX
/*
In id_ex module, we pass the info we get in ID module, 
after a clk cycle, to EX module.
*/
`include "defines.v"

module id_ex(
    input wire                      clk,
    input wire                      rst,

    // info from ID
    input wire[4:0]                 id_aluop,
    //input wire[2:0]               id_alusel,
    input wire[31:0]                id_reg1,
    input wire[31:0]                id_reg2,
    input wire[4:0]                 id_wd,
    input wire                      id_wreg,
    input wire[31:0]                id_inst,
    input wire[5:0]                 stall,
    // info we need to pass to EX
    output reg[4:0]                 ex_aluop,
    //output reg[2:0]               ex_alusel,
    output reg[31:0]                ex_reg1,
    output reg[31:0]                ex_reg2,
    output reg[4:0]                 ex_wd,
    output reg                      ex_wreg,
    output reg[31:0]                ex_inst

);

    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            ex_aluop <= `EXE_NOP_OP;
            //ex_alusel <= `EXE_RES_NOP;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= 5'b00000;
            ex_wreg <= `WriteDisable;
            ex_inst <= `ZeroWord;
        end
        else if (stall[2] == `StallEnable && stall[3] == `StallDisable) begin
			ex_aluop <= `EXE_NOP_OP;
			//ex_alusel <= `EXE_RES_NOP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= 5'b00000;
			ex_wreg <= `WriteDisable;
			
		end
        else if (stall[2] == `StallDisable) begin
            ex_aluop <= id_aluop;
            //ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;
            ex_inst <= id_inst;
        end
    
    end


endmodule