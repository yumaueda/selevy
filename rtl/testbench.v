`include "defs.v"
`timescale 1ns/100ps


module testbench;

parameter CLK_PERIOD_h = 5;
parameter DUMPFILE     = "wave.vcd";

reg         CLK;
reg         reset;
wire [ 3:0] gout;
wire        TXD;

selevy selevy (
    CLK,
    reset,
    gout,
    TXD
);

initial begin
    $dumpfile(DUMPFILE);
    $dumpvars(0, testbench);

    CLK = 0; reset = 0;

    #CLK_PERIOD_h reset = ~reset;

    repeat (2) begin
        #CLK_PERIOD_h CLK= ~CLK;
    end

    #CLK_PERIOD_h reset = ~reset;

    repeat (1000*2) begin
        #CLK_PERIOD_h CLK = ~CLK;
    end
    $finish;
end

endmodule
