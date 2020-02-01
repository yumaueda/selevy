module GPIO
(
    input  wire              CLK,
    input  wire [`MXLEN-1:0] alu_out,
    output wire [ 3:0]        out_ja1
);

assign out_ja1 = alu_out[ 3:0];

endmodule
