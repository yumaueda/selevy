`include "defs.v"


module TRAPHDLR
(
    input  wire              i_misaligned,
    input  wire              illegal_i,
    input  wire              l_misaligned,
    input  wire              s_misaligned,
    input  wire              ecall_m,
    output wire              exception,
    output wire [`MXLEN-1:0] mcause
);

function [`MXLEN-1:0] set_mcause;
input instr_misaligned;
input illegal_instr;
input load_misaligned;
input store_misaligned;
input ecall_m;
begin
    // The priority of interrupts is determined as below
    if (illegal_instr) begin
        set_mcause = 32'd2;
    end
    else if (instr_misaligned) begin
        set_mcause = 32'd0;
    end
    else if (ecall_m) begin
        set_mcause = 32'd11;
    end
    else if (store_misaligned) begin
        set_mcause = 32'd6;
    end
    else if (load_misaligned) begin
        set_mcause = 32'd4;
    end
end
endfunction

assign mcause = set_mcause(i_misaligned,
                           illegal_i,
                           l_misaligned,
                           s_misaligned,
                           ecall_m);

assign exception  = (
    i_misaligned == 1'b1 ||
    illegal_i    == 1'b1 ||
    l_misaligned == 1'b1 ||
    s_misaligned == 1'b1 ||
    ecall_m      == 1'b1
)? 1'b1 : 1'b0;

endmodule
