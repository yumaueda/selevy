`include "defs.v"


module ALU (
    input wire [31:0] read1, read2,
    input wire [1:0] ops,
    output reg [31:0] out,
    output wire zero
    );

    assign zero = (out==0);

    always @(read1, read2, ops) begin
        case (ops)
            2'b00:
                out <= read1 & read2;
            2'b01:
                out <= read1 | read2;
            2'b10:
                out <= read1 + read2;
            2'b11:
                out <= read1 - read2;
        endcase
    end
endmodule


module ALUCTRL (
    input wire [1:0]    ops,
    input wire [2:0]    funct,
    input wire          thirty,
    output reg [1:0]    out
    );

    always @(ops, funct, thirty) begin
        case (ops)
            `OPCODE_I_ALU:
                out <= `ALU_ADD;
            `OPCODE_S_ALU:
                out <= `ALU_ADD;
            `OPCODE_B_ALU:
                out <= `ALU_SUB;
            `OPCODE_R_ALU:
                case (funct)
                    `R_ADDSUB:
                        case (thirty)
                            2'b0:
                                out <= `ALU_ADD; 
                            2'b1:
                                out <= `ALU_SUB;
                        endcase
                endcase
        endcase
    end
endmodule