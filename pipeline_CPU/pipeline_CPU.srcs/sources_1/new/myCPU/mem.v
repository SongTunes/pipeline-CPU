// module MEM
`include "defines.v"
/*
In this module, we load data from memory and save them in registers, 
or save reg data in memory.
If not lw / sw, we just spread the signal.
*/
module mem(
	input wire						rst,
	
	// info from EX
	input wire[4:0]       			wd_i,
	input wire                    	wreg_i,
	input wire[31:0]			  	    wdata_i,
	
	input wire[4:0]        			aluop_i,
	input wire[31:0]          		mem_addr_i,
	input wire[31:0]          		reg2_i,
	
	// info to WB
	output reg[4:0]      			wd_o,
	output reg                   	wreg_o,
	output reg[31:0]			 	    wdata_o,
	
	// info from memory
	input wire[31:0]          		mem_data_i,
	
	// info to memory
	output reg[31:0]          		mem_addr_o,
	output wire					 	mem_we_o,
	output reg[31:0]          		mem_data_o
);

    
    reg          	mem_we;
    
    assign mem_we_o = mem_we ;
    
    	
    	always @ (*) begin
    		if(rst == `RstEnable) begin
    			wd_o <= 5'b00000;
    			wreg_o <= `WriteDisable;
    			wdata_o <= `ZeroWord;

    			mem_addr_o <= `ZeroWord;
    			mem_we <= `WriteDisable;
    			mem_data_o <= `ZeroWord;
    		end else begin
    			wd_o <= wd_i;
    			wreg_o <= wreg_i;
    			wdata_o <= wdata_i;

    			mem_we <= `WriteDisable;
    			mem_addr_o <= `ZeroWord;
				mem_data_o <= `ZeroWord;
    			case (aluop_i)
    				`EXE_LW_OP:		begin
    					mem_addr_o <= mem_addr_i;
    					mem_we <= `WriteDisable;
    					wdata_o <= mem_data_i;
    				end
    				`EXE_SW_OP:		begin
    					mem_addr_o <= mem_addr_i;
    					mem_we <= `WriteEnable;
    					mem_data_o <= reg2_i;
    				end
    				default:	begin
    				end
    			endcase	
    		end
    	end
endmodule