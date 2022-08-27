
`define RstEnable       1'b0          
`define RstDisable      1'b1 
`define WriteEnable     1'b1   
`define WriteDisable    1'b0    
`define ReadEnable      1'b1    
`define ReadDisable     1'b0     
`define Branch          1'b1	
`define NotBranch       1'b0			
`define ZeroWord        32'h00000000
`define RegNum          32               // reg num
`define RegNumLog2      5            // num of reg id

// opcode
`define INSR_OR         6'b100101  
`define INST_ORI        6'b001101  
`define INST_LUI        6'b001111     
`define FUNC_ADD        6'b100000	
`define INST_J          6'b000010	
`define INST_BEQ        6'b000100
`define INST_LW         6'b100011
`define INST_SW         6'b101011
`define INST_NOP        6'b000000
`define INST_FUNC       6'b000000

`define INST_BNE        6'b000101
`define INST_ADDI       6'b001000
`define INST_ADDIU      6'b001001
`define FUNC_ADDU       6'b100001
`define FUNC_SUB        6'b100010
`define FUNC_SUBU       6'b100011
// AluOp
`define EXE_NOP_OP      0
`define EXE_OR_OP       1
`define EXE_ORI_OP      2
`define EXE_LUI_OP      3  
`define EXE_ADD_OP      4
`define EXE_J_OP        5
`define EXE_BEQ_OP      6
`define EXE_LW_OP       7
`define EXE_SW_OP       8

`define EXE_BNE_OP      9
`define EXE_ADDI_OP     10
`define EXE_ADDIU_OP    11
`define EXE_ADDU_OP     12
`define EXE_SUB_OP      13
`define EXE_SUBU_OP     14