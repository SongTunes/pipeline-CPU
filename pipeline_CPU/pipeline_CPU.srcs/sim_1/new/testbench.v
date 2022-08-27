`timescale 1ns / 1ps

module testbench();
    reg rstn, clk;
    initial begin
        // Load instructions
     $readmemh("C:/Users/s2330/Desktop/makeCPUresourse/pipeline-CPU/pipeline_CPU/test/logicInstructions.txt", TOP.INSTR_MEM.im);
     // Load register initial values
     $readmemh("C:/Users/s2330/Desktop/makeCPUresourse/single-cycle-processor-master/tests/register.txt", TOP.REG_FILE.gpr);
     // Load memory data initial values
     $readmemh("C:/Users/s2330/Desktop/makeCPUresourse/single-cycle-processor-master/tests/data_memory.txt", TOP.DATA_MEM.dm);
        rstn = 1'b0;
        clk = 1'b0;
        #100 rstn = 1'b1;
    end

    always #5 clk = ~clk;

    pipeline_CPU pipeline_CPU0(
        .rstn(rstn),
        .clk(clk)
    );
endmodule
