`include "defs.v"


module selevy (
    input  wire       CLK,
    input  wire       reset,
    output wire [3:0] out_ja1,
    output wire       out_clk
    );

    `ifdef EXHIBITION
    wire out_clk;
    MMCM mmcm(
        CLK,
        out_clk
    );
    `else
    assign out_clk = CLK;
    `endif

    wire [`WORDSIZE-1:0] pc_addr;
    wire [`WORDSIZE-1:0] pc_out;
    wire [`WORDSIZE-1:0] incpc_out;
    wire [`WORDSIZE-1:0] signextnr_out;
    wire [`WORDSIZE-1:0] br_tgt_target;
    PC pc (
        pc_addr,
        pc_out,
        out_clk,
        reset
    );
    INCPC incpc (
        pc_out,
        incpc_out
    );
    BR_TGT br_tgt (
        pc_out,
        signextnr_out,
        br_tgt_target
    );

    wire [`WORDSIZE-1:0] rom_out;
    ROM selevy_rom (
        pc_out,
        rom_out
    );

    wire [`WORDSIZE-1:0] rf_write_data;
    wire                 rf_regwrite;
    wire [`WORDSIZE-1:0] rf_out1, rf_out2;
    REGFILE selevy_regfile (
       rom_out[19:15], rom_out[24:20], rom_out[11:7],
       rf_write_data,
       rf_regwrite,
       rf_out1,
       rf_out2,
       out_clk,reset
    );

    wire ctrl_branch, ctrl_alusrc;
    wire ctrl_memwrite;
    wire [1:0] ctrl_storeops, ctrl_extnrops;
    wire [2:0] ctrl_aluops, ctrl_loadops;
    wire [2:0] ctrl_br_ops;
    CTRL ctrl(
        rom_out[6:0],
        rom_out[14:12],
        ctrl_alusrc,
        ctrl_loadops,
        ctrl_aluops,
        ctrl_extnrops,
        ctrl_memwrite,
        rf_regwrite,
        ctrl_storeops,
        ctrl_br_ops
    );

    SIGNEXTNR signextnr (
        rom_out,
        ctrl_extnrops,
        signextnr_out
    );

    wire [4:0] aluctrl_out;
    ALUCTRL aluctrl (
        ctrl_aluops,
        rom_out[14:12],
        rom_out[31:25],
        aluctrl_out
    );

    wire [`WORDSIZE-1:0] alu_read2;
    wire [`WORDSIZE-1:0] alu_out;
    wire [1:0]           alu_br_ops;
    ALU alu (
        rf_out1, alu_read2,
        aluctrl_out,
        alu_out,
        alu_br_ops
    );

    wire [`WORDSIZE-1:0] ram_read_data;
    RAM selevy_ram (
        alu_out, rf_out2,
        ctrl_loadops,
        ctrl_memwrite,
        ctrl_storeops,
        ram_read_data,
        out_clk, reset
    );

    assign alu_read2 = ctrl_alusrc ? signextnr_out : rf_out2;

    function [`WORDSIZE-1:0] set_rf_write_data;
        input [2:0]           loadops;
        input [`WORDSIZE-1:0] ram_out;
        input [`WORDSIZE-1:0] alu;
        begin
            if (loadops == `NO_LOAD)
                set_rf_write_data = alu;
            else
                set_rf_write_data = ram_out;
        end
    endfunction

    assign rf_write_data = set_rf_write_data(ctrl_loadops, ram_read_data, alu_out);

    BRANCHCTRL bctrl (
        ctrl_br_ops,
        alu_br_ops,
        incpc_out,
        br_tgt_target,
        pc_addr
    );

    GPIO gpio (
        out_clk,
        alu_out,
        ram_read_data,
        out_ja1
    );
endmodule
