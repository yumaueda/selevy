`include "defs.v"


module RAM
#(
    parameter [10:0] RAM_COL_MAX = 11'd1024,
    parameter [ 3:0] DATA_WIDTH  = 4'd8,
    parameter [ 2:0] F3_LB       = 3'd0,
    parameter [ 2:0] F3_LH       = 3'd1,
    parameter [ 2:0] F3_LW       = 3'd2,
    parameter [ 2:0] F3_LBU      = 3'd4,
    parameter [ 2:0] F3_LHU      = 3'd5,
    parameter [ 2:0] F3_SB       = 3'd0,
    parameter [ 2:0] F3_SH       = 3'd1,
    parameter [ 2:0] F3_SW       = 3'd2
)
(
    input  wire              CLK,
    input  wire [`MXLEN-1:0] addr,
    input  wire [`MXLEN-1:0] w_data,
    input  wire              load,
    input  wire [ 2:0]       load_ops,
    input  wire              store,
    input  wire [ 2:0]       store_ops,
    input  wire              exception,
    output wire [`MXLEN-1:0] r_data,
    output wire              load_misaligned,
    output wire              store_misaligned
);

// The following exceptions never happen in the current implementation
//
// + load_misaligned
// + store_misaligned

assign load_misaligned  = 0;
assign store_misaligned = 0;

reg [ 7:0] ram [RAM_COL_MAX-1:0];

function [`MXLEN-1:0] signextend_b;
input    [ 7:0] in;
begin
    signextend_b[ 7:0] = in;
    signextend_b[`MXLEN-1:8] = {24{in[ 7]}};
end
endfunction

function [`MXLEN-1:0] signextend_h;
input    [15:0] in;
begin
    signextend_h[15:0] = in;
    signextend_h[`MXLEN-1:16] = {16{in[15]}};
end
endfunction

function [`MXLEN-1:0] set_r_data;
input              l;
input [2:0]        ops;
input [`MXLEN-1:0] r_addr;
begin
    if (l == 1'b1) begin
        case (ops)
            F3_LB: begin
                set_r_data = signextend_b(
                    ram[r_addr]
                );
            end
            F3_LH: begin
                set_r_data = signextend_h({
                    ram[r_addr+1],
                    ram[r_addr]
                });
            end
            F3_LW: begin
                set_r_data = {
                    ram[r_addr+3],
                    ram[r_addr+2],
                    ram[r_addr+1],
                    ram[r_addr]
                };
            end
            F3_LBU: begin
                set_r_data = {
                    24'd0,
                    ram[r_addr]
                };
            end
            F3_LHU: begin
                set_r_data = {
                    16'd0,
                    ram[r_addr+1],
                    ram[r_addr]
                };
            end
        endcase
    end
    else begin
        set_r_data = {`MXLEN{1'b0}};
    end
end
endfunction

assign r_data = set_r_data(load, load_ops, addr);

task do_store;
input [`MXLEN-1:0] w_addr;
input [`MXLEN-1:0] data;
input [ 2:0]       ops;
begin
    case (ops)
        F3_SB: begin
            ram[w_addr+0] <= data[ 7:0];
        end
        F3_SH: begin
            ram[w_addr+0] <= data[15:8];
            ram[w_addr+1] <= data[ 7:0];
        end
        F3_SW: begin
            ram[w_addr+0] <= data[31:24];
            ram[w_addr+1] <= data[23:16];
            ram[w_addr+2] <= data[15:8];
            ram[w_addr+3] <= data[ 7:0];
        end
    endcase
end
endtask

always @(posedge CLK) begin
    if (exception != 1'b1) begin
        if (store) begin
            do_store(addr, w_data, store_ops);
        end
    end
end

endmodule
