`include "defs.v"


module TRAPHANDLER (
    input  wire instr_misaligned_exc,
    input  wire illegal_instr_exc,
    output wire abort,
    output wire exccode
    );

    function set_abort;
        input instr_misaligned;
        input illegal_instr;
        begin
        end
    endfunction

    assign abort = set_abort(
        instr_misaligned_exc,
    );


endmodule
