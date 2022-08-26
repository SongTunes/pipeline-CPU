// module IF_ID

module if_id(
    input wire clk,
    input wire rst,

    // signal from if
    input wire[31:0] if_pc,
    input wire[31:0] if_inst,


    // signal in id

    output reg[31:0] id_pc,
    output reg[31:0] id_inst
);

    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;

        end
        else begin
            id_pc <= if_pc;
            id_inst <= if_inst;

        end
    end
endmodule