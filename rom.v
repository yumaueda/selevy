`include "defs.v"


module ROM #(
    parameter init_data_path = 0
    )(
    input wire [31:0] read_addr,
    output reg [31:0] out,
    input wire CLK,
    input wire reset
    );

    reg [`WORDSIZE-1:0] rom [`ROM_COL_MAX-1:0];

    always @(posedge CLK) begin
        out <= rom[read_addr];
    end

    always @(posedge reset) begin : rst
        integer i;
        for (i = 0; i < `ROM_COL_MAX; i++) begin
            rom[i] = 0;
        end
        if (init_data_path) begin : zero
            $readmemb(init_data_path, rom);
        end
    end
endmodule