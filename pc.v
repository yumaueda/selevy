`include "defs.v"


module PC (
    input wire [`WORDSIZE-1:0] addr,
    output reg [`WORDSIZE-1:0] out,
    input wire CLK,
    input wire reset
    );

    always @(posedge CLK) begin
        out <= addr;
    end

    always @(posedge reset) begin
        out <= 0;
    end
endmodule


module INCPC (
    input wire [`WORDSIZE-1:0] addr,
    output reg [`WORDSIZE-1:0] out
    );

    always @(addr) begin
        out <= addr + (`WORDSIZE / 8);
    end
endmodule


module BR_TGT (
    input wire [`WORDSIZE-1:0] addr1,
    input wire [`WORDSIZE-1:0] addr2,
    output reg [`WORDSIZE-1:0] target
    );

    always @(addr1, addr2) begin
        target <= addr1 + addr2;
    end
endmodule