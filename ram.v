`include "defs.v"


module RAM (
    input wire [31:0] addr, write_data,
    input wire memread, memwrite,
    output reg [31:0] read_data,
    input wire CLK,
    input wire reset
    );

    reg [`WORDSIZE-1:0] ram [`ROM_COL_MAX-1:0];

    always @(posedge CLK) begin
        if (memread)
            read_data <= ram[addr];
        if (memwrite)
            ram[addr] <= write_data;
    end

    always @(posedge reset) begin : rst
        integer i;
        for (i = 0; i < `ROM_COL_MAX; i++) begin
            ram[i] = 0;
        end
    end
endmodule