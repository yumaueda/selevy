`include "defs.v"


module REGFILE (
    input wire [4:0] read1, read2, write1,
    input wire [31:0] write_data,
    input wire regwrite,
    output wire [31:0] out1,
    output wire [31:0] out2,
    input wire CLK, reset
    );

    reg [`WORDSIZE-1:0] rf [`REG_NUM-1:0];

    assign out1 = rf[read1];
    assign out2 = rf[read2];

    always @(posedge CLK) begin
        if (reset) begin : rst
            integer i;
            for (i = 0; i < `WORDSIZE; i = i + 1) begin
                rf[i] <= 0;
            end
        end
        else if (regwrite) begin
            rf[write1] <= write_data;
        end
    end
endmodule
