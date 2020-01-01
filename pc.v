`include "defs.v"


module PC (
    input  wire [`MXLEN-1:0] addr,
    output reg  [`MXLEN-1:0] out,
    input  wire CLK,
    input  wire reset
    );

    parameter reset_vec = 32'b0;

    always @(posedge CLK) begin
        if (reset) out[`MXLEN-1:0] <= reset_vec;
        else out[`MXLEN-1:0] <= addr;
    end
endmodule


module INCPC (
    input wire [`MXLEN-1:0] addr,
    output wire [`MXLEN-1:0] out
    );

    assign out = addr + 4;
endmodule


module BR_TGT (
    input wire [`MXLEN-1:0] addr1,
    input wire [`MXLEN-1:0] addr2,
    output wire [`MXLEN-1:0] target
    );

    assign target = addr1 + addr2;
endmodule
