`include "defs.v"


module SIGNEXTNR (
    input wire [`WORDSIZE-1:0]    read,
    input wire [1:0]              ops,
    output reg [`WORDSIZE-1:0]    out
    );

    always @(read) begin
        out[`WORDSIZE-1] <= read[`WORDSIZE-1];
        case (ops)
            `EXTNR_B: begin
                out[11]   <= read[7];
                out[10:5] <= read[`WORDSIZE-2:`WORDSIZE-7];
                out[4:1]  <= read[11:8];
            end
            `EXTNR_S: begin
                out[10:5] <= read[`WORDSIZE-2:`WORDSIZE-7];
                out[4:0]  <= read[11:7];
            end
            `EXTNR_I:
                out[10:0] <= read[`WORDSIZE-2:`WORDSIZE-12];
            `EXTNR_R:
                out <= 0;
        endcase
    end
endmodule