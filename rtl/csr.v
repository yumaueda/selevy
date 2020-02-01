`include "defs.v"

`define mstatus_mie    mstatus[3]
`define mstatus_mpie   mstatus[7]
`define mstatus_mpp    mstatus[12:11]
`define mcause_intrp   mcause[`MXLEN-1:`MXLEN-2]
`define mcause_exccode mcause[`MXLEN-3:0]
`define mcycle_mcycle  mcycle[`MXLEN-1:0]
`define mcycleh_mcycle mcycle[`MXLEN*2-1:`MXLEN]


module CSR (
    input  wire                 CLK,
    input  wire                 reset,
    input  wire [11:0]          csr_addr,
    input  wire [`MXLEN-1:0]    rs1_data,
    input  wire [4:0]           zimm,
    input  wire [2:0]           csr_ops,
    output wire                 csr_data
    );

    //-----------------------
    // CSRs' address mapping
    //-----------------------

    // Implemented
    parameter addr_mhartid       = 12'hf14;
    parameter addr_mstatus       = 12'h300;
    parameter addr_mip           = 12'h344;
    parameter addr_mie           = 12'h304;
    parameter addr_mcause        = 12'h342;
    parameter addr_mtvec         = 12'h305;
    parameter addr_mtval         = 12'h343;
    parameter addr_mepc          = 12'h341;
    parameter addr_mscratch      = 12'h340;
    parameter addr_mcycle        = 12'hb00;
    parameter addr_minstret      = 12'hb02;
    parameter addr_mcycleh       = 12'hb80;
    parameter addr_minstreth     = 12'hb82;

    // Unimplemented && hardwired to zero
    parameter addr_misa          = 12'h301;
    parameter addr_mvendorid     = 12'hf11;
    parameter addr_marchid       = 12'hf12;
    parameter addr_mimpid        = 12'hf13;
    parameter addr_mstatush      = 12'hf14;
    //---------------------------------------------------
    // The mhpmcounters' address have a graded increase,
    // so only two of them are defined as a parameter.
    //---------------------------------------------------
    parameter addr_mhpmcounter3  = 12'hb03;
    parameter addr_mhpmcounter3h = 12'hb83;
    parameter addr_mcountinhibit = 12'h320;
    parameter addr_mhpmevent3    = 12'h323;

    // These registers should not exist in M-mode-only systems.
    //
    // - medeleg
    // - mideleg

    //----------------------------------------------------------------
    // CSRs
    //
    // The mstatush register is not implemented.
    // Therefore, memory accesses made from M-mode are little-endian.
    //----------------------------------------------------------------
    reg [`MXLEN-1:0]   mstatus;
    reg [`MXLEN-1:0]   mip;
    reg [`MXLEN-1:0]   mie;
    reg [`MXLEN-1:0]   mcause;
    reg [`MXLEN-1:0]   mtvec;
    reg [`MXLEN-1:0]   mtval;
    reg [`MXLEN-1:0]   mepc;
    reg [`MXLEN-1:0]   mscratch;
    reg [`MXLEN*2-1:0] mcycle;
    reg [`MXLEN*2-1:0] minstret;

    function [`MXLEN-1:0] set_csr_data;
        input [11:0] addr;
        begin
            // Implemented
            if (addr == addr_mhartid)
                set_csr_data = 32'b0;
            else if (addr == addr_mstatus)
                set_csr_data = mstatus;
            else if (addr == addr_mip)
                set_csr_data = mip;
            else if (addr == addr_mie)
                set_csr_data = mie;
            else if (addr == addr_mcause)
                set_csr_data = mcause;
            else if (addr == addr_mtvec)
                set_csr_data = mtvec;
            else if (addr == addr_mepc)
                set_csr_data = mepc;
            else if (addr == addr_mtval)
                set_csr_data = mtval;
            else if (addr == addr_mscratch)
                set_csr_data = mscratch;
            else if (addr == addr_mcycle)
                set_csr_data = mcycle;
            else if (addr == addr_minstret)
                set_csr_data = minstret;
            // Unimplemented 
            // mvendorid, marchid, mimpid
            else if (addr >= addr_mvendorid && addr <= addr_mimpid)
                set_csr_data = 32'b0;
            else if (addr == addr_misa)
                set_csr_data = 32'b0;
            else if (addr == addr_mstatush)
                set_csr_data = 32'b0;
            else if (addr >= addr_mhpmcounter3 && addr <= addr_mhpmcounter3+28)
                set_csr_data = 32'b0;
            else if (addr >= addr_mhpmcounter3h && addr <= addr_mhpmcounter3h+28)
                set_csr_data = 32'b0;
            else if (addr >= addr_mhpmevent3 && addr <= addr_mhpmevent3+28)
                set_csr_data = 32'b0;
            //------------------------------------------------
            // Attempts to access a non-existent CSR raise an
            // illegal instruction exception.
            //------------------------------------------------
            else begin
                // raise illegal instruction exception
                `mcause_intrp   = 1'b0;
                `mcause_exccode = 31'b0;
            end
        end
    endfunction

    assign csr_data = set_csr_data(csr_addr);

    task inccounter;
        begin
            mcycle   <= (mcycle   == 64'hffffffffffffffff) ? 0 : mcycle + 1;
            minstret <= (minstret == 64'hffffffffffffffff) ? 0 : minstret + 1;
        end
    endtask

    always @(negedge CLK) begin
        inccounter();
        if (reset) begin
            `mcause_intrp        <= 1'b1;
            `mcause_exccode      <= 30'b0;
            mcycle               <= 63'b0;
            minstret             <= 63'b0;
            //-----------------------------------------
            // Hardwire zero into unimplemented fields
            //-----------------------------------------
            mstatus[`MXLEN-1:13] <= 19'b0;
            mstatus[10:8]        <= 3'b0;
        end
    end

endmodule
