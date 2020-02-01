`include "defs.v"


module REGFILE
#(
    parameter   [5:0]        REG_NUM = 6'd32
)
(
    input  wire              CLK,
    input  wire [ 4:0]       r_addr1,
    input  wire [ 4:0]       r_addr2,
    input  wire [ 4:0]       w_addr,
    input  wire              reg_write,
    input  wire [`MXLEN-1:0] w_data,
    output wire [`MXLEN-1:0] r_data1,
    output wire [`MXLEN-1:0] r_data2
);

reg  [`MXLEN-1:0] regfile [`REG_NUM-1:0];

always @(posedge CLK) begin
    if (reg_write) begin
        if (w_addr != 5'd0) begin
            regfile[w_addr] <= w_data;
        end
    end
end

assign r_data1 = regfile[r_addr1];
assign r_data2 = regfile[r_addr2];

initial begin
    regfile[5'd0] <= {`MXLEN{1'b0}};
end

endmodule
