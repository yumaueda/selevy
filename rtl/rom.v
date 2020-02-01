`include "defs.v"

// TODO: Instruction-fetch must be little-endian.

module ROM
(
    input  wire [31:0] addr,
    output wire [31:0] data
);


reg [`MXLEN-1:0] rom [`ROM_COL_MAX-1:0];

function [`MXLEN-1:0] set_data;
input [`MXLEN-1:0] a;
begin
    if (a % 4 == 0) begin
        set_data = rom[a/4];
    end
end
endfunction

assign data = set_data(addr);

initial begin
    $readmemb(`BOOTROM, rom);
end
endmodule
