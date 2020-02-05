module UART_TX_CTRL
#(
    parameter [ 1:0] RDY       = 2'b01,
    parameter [ 1:0] LOAD      = 2'b10,
    parameter [ 1:0] SEND      = 2'b11,
    parameter [ 3:0] IDX_MAX   = 10,
    parameter [13:0] TMR_MAX   = 14'b10100010110000 // 10416 = round(100MHz/9600Hz) - 1
)
(
    input  wire       CLK,
    input  wire       send,
    input  wire [7:0] send_data,
    output wire       ready,
    output wire       UART_TX
);

reg         tx_bit;
reg  [ 1:0] tx_state;
reg  [ 9:0] tx_data;
reg  [ 3:0] index;
reg  [13:0] tx_tmr;
wire        bit_done;

initial begin
    tx_bit   = 1'b1;
    tx_state = RDY;
    tx_tmr   = 14'd0;
end

always @(posedge CLK) begin : state_transition
    case (tx_state)
        RDY:
            if (send)
                tx_state <= LOAD;
        LOAD:
            tx_state <= SEND;
        SEND:
            if (bit_done) begin
                if (index == IDX_MAX)
                    tx_state <= RDY;
                else
                    tx_state <= LOAD;
            end
        default: // should never be reached
            tx_state <= RDY;
    endcase
end

always @(posedge CLK) begin : timing
    if (tx_state == RDY) begin
        tx_tmr <= 14'd0;
    end
    else begin
        if (bit_done)
            tx_tmr <= 14'd0;
        else
            tx_tmr <= tx_tmr + 1;
    end
end

always @(posedge CLK) begin : increment_index
    if (tx_state == RDY)
        index <= 0;
    else if (tx_state == LOAD)
        index <= index + 1;
end

always @(posedge CLK) begin : data_latch
    if (send)
        tx_data <= {1'b1, send_data, 1'b0};
end

always @(posedge CLK) begin : bit0
    if (tx_state == RDY)
        tx_bit <= 1'b1;
    else if (tx_state == LOAD)
        tx_bit <= tx_data[index];
end

assign bit_done = (tx_tmr == TMR_MAX)? 1 : 0;
assign UART_TX   = tx_bit;
assign ready     = (tx_state == RDY)? 1 : 0;

endmodule
