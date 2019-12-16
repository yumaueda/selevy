`include "defs.v"


module ROM(
    /* `read_addr` must be multiple of 4 */
    input  wire [31:0] read_addr,
    output wire [31:0] out
    );

    reg [`WORDSIZE-1:0] rom [`ROM_COL_MAX-1:0];

    assign out = rom[read_addr/4];

    initial begin : rst
        integer i;
        for (i = 0; i < `ROM_COL_MAX; i = i + 1) begin
            rom[i] = 0;
        end
        $readmemb(`ROM_INIT, rom);
    end
endmodule
