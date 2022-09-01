`timescale 1ns / 1ps

module testbench();
    reg rstn, clk;
    reg down, up;
    initial begin
        rstn = 1'b0;
        clk = 1'b0;
        down = 1'b0;
        #100 rstn = 1'b1;
        #1000 down = 1'b1;
        #800000 down = 1'b0;

        #1000 up = 1'b1;
        #800000 up = 1'b0;

        #1000 up = 1'b1;
        #800000 up = 1'b0;

    end

    always #5 clk = ~clk;

    pipeline_CPU pipeline_CPU0(
        .rstn(rstn),
        .clk(clk),
        .down_btn_key(down),
        .up_btn_key(up)
    );
endmodule
