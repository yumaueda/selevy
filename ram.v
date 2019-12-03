`include "defs.v"


module RAM (
    input wire [31:0] addr, write_data,
    input wire memread, memwrite,
    output reg [31:0] read_data,
    input wire CLK,
    input wire reset
    );

    reg [7:0] ram [`ROM_COL_MAX-1:0];

    always @(posedge CLK) begin
        if (memwrite)
            store_word(write_data);
    end

    always @(posedge reset) begin : rst
        integer i;
        for (i = 0; i < `ROM_COL_MAX; i++) begin
            ram[i] = 0;
        end
    end

    always @(addr) begin
        if (memread)
            read_data <= get_read_data(addr);
    end

    function [31:0] get_read_data;
    input [31:0] in;
    begin : append3bytes
        get_read_data[31:24] = ram[in];
        get_read_data[23:16] = ram[in+1];
        get_read_data[15: 8] = ram[in+2];
        get_read_data[ 7: 0] = ram[in+3];
    end
    endfunction

    /*
     * Needs a controll signal for
     * knowing how many bytes it takes up in RAM.
     */

    /*
     * task do_store;
     * endtask
     */

    task store_word;
    input [`WORDSIZE-1:0] in;
    begin
        ram[addr]   = write_data[31:24];
        ram[addr+1] = write_data[23:16];
        ram[addr+2] = write_data[15: 8];
        ram[addr+3] = write_data[ 7: 0];
    end
    endtask
endmodule