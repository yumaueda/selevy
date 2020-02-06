module UART_TOP_CTRL
#(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
)
(
    input   wire                  CLK,
    input   wire                  ram_te,
    input   wire [DATA_WIDTH-1:0] ram_txd,
    output  wire                  TXD
);

// tx_fifo
wire                  tx_w_enable;
wire                  tx_r_enable;
wire [ADDR_WIDTH:0]   tx_count;

// tx_fifo & uart_tx_ctrl
reg  [DATA_WIDTH-1:0] send_data;

// uart_tx_ctrl
wire                  tx_send;
wire [DATA_WIDTH-1:0] tx_send_data;
wire                  tx_ready;

FIFO tx_fifo (
    CLK,
    tx_w_enable,
    tx_r_enable,
    tx_w_data_arr[1],
    tx_send_data,
    tx_count
);

UART_TX_CTRL uart_tx_ctrl (
    CLK,
    tx_send,
    tx_send_data,
    tx_ready,
    TXD
);

reg  [DATA_WIDTH-1:0] tx_w_data_arr [ 1:0];

function set_tx_w_enable;
input [DATA_WIDTH-1:0] w_data_1;
input [DATA_WIDTH-1:0] w_data_2;
input                  r_enable;
input [ADDR_WIDTH:0]   count;
begin
    if (w_data_1 != w_data_2) begin
        if (tx_count < ADDR_WIDTH**2) begin
            set_tx_w_enable = 1'b1;
        end
        else if (tx_count == ADDR_WIDTH && r_enable == 1'b1) begin
            set_tx_w_enable = 1'b1;
        end
        else begin
            set_tx_w_enable = 1'b0;
        end
    end
    else begin
        set_tx_w_enable = 1'b0;
    end
end
endfunction

assign tx_w_enable = set_tx_w_enable(tx_w_data_arr[0],
                                     tx_w_data_arr[1],
                                     tx_r_enable,
                                     tx_count);

assign tx_r_enable = (tx_ready == 1'b1 && tx_count > 0);

always @(posedge CLK) begin
    tx_w_data_arr[1] <= tx_w_data_arr[0]; 
    tx_w_data_arr[0] <= ram_txd;
end

endmodule
