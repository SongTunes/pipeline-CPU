// module IF_ID
`include "defines.v"

module if_id(
    input wire clk,
    input wire rst,

    // signal from if
    input wire[31:0] if_pc,
    input wire[31:0] if_inst,

    // branch flush
    input wire[5:0] stall,
    input wire flush,


    // signal in id

    output reg[31:0] id_pc,
    output reg[31:0] id_inst
);

    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;

        end
        else if(flush == 1'b1) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
        else if (stall[1] == `StallEnable && stall[2] == `StallDisable) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
        else if (stall[1] == `StallDisable) begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end

    end
endmodule