`include "defs.v"


(* dont_touch = "true" *)
module CTRL (
    input wire [6:0]    read_opcode,
    input wire [2:0]    read_funct,
    output reg          branch,
    output reg          alusrc, 
    output reg          load,
    output reg [2:0]    aluops,
    output reg [1:0]    extnrops,
    output reg          memwrite,
    output reg          regwrite,
    output reg [1:0]    storeops
    );

    always @(read_opcode, read_funct) begin
        branch   <= 0; // beq
        alusrc   <= 0; // lw, S
        load     <= 0; // lw
        aluops   <= 0;
        extnrops <= 0;
        memwrite <= 0; // S
        regwrite <= 0; // R, lw
        storeops <= 0; // S
        case (read_opcode)
            `OPCODE_I: begin
                aluops   <= `OPCODE_I_ALU;
                alusrc   <= 1;
                extnrops <= `EXTNR_I;
                load     <= 1;
                regwrite <= 1;
            end
            `OPCODE_I_I: begin
                aluops   <= `OPCODE_I_I_ALU;
                alusrc   <= 1;
                extnrops <= `EXTNR_I;
                regwrite <= 1;
            end
            `OPCODE_S: begin
                alusrc   <= 1;
                aluops   <= `OPCODE_S_ALU;
                extnrops <= `EXTNR_S;
                memwrite <= 1;
                /*
                 * STORE_{B,H,W} = FUNCT_S{B,H,W} + 1
                 */
                (* full_case *)
                case (read_funct)
                    `FUNCT_SB:
                        storeops <= `STORE_B;
                    `FUNCT_SH:
                        storeops <= `STORE_H;
                    `FUNCT_SW:
                        storeops <= `STORE_W;
                endcase
            end
            `OPCODE_R: begin
                aluops   <= `OPCODE_R_ALU;
                extnrops <= `EXTNR_R;
                regwrite <= 1;
            end
            `OPCODE_B: begin
                branch   <= 1;
                aluops   <= `OPCODE_B_ALU;
                extnrops <= `EXTNR_B;
            end
            default: begin
            end
        endcase
    end
endmodule
