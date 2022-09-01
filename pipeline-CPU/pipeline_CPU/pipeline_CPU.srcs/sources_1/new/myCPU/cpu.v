// top CPU module

`include "defines.v"

module mycpu(
    input wire                      clk,
    input wire                      rstn,

    input  wire[31:0]               inst_rom_rdata,
    output wire[31:0]               inst_rom_addr,

	// connect to data ram memory
	input  wire[31:0]               data_ram_rdata,
	output wire[31:0]               data_ram_addr,
	output wire[31:0]               data_ram_wdata,
	output wire                     data_ram_wen
);

    // connect IF_ID and ID
    wire[31:0] pc;
    wire[31:0] id_pc_i;
    wire[31:0] id_inst_i;

    wire       flush;

    // connect ID and ID_EX
    wire[4:0]       id_aluop_o;
    wire[31:0]      id_reg1_o;
    wire[31:0]      id_reg2_o;
    wire            id_wreg_o;
    wire[4:0]       id_wd_o;
    wire[31:0]      id_inst_o;

    // connect ID_EX and EX
    wire[4:0]       ex_aluop_i;
    wire[31:0]      ex_reg1_i;
    wire[31:0]      ex_reg2_i;
    wire            ex_wreg_i;
    wire[4:0]       ex_wd_i;
    wire[31:0]      ex_inst_i ;
    
    // connect ID and Regfile
    wire            reg1_read;
    wire            reg2_read;
    wire[31:0]      reg1_data;
    wire[31:0]      reg2_data;
    wire[4:0]       reg1_addr;
    wire[4:0]       reg2_addr;

    // connect EX and EX_MEM
    wire            ex_wreg_o;
    wire[4:0]       ex_wd_o;
    wire[31:0]      ex_wdata_o;

    wire[4:0]       ex_aluop_o;
    wire[31:0]      ex_mem_addr_o;
    wire[31:0]      ex_reg2_o;

    wire[4:0]       mem_aluop_i;
    wire[31:0]      mem_mem_addr_i;
    wire[31:0]      mem_reg2_i;


    // connect EX_MEM and MEM
    wire[31:0]      ex_wdata_i;
    wire 			ex_is_in_delayslot_o;

    // connect MEM and MEM_WB
    wire            mem_wreg_o;
    wire[4:0]       mem_wd_o;
    wire[31:0]      mem_wdata_o;

    // connect MEM_WB and WB
    wire            mem_wreg_i;
    wire[4:0]       mem_wd_i;
    wire[31:0]      mem_wdata_i;
    
    wire 			mem_is_in_delayslot_i;    


    // connect WB and Regfile
    wire[4:0]       wb_wd_i;
    wire            wb_wreg_i;
    wire[31:0]      wb_wdata_i;
    
    wire            id_branch_flag_o;
    wire[31:0]      id_branch_target_addr_o;

    wire 			mem_is_in_delayslot_o;
    
    
    // ?�� CTRL �M��L��?
	wire 						stallreq_from_id;	
	wire[31:0]				    new_pc;
	wire[5:0]                    stall;

    // pc_reg real
    pc_reg pc_reg0(
        .clk(clk),  
        .rst(rstn),  
        .pc(pc),
        .stall(stall),
    	.branch_flag_i(id_branch_flag_o),
    	.branch_target_addr_i(id_branch_target_addr_o)
    	//.new_pc(new_pc)
    );

    assign inst_rom_addr = pc;  // ?

    //Regfile real
    regfile regfile1(
        .clk(clk),
        .rst(rstn),
        
        // info from MEM_WB
        .we(wb_wreg_i), 
        .waddr(wb_wd_i),
        .wdata(wb_wdata_i),
        // info from ID
        .re1(reg1_read),    
        .raddr1(reg1_addr), 
        .rdata1(reg1_data),
        .re2(reg2_read),    
        .raddr2(reg2_addr),
        .rdata2(reg2_data)
    );

    // IF_ID real
    if_id if_id0(
        .clk(clk),  
        .rst(rstn),
        .if_pc(pc),
        .if_inst(inst_rom_rdata),
        .stall(stall),
        .flush(flush),

        .id_pc(id_pc_i),
        .id_inst(id_inst_i)

    );
    
    // ID real
    id id0(
        .rst(rstn),  
        .pc_i(id_pc_i), 
        .inst_i(id_inst_i),
        // input from Regfile
        .rd1_i(reg1_data),    
        .rd2_i(reg2_data),
        
        .ex_aluop_i(ex_aluop_o),  //
        
        // output to Regfile
        .reg1_read_o(reg1_read),    
        .reg2_read_o(reg2_read),
        .reg1_addr_o(reg1_addr),    
        .reg2_addr_o(reg2_addr),
        // pass to ID_EX
        .aluop_o(id_aluop_o),   
        .is_in_delayslot_i(is_delayslot_o),
        //.alusel_o(id_alusel_o),
        .reg1_o(id_reg1_o),     
        .reg2_o(id_reg2_o),
        .wd_o(id_wd_o),         
        .wreg_o(id_wreg_o),
    	.inst_o(id_inst_o),

        // extra data wire to solve the data rela
        .ex_wreg_i(ex_wreg_o),
        .ex_wd_i(ex_wd_o),
        .ex_wdata_i(ex_wdata_o),
        .mem_wreg_i(mem_wreg_o),
        .mem_wd_i(mem_wd_o),
        .mem_wdata_i(mem_wdata_o),


    	
    	.branch_flag_o(id_branch_flag_o),  
    	.branch_target_addr_o(id_branch_target_addr_o),
        .flush(flush),
        .is_in_delayslot_o(is_in_delayslot_o),
        // output to  CTRL
		.stallreq(stallreq_from_id)

        
    );

    // ID_EX real
    id_ex id_ex0(
        .clk(clk),  .rst(rstn),
        // info from ID
        .id_aluop(id_aluop_o),

        .id_reg1(id_reg1_o),
        .id_reg2(id_reg2_o),
        .id_wd(id_wd_o),
        .id_wreg(id_wreg_o),
        .id_inst(id_inst_o),
        .stall(stall),
        // info to EX
        .ex_aluop(ex_aluop_i),

        .ex_reg1(ex_reg1_i),
        .ex_reg2(ex_reg2_i),
        .ex_wd(ex_wd_i),
        .ex_wreg(ex_wreg_i),
        .ex_inst(ex_inst_i)
    );
    
    //EX real
    ex ex0(
        .rst(rstn),
        // info from ID_EX
        .aluop_i(ex_aluop_i),   

        .reg1_i(ex_reg1_i),     
        .reg2_i(ex_reg2_i),
        .wd_i(ex_wd_i),         
        .wreg_i(ex_wreg_i),
    	.inst_i(ex_inst_i),
        .is_in_delayslot_i(ex_is_in_delayslot),
        // info to EX_MEM
        .wd_o(ex_wd_o),         
        .wreg_o(ex_wreg_o),
        .wdata_o(ex_wdata_o),
       
    	.aluop_o(ex_aluop_o),
    	.mem_addr_o(ex_mem_addr_o),
    	.reg2_o(ex_reg2_o),
    	.is_in_delayslot_o(ex_is_in_delayslot_o)
    );

    // EX_MEM real
    ex_mem ex_mem0(
        .clk(clk),
        .rst(rstn),

        // info from EX
        .ex_wd(ex_wd_o),
        .ex_wreg(ex_wreg_o),
        .ex_wdata(ex_wdata_o),
        .ex_aluop(ex_aluop_o),
        .ex_mem_addr(ex_mem_addr_o),
        .ex_reg2(ex_reg2_o),
        .ex_is_in_delayslot(ex_is_in_delayslot_o),
        .stall(stall),
        
        // info to MEM
        .mem_wd(mem_wd_i),
        .mem_wreg(mem_wreg_i),
        .mem_wdata(mem_wdata_i),
        .mem_aluop(mem_aluop_i),
        .mem_mem_addr(mem_mem_addr_i),
        .mem_reg2(mem_reg2_i),
        .mem_is_in_delayslot(mem_is_in_delayslot_i)

    );

    // MEM real
    mem mem0(
    	.rst(rstn),
    	
    	// info from EX_MEM
    	.wd_i(mem_wd_i),
    	.wreg_i(mem_wreg_i),
    	.wdata_i(mem_wdata_i),
    	
      	.aluop_i(mem_aluop_i),
    	.mem_addr_i(mem_mem_addr_i),
    	.reg2_i(mem_reg2_i),
    	
    	.is_in_delayslot_i(mem_is_in_delayslot_i),

        // info to MEM_WB
    	.wd_o(mem_wd_o),
    	.wreg_o(mem_wreg_o),
    	.wdata_o(mem_wdata_o),
    	
    	// info from mem
    	.mem_data_i(data_ram_rdata),

        // info to mem
    	.mem_addr_o(data_ram_addr),
    	.mem_we_o(data_ram_wen),
    	.mem_data_o(data_ram_wdata),
    	
    	.is_in_delayslot_o(mem_is_in_delayslot_o)
    	
    );

    // MEM_WB real
    mem_wb mem_wb0(
        .clk(clk),
        .rst(rstn),

        // info from MEM
        .mem_wd(mem_wd_o),
        .mem_wreg(mem_wreg_o),
        .mem_wdata(mem_wdata_o),
        .stall(stall),
        // info to WB
        .wb_wd(wb_wd_i),
        .wb_wreg(wb_wreg_i),
        .wb_wdata(wb_wdata_i)
    );


    
    ctrl ctrl0 (
		.rst(rstn),
		.stallreq_from_id(stallreq_from_id),
		.stall(stall)
		//.new_pc(new_pc),
		//.flush(flush)
	);
endmodule