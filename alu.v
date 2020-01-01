`include "defs.v"


module ALU (
    input  wire [`MXLEN-1:0] read1, read2,
    input  wire [4:0] ops,
    output reg  [`MXLEN-1:0] out,
    output wire [1:0] alu_br_ops
    );

    function [1:0] set_alu_br_ops;
        input [31:0] out;
        begin
            if (out == 0)
                set_alu_br_ops = `ALU_BR_EQ;
            else if (out < 0)
                set_alu_br_ops = `ALU_BR_LT;
            else
                set_alu_br_ops = `ALU_BR_GT;
        end
    endfunction

    assign alu_br_ops = set_alu_br_ops(out);

    always @(read1, read2, ops) begin
        (* full_case *)
        case (ops)
            `ALU_AND:       out <= read1 & read2;
            `ALU_SUB:       out <= read1 - read2;
            `ALU_SLL:       out <= read1 << read2[4:0];
            `ALU_SLT:
                if ($signed(read1) < $signed(read2)) out <= 1'b1;
                else                                 out <= 1'b0;
            `ALU_SLTU:
                if (read1 < read2) out <= 1'b1;
                else               out <= 1'b0;
            `ALU_XOR:       out <= read1 ^ read2;
            `ALU_SRL:       out <= read1 >> read2[4:0];
            `ALU_SRA:       out <= $signed(read1) >>> $signed(read2[4:0]);
            `ALU_OR:        out <= read1 | read2;
            `ALU_ADD:       out <= read1 + read2;
            `ALU_SUB_S:     out <= $signed(read1) - $signed(read2);
            `ALU_MUL:       out <= $signed(read1) * $signed(read2);
            `ALU_MULH:   begin
                out <= $signed(read1) * $signed(read2);
                out[(`MXLEN/2)-1:0] <= 0;
            end
            `ALU_MULHSU: begin
                out <= $signed(read1) * read2;
                out[(`MXLEN/2)-1:0] <= 0;
            end
            `ALU_MULHU:  begin
                out <= read1 / read2;
                out[(`MXLEN/2)-1:0] <= 0;
            end
            `ALU_DIV:       out <= $signed(read1) / $signed(read2);
            `ALU_DIVU:      out <= read1 / read2;
            `ALU_REM:       out <= $signed(read1) % $signed(read2);
            `ALU_REMU:      out <= read1 % read2;
        endcase
    end
endmodule


module ALUCTRL (
    input wire [2:0]    ops,
    input wire [2:0]    funct3,
    input wire [6:0]    funct7,
    output reg [4:0]    out
    );

    always @(ops, funct3, funct7) begin
        out <= 0;
        (* full_case *)
        case (ops)
            `OPCODE_I_ALU:
                out <= `ALU_ADD;
            `OPCODE_S_ALU:
                out <= `ALU_ADD;
            `OPCODE_B_ALU:
                if (funct3 == `FUNCT_LTU || funct3 == `FUNCT_GEU)
                    out <= `ALU_SUB_S;
                else
                    out <= `ALU_SUB;
            `OPCODE_R_ALU:
                (* full_case *)
                case (funct3)
                    `F3_ADDSUBMUL:
                        case (funct7[0])
                            1'b0:
                                case (funct7[5])
                                    1'b0: out <= `ALU_ADD;
                                    1'b1: out <= `ALU_SUB;
                                endcase
                            1'b1: out <= `ALU_MUL;
                        endcase
                    `F3_SLLMULH:
                        case (funct7[0])
                            1'b0: out <= `ALU_SLL;
                            1'b1: out <= `ALU_MULH;
                        endcase
                    `F3_SLTMULHSU:
                        case (funct7[0])
                            1'b0: out <= `ALU_SLT;
                            1'b1: out <= `ALU_MULHSU;
                        endcase
                    `F3_SLTUMULHU:
                        case (funct7[0])
                            1'b0: out <= `ALU_SLTU;
                            1'b1: out <= `ALU_MULHU;
                        endcase
                    `F3_XORDIV:
                        case (funct7[0])
                            1'b0: out <= `ALU_XOR;
                            1'b1: out <= `ALU_DIV;
                        endcase
                    `F3_SRLSRADIVU:
                        case (funct7[0])
                            1'b0:
                                case (funct7[5])
                                    1'b0: out <= `ALU_SRL;
                                    1'b1: out <= `ALU_SRA;
                                endcase
                            1'b1: out <= `ALU_DIVU;
                        endcase
                    `F3_ORREM:
                        out <= `ALU_OR;
                    `F3_ANDREMU:
                        out <= `ALU_AND;
                endcase
            `OPCODE_I_I_ALU:
                (* full_case *)
                case (funct3)
                    `F3_ADDSUBMUL: out <= `ALU_ADD;
                    `F3_SLLMULH:   out <= `ALU_SLL;
                    `F3_SLTMULHSU: out <= `ALU_SLT;
                    `F3_SLTUMULHU: out <= `ALU_SLTU;
                    `F3_XORDIV:    out <= `ALU_XOR;
                    `F3_SRLSRADIVU:
                        case (funct7[5])
                            2'b00: out <= `ALU_SRL;
                            2'b01: out <= `ALU_SRA;
                        endcase
                    `F3_ORREM:     out <= `ALU_OR;
                    `F3_ANDREMU:   out <= `ALU_AND;
                endcase
        endcase
    end
endmodule
