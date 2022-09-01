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
    
    //solve Load delay problem
    input wire[4:0]		        ex_aluop_i,
    
    input wire 					is_in_delayslot_i,

    // info to Regfile
    output reg                          reg1_read_o,  // control signal: read enable. imm:0 or reg:1
    output reg                          reg2_read_o,  // imm:0 or reg:1

    output reg[4:0]                     reg1_addr_o,  // the id of the reg1 that we will read
    output reg[4:0]                     reg2_addr_o,  // the id of the reg2 that we will read
	
	// branch info to PC
	output reg 					        branch_flag_o,
	output reg[31:0]			            branch_target_addr_o,
	
    // info to EX
    output reg[4:0]                     aluop_o,
    //output reg[2:0]                   alusel_o,
    output reg[31:0]                    reg1_o,  // the op num we read
    output reg[31:0]                    reg2_o,
    output reg[4:0]                     wd_o,  // the id of the reg we will wb, its value depends on the instruction.
    output reg                          wreg_o,
	output wire[31:0]                   inst_o,

    output reg                          flush,
    output reg 					        is_in_delayslot_o,
    output wire					        stallreq		// request pipeline interrupt
);
    // 
    wire[5:0] op = inst_i[31:26];
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0];
    wire[4:0] op4 = inst_i[20:16];
    
    //
    reg[31:0]   imm;
    
    //Indicates whether the register 1/2 to be read is related to the load of the previous instruction
    reg stallreq_for_reg1_loadrelate;
	reg stallreq_for_reg2_loadrelate;
	// Whether the previous one is a load instruction
    wire pre_inst_is_load;
    
    wire[31:0] pc_plus_4;
    wire[31:0] imm_sll2_signedext; 
    
    assign pc_plus_4 = pc_i +4;
    assign imm_sll2_signedext = {{14{inst_i[15]}}, inst_i[15:0], 2'b00 };  
    
    assign inst_o = inst_i;
    
    // According to the value of the input signal ex_aluop_i, 
    //determine whether the previous instruction is a load instruction, 
    //if so, set pre_inst_is_load to 1, otherwise set to 0
    assign pre_inst_is_load = (ex_aluop_i == `EXE_LW_OP) ? 1'b1 : 1'b0;
							   
							   
	assign stallreq = stallreq_for_reg1_loadrelate | stallreq_for_reg2_loadrelate;
    
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
            reg1_addr_o <=  inst_i[25:21]; //rs
            reg2_addr_o <=  inst_i[20:16]; //rt
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
    		  		                //alusel_o <= `EXE_RES_ARITHMETIC;		
    				                reg1_read_o <= 1'b1;	
    				                reg2_read_o <= 1'b1;
    				            end
    				            `FUNC_ADDU: begin
                                    wreg_o <= `WriteEnable;		
                                    aluop_o <= `EXE_ADDU_OP;
                                   //alusel_o <= `EXE_RES_ARITHMETIC;		
                                    reg1_read_o <= 1'b1;	
                                    reg2_read_o <= 1'b1;
                                 end
    				            `FUNC_SUB: begin
                                    wreg_o <= `WriteEnable;		
                                    aluop_o <= `EXE_SUB_OP;
                                    //alusel_o <= `EXE_RES_ARITHMETIC;		
                                    reg1_read_o <= 1'b1;	
                                    reg2_read_o <= 1'b1;
                                 end
    				            `FUNC_SUBU: begin
    				                wreg_o <= `WriteEnable;		
    				                aluop_o <= `EXE_SUB_OP;
    		  		                //alusel_o <= `EXE_RES_ARITHMETIC;		
    				                reg1_read_o <= 1'b1;	
    				                reg2_read_o <= 1'b1;
    				            end
    				            `FUNC_AND: begin
    				                wreg_o <= `WriteEnable;		
    				                aluop_o <= `EXE_AND_OP;
    		  		                //alusel_o <= `EXE_RES_ARITHMETIC;		
    				                reg1_read_o <= 1'b1;	
    				                reg2_read_o <= 1'b1;
    				            end
    				            `FUNC_NOR: begin
    				                wreg_o <= `WriteEnable;		
    				                aluop_o <= `EXE_NOR_OP;
    		  		                //alusel_o <= `EXE_RES_ARITHMETIC;		
    				                reg1_read_o <= 1'b1;	
    				                reg2_read_o <= 1'b1;
    				            end
    				            `FUNC_OR: begin
    				                wreg_o <= `WriteEnable;		
    				                aluop_o <= `EXE_OR_OP;
    		  		                //alusel_o <= `EXE_RES_ARITHMETIC;		
    				                reg1_read_o <= 1'b1;	
    				                reg2_read_o <= 1'b1;
    				            end
    				            `FUNC_XOR: begin
    				                wreg_o <= `WriteEnable;		
    				                aluop_o <= `EXE_XOR_OP;
    		  		                //alusel_o <= `EXE_RES_ARITHMETIC;		
    				                reg1_read_o <= 1'b1;	
    				                reg2_read_o <= 1'b1;
    				            end
								`FUNC_SLLV: begin
    				                wreg_o <= `WriteEnable;		
    				                aluop_o <= `EXE_SLLV_OP;
    		  		                //alusel_o <= `EXE_RES_ARITHMETIC;		
    				                reg1_read_o <= 1'b1;	
    				                reg2_read_o <= 1'b1;
    				            end
    				            `FUNC_SRLV: begin
    				                wreg_o <= `WriteEnable;		
    				                aluop_o <= `EXE_SRLV_OP;
    		  		                //alusel_o <= `EXE_RES_ARITHMETIC;		
    				                reg1_read_o <= 1'b1;	
    				                reg2_read_o <= 1'b1;
    				            end
    				            `FUNC_SRAV: begin
    				                wreg_o <= `WriteEnable;		
    				                aluop_o <= `EXE_SRAV_OP;
    		  		                //alusel_o <= `EXE_RES_ARITHMETIC;		
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
								`FUNC_SRA: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_SRL_OP;
                                    imm <= {16'h0, inst_i[15:0]};
                                    reg1_read_o <= 1'b0;
                                    reg2_read_o <= 1'b1;          
                                end
                                `FUNC_SLT: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_SLT_OP;
                                    reg1_read_o <= 1'b1;
                                    reg2_read_o <= 1'b1;          
                                end
                                `FUNC_SLTU: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_SLTU_OP;
                                    reg1_read_o <= 1'b1;
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
					imm <= {16'h0, inst_i[15:0]};
    				reg1_read_o <= 1'b1;  // 1:reg	
    				reg2_read_o <= 1'b0;  // 0:imm
					wd_o <= inst_i[20:16];
    			end
    			
    			`INST_ADDIU : begin
    				wreg_o <= `WriteEnable;		
    				aluop_o <= `EXE_ADDIU_OP;
    		  		imm <= {16'h0, inst_i[15:0]};
    				reg1_read_o <= 1'b1;  // 1:reg	
    				reg2_read_o <= 1'b0;  // 0:imm
					wd_o <= inst_i[20:16];
    			end
    			
    			`INST_XORI:          begin
    				wreg_o <= `WriteEnable;		
    				aluop_o <= `EXE_XOR_OP;
    		  		//alusel_o <= `EXE_RES_ARITHMETIC;		
    				reg1_read_o <= 1'b1;//1:reg	
    				reg2_read_o <= 1'b0;//0:imm
    				imm <=  {16'h0, inst_i[15:0]};  // 0 expend
                    wd_o <= inst_i[20:16];  // reg id we are going to write
    			end
    			
    			`INST_SLTI:          begin
    				wreg_o <= `WriteEnable;		
    				aluop_o <= `EXE_SLT_OP;
    		  		//alusel_o <= `EXE_RES_ARITHMETIC;		
    				reg1_read_o <= 1'b1;//1:reg	
    				reg2_read_o <= 1'b0;//0:imm
    				imm <=  {{16{inst_i[15]}}, inst_i[15:0]};  // 0 expend
                    wd_o <= inst_i[20:16];  // reg id we are going to write
    			end
    			`INST_SLTIU:          begin
    				wreg_o <= `WriteEnable;		
    				aluop_o <= `EXE_SLTU_OP;
    		  		//alusel_o <= `EXE_RES_ARITHMETIC;		
    				reg1_read_o <= 1'b1;//1:reg	
    				reg2_read_o <= 1'b0;//0:imm
    				imm <=  {{16{inst_i[15]}}, inst_i[15:0]};  // 0 expend
                    wd_o <= inst_i[20:16];  // reg id we are going to write
    			end
    			
    			`INST_FUNC2:          begin
    			 case ( op3 )
    			     `FUNC_CLZ: begin
    			         wreg_o <= `WriteEnable;		
                         aluop_o <= `EXE_CLZ_OP;
                         //alusel_o <= `EXE_RES_ARITHMETIC;		
                         reg1_read_o <= 1'b1;//1:reg	
                         reg2_read_o <= 1'b0;//0:imm
    			     end
    			     `FUNC_CLO: begin
    			         wreg_o <= `WriteEnable;		
                         aluop_o <= `EXE_CLO_OP;
                         //alusel_o <= `EXE_RES_ARITHMETIC;		
                         reg1_read_o <= 1'b1;//1:reg	
                         reg2_read_o <= 1'b0;//0:imm
    			     end
    			     default: begin
    			     end
    			 endcase
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


		stallreq_for_reg1_loadrelate <= `StallDisable;
		if (rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end
		else if (reg1_read_o == `ReadEnable) begin
			if (pre_inst_is_load == 1'b1 && ex_wd_i == reg1_addr_o) begin
				stallreq_for_reg1_loadrelate <= `StallEnable;
			end
/*			else if (ex_wreg_i == `WriteEnable && ex_wd_i == reg1_addr_o) begin
				reg1_o <= ex_wdata_i;
			end
			else if (mem_wreg_i == `WriteEnable && mem_wd_i == reg1_addr_o) begin
				reg1_o <= mem_wdata_i;
			end
			else begin
				reg1_o <= rd1_i;
			end*/
		end
/*		else if (reg1_read_o == `ReadDisable) begin
			reg1_o <= imm;
		end
		else begin
			reg1_o <= `ZeroWord;
		end*/

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


		stallreq_for_reg2_loadrelate <= `StallDisable;
		if (rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end
		else if (reg2_read_o == `ReadEnable) begin
			if (pre_inst_is_load == 1'b1 && ex_wd_i == reg2_addr_o) begin
				stallreq_for_reg2_loadrelate <= `StallEnable;
			end
			/*else if (ex_wreg_i == `WriteEnable && ex_wd_i == reg2_addr_o) begin
				reg2_o <= ex_wdata_i;
			end
			else if (mem_wreg_i == `WriteEnable && mem_wd_i == reg2_addr_o) begin
				reg2_o <= mem_wdata_i;
			end
			else begin
				reg2_o <= rd2_i;
			end*/
		end
		/*else if (reg2_read_o == `ReadDisable) begin
			reg2_o <= imm;
		end
		else begin
			reg2_o <= `ZeroWord;
		end*/


		

    end
    
    //If the previous instruction is a load instruction,
    // and the load instruction to be loaded into the destination register is the general register read
    // by the current instruction through the regfile module read port 1, 
    //it means that there is a load related
//     always @(*) begin
// 		stallreq_for_reg1_loadrelate <= `StallDisable;
// 		if (rst == `RstEnable) begin
// 			reg1_o <= `ZeroWord;
// 		end
// 		else if (reg1_read_o == `ReadEnable) begin
// 			if (pre_inst_is_load == 1'b1 && ex_wd_i == reg1_addr_o) begin
// 				stallreq_for_reg1_loadrelate <= `StallEnable;
// 			end
// /*			else if (ex_wreg_i == `WriteEnable && ex_wd_i == reg1_addr_o) begin
// 				reg1_o <= ex_wdata_i;
// 			end
// 			else if (mem_wreg_i == `WriteEnable && mem_wd_i == reg1_addr_o) begin
// 				reg1_o <= mem_wdata_i;
// 			end
// 			else begin
// 				reg1_o <= rd1_i;
// 			end*/
// 		end
// /*		else if (reg1_read_o == `ReadDisable) begin
// 			reg1_o <= imm;
// 		end
// 		else begin
// 			reg1_o <= `ZeroWord;
// 		end*/
// 	end
    
// 	always @(*) begin
// 		stallreq_for_reg2_loadrelate <= `StallDisable;
// 		if (rst == `RstEnable) begin
// 			reg2_o <= `ZeroWord;
// 		end
// 		else if (reg2_read_o == `ReadEnable) begin
// 			if (pre_inst_is_load == 1'b1 && ex_wd_i == reg2_addr_o) begin
// 				stallreq_for_reg2_loadrelate <= `StallEnable;
// 			end
// 			/*else if (ex_wreg_i == `WriteEnable && ex_wd_i == reg2_addr_o) begin
// 				reg2_o <= ex_wdata_i;
// 			end
// 			else if (mem_wreg_i == `WriteEnable && mem_wd_i == reg2_addr_o) begin
// 				reg2_o <= mem_wdata_i;
// 			end
// 			else begin
// 				reg2_o <= rd2_i;
// 			end*/
// 		end
// 		/*else if (reg2_read_o == `ReadDisable) begin
// 			reg2_o <= imm;
// 		end
// 		else begin
// 			reg2_o <= `ZeroWord;
// 		end*/
// 	end
	
	always @(*) begin
		if (rst == `RstEnable) begin
			is_in_delayslot_o <= `NotInDelaySlot;
		end
		else begin
			is_in_delayslot_o <= is_in_delayslot_i;
		end
	end
endmodule