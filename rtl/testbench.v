`include "defs.v"
`timescale 1ns/100ps


module selevytest;

parameter CLK_PERIOD_h = 5;
parameter DUMPFILE     = "wave.vcd";

reg  CLK, reset;
wire [3:0] gout;

selevy core (
    CLK,
    reset,
    gout
);

initial begin
    $dumpfile(DUMPFILE);
    $dumpvars(0, selevytest);

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
