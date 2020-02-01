`include "defs.v"


module PCUNIT
#(
    parameter   [`MXLEN-1:0] RST_VEC = 32'd0
)
(
    input  wire              CLK,
    input  wire              RST,
    input  wire              branch,
    input  wire [2:0]        pcunit_ops,
    input  wire [1:0]        val_eval,
    input  wire [`MXLEN-1:0] signextnr_out,
    output reg  [`MXLEN-1:0] pc_val
);

wire [`MXLEN-1:0] next_pc_val;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        pc_val <= RST_VEC;
    end
    else begin
        pc_val <= next_pc_val;
    end
end

assign next_pc_val = set_out(branch,
                           pcunit_ops,
                           val_eval,
                           pc_val,
                           signextnr_out);

function [`MXLEN-1:0] set_out;
input                 b;
input    [ 2:0]       ctrl_ops;
input    [ 1:0]       alu_ops;
input    [`MXLEN-1:0] pc;
input    [`MXLEN-1:0] signextnr;
begin
    if (b == 1'b1) begin
        case (ctrl_ops)
            `F3_BEQ: begin
                if (alu_ops == `ALU_BR_EQ) begin
                    set_out = pc + signextnr;
                end
                else begin
                    set_out = pc + 3'd4;
                end
            end
            `F3_BNE: begin
                if (alu_ops != `ALU_BR_EQ) begin
                    set_out = pc + signextnr;
                end
                else begin
                    set_out = pc + 3'd4;
                end
            end
            `F3_BLT: begin
                if (alu_ops == `ALU_BR_LT) begin
                    set_out = pc + signextnr;
                end
                else begin
                    set_out = pc + 3'd4;
                end
            end
            `F3_BGE: begin
                if (alu_ops == `ALU_BR_GT || alu_ops == `ALU_BR_EQ) begin
                    set_out = pc + signextnr;
                end
                else begin
                    set_out = pc + 3'd4;
                end
            end
            `F3_BLTU: begin
                if (alu_ops == `ALU_BR_LT) begin
                    set_out = pc + signextnr;
                end
                else begin
                    set_out = pc + 3'd4;
                end
            end
            `F3_BGEU: begin
                if (alu_ops == `ALU_BR_GT || alu_ops == `ALU_BR_EQ) begin
                    set_out = pc + signextnr;
                end
                else begin
                    set_out = pc + 3'd4;
                end
            end
        endcase
    end
    else begin
        set_out = pc + 3'd4;
    end
end
endfunction

endmodule
