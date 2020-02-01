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
    parameter [ 2:0] F3_ORI        = 3'b111
)
(
    // FROM_ROM
    input  wire [ 6:0]       opcode,
    input  wire [ 2:0]       funct3,
    input  wire [ 6:0]       funct7,
    input  wire [24:0]       imm,    // instr[31:7]
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
    output reg               reg_write
);

always @(opcode, funct3, funct7) begin
    pcunit_ops               <= funct3;
    imm_extended[`MXLEN-1]   <= imm[24];
    load_ops                 <= funct3;
    store_ops                <= funct3;

    case (opcode)
        OPCODE_I: begin
            alu_ops                   <= `ALU_ADD;
            src_imm                   <= 1'b1;
            branch                    <= 1'b0;
            imm_extended[`MXLEN-2:11] <= {20{1'b0}};
            imm_extended[10:0]        <= imm[23:13];
            load                      <= 1'b1;
            store                     <= 1'b0;
            reg_write                 <= 1'b1;
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
            endcase
            src_imm                   <= 1'b1;
            branch                    <= 1'b0;
            imm_extended[`MXLEN-2:11] <= {20{1'b0}};
            imm_extended[10:0]        <= imm[23:13];
            load                      <= 1'b0;
            store                     <= 1'b0;
            reg_write                 <= 1'b1;
        end
        OPCODE_S: begin
            alu_ops                   <= `ALU_ADD;
            src_imm                   <= 1'b1;
            branch                    <= 1'b0;
            imm_extended[`MXLEN-2:11] <= {20{1'b0}};
            imm_extended[10:0]        <= {imm[23:18], imm[ 4:0]};
            load                      <= 1'b0;
            store                     <= 1'b1;
            reg_write                 <= 1'b0;
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
                            src_imm <= 1'b1;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_MUL;
                            src_imm <= 1'b0;
                        end
                    endcase
                end
                F3_SLLMULH: begin
                    case (funct7[0])
                        1'b0: begin
                            alu_ops <= `ALU_SLL;
                            src_imm <= 1'b1;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_MULH;
                            src_imm <= 1'b0;
                        end
                    endcase
                end
                F3_XORDIV: begin
                    case (funct7[0])
                        1'b0: begin
                            alu_ops <= `ALU_XOR;
                            src_imm <= 1'b1;
                        end
                        1'b1: begin
                            alu_ops <= `ALU_DIV;
                            src_imm <= 1'b0;
                        end
                    endcase
                end
                `F3_SRLSRADIVU: begin
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
                `F3_ORREM: begin
                    alu_ops <= `ALU_OR;
                end
                `F3_ANDREMU: begin
                    alu_ops <= `ALU_AND;
                end
            endcase
            branch                    <= 1'b0;
            imm_extended[`MXLEN-2:11] <= {20{1'b0}};
            imm_extended[10:0]        <= imm[23:13];
            load                      <= 1'b0;
            store                     <= 1'b0;
            reg_write                 <= 1'b1;
        end
        OPCODE_B: begin
            if (funct3 == `F3_BLTU || funct3 == `F3_BGEU) begin
                alu_ops <= `ALU_SUB;
            end
            else begin
                alu_ops <= `ALU_SUB_S;
            end
            branch                    <= 1'b1;
            imm_extended[`MXLEN-2:12] <= {19{1'b0}};
            imm_extended[11:1]        <= {imm[0], imm[23:18], imm[ 4:1]};
            load                      <= 1'b0;
            store                     <= 1'b0;
            reg_write                 <= 1'b0;
        end
    endcase
end
endmodule
