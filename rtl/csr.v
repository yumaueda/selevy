`include "defs.v"


module CSR
#(
    //-----------------------
    // CSRs' address mapping
    //-----------------------
    parameter mstatus_addr  = 12'h300,
    parameter misa_addr     = 12'h301,
    parameter mie_addr      = 12'h304,
    parameter mtvec_addr    = 12'h305,
    parameter mstatush_addr = 12'h310,
    parameter mscratch_addr = 12'h340,
    parameter mepc_addr     = 12'h341,
    parameter mcause_addr   = 12'h342,
    parameter mtval_addr    = 12'h343,
    parameter mip_addr      = 12'h344
)
(
    input  wire              CLK,
    input  wire              RST,
    input  wire              exception,
    input  wire              mret,
    input  wire              csr_read,
    input  wire              csr_write,
    input  wire [`MXLEN-1:0] pc_val,
    input  wire [`MXLEN-1:0] exception_num, // mcause
    input  wire [`MXLEN-1:0] instr,
    input  wire [`MXLEN-1:0] alu_out,       // alu_out, w_data
    output wire [`MXLEN-1:0] r_data
);

wire [11:0]       csr_addr;
wire [ 2:0]       sys_funct3;

assign csr_addr   = instr[`MXLEN-1:`MXLEN-12];
assign sys_funct3 = instr[14:12];

reg  [ 1:0]       cpm; // holds current privilege mode

reg  [`MXLEN-1:0] misa;
reg  [`MXLEN-1:0] mip;
reg  [`MXLEN-1:0] mie;
reg  [`MXLEN-1:0] mscratch;
reg  [`MXLEN-1:0] mepc;
reg  [`MXLEN-1:0] mstatus;
reg  [`MXLEN-1:0] mstatush;
reg  [`MXLEN-1:0] mtvec;
reg  [`MXLEN-1:0] mcause;
reg  [`MXLEN-1:0] mtval;

function [`MXLEN-1:0] set_r_data;
input [11:0] r_csr_addr;
begin
    if (csr_read == 1'b1) begin
        if (exception == 1'b1) begin
            if (exception_num[`MXLEN-1] == 1'b1) begin
                set_r_data = mtvec + (4 * exception_num);
            end
            else begin
                set_r_data = mtvec;
            end
        end
        else if (mret == 1'b1) begin
            set_r_data = mepc;
        end
        else begin
            case (r_csr_addr)
                mstatus_addr: begin
                    set_r_data = mstatus;
                end
                mstatush_addr: begin
                    set_r_data = mstatush;
                end
                misa_addr: begin
                    set_r_data = misa;
                end
                mie_addr: begin
                    set_r_data = mie;
                end
                mtvec_addr: begin
                    set_r_data = mtvec;
                end
                mscratch_addr: begin
                    set_r_data = mscratch;
                end
                mepc_addr: begin
                    set_r_data = mepc;
                end
                mcause_addr: begin
                    set_r_data = mcause;
                end
                mtval_addr: begin
                    set_r_data = mtval;
                end
                mip_addr: begin
                    set_r_data = mip;
                end
            endcase
        end
    end
    else begin
        set_r_data = {`MXLEN{1'b0}};
    end
end
endfunction

assign r_data = set_r_data(csr_addr);

always @(posedge CLK) begin
    if (RST) begin
        cpm                     <= 2'b11;
        mstatus[3]              <= 1'b0;                      // mstatus.MIE  <= 1'b0;
        mstatus[17]             <= 1'b0;                      // mstatus.MPRV <= 1'b0;
        misa[`MXLEN-1:`MXLEN-2] <= 2'b01;                     // XLEN <= 32;
        misa[`MXLEN-3:26]       <= {`MXLEN-3-26+1{1'b1}};
        misa[25:0]              <= {13'd0, 1'b1, 4'd0, 8'd0}; // RV32IM
        mcause                  <= {1'b1, {`MXLEN-1{1'b0}}};  // Indicating the cause of the reset
    end
    else if (exception == 1'b1) begin
        mepc   <= pc_val;
        mcause <= exception_num;
        if (exception_num == 32'd1) begin       // Instruction access fault
            mtval <= pc_val;
        end
        else if (exception_num == 32'd2) begin  // Illegal instruction
            mtval <= instr;
        end
        else if (exception_num == 32'd0) begin  // Instruction address mialigned
            mtval <= pc_val;
        end
        else if (exception_num == 32'd6) begin  // Store/AMO address misaligned
            mtval <= alu_out;
        end
        else if (exception_num == 32'd4) begin  // Load address misaligned
            mtval <= alu_out;
        end
        else if (exception_num == 32'd7) begin  // Store/AMO access fault
            mtval <= alu_out;
        end
        else if (exception_num == 32'd5) begin  // Load access fault
            mtval <= alu_out;
        end
        else begin
            mtval <= 32'd0;
        end
        mstatus[7] <= mstatus[3];    // mstatus.MPIE <= mstatus.MIE;
        mstatus[3] <= 1'b0;          // mstatus.MIE  <= 1'b0;
        mstatus[12:11] <= cpm;
    end
    else if (mret == 1'b1) begin
        mstatus[3] <= mstatus[7];     // mstatus.MIE  <= mstatus.MPIE;
        cpm        <= mstatus[12:11];
    end
    else if (csr_write) begin
    end
end


endmodule
