`include "defs.v"


module BRANCHCTRL (
    input  wire [2:0] ctrl_br_ops,
    input  wire [1:0] alu_br_ops,
    input  wire [`MXLEN-1:0] incpc_out,
    input  wire [`MXLEN-1:0] br_tgt_target,
    output wire [`MXLEN-1:0] pc_addr
    );

    assign pc_addr = set_pc_addr(ctrl_br_ops,
                                 alu_br_ops,
                                 incpc_out,
                                 br_tgt_target);

    function [`MXLEN-1:0] set_pc_addr;
        input [2:0] ctrl_ops;
        input [1:0] alu_ops;
        input [`MXLEN-1:0] incpc;
        input [`MXLEN-1:0] br_target;
        begin
            (* full_case *)
            case (ctrl_ops)
                `FUNCT_EQ:
                    if (alu_ops == `ALU_BR_EQ)
                        set_pc_addr = br_target;
                    else
                        set_pc_addr = incpc;
                `FUNCT_NE:
                    if (alu_ops != `ALU_BR_EQ)
                        set_pc_addr = br_target;
                    else
                        set_pc_addr = incpc;
                `FUNCT_LT:
                    if (alu_ops == `ALU_BR_LT)
                        set_pc_addr = br_target;
                    else
                        set_pc_addr = incpc;
                `FUNCT_GE:
                    if (alu_ops == `ALU_BR_GT || alu_ops == `ALU_BR_EQ)
                        set_pc_addr = br_target;
                    else
                        set_pc_addr = incpc;
                `FUNCT_LTU:
                    if (alu_ops == `ALU_BR_LT)
                        set_pc_addr = br_target;
                    else
                        set_pc_addr = incpc;
                `FUNCT_GEU:
                    if (alu_ops == `ALU_BR_GT || alu_ops == `ALU_BR_EQ)
                        set_pc_addr = br_target;
                    else
                        set_pc_addr = incpc;
                `NO_BRANCH:
                    set_pc_addr = incpc;
            endcase
        end
    endfunction
endmodule
