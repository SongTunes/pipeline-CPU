// module EX_MEM
/*
In EX_MEM, we pass the info(calculate result)
to MEM module after a clk cycle.

*/
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
    

    // info we will pass to MEM
    output reg[4:0]         mem_wd,
    output reg              mem_wreg,
    output reg[31:0]        mem_wdata,

    output reg[4:0]         mem_aluop,
    output reg[31:0]        mem_mem_addr,
    output reg[31:0]        mem_reg2

);

    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            mem_wd <= 5'b00000;
            mem_wreg <= `WriteDisable;
            mem_wdata <= `ZeroWord;
            mem_aluop <= 5'b00000;
            mem_mem_addr <= `ZeroWord;
            mem_reg2 <= `ZeroWord;
        end
        else begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
            mem_aluop <= ex_aluop;
            mem_mem_addr <= ex_mem_addr;
            mem_reg2 <= ex_reg2;
        end
    end
endmodule