`include "defs.v"


module ALU
(
    input  wire [`MXLEN-1:0] read1,
    input  wire [`MXLEN-1:0] read2_reg,
    input  wire [`MXLEN-1:0] read2_imm,
    input  wire [`MXLEN-1:0] read2_csr,
    input  wire [ 4:0]       alu_ops,
    input  wire              src_imm,
    input  wire              csr_read,
    output wire [`MXLEN-1:0] out,
    output wire [ 1:0]       val_eval
);


wire [`MXLEN-1:0] read2;

function [`MXLEN-1:0] set_read2;
input              imm;
input              csr;
input [`MXLEN-1:0] r2_reg;
input [`MXLEN-1:0] r2_imm;
input [`MXLEN-1:0] r2_csr;
begin
    if (csr == 1'b1) begin
        set_read2 = r2_csr;
    end
    else if (imm == 1'b1) begin
        set_read2 = r2_imm;
    end
    else begin
        set_read2 = r2_reg;
    end
end
endfunction

assign read2 = set_read2(src_imm,
                         csr_read,
                         read2_reg,
                         read2_imm,
                         read2_csr);

function [1:0] set_val_eval;
input [`MXLEN-1:0] out;
begin
    if (out == 0) begin
        set_val_eval = `ALU_BR_EQ;
    end
    else if (out < 0) begin
        set_val_eval = `ALU_BR_LT;
    end
    else begin
        set_val_eval = `ALU_BR_GT;
    end
end
endfunction

assign val_eval = set_val_eval(out);

function [`MXLEN-1:0] set_out;
input [`MXLEN-1:0] r1;
input [`MXLEN-1:0] r2;
input [ 4:0]       ops;
begin
    case (ops)
        `ALU_AND: begin
            set_out = r1 & r2;
        end
        `ALU_SUB: begin
            set_out = r1 - r2;
        end
        `ALU_SLL: begin
            set_out = r1 << r2[4:0];
        end
        `ALU_SLT: begin
            if ($signed(r1) < $signed(r2)) begin
                set_out = 1'b1;
            end
            else begin
                set_out = 1'b0;
            end
        end
        `ALU_SLTU: begin
            if (r1 < r2) begin
                set_out = 1'b1;
            end
            else begin
                set_out = 1'b0;
            end
        end
        `ALU_XOR: begin
            set_out = r1 ^ r2;
        end
        `ALU_SRL: begin
            set_out = r1 >> r2[4:0];
        end
        `ALU_SRA: begin
            set_out = $signed(r1) >>> $signed(r2[4:0]);
        end
        `ALU_OR: begin
            set_out = r1 | r2;
        end
        `ALU_ADD: begin
            set_out = r1 + r2;
        end
        `ALU_SUB_S: begin
            set_out = $signed(r1) - $signed(r2);
        end
        `ALU_MUL: begin
            set_out = $signed(r1) * $signed(r2);
        end
        `ALU_MULH: begin
            set_out = ($signed(r1) * $signed(r2)) & {16'hFFFF, 16'd0};
        end
        `ALU_MULHSU: begin
            set_out = ($signed(r1) * r2) & {16'hFFFF, 16'd0};
        end
        `ALU_MULHU: begin
            set_out = (r1 / r2) & {16'hFFFF, 16'd0};
        end
        `ALU_DIV: begin
            set_out = $signed(r1) / $signed(r2);
        end
        `ALU_DIVU: begin
            set_out = r1 / r2;
        end
        `ALU_REM: begin
            set_out = $signed(r1) % $signed(r2);
        end
        `ALU_REMU: begin
            set_out = r1 % r2;
        end
        `ALU_CSRRW: begin
            set_out = 32'd0 + r2;
        end
    endcase
end
endfunction

assign out = set_out(read1, read2, alu_ops);

endmodule
