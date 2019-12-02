`include "defs.v"


module ROM #(
    parameter init_data_path = 0
    )(
    input wire [31:0] read_addr,
    output wire [31:0] out,
    input wire reset
    );

    reg [`WORDSIZE-1:0] rom [`ROM_COL_MAX-1:0];

    assign out = rom[read_addr];

    always @(posedge reset) begin : rst
        integer i;
        for (i = 0; i < `ROM_COL_MAX; i++) begin : zero
            rom[i] = 0;
        end
        if (init_data_path) begin
            $readmemb(init_data_path, rom);
        end
    end
endmodule