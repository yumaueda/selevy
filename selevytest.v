`include "defs.v"


module selevytest;
    parameter CYC = 2;
    reg CLK, reset;

    selevy s(
        CLK,
        reset
    );
    defparam s.rf_init_data_path = "rf.bin";
    defparam s.rom_init_data_path = "rom.bin";

    integer i;
    initial begin
        $dumpfile(`DUMPFILE);
        $dumpvars(0, selevytest);
        $monitor("%t: ra=%b, rb=%b",
            $time,
            s.regfile.rf[1],
            s.regfile.rf[2]);
                CLK = 0; reset = 0;
        repeat (2) begin
            #(CYC/2)  reset = ~reset;
        end
        $display("REGISTERES");
        for (i = 0; i < `REG_NUM; i++) begin
            $display("%d: %b", i, s.regfile.rf[i]);
        end
        $display("ROM");
        for (i = 0; i < `ROM_COL_MAX; i++) begin
            $display("%d: %b", i, s.rom.rom[i]);
        end
        repeat (4*2) begin
            #(CYC/2)  CLK = ~CLK;
        end
        #(CYC/2)  $finish;
    end
endmodule