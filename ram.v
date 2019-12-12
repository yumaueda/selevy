`include "defs.v"


module RAM (
    input wire [31:0] addr, write_data,
    input wire memread, memwrite,
    input wire [1:0] storeops,
    output wire [31:0] read_data,
    input wire CLK,
    input wire reset
    );

    reg [7:0] ram [`ROM_COL_MAX-1:0];

    always @(posedge CLK) begin
        if (memwrite)
            do_store();
    end

    always @(posedge reset) begin : rst
        integer i;
        for (i = 0; i < `ROM_COL_MAX; i = i + 1) begin
            ram[i] <= 0;
        end
    end

    assign read_data = {
        ram[addr],
        ram[addr+1],
        ram[addr+2],
        ram[addr+3]
    };

    task store_byte;
    begin
        ram[addr] <= write_data[7:0];
    end
    endtask

    task store_half_word;
    begin
        ram[addr]   <= write_data[15:8];
        ram[addr+1] <= write_data[7:0];
    end
    endtask

    task store_word;
    begin
        ram[addr]   <= write_data[31:24];
        ram[addr+1] <= write_data[23:16];
        ram[addr+2] <= write_data[15: 8];
        ram[addr+3] <= write_data[ 7: 0];
    end
    endtask

    task do_store;
    begin
        case (storeops)
            `STORE_B: store_byte();
            `STORE_H: store_half_word();
            `STORE_W: store_word();
        endcase
    end
    endtask
endmodule