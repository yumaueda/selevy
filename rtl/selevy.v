`include "defs.v"


module selevy 
(
    input  wire       CLK,
    input  wire       RST,
    output wire [3:0] out_ja1
);

wire [`MXLEN-1:0] pc_val;       // pcunit_to_rom

wire [ 4:0]       alu_ops;      // decoder_to_alu
wire              src_imm;      // decoder_to_alu
wire              branch;       // decoder_to_pcunit
wire [ 2:0]       pcunit_ops;   // decoder_to_pcunit
wire [`MXLEN-1:0] imm_extended; // decoder_to_{pcunit, alu}
wire              load;         // decoder_to_ram
wire [ 2:0]       load_ops;     // decoder_to_ram
wire              store;        // decoder_to_ram
wire [ 2:0]       store_ops;    // decoder_to_ram
wire              reg_write;    // decoder_to_regfile

wire [ 1:0]       val_eval;     // alu_to_pcunit

wire [`MXLEN-1:0] instr;        // rom_to_{decoder, regfile}

wire [`MXLEN-1:0] rf_w_data;    // selevy_to_regfile
wire [`MXLEN-1:0] rf_r_data1;   // regfile_to_alu
wire [`MXLEN-1:0] rf_r_data2;   // regfile_to_{alu, ram}

wire [`MXLEN-1:0] alu_out;      // alu_to_{ram, regfile}

wire [`MXLEN-1:0] ram_r_data;   // ram_to_regfile

PCUNIT pcunit (
    CLK,
    RST,
    branch,
    pcunit_ops,
    val_eval,
    imm_extended,
    pc_val
);

ROM rom (
    pc_val,
    instr
);

function [`MXLEN-1:0] set_rf_w_data;
input              l;
input [`MXLEN-1:0] ram_r;
input [`MXLEN-1:0] alu_o;
begin
    set_rf_w_data = (l == 1'b1)? ram_r : alu_o;
end
endfunction

assign rf_w_data = set_rf_w_data(load, ram_r_data, alu_out);

REGFILE regfile (
    CLK,
    instr[19:15],
    instr[24:20],
    instr[11:7],
    reg_write,
    rf_w_data,
    rf_r_data1,
    rf_r_data2
);

DECODER decoder (
    instr[ 6:0],
    instr[14:12],
    instr[31:25],
    instr[31:7],
    alu_ops,
    src_imm,
    branch,
    pcunit_ops,
    imm_extended,
    load,
    load_ops,
    store,
    store_ops,
    reg_write
);

ALU alu (
    rf_r_data1,
    rf_r_data2,
    imm_extended,
    alu_ops,
    src_imm,
    alu_out,
    val_eval
);


RAM ram (
    CLK,
    alu_out,
    rf_r_data2,
    load,
    load_ops,
    store,
    store_ops,
    ram_r_data
);

GPIO gpio (
    CLK,
    alu_out,
    out_ja1
);

endmodule
