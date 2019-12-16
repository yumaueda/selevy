`include "defs.v"


module PC (
    input  wire [`WORDSIZE-1:0] addr,
    output reg  [`WORDSIZE-1:0] out,
    input  wire CLK,
    input  wire reset
    );

    always @(posedge CLK) begin
        if (reset) begin : rst
            out[`WORDSIZE-1:0] <= 32'd0;
        end
        else begin
            out[`WORDSIZE-1:0] <= addr;
        end
    end
endmodule


module INCPC (
    input wire [`WORDSIZE-1:0] addr,
    output wire [`WORDSIZE-1:0] out
    );

    assign out = addr + 4;
endmodule


module BR_TGT (
    input wire [`WORDSIZE-1:0] addr1,
    input wire [`WORDSIZE-1:0] addr2,
    output wire [`WORDSIZE-1:0] target
    );

    assign target = addr1 + addr2;
endmodule
