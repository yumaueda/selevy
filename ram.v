`include "defs.v"


module RAM (
    input wire [31:0] addr, write_data,
    output reg [31:0] read_data,
    input wire do_read, do_write,
    input wire CLK
    );

    reg [`WORDSIZE-1:0] ram [`ROM_COL_MAX-1:0];

    always @(posedge CLK) begin
        if (do_read)
            read_data <= ram[addr];
        if (do_write)
            ram[addr] <= write_data;
    end
endmodule