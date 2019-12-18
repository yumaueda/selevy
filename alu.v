`include "defs.v"


module ALU (
    input  wire [`WORDSIZE-1:0] read1, read2,
    input  wire [3:0] ops,
    output reg  [`WORDSIZE-1:0] out,
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
        out <= 0;
        (* full_case *)
        case (ops)
            `ALU_AND:
                out <= read1 & read2;
            `ALU_SUB:
                out <= read1 - read2;
            `ALU_SLL:
                out <= read1 << read2[4:0];
            `ALU_SLT:
                if ($signed(read1) < $signed(read2)) begin
                    out <= 1'b1;
                end else begin
                    out <= 1'b0;
                end
            `ALU_SLTU:
                if (read1 < read2) begin
                    out <= 1'b1;
                end else begin
                    out <= 1'b0;
                end
            `ALU_XOR:
                out <= read1 ^ read2;
            `ALU_SRL:
                out <= read1 >> read2[4:0];
            `ALU_SRA:
                out <= $signed(read1) >>> $signed(read2[4:0]);
            `ALU_OR:
                out <= read1 | read2;
            `ALU_ADD:
                out <= read1 + read2;
            `ALU_SUB_S:
                out <= $signed(read1) - $signed(read2);
        endcase
    end
endmodule


/*
 * The first and second case statement should be
 * written in ctrl.v.
 */
module ALUCTRL (
    input wire [2:0]    ops,
    input wire [2:0]    funct3,
    input wire          funct7_30,
    output reg [3:0]    out
    );

    always @(ops, funct3, funct7_30) begin
        out <= 0;
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
                    `R_ADDSUB:
                        case (funct7_30)
                            2'b0:
                                out <= `ALU_ADD; 
                            2'b1:
                                out <= `ALU_SUB;
                        endcase
                    `R_SLL:
                        out <= `ALU_SLL;
                    `R_SLT:
                        out <= `ALU_SLT;
                    `R_SLTU:
                        out <= `ALU_SLTU;
                    `R_XOR:
                        out <= `ALU_XOR;
                    `R_AND:
                        out <= `ALU_AND;
                    `R_OR:
                        out <= `ALU_OR;
                    `R_SRLSRA:
                        case (funct7_30)
                            2'b00:
                                out <= `ALU_SRL;
                            2'b01:
                                out <= `ALU_SRA;
                        endcase
                endcase
            `OPCODE_I_I_ALU:
                (* full_case *)
                case (funct3)
                    `R_ADDSUB:
                        out <= `ALU_ADD;
                    `R_SLL:
                        out <= `ALU_SLL;
                    `R_SLT:
                        out <= `ALU_SLT;
                    `R_SLTU:
                        out <= `ALU_SLTU;
                    `R_XOR:
                        out <= `ALU_XOR;
                    `R_AND:
                        out <= `ALU_AND;
                    `R_OR:
                        out <= `ALU_OR;
                    `R_SRLSRA:
                        case (funct7_30)
                            2'b00:
                                out <= `ALU_SRL;
                            2'b01:
                                out <= `ALU_SRA;
                        endcase
                endcase
        endcase
    end
endmodule
