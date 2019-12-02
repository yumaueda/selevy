`include "defs.v"


module selevytest;
    parameter CYC = 1;
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
        $monitor("%t: %b", $time, s.regfile.rf[1]);
                CLK = 0; reset = 0;
        #(CYC)  reset = 1;
        #(CYC)  reset = 0;
        $display("REGISTERES");
        for (i = 0; i < 32; i++) begin
            $display("%d: %b", i, s.regfile.rf[i]);
        end
        $display("ROM");
        for (i = 0; i < 2; i++) begin
            $display("%d: %b", i, s.rom.rom[i]);
        end
        #(CYC)  CLK = 1;
        #(CYC)  CLK = 0;
        #(CYC)  CLK = 1;
        #(CYC)  CLK = 0;
        #(CYC)  $finish;

    end
endmodule