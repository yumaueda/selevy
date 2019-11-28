`include "defs.v"


module REGFILE (
    input wire [4:0] read1, read2, write1,
    input wire [31:0] write_data,
    input wire regwrite,
    output wire [31:0] out1,
    output wire [31:0] out2,
    input wire CLK
    );

    reg [`WORDSIZE:0] rf [`ROM_COL_MAX:0];

    assign out1 = rf[read1];
    assign out2 = rf[read2];
    
    always @(posedge CLK) begin
        if (regwrite)
            rf[write1] <= write_data;
    end
endmodule