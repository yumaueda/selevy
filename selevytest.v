`include "defs.v"


module selevytest;
    parameter CYC = 1;
    reg CLK, reset;

    selevy s(
        CLK,
        reset
    );
    defparam s.rf_init_data_path = "rf.bin";

    integer i;
    initial begin
        $dumpfile(`DUMPFILE);
        $dumpvars(0, selevytest);
                reset = 0;
        #(CYC)  reset = 1;
        #(CYC)  reset = 0;
        $display("REGISTERES");
        for (i = 0; i < 32; i++) begin
            $display("%d: %b", i, s.regfile.rf[i]);
        end
        #(CYC)  $finish;

    end
endmodule