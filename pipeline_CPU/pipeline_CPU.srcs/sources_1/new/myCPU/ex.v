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
    wire[31:0]                   res_add; // ans of math
    
    wire                         overflow_add;		    

    // -----
    // pass aluop to MEM
    assign aluop_o = aluop_i;
    
    // mem_addr_o: the addr of mem we will visit
    // reg1_i: base
    // inst_i[15:0]: offset
    assign mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};
    
    //reg2_i: the data of instruction sw
    assign reg2_o = reg2_i;
    
    
    // calculate
    assign res_or = reg1_i | reg2_i;
    assign res_add = reg1_i + reg2_i;

    // overflow?
    assign overflow_add = ((!reg1_i[31] && !reg2_i[31]) && res_add[31]) || ((reg1_i[31] && reg2_i[31]) && (!res_add[31]));
    
    
    
    // select a ans according to aluop_i
    always @ (*) begin
        wd_o <= wd_i;       // addr of the reg we will write
    	// ignore if overflow
    	if((aluop_i == `EXE_ADD_OP) && (overflow_add == 1'b1)) begin
    		wreg_o <= `WriteDisable;
    	end else begin
    		wreg_o <= wreg_i;
    	end
        case(aluop_i)
            `EXE_OR_OP : begin
                wdata_o <= res_or;
            end
    		`EXE_ADD_OP : begin
    			wdata_o <= res_add;
    		end
            default : begin
                wdata_o <= `ZeroWord;
            end
        endcase
    end
endmodule