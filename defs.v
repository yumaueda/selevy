`define WORDSIZE      32


`define ALU_AND       2'b00
`define ALU_OR        2'b01
`define ALU_ADD       2'b10
`define ALU_SUB       2'b11


`define EXTNR_B       2'b00
`define EXTNR_S       2'b01
`define EXTNR_I       2'b10
`define EXTNR_R       2'b11


`define OPCODE_B      7'b1100011
`define OPCODE_I      7'b0000011
`define OPCODE_R      7'b0110011
`define OPCODE_S      7'b0100011


`define OPCODE_B_ALU  2'b00
`define OPCODE_I_ALU  2'b01
`define OPCODE_R_ALU  2'b10
`define OPCODE_S_ALU  2'b11


`define R_ADDSUB      3'b000
`define R_AND         3'b111
`define R_OR          3'b110


`define REG_NUM       32
`define ROM_COL_MAX   64


`define DUMPFILE "selevy.vcd"