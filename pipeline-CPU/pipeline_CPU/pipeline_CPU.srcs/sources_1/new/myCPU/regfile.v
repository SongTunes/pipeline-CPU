// module Regfile

`include "defines.v"
module regfile(
    input wire clk,
    input wire rst,

    // write port
    input wire                  we,
    input wire[4:0]             waddr,
    input wire[31:0]            wdata,

    // read port1
    input wire                  re1,  // read enable
    input wire[4:0]             raddr1,
    output reg[31:0]            rdata1,

    // read port2
    input wire                  re2,
    input wire[4:0]             raddr2,
    output reg[31:0]            rdata2
);

    // registers
    reg[31:0] regs[0:31];
    
    integer i;
    initial begin
        for (i = 0; i < 32; i = i+ 1) regs[i] <= 0;  
    end
    
    
    // write
    always @ (posedge clk) begin
        if(rst==`RstDisable)begin
            if((we==`WriteEnable) && (waddr !=`RegNumLog2'h0))begin
                regs[waddr]<=wdata;
            end
        end
    end
    
    // read from reg1
    always @ (*) begin
        if(rst==`RstEnable) begin
            rdata1<=`ZeroWord;
        end
        else if(raddr1==`RegNumLog2'h0) begin
            rdata1<=`ZeroWord;
        end
        else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
            rdata1 <= wdata;  // use the data instead of read it from reg
        end  // solve 2 instructions has data rela in ID and WB
        else if(re1==`ReadEnable) begin
            rdata1<=regs[raddr1];
        end
        else begin
            rdata1<=`ZeroWord;
        end
    end
    
    // read from reg2
    always @ (*) begin
        if(rst==`RstEnable) begin
            rdata2<=`ZeroWord;
        end
        else if(raddr2==`RegNumLog2'h0) begin
            rdata2<=`ZeroWord;
        end
        else if((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin
            rdata2 <= wdata;
        end  // 
        else if(re2==`ReadEnable) begin
            rdata2<=regs[raddr2];
        end
        else begin
            rdata2<=`ZeroWord;
        end
    end
endmodule