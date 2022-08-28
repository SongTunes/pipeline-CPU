// module EX


`include "defines.v"
module ex(
    input wire                   rst,

    // info from ID
    input wire[4:0]              aluop_i,
    //input wire[2:0]            alusel_i,
    input wire[31:0]             reg1_i,
    input wire[31:0]             reg2_i,
    input wire[4:0]              wd_i,
    input wire                   wreg_i,
    input wire[31:0]		     inst_i,
	
    //
    output reg[4:0]              wd_o,  // addr
    output reg                   wreg_o,  // control signal
    output reg[31:0]             wdata_o,  // alu output

	// pass to others
	output wire[4:0]		     aluop_o,
	output wire[31:0]            mem_addr_o,
	output wire[31:0]		     reg2_o
);

    wire[31:0]                   res_or;		// ans of or
    wire[31:0]                   res_add; // ans of add
    wire[31:0]                   res_sll; // ans of sll
    wire[31:0]                   res_srl; // ans of srl
    wire[31:0]                   res_slt_slti;
    wire[31:0]                   res_sltu_sltiu;
    wire[31:0]                   res_clz;
    wire[31:0]                   res_clo;

    wire[32:0]                   res_add_e;
    wire[32:0]                   res_sub_e;

    wire                         overflow_add;	
    wire                         overflow_sub;


    wire[5:0]                    sa; //offset of sll or srl    

    wire[32:0]                   reg1_e;
    wire[32:0]                   reg2_e;
    wire[31:0]                   reg2_n;
    wire[32:0]                   reg2_n_e;
    wire[31:0]                   result_sum;
    wire[31:0]                   reg1_i_not; 
    // -----
    // pass aluop to MEM
    assign aluop_o = aluop_i;
    
    // mem_addr_o: the addr of mem we will visit
    // reg1_i: base
    // inst_i[15:0]: offset
    assign mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};
    
    //reg2_i: the data of instruction sw
    assign reg2_o = reg2_i;

    // sa: offfset
    assign sa = reg1_i[10:6];    
    
    // calculate
    assign res_add = reg1_i + reg2_i;
    assign res_sub = reg1_i - reg2_i;
    assign res_and = reg1_i & reg2_i;
    assign res_nor = ~(reg1_i | reg2_i);
    assign res_or = reg1_i | reg2_i;
    assign res_xor = reg1_i ^ reg2_i;
    assign res_sll = reg2_i << sa;
    //assign res_srl = reg2_i >> reg1_i[4:0];
    assign res_srl = reg2_i >> sa;
    assign res_sra = ({32{reg2_i[31]}}<<(6'd32-{1'b0,reg1_i[4:0]})) | reg2_i >> reg1_i[4:0]; 
    
    assign result_sum = reg1_i + (~reg2_i) + 1;  // use complement to calculate difference
    assign res_slt_slti = ((reg1_i[31] && !reg2_i[31]) || (!reg1_i[31] && !reg2_i[31] && result_sum[31]) || (reg1_i[31] && reg2_i[31] && result_sum[31])) ? 1 : 0;
    assign res_sltu_stliu = (reg1_i < reg2_i) ? 1 : 0;
    assign reg1_i_not = ~reg1_i;
    assign res_clz = reg1_i_not[31] ? 0 :
                     reg1_i_not[30] ? 1 :
                     reg1_i_not[29] ? 2 :
                     reg1_i_not[28] ? 3 :
                     reg1_i_not[27] ? 4 :
                     reg1_i_not[26] ? 5 :
                     reg1_i_not[25] ? 6 :
                     reg1_i_not[24] ? 7 :
                     reg1_i_not[23] ? 8 :
                     reg1_i_not[22] ? 9 :
                     reg1_i_not[21] ? 10 :
                     reg1_i_not[20] ? 11 :
                     reg1_i_not[19] ? 12 :
                     reg1_i_not[18] ? 13 :
                     reg1_i_not[17] ? 14 :
                     reg1_i_not[16] ? 15 :
                     reg1_i_not[15] ? 16 :
                     reg1_i_not[14] ? 17 :
                     reg1_i_not[13] ? 18 :
                     reg1_i_not[12] ? 19 :
                     reg1_i_not[11] ? 20 :
                     reg1_i_not[10] ? 21 :
                     reg1_i_not[9] ? 22 :
                     reg1_i_not[8] ? 23 :
                     reg1_i_not[7] ? 24 :
                     reg1_i_not[6] ? 25 :
                     reg1_i_not[5] ? 26 :
                     reg1_i_not[4] ? 27 :
                     reg1_i_not[3] ? 28 :
                     reg1_i_not[2] ? 29 :
                     reg1_i_not[1] ? 30 :
                     reg1_i_not[0] ? 31 : 32;
    assign res_clo = reg1_i[31] ? 0 :
                     reg1_i[30] ? 1 :
                     reg1_i[29] ? 2 :
                     reg1_i[28] ? 3 :
                     reg1_i[27] ? 4 :
                     reg1_i[26] ? 5 :
                     reg1_i[25] ? 6 :
                     reg1_i[24] ? 7 :
                     reg1_i[23] ? 8 :
                     reg1_i[22] ? 9 :
                     reg1_i[21] ? 10 :
                     reg1_i[20] ? 11 :
                     reg1_i[19] ? 12 :
                     reg1_i[18] ? 13 :
                     reg1_i[17] ? 14 :
                     reg1_i[16] ? 15 :
                     reg1_i[15] ? 16 :
                     reg1_i[14] ? 17 :
                     reg1_i[13] ? 18 :
                     reg1_i[12] ? 19 :
                     reg1_i[11] ? 20 :
                     reg1_i[10] ? 21 :
                     reg1_i[9] ? 22 :
                     reg1_i[8] ? 23 :
                     reg1_i[7] ? 24 :
                     reg1_i[6] ? 25 :
                     reg1_i[5] ? 26 :
                     reg1_i[4] ? 27 :
                     reg1_i[3] ? 28 :
                     reg1_i[2] ? 29 :
                     reg1_i[1] ? 30 :
                     reg1_i[0] ? 31 : 32;

    // overflow?
    assign reg1_e = {reg1_i[31], reg1_i[31:0]};
    assign reg2_e = {reg2_i[31], reg2_i[31:0]};

    assign res_add_e = reg1_e + reg2_e;

    assign overflow_add = (reg1_i[31] ~^ reg2_i[31]) && (res_add_e[32] ^ res_add_e[31]);

    
    assign res_sub_e = reg1_e + reg2_n_e;
    assign overflow_sub = (reg1_i[31] ~^ reg2_n[31]) && (res_sub_e[32] ^ res_sub_e[31]);
    
    
    
    // select a ans according to aluop_i
    always @ (*) begin
        wd_o <= wd_i;       // addr of the reg we will write
    	// ignore if overflow
    	if((aluop_i == `EXE_ADD_OP | `EXE_ADDI_OP) && (overflow_add == 1'b1)) begin
    		wreg_o <= `WriteDisable;
    	end 
        else if(aluop_i == `EXE_SUB_OP && overflow_sub == 1'b1) begin
            wreg_o <= `WriteDisable;
        end
        else begin
    		wreg_o <= wreg_i;
    	end
        case(aluop_i)
            `EXE_ADD_OP : begin
    			wdata_o <= res_add;
    		end
    		`EXE_SUB_OP : begin
    			wdata_o <= res_sub;
    		end
    		`EXE_AND_OP : begin
    			wdata_o <= res_and;
    		end
    		`EXE_NOR_OP : begin
    			wdata_o <= res_nor;
    		end
            `EXE_OR_OP : begin
                wdata_o <= res_or;
            end
    		`EXE_XOR_OP : begin
    			wdata_o <= res_xor;
    		end
    		`EXE_SRL_OP : begin
    			wdata_o <= res_srl;
    		end
    		`EXE_SRA_OP : begin
    			wdata_o <= res_sra;
    		end
            `EXE_SLL_OP : begin
                wdata_o <= res_sll;
            end
     		`EXE_ADDI_OP : begin
    			wdata_o <= res_add;
    		end
    		`EXE_ADDIU_OP : begin
    			wdata_o <= res_add;
    		end
    		`EXE_ADDU_OP : begin
    			wdata_o <= res_add;
    		end
            `EXE_SLT_OP : begin 
                wdata_o <= res_slt_slti;
            end
            `EXE_SLTI_OP : begin 
                wdata_o <= res_slt_slti;
            end
            `EXE_SLTU_OP : begin 
                wdata_o <= res_sltu_sltiu;
            end
            `EXE_SLTIU_OP : begin 
                wdata_o <= res_sltu_sltiu;
            end
            `EXE_CLZ_OP : begin
                wdata_o <= res_clz;
            end
            `EXE_CLO_OP : begin
                wdata_o <= res_clo;
            end
            default : begin
                wdata_o <= `ZeroWord;
            end
        endcase
    end
endmodule