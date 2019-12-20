/*--------------------
`define EXHIBITION    1
--------------------*/
`define WORDSIZE      32


`define ALU_ADD       4'b0000
`define ALU_SUB       4'b0001
`define ALU_SLL       4'b0010
`define ALU_SLT       4'b0011
`define ALU_SLTU      4'b0100
`define ALU_XOR       4'b0101
`define ALU_SRL       4'b0110
`define ALU_SRA       4'b0111
`define ALU_OR        4'b1000
`define ALU_AND       4'b1001
`define ALU_SUB_S     4'b1010 // BLTU, BGEU


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


`define OPCODE_B_ALU      3'b000
`define OPCODE_I_ALU      3'b001
`define OPCODE_I_I_ALU    3'b010
`define OPCODE_R_ALU      3'b011
`define OPCODE_S_ALU      3'b100


`define R_ADDSUB      3'b000
`define R_SLL         3'b001
`define R_SLT         3'b010
`define R_SLTU        3'b011
`define R_XOR         3'b100
`define R_SRLSRA      3'b101
`define R_OR          3'b110
`define R_AND         3'b111


`define REG_NUM       32
`define RAM_COL_MAX   32
`define ROM_COL_MAX   32


`define STORE_B       2'b01
`define STORE_H       2'b10
`define STORE_W       2'b11


`define DUMPFILE "selevy.vcd"

`define ROM_INIT "load.data"
