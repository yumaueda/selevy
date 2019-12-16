module GPIO (
    input wire  CLK,
    input wire  [`WORDSIZE-1:0] alu_out,
    input wire  [`WORDSIZE-1:0] ram_read_data,
    output wire [3:0] out_ja1
    );

    assign out_ja1 = alu_out[3:0];
endmodule
