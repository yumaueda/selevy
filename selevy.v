`timescale 1ns/1ps


module selevy #(
    parameter rf_init_data_path = 0,
    parameter rom_init_data_path = 0
    )(
    input wire CLK, reset
    );


    wire [31:0] pc_addr;
    wire [31:0] pc_out;
    wire [31:0] incpc_out;
    wire [31:0] signextnr_out;
    wire [31:0] br_tgt_target;
    PC pc (
        pc_addr,
        pc_out,
        CLK,
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


    wire [31:0] rom_out;
    ROM rom (
        pc_out,
        rom_out,
        reset
    );
    defparam rom.init_data_path = rom_init_data_path;


    wire [31:0] rf_write_data;
    wire rf_regwrite;
    wire [31:0] rf_out1, rf_out2;
    REGFILE regfile (
       rom_out[19:15], rom_out[24:20], rom_out[11:7],
       rf_write_data,
       rf_regwrite,
       rf_out1,
       rf_out2,
       CLK,
       reset
    );
    defparam regfile.init_data_path = rf_init_data_path;


    wire ctrl_branch, ctrl_alusrc, ctrl_load;
    wire ctrl_memread, ctrl_memwrite;
    wire [1:0] ctrl_storeops;
    wire [1:0] ctrl_aluops, ctrl_extnrops;
    CTRL ctrl(
        rom_out[6:0],
        rom_out[14:12],
        ctrl_branch,
        ctrl_alusrc,
        ctrl_load,
        ctrl_aluops,
        ctrl_extnrops,
        ctrl_memread,
        ctrl_memwrite,
        rf_regwrite,
        ctrl_storeops
    );


    SIGNEXTNR signextnr (
        rom_out,
        ctrl_extnrops,
        signextnr_out
    );


    wire [1:0] aluctrl_out;
    ALUCTRL aluctrl (
        ctrl_aluops,
        rom_out[14:12],
        rom_out[30],
        aluctrl_out
    );


    wire [`WORDSIZE-1:0] alu_read2;
    wire [`WORDSIZE-1:0] alu_out;
    wire alu_zero;
    ALU alu (
        rf_out1, alu_read2,
        aluctrl_out,
        alu_out,
        alu_zero
    );


    wire [31:0] ram_read_data;
    RAM ram (
        alu_out, rf_out2,
        ctrl_memread, ctrl_memwrite,
        ctrl_storeops,
        ram_read_data,
        CLK,
        reset
    );


    assign alu_read2 = ctrl_alusrc ? signextnr_out : rf_out2;
    assign pc_addr = (ctrl_branch & alu_zero) ? br_tgt_target : incpc_out;
    assign rf_write_data = ctrl_load ? ram_read_data : alu_out;
endmodule