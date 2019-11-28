`include "defs.v"


module CTRL (
    input wire [6:0]    read,
    output reg          branch,
    output reg          alusrc, 
    output reg          load,
    output reg [1:0]    aluops,
    output reg [1:0]    extnrops,
    output reg          memread,
    output reg          memwrite,
    output reg          regwrite
    );

    always @(read) begin
        branch   <= 0; // beq
        alusrc   <= 0; // lw, sw
        load     <= 0; // lw
        aluops   <= 0;
        extnrops <= 0;
        memread  <= 0; // lw
        memwrite <= 0; // sw
        regwrite <= 0; // R, lw
        case (read)
            `OPCODE_B: begin
                branch   <= 1;
                aluops   <= `OPCODE_B_ALU;
                extnrops <= `EXTNR_B;
            end
            `OPCODE_S: begin
                alusrc   <= 1;
                aluops   <= `OPCODE_S_ALU;
                extnrops <= `EXTNR_S;
                memwrite <= 1;
            end
            `OPCODE_I: begin
                alusrc   <= 1;
                load     <= 1;
                aluops   <= `OPCODE_I_ALU;
                extnrops <= `EXTNR_I;
                memread  <= 1;
                regwrite <= 1;
            end
            `OPCODE_R: begin
                aluops   <= `OPCODE_R_ALU;
                extnrops <= `EXTNR_R;
                regwrite <= 1;
            end
        endcase
    end
endmodule