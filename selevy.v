module selevy (
        input wire CLK, reset
    );

    wire [`WORDSIZE-1:0] alu_read1, alu_read2;
    wire [1:0] alu_ops;
    wire[`WORDSIZE-1:0] alu_out;
    wire alu_zero;
    ALU alu(
        alu_read1, alu_read2,
        alu_ops,
        alu_out,
        alu_zero
    );

    wire [1:0] aluctrl_ops;
    wire [2:0] aluctrl_funct;
    wire aluctrl_thirty;
    ALUCTRL aluctrl(
        aluctrl_ops,
        aluctrl_funct,
        aluctrl_thirty,
        alu_ops
    );

    wire [31:0] rom_read_addr;
    wire [31:0] rom_out;
    ROM rom(
        rom_read_addr,
        rom_out,
        CLK
    );

    wire [31:0] rf_write_data;
    wire rf_regwrite;
    wire [31:0] rf_out2;
    REGFILE regfile(
       rom_out[19:15], rom_out[24:20], rom_out[11:7],
       rf_write_data,
       rf_regwrite,
       alu_read1,
       rf_out2,
       CLK
    );

    wire [1:0] signextnr_ops;
    wire [31:0] signextnr_out;
    SIGNEXTNR signextnr(
        rom_out,
        signextnr_ops,
        signextnr_out
    );


endmodule