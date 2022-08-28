// module ID
/*
In module ID, we analyze the instruction
and get some infomation we need.
*/

`include "defines.v"
module id(
    input wire                          rst,
    input wire[31:0]                    pc_i,  // the value of pc(the addr of inst)
    input wire[31:0]                    inst_i,

    // data from reg
    input wire[31:0]                    rd1_i,
    input wire[31:0]                    rd2_i,

    // extra data wire to solve the data rela
    input wire                          ex_wreg_i,  // if we are going to write the reg in EX
    input wire[4:0]                     ex_wd_i,  // the reg addr we are going to write
    input wire[31:0]                    ex_wdata_i,  // the data we are going to write
    input wire                          mem_wreg_i,  // MEM
    input wire[4:0]                     mem_wd_i,
    input wire[31:0]                    mem_wdata_i,

    // info to Regfile
    output reg                          reg1_read_o,  // control signal: read enable. imm:0 or reg:1
    output reg                          reg2_read_o,  // imm:0 or reg:1

    output reg[4:0]                     reg1_addr_o,  // the id of the reg1 that we will read
    output reg[4:0]                     reg2_addr_o,  // the id of the reg2 that we will read
	
	// branch info to PC
	output reg 					        branch_flag_o,
	output reg[31:0]			        branch_target_addr_o,
	
    // info to EX
    output reg[4:0]                     aluop_o,
    //output reg[2:0]                   alusel_o,
    output reg[31:0]                    reg1_o,  // the op num we read
    output reg[31:0]                    reg2_o,
    output reg[4:0]                     wd_o,  // the id of the reg we will wb, its value depends on the instruction.
    output reg                          wreg_o,
	output wire[31:0]                   inst_o,

    output reg                          flush
);
    // 
    wire[5:0] op = inst_i[31:26];
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0];
    wire[4:0] op4 = inst_i[20:16];
    
    //
    reg[31:0]   imm;
    
    wire[31:0] pc_plus_4;
    wire[31:0] imm_sll2_signedext; 
    
    assign pc_plus_4 = pc_i +4;
    assign imm_sll2_signedext = {{14{inst_i[15]}}, inst_i[15:0], 2'b00 };  
    
    assign inst_o = inst_i;
    
    // translation
    always @ (*) begin
        if(rst == `RstEnable) begin
            aluop_o <=  `EXE_NOP_OP;
         
            wd_o    <=  5'b00000;
            wreg_o  <=  `WriteDisable;
            reg1_read_o <=  1'b0;
            reg2_read_o <=  1'b0;
            reg1_addr_o <=  5'b00000;
            reg2_addr_o <=  5'b00000;
            imm         <=  32'h0;
    		branch_target_addr_o <= `ZeroWord;
    		branch_flag_o <= `NotBranch;
            flush <= `NotFlush;
        end 
        else begin
            aluop_o <=  `EXE_NOP_OP;
          
            wd_o    <=  inst_i[15:11];
            wreg_o  <=  `WriteDisable;
            reg1_read_o <=  1'b0;
            reg2_read_o <=  1'b0;
            reg1_addr_o <=  inst_i[25:21];
            reg2_addr_o <=  inst_i[20:16];
            imm         <=  `ZeroWord;    
    		branch_target_addr_o <= `ZeroWord;
    		branch_flag_o <= `NotBranch;
            flush <= `NotFlush;
    
            case(op)
                `INST_FUNC:  begin  // special
                    
                    case(op3)
                        `FUNC_ADD: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_ADD_OP;
                        
                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                        end
                        `FUNC_ADDU: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_ADDU_OP;
                        
                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                            end
                        `FUNC_SUB: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_SUB_OP;
                                
                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                            end
                        `FUNC_SUBU: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_SUB_OP;
                        
                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                        end
                        `FUNC_AND: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_AND_OP;
                        
                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                        end
                        `FUNC_NOR: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_NOR_OP;
                        
                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                        end
                        `FUNC_OR: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_OR_OP;
                
                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                        end
                        `FUNC_XOR: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_XOR_OP;
                
                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                        end
                        `FUNC_SRLV: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_SRL_OP;

                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                        end
                        `FUNC_SRAV: begin
                            wreg_o <= `WriteEnable;		
                            aluop_o <= `EXE_SRA_OP;

                            reg1_read_o <= 1'b1;	
                            reg2_read_o <= 1'b1;
                        end
                        `FUNC_SLL: begin
                            wreg_o <= `WriteEnable;
                            aluop_o <= `EXE_SLL_OP;
                            imm <= {16'h0, inst_i[15:0]};
                            reg1_read_o <= 1'b0;
                            reg2_read_o <= 1'b1;          
                        end
                        `FUNC_SRL: begin
                            wreg_o <= `WriteEnable;
                            aluop_o <= `EXE_SRL_OP;
                            imm <= {16'h0, inst_i[15:0]};
                            reg1_read_o <= 1'b0;
                            reg2_read_o <= 1'b1;          
                        end
                        
                            
                        
                        
                        default : begin
                        end
                    endcase
                        
                end
                `INST_ORI : begin
                    wreg_o  <=  `WriteEnable;  // ori need write enable
                    aluop_o <=  `EXE_OR_OP;

                    reg1_read_o <= 1'b1;  // 1: reg
                    reg2_read_o <= 1'b0;  // 0: imm
                    imm <=  {16'h0, inst_i[15:0]};  // 0 expend
                    wd_o <= inst_i[20:16];  // reg id we are going to write
                end
                `INST_LUI : begin          // lui
                    wreg_o  <=  `WriteEnable;
                    aluop_o <=  `EXE_OR_OP;
                
                    reg1_read_o <= 1'b1;
                    reg2_read_o <= 1'b0;
                    imm <=  {inst_i[15:0], 16'h0};  // low 16b = 0
                    wd_o <= inst_i[20:16];  // rt
                end
                `INST_J : begin
    		  		wreg_o <= `WriteDisable;		
    				aluop_o <= `EXE_J_OP;
    		  		//alusel_o <= `EXE_RES_JUMP_BRANCH; 
    				reg1_read_o <= 1'b0;	
    				reg2_read_o <= 1'b0;
    			    branch_target_addr_o <= {pc_plus_4[31:28], inst_i[25:0], 2'b00};
    			    branch_flag_o <= `Branch;	  
                    // flush the pipeline
                    flush <= `Flush;  	
    			end
    			`INST_BEQ : begin
    		  		wreg_o <= `WriteDisable;		
    				aluop_o <= `EXE_BEQ_OP;
    		  		//alusel_o <= `EXE_RES_JUMP_BRANCH; 
    				reg1_read_o <= 1'b1;	
    				reg2_read_o <= 1'b1;
    		  		if(reg1_o == reg2_o) begin
    			    	branch_target_addr_o <= pc_plus_4 + imm_sll2_signedext;
    			    	branch_flag_o <= `Branch;	
                        // flush the pipeline
                        flush <= `Flush;  	
    			    end
    			end
    			`INST_LW : begin
    		  		wreg_o <= `WriteEnable;		
    				aluop_o <= `EXE_LW_OP;
    		  		//alusel_o <= `EXE_RES_LOAD_STORE; 
    				reg1_read_o <= 1'b1;	
    				reg2_read_o <= 1'b0;	  	
    				wd_o <= inst_i[20:16]; 
    			end
    			`INST_SW : begin
    		  		wreg_o <= `WriteDisable;		
    				aluop_o <= `EXE_SW_OP;
    		  		reg1_read_o <= 1'b1;	
    				reg2_read_o <= 1'b1; 
    		  		//alusel_o <= `EXE_RES_LOAD_STORE; 
    			end
    			
    			`INST_BNE : begin
    		  		wreg_o <= `WriteDisable;		
    				aluop_o <= `EXE_BNE_OP;
    		  		//alusel_o <= `EXE_RES_JUMP_BRANCH; 
    				reg1_read_o <= 1'b1;	
    				reg2_read_o <= 1'b1;
    		  		if(reg1_o != reg2_o) begin
    			    	branch_target_addr_o <= pc_plus_4 + imm_sll2_signedext;
    			    	branch_flag_o <= `Branch;	
                        // flush the pipeline
                        flush <= `Flush;    	
    			    end
    			end
    			`INST_ADDI : begin
    				wreg_o <= `WriteEnable;		
    				aluop_o <= `EXE_ADDI_OP;
    		  	
    				reg1_read_o <= 1'b1;  // 1:reg	
    				reg2_read_o <= 1'b0;  // 0:imm
    			end
    			
    			`INST_ADDIU : begin
    				wreg_o <= `WriteEnable;		
    				aluop_o <= `EXE_ADDIU_OP;
    		  		
    				reg1_read_o <= 1'b1;  // 1:reg	
    				reg2_read_o <= 1'b0;  // 0:imm
    			end
    			
    			default:begin
    			end
            endcase
        end
    end
    
    // get the op num1
    always @ (*) begin
        if(rst == `RstEnable) begin
            reg1_o <= `ZeroWord;
        end 
        // solve data rela
        else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin
            reg1_o <= ex_wdata_i;
        end  // we can get the value from EX
        else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o)) begin
            reg1_o <= mem_wdata_i;
        end  // we can get the value from MEM
        // 
        else if(reg1_read_o == 1'b1) begin
            reg1_o <= rd1_i;
        end 
        else if(reg1_read_o == 1'b0) begin
            reg1_o <= imm;
        end 
        else begin
            reg1_o <= `ZeroWord;
        end
    end
    
    // get the op num2
    always @ (*) begin
        if(rst == `RstEnable) begin
            reg2_o <= `ZeroWord;
        end 
        // solve data rela
        else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin
            reg2_o <= ex_wdata_i;
        end  // we can get the value from EX
        else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o)) begin
            reg2_o <= mem_wdata_i;
        end  // we can get the value from MEM
        //
        else if(reg2_read_o == 1'b1) begin
            reg2_o <= rd2_i;
        end 
        else if(reg2_read_o == 1'b0) begin
            reg2_o <= imm;
        end 
        else begin
            reg2_o <= `ZeroWord;
        end
    end
endmodule