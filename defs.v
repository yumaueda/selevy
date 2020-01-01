`define DUMPFILE      "selevy.vcd"
/*--------------------
`define EXHIBITION
`define ICARUS // Define this macro by using the D option of an iverilog command
--------------------*/
`define ROM_INIT      "test/rom.data"
`define MXLEN      32


/*--------------------
 * ALUCTRL -> ALU
--------------------*/
`define ALU_ADD       5'b00000 // ADD,  ADDI
`define ALU_SUB       5'b00001 // SUB,  SUBI
`define ALU_SLL       5'b00010 // SLL,  SLLI
`define ALU_SLT       5'b00011 // SLT,  SLTI
`define ALU_SLTU      5'b00100 // SLTU, SLTIU
`define ALU_XOR       5'b00101 // XOR,  XORI
`define ALU_SRL       5'b00110 // SRL,  SRLI
`define ALU_SRA       5'b00111 // SRA,  SRAI
`define ALU_OR        5'b01000 // OR,   ORI
`define ALU_AND       5'b01001 // AND,  ANDI
`define ALU_SUB_S     5'b01010 // BLTU, BGEU
`define ALU_MUL       5'b01011 // MUL
`define ALU_MULH      5'b01100 // MULH
`define ALU_MULHSU    5'b01101 // MULHSU
`define ALU_MULHU     5'b01110 // MULHU
`define ALU_DIV       5'b01111 // DIV
`define ALU_DIVU      5'b10000 // DIVU
`define ALU_REM       5'b10001 // REM
`define ALU_REMU      5'b10010 // REMU

`define F3_ADDSUBMUL  3'b000
`define F3_SLLMULH    3'b001
`define F3_SLTMULHSU  3'b010
`define F3_SLTUMULHU  3'b011
`define F3_XORDIV     3'b100
`define F3_SRLSRADIVU 3'b101
`define F3_ORREM      3'b110
`define F3_ANDREMU    3'b111


`define ALU_BR_EQ     2'b00
`define ALU_BR_LT     2'b01
`define ALU_BR_GT     2'b10


`define EXTNR_B       2'b00
`define EXTNR_S       2'b01
`define EXTNR_I       2'b10
`define EXTNR_R       2'b11


/*---------------------
 * I
---------------------*/
`define NO_LOAD       3'b011
`define FUNCT_LB      3'b000
`define FUNCT_LH      3'b001
`define FUNCT_LW      3'b010
`define FUNCT_LBU     3'b100
`define FUNCT_LHU     3'b101


/*---------------------
 * B
---------------------*/
`define FUNCT_EQ      3'b000
`define FUNCT_NE      3'b001
`define FUNCT_LT      3'b010
`define FUNCT_GE      3'b011
`define FUNCT_LTU     3'b100
`define FUNCT_GEU     3'b101
`define NO_BRANCH     3'b110


/*---------------------
 * S
---------------------*/
`define FUNCT_SB      3'b000
`define FUNCT_SH      3'b001
`define FUNCT_SW      3'b010


`define OPCODE_I      7'b0000011
`define OPCODE_S      7'b0100011
`define OPCODE_I_I    7'b0010011
`define OPCODE_R      7'b0110011
`define OPCODE_B      7'b1100011
`define OPCODE_SYSTEM 7'b1110011


`define OPCODE_B_ALU      3'b000
`define OPCODE_I_ALU      3'b001
`define OPCODE_I_I_ALU    3'b010
`define OPCODE_R_ALU      3'b011
`define OPCODE_S_ALU      3'b100




`define REG_NUM       32
`define RAM_COL_MAX   32
`define ROM_COL_MAX   32


`define STORE_B       2'b01
`define STORE_H       2'b10
`define STORE_W       2'b11
