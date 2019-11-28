`include "defs.v"


module ROM (
    input wire [31:0] read_addr,
    output reg [31:0] out,
    input wire CLK
    );

    reg [`WORDSIZE-1:0] rom [`ROM_COL_MAX-1:0];

    always @(posedge CLK) begin
        out <= rom[read_addr];
    end
endmodule