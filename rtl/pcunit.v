`include "defs.v"


module PCUNIT
#(
    parameter   [`MXLEN-1:0] RST_VEC = 32'd0
)
(
    input  wire              CLK,
    input  wire              RST,
    input  wire              branch,
    input  wire              exception,
    input  wire              mret,
    input  wire [`MXLEN-1:0] mtvec_or_mepc, // csr_r_data
    input  wire [ 2:0]        pcunit_ops,
    input  wire [ 1:0]        val_eval,
    input  wire [`MXLEN-1:0] imm_extended,
    output reg  [`MXLEN-1:0] pc_val,
    output wire              i_misaligned
);

wire [`MXLEN-1:0] next_pc_val;

always @(posedge CLK) begin
    if (RST == 1'b1) begin
        pc_val <= RST_VEC;
    end
    else if (exception == 1'b1) begin
        pc_val <= mtvec_or_mepc;        // mtvec | mtvec + 4 * $exception_number
    end
    else if (mret == 1'b1) begin
        pc_val <= mtvec_or_mepc + 3'd4; // mepc
    end
    else begin
        pc_val <= next_pc_val;
    end
end

assign next_pc_val = set_next_pc_val(branch,
                             pcunit_ops,
                             val_eval,
                             pc_val,
                             imm_extended);

assign i_misaligned = (next_pc_val%4 == 0)? 0 : 1;

function [`MXLEN-1:0] set_next_pc_val;
input                 b;
input    [ 2:0]       ops;
input    [ 1:0]       eval;
input    [`MXLEN-1:0] pc_current;
input    [`MXLEN-1:0] imm;
begin
    if (b == 1'b1) begin
        case (ops)
            `F3_BEQ: begin
                if (eval == `ALU_BR_EQ) begin
                    set_next_pc_val = pc_current + imm;
                end
                else begin
                    set_next_pc_val = pc_current + 3'd4;
                end
            end
            `F3_BNE: begin
                if (eval != `ALU_BR_EQ) begin
                    set_next_pc_val = pc_current + imm;
                end
                else begin
                    set_next_pc_val = pc_current + 3'd4;
                end
            end
            `F3_BLT: begin
                if (eval == `ALU_BR_LT) begin
                    set_next_pc_val = pc_current + imm;
                end
                else begin
                    set_next_pc_val = pc_current + 3'd4;
                end
            end
            `F3_BGE: begin
                if (eval==`ALU_BR_GT || eval==`ALU_BR_EQ) begin
                    set_next_pc_val = pc_current + imm;
                end
                else begin
                    set_next_pc_val = pc_current + 3'd4;
                end
            end
            `F3_BLTU: begin
                if (eval == `ALU_BR_LT) begin
                    set_next_pc_val = pc_current + imm;
                end
                else begin
                    set_next_pc_val = pc_current + 3'd4;
                end
            end
            `F3_BGEU: begin
                if (eval==`ALU_BR_GT || eval==`ALU_BR_EQ) begin
                    set_next_pc_val = pc_current + imm;
                end
                else begin
                    set_next_pc_val = pc_current + 3'd4;
                end
            end
        endcase
    end
    else begin
        set_next_pc_val = pc_current + 3'd4;
    end
end
endfunction

endmodule
