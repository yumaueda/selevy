`include "defs.v"


module DECODER
#(
    parameter [ 6:0] OPCODE_I      = 7'b0000011,
    parameter [ 6:0] OPCODE_IR     = 7'b0010011,
    parameter [ 6:0] OPCODE_S      = 7'b0100011,
    parameter [ 6:0] OPCODE_R      = 7'b0110011,
    parameter [ 6:0] OPCODE_B      = 7'b1100011,
    parameter [ 6:0] OPCODE_SYS    = 7'b1110011,
    parameter [ 2:0] F3_ADDSUBMUL  = 3'b000,
    parameter [ 2:0] F3_SLLMULH    = 3'b001,
    parameter [ 2:0] F3_SLTMULHSU  = 3'b010,
    parameter [ 2:0] F3_SLTUMULHU  = 3'b011,
    parameter [ 2:0] F3_XORDIV     = 3'b100,
    parameter [ 2:0] F3_SRLSRADIVU = 3'b101,
    parameter [ 2:0] F3_ORREM      = 3'b110,
    parameter [ 2:0] F3_ANDREMU    = 3'b111,
    parameter [ 2:0] F3_ADDI       = 3'b000,
    parameter [ 2:0] F3_SLLI       = 3'b001,
    parameter [ 2:0] F3_SLTI       = 3'b010,
    parameter [ 2:0] F3_SLTIU      = 3'b011,
    parameter [ 2:0] F3_XORI       = 3'b100,
    parameter [ 2:0] F3_SRLAI      = 3'b101,
    parameter [ 2:0] F3_ORI        = 3'b110,
    parameter [ 2:0] F3_ANDI       = 3'b111,
    parameter [ 2:0] F3_CSRRW      = 3'b001,
    parameter [ 2:0] F3_CSRRS      = 3'b010,
    parameter [ 2:0] F3_CSRRC      = 3'b011,
    parameter [ 2:0] F3_CSRRWI     = 3'b101,
    parameter [ 2:0] F3_CSRRSI     = 3'b110,
    parameter [ 2:0] F3_CSRRCI     = 3'b111
)
(
    // FROM_ROM
    input  wire [`MXLEN-1:0] instr,
    // ALU
    output reg  [ 4:0]       alu_ops,
    output reg               src_imm,
    // PCUNIT
    output reg               branch,
    output reg  [ 2:0]       pcunit_ops,
    // IMM_EXTENDED
    output reg  [`MXLEN-1:0] imm_extended,
    // RAM
    output reg               load,
    output reg  [ 2:0]       load_ops,
    output reg               store,
    output reg  [ 2:0]       store_ops,
    // REGFILE
    output reg               reg_write,
    // CSR
    output reg               mret,
    output reg               csr_read,
    output reg               csr_write,
    // TRAPHDLR
    output reg               illegal_i,
    output reg               ecall_m
);

wire [ 6:0] opcode;
wire [ 2:0] funct3;
wire [ 7:0] funct7;
wire [ 4:0] rd;
wire [ 4:0] rs1;
wire [ 4:0] rs2;
wire [24:0] imm;

assign opcode = instr[ 6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];
assign rd     = instr[11:7];
assign rs1    = instr[19:15];
assign rs2    = instr[24:20];
assign imm    = instr[31:7];

always @(instr) begin
    pcunit_ops               <= funct3;
    load_ops                 <= funct3;
    store_ops                <= funct3;

    case (opcode)
        OPCODE_I: begin
            alu_ops                   <= `ALU_ADD;
            src_imm                   <= 1'b1;
            branch                    <= 1'b0;
            imm_extended[`MXLEN-1]    <= imm[24];
            imm_extended[`MXLEN-2:11] <= {20{1'b0}};
            imm_extended[10:0]        <= imm[23:13];
            store                     <= 1'b0;
            if (funct3==3'b011 || funct3>3'b101) begin
                load      <= 1'b0;
                reg_write <= 1'b0;
                illegal_i <= 1'b1;
            end
            else begin
                load      <= 1'b1;
                reg_write <= 1'b1;
                illegal_i <= 1'b0;
            end
            mret      <= 1'b0;
            csr_write <= 1'b0;
            csr_read  <= 1'b0;
            ecall_m   <= 1'b0;
        end
        OPCODE_IR: begin
            case (funct3)
                F3_ADDI: begin
                    alu_ops <= `ALU_ADD;
                end
                F3_SLLI: begin
                    alu_ops <= `ALU_SLL;
                end
                F3_SLTI: begin
                    alu_ops <= `ALU_SLT;
                end
                F3_SLTIU: begin
                    alu_ops <= `ALU_SLTU;
                end
                F3_XORI: begin
                    alu_ops <= `ALU_XOR;
                end
                F3_SRLAI: begin
                    case (funct7[5])
                        1'b0: begin
                            alu_ops <= `ALU_SRL;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_SRA;
                        end
                    endcase
                end
                F3_ORI: begin
                    alu_ops <= `ALU_OR;
                end
                F3_ANDI: begin
                    alu_ops <= `ALU_AND;
                end
            endcase
            src_imm                   <= 1'b1;
            branch                    <= 1'b0;
            imm_extended[`MXLEN-1]    <= imm[24];
            imm_extended[`MXLEN-2:11] <= {20{1'b0}};
            imm_extended[10:0]        <= imm[23:13];
            load                      <= 1'b0;
            store                     <= 1'b0;
            reg_write                 <= 1'b1;
            illegal_i                 <= 1'b0;
            mret      <= 1'b0;
            csr_write <= 1'b0;
            csr_read  <= 1'b0;
            ecall_m   <= 1'b0;
        end
        OPCODE_S: begin
            alu_ops                   <= `ALU_ADD;
            src_imm                   <= 1'b1;
            branch                    <= 1'b0;
            imm_extended[`MXLEN-1]    <= imm[24];
            imm_extended[`MXLEN-2:11] <= {20{1'b0}};
            imm_extended[10:0]        <= {imm[23:18], imm[ 4:0]};
            load                      <= 1'b0;
            store                     <= 1'b1;
            reg_write                 <= 1'b0;
            if (funct3 > 3'b010) begin
                illegal_i <= 1'b1;
            end
            else begin
                illegal_i <= 1'b0;
            end
            mret      <= 1'b0;
            csr_write <= 1'b0;
            csr_read  <= 1'b0;
            ecall_m   <= 1'b0;
        end
        OPCODE_R: begin
            case (funct3)
                F3_ADDSUBMUL: begin
                    case (funct7[0])
                        1'b0: begin
                            case (funct7[5])
                                1'b0: alu_ops <= `ALU_ADD;
                                1'b1: alu_ops <= `ALU_SUB;
                            endcase
                        end
                        1'b1: begin
                            alu_ops <= `ALU_MUL;
                        end
                    endcase
                end
                F3_SLLMULH: begin
                    case (funct7[0])
                        1'b0: begin
                            alu_ops <= `ALU_SLL;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_MULH;
                        end
                    endcase
                end
                F3_SLTMULHSU: begin
                    case (funct7[0])
                        1'b0: begin
                            alu_ops <= `ALU_SLT;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_MULHSU;
                        end
                    endcase
                end
                F3_SLTUMULHU: begin
                    case (funct7[0])
                        1'b0: begin
                            alu_ops <= `ALU_SLTU;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_MULHSU;
                        end
                    endcase
                end
                F3_XORDIV: begin
                    case (funct7[0])
                        1'b0: begin
                            alu_ops <= `ALU_XOR;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_DIV;
                        end
                    endcase
                end
                F3_SRLSRADIVU: begin
                    case (funct7[0])
                        1'b0: begin
                            case (funct7[5])
                                1'b0: alu_ops <= `ALU_SRL;
                                1'b1: alu_ops <= `ALU_SRA;
                            endcase
                        end
                        1'b1:  begin
                            alu_ops <= `ALU_DIVU;
                        end
                    endcase
                end
                F3_ORREM: begin
                    case (funct7[0])
                        1'b0: begin
                            alu_ops <= `ALU_OR;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_REM;
                        end
                    endcase
                end
                F3_ANDREMU: begin
                    case (funct7[0])
                        1'b0: begin
                            alu_ops <= `ALU_AND;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_REMU;
                        end
                    endcase
                end
            endcase
            src_imm                   <= 1'b0;
            branch                    <= 1'b0;
            imm_extended[`MXLEN-1]    <= imm[24];
            imm_extended[`MXLEN-2:11] <= {20{1'b0}};
            imm_extended[10:0]        <= imm[23:13];
            load                      <= 1'b0;
            store                     <= 1'b0;
            reg_write                 <= 1'b1;
            illegal_i                 <= 1'b0;
            mret      <= 1'b0;
            csr_write <= 1'b0;
            csr_read  <= 1'b0;
            ecall_m   <= 1'b0;
        end
        OPCODE_B: begin
            if (funct3==`F3_BLTU || funct3==`F3_BGEU) begin
                alu_ops   <= `ALU_SUB;
                illegal_i <= 1'b0;
            end
            else if (funct3==`F3_BEQ || funct3==`F3_BNE || funct3==`F3_BLT || funct3==`F3_BGE) begin
                alu_ops   <= `ALU_SUB_S;
                illegal_i <= 1'b0;
            end
            else begin
                alu_ops   <= `ALU_SUB; // alu_ops cannot be an unexpected value
                illegal_i <= 1'b1;
            end
            src_imm                   <= 1'b0;
            branch                    <= 1'b1;
            imm_extended[`MXLEN-1]    <= imm[24];
            imm_extended[`MXLEN-2:12] <= {19{1'b0}};
            imm_extended[11:0]        <= {imm[0], imm[23:18], imm[ 4:1], 1'b0};
            load                      <= 1'b0;
            store                     <= 1'b0;
            reg_write                 <= 1'b0;
            mret                      <= 1'b0;
            csr_write                 <= 1'b0;
            csr_read                  <= 1'b0;
            ecall_m                   <= 1'b0;
        end
        OPCODE_SYS: begin
            // TODO: Validate the CSRs' address and raise an illegal instruction
            // exception if found the one invalid.
            if (funct3>=3'd1 && funct3<=3'd3) begin // CSRRW/S/C
                if (funct3==3'd1) begin
                    alu_ops <= `ALU_CSRRW;
                end
                else begin
                    alu_ops <= `ALU_AND;
                end
                src_imm   <= 1'b0;
                reg_write <= (rd==5'd0)? 1'b0 : 1'b1;
                csr_write <= (rs1==5'd0)? 1'b0 : 1'b1;
                csr_read  <= 1'b1;
                mret      <= 1'b0;
                illegal_i <= 1'b0;
                ecall_m   <= 1'b0;
            end
            else if (funct3>=3'd5 && funct3<=3'd7) begin // CSRR{W/S/C}I
                if (funct3==3'd5) begin
                    alu_ops <= `ALU_CSRRW;
                end
                else begin
                    alu_ops   <= `ALU_AND;
                end
                src_imm   <= 1'b1;
                reg_write <= (rd==5'd0)? 1'b0 : 1'b1;
                csr_write <= (rs1==5'd0)? 1'b0 : 1'b1;
                csr_read  <= 1'b1;
                mret      <= 1'b0;
                illegal_i <= 1'b0;
                ecall_m   <= 1'b0;
            end
            else if (funct3 == 3'd0) begin // ECALL, MRET
                alu_ops   <= `ALU_AND; // cannot be an unexpected value
                src_imm   <= 1'b0;
                reg_write <= 1'b0;
                if (instr[`MXLEN-1:7] == 25'd0) begin // ECALL
                    mret      <= 1'b0;
                    illegal_i <= 1'b0;
                    ecall_m   <= 1'b1;
                end
                else if (instr[`MXLEN-1:25]==7'b0011000 && rs2==5'b00010) begin // MRET
                    mret      <= 1'b1;
                    illegal_i <= 1'b0;
                    ecall_m   <= 1'b1;
                end
                else begin // EREAK is currently not implemented
                    mret      <= 1'b0;
                    illegal_i <= 1'b1;
                    ecall_m   <= 1'b0;
                end
                csr_write <= 1'b0;
                csr_read  <= 1'b0;
            end
            else begin // funct3==3'd4
                alu_ops   <= `ALU_AND; // cannnot be an unexpected value
                src_imm   <= 1'b0;
                reg_write <= 1'b0;
                mret      <= 1'b0;
                csr_write <= 1'b0;
                csr_read  <= 1'b0;
                illegal_i <= 1'b1;
                ecall_m   <= 1'b0;
            end
            branch                   <= 1'b0;
            imm_extended[`MXLEN-1:5] <= {`MXLEN-5{1'b0}};
            imm_extended[ 4:0]       <= imm[12:8];
            load                     <= 1'b0;
            store                    <= 1'b0;
        end
        default: begin
            alu_ops                  <= `ALU_CSRRW; // cannot be an unexpected value
            src_imm                  <= 1'b0;
            branch                   <= 1'b0;
            imm_extended[`MXLEN-1:0] <= {`MXLEN{1'b0}};
            load                     <= 1'b0;
            store                    <= 1'b0;
            reg_write                <= 1'b0;
            mret                     <= 1'b0;
            csr_write                <= 1'b0;
            csr_read                 <= 1'b0;
            illegal_i                <= 1'b1;
            ecall_m                  <= 1'b0;
        end
    endcase
end
endmodule
