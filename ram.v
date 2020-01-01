`include "defs.v"


module RAM (
    input  wire [31:0] addr, write_data,
    input  wire [ 2:0] ctrl_loadops,
    input  wire memwrite,
    input  wire [ 1:0] storeops,
    output wire [31:0] read_data,
    input  wire CLK, reset
    );

    reg [7:0] ram [`RAM_COL_MAX-1:0];

    always @(posedge CLK) begin
        if (reset) begin : rst
            integer i;
            for (i = 0; i < `RAM_COL_MAX; i = i + 1) begin
                ram[i] <= 0;
            end
        end
        else if (memwrite) begin
            do_store();
        end
    end

    function [`MXLEN-1:0] signextend_h;
        input [15:0] in;
        begin
            signextend_h[15:0] = in;
            if (in[15])
                signextend_h[`MXLEN-1:16] = 16'b1111111111111111;
            else
                signextend_h[`MXLEN-1:16] = 16'b0;
        end
    endfunction

    function [`MXLEN-1:0] signextend_b;
        input [7:0] in;
        begin
            signextend_b[7:0] = in[7:0];
            if (in[7]) begin
                signextend_b[`MXLEN-1:8] = 24'b111111111111111111111111;
            end
            else
                signextend_b[`MXLEN-1:8] = 24'b0;
        end
    endfunction

    function [`MXLEN-1:0] set_read_data;
        input [2:0] loadops;
        input [`MXLEN-1:0] address;
        begin
            if (loadops == `NO_LOAD)
                set_read_data = 32'b0;
            else begin
                (* full_case *)
                case (loadops)
                    `FUNCT_LB: begin
                        set_read_data = signextend_b(ram[address]);
                    end
                    `FUNCT_LH: begin
                        set_read_data = signextend_h({
                            ram[address],
                            ram[address+1]
                        });
                    end
                    `FUNCT_LW: begin
                        set_read_data = {
                            8'b0,
                            ram[address],
                            ram[address+1],
                            ram[address+2]
                        };
                    end
                    `FUNCT_LBU: begin
                        set_read_data = {
                            24'b0,
                            ram[address]
                        };
                    end
                    `FUNCT_LHU: begin
                        set_read_data = {
                            16'b0,
                            ram[address],
                            ram[address+1]
                        };
                    end
                endcase
            end
        end
    endfunction

    assign read_data = set_read_data(ctrl_loadops, addr);

    /*--------------------
    assign read_data = {
        ram[addr],
        ram[addr+1],
        ram[addr+2],
        ram[addr+3]
    };
    --------------------*/

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
        (* full_case *)
        case (storeops)
            `STORE_B: store_byte();
            `STORE_H: store_half_word();
            `STORE_W: store_word();
        endcase
    end
    endtask
endmodule
