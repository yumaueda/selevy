`include "defs.v"


module REGFILE #(
    parameter init_data_path = 0
    )(
    input wire [4:0] read1, read2, write1,
    input wire [31:0] write_data,
    input wire regwrite,
    output wire [31:0] out1,
    output wire [31:0] out2,
    input wire CLK,
    input wire reset
    );

    reg [`WORDSIZE-1:0] rf [`REG_NUM-1:0];

    assign out1 = rf[read1];
    assign out2 = rf[read2];
    
    always @(posedge CLK) begin
        if (regwrite)
            rf[write1] <= write_data;
    end

    always @(posedge reset) begin : rst
        integer i;
        for (i = 0; i < `WORDSIZE; i++) begin
            rf[i] = 0;
        end
        if (init_data_path) begin
            $readmemb(init_data_path, rf);
        end
    end
endmodule