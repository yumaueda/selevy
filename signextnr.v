`include "defs.v"


module SIGNEXTNR (
    input wire [`WORDSIZE-1:0]    read,
    input wire [1:0]              ops,
    output wire [`WORDSIZE-1:0]    out
    );

    assign out = signextend(read);

    function [31:0] signextend;
    input [31:0] in;
    begin
        signextend[`WORDSIZE-1] = in[`WORDSIZE-1];
        case (ops)
            `EXTNR_B: begin
                signextend[11] = in[7];
                signextend[10:5] = in[`WORDSIZE-2:`WORDSIZE-7];
                signextend[4:1] = in[11:8];
            end
            `EXTNR_S: begin
                signextend[10:5] = in[`WORDSIZE-2:`WORDSIZE-7];
                signextend[4:0] = in[11:7];
            end 
            `EXTNR_I: begin
                signextend[10:0] = in[`WORDSIZE-2:`WORDSIZE-12];
            end 
            `EXTNR_R: begin
                signextend = 0;
            end
        endcase
    end
    endfunction
endmodule