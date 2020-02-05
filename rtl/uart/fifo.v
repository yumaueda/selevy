//------------------------------------------------
// WARNING: This fifo module has no protection
// mechanism against write when the fifo is full.
//------------------------------------------------


module FIFO
#(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
)
(
    input  wire                  CLK,
    input  wire                  w_enable,
    input  wire                  r_enable,
    input  wire [DATA_WIDTH-1:0] w_data,
    output reg  [DATA_WIDTH-1:0] r_data,
    output reg  [ADDR_WIDTH:0]   count
);

reg [ADDR_WIDTH-1:0] w_addr;
reg [ADDR_WIDTH-1:0] r_addr;
reg [DATA_WIDTH-1:0] ram [ADDR_WIDTH**2-1:0];

initial begin
    r_data <= 0;
    count  <= 0;
    w_addr <= 0;
    r_addr <= 0;
end

always @(posedge CLK) begin : dpm
    if (w_enable) begin
        ram[w_addr] <= w_data;
    end
    if (r_enable) begin
        r_data <= ram[r_addr];
    end
end

always @(posedge CLK) begin : addr
    if (w_enable)
        w_addr <= w_addr + 1'b1;
    if (r_enable)
        r_addr <= r_addr + 1'b1;
end

always @(posedge CLK) begin : count_data
    case ({w_enable, r_enable})
        2'b00: count <= count;
        2'b01: count <= count - 9'd1;
        2'b10: count <= count + 9'd1;
        2'b11: count <= count;
    endcase
end

endmodule
