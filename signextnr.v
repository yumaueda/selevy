`include "defs.v"


module SIGNEXTNR (
    input wire [`MXLEN-1:0]    read,
    input wire [1:0]              ops,
    output reg [`MXLEN-1:0]    out
    );

    always @(ops, read) begin
        out <= 0;
        out[`MXLEN-1] <= read[`MXLEN-1];
        if (read[`MXLEN-1]) begin
            out[`MXLEN-2:`MXLEN-21] <= 20'b11111111111111111111;
        end
        case (ops)
            `EXTNR_B: begin
                out[11] <= read[7];
                out[10:5] <= read[`MXLEN-2:`MXLEN-7];
                out[4:1] <= read[11:8];
            end
            `EXTNR_S: begin
                out[10:5] <= read[`MXLEN-2:`MXLEN-7];
                out[4:0] <= read[11:7];
            end 
            `EXTNR_I: begin
                out[10:0] <= read[`MXLEN-2:`MXLEN-12];
            end
            `EXTNR_R: begin
                out <= 0;
            end
        endcase
    end
endmodule
