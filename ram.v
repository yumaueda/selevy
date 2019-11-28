`include "defs.v"


module RAM (
    input wire [31:0] addr, write_data,
    input wire memread, memwrite,
    output reg [31:0] read_data,
    input wire CLK
    );

    reg [`WORDSIZE-1:0] ram [`ROM_COL_MAX-1:0];

    always @(posedge CLK) begin
        if (memread)
            read_data <= ram[addr];
        if (memwrite)
            ram[addr] <= write_data;
    end
endmodule