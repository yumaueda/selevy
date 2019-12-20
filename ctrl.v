`include "defs.v"


module CTRL (
    input  wire [6:0]   read_opcode,
    input  wire [2:0]   read_funct,
    output reg          alusrc, 
    output reg  [2:0]   loadops,
    output reg  [2:0]   aluops,
    output reg  [1:0]   extnrops,
    output reg          memwrite,
    output reg          regwrite,
    output reg  [1:0]   storeops,
    output reg  [2:0]   branchops
    );

    always @(read_opcode, read_funct) begin
        alusrc <= 0; // lw, S
        loadops <= `NO_LOAD; // I
        aluops <= 0;
        extnrops <= 0;
        memwrite <= 0; // S
        regwrite <= 0; // R, lw
        storeops <= 0; // S
        branchops[2:0] <= `NO_BRANCH; // B
        case (read_opcode)
            `OPCODE_I: begin
                aluops   <= `OPCODE_I_ALU;
                alusrc   <= 1;
                extnrops <= `EXTNR_I;
                loadops <= read_funct;
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
                aluops   <= `OPCODE_B_ALU;
                extnrops <= `EXTNR_B;
                branchops <= read_funct;
            end
        endcase
    end
endmodule
