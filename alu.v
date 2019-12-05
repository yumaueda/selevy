`include "defs.v"


module ALU (
    input wire [31:0] read1, read2,
    input wire [2:0] ops,
    output reg [31:0] out,
    output wire zero
    );

    assign zero = (out==0);

    always @(read1, read2, ops) begin
        case (ops)
            `ALU_AND:
                out <= read1 & read2;
            `ALU_OR:
                out <= read1 | read2;
            `ALU_ADD:
                out <= read1 + read2;
            `ALU_SUB:
                out <= read1 - read2;
            `ALU_XOR:
                out <= read1 ^ read2;
        endcase
    end
endmodule


/*
 * The first and second case statement should be
 * written in ctrl.v.
 */
module ALUCTRL (
    input wire [1:0]    ops,
    input wire [2:0]    funct3,
    input wire          funct7_30,
    output reg [2:0]    out
    );

    always @(ops, funct3, funct7_30) begin
        case (ops)
            `OPCODE_I_ALU:
                out <= `ALU_ADD;
            `OPCODE_S_ALU:
                out <= `ALU_ADD;
            `OPCODE_B_ALU:
                out <= `ALU_SUB;
            `OPCODE_R_ALU:
                case (funct3)
                    `R_ADDSUB:
                        case (funct7_30)
                            2'b0:
                                out <= `ALU_ADD; 
                            2'b1:
                                out <= `ALU_SUB;
                        endcase
                    `R_AND:
                        out <= `ALU_AND;
                    `R_OR:
                        out <= `ALU_OR;
                    `R_XOR:
                        out <= `ALU_XOR;
                endcase
        endcase
    end
endmodule