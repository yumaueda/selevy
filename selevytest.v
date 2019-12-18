`include "defs.v"
`timescale 1ns/1ps


module selevytest;
    parameter CYC = 1000;
    reg CLK, reset;
    wire [3:0] gout;
    wire out_clk;

    selevy sel (
        CLK,
        reset,
        gout,
        out_clk
    );

    // integer i;
    initial begin
        $dumpfile(`DUMPFILE);
        $dumpvars(0, selevytest);
        /*--------------------
        $monitor("%t:\nx0=%b\nx1=%b\nx2=%b\nram[0]=%b\nram[1]=%b\nram[2]=%b\nram[3]=%b\n",
            $time,
            sel.selevy_regfile.rf[0],
            sel.selevy_regfile.rf[1],
            sel.selevy_regfile.rf[2],
            sel.selevy_ram.ram[0],
            sel.selevy_ram.ram[1],
            sel.selevy_ram.ram[2],
            sel.selevy_ram.ram[3]
            );
        --------------------*/
        CLK = 0; reset = 0;
        #(CYC/2) reset  =~reset;
        repeat (2) begin
            #(CYC/2) CLK = ~CLK;      
        end
        #(CYC/2) reset  =~reset;
        /*--------------------
        $display("REGISTERES");
        for (i = 0; i < `REG_NUM; i = i + 1) begin
            $display("%d: %b", i*4, sel.selevy_regfile.rf[i]);
        end
        $display("ROM");
        for (i = 0; i < `ROM_COL_MAX; i = i + 1) begin
            $display("%d: %b", i*4, sel.selevy_rom.rom[i]);
        end
        --------------------*/
        repeat (21*2)
            #(CYC/2)  CLK = ~CLK;
        #(CYC/2)$finish;
end
endmodule
