# Selevy

Selevy is extremely simple implementation of a sigle-cycle RISC-V CPU in Verilog. Currently only a subset of the RV32IM is implemented.

## License

This program follows [BSD 2-clause License](./LICENSE.txt).

## Currently available instructions

### RV32I

| Type | Instruction |
| ---- | ----------- |
| B    | BEQ         |
| B    | BNE         |
| B    | BLT         |
| B    | BGE         |
| B    | BLTU        |
| B    | BGEU        |
| I    | LB          |
| I    | LW          |
| I    | LBU         |
| I    | LHU         |
| I    | ADDI        |
| I    | SLTI        |
| I    | SLTIU       |
| I    | XORI        |
| I    | ORI         |
| I    | ANDI        |
| I    | SLLI        |
| I    | SRLI        |
| I    | SRAI        |
| S    | SB          |
| S    | SH          |
| S    | SW          |
| R    | ADD         |
| R    | SUB         |
| R    | SLL         |
| R    | SLT         |
| R    | SLTU        |
| R    | XOR         |
| R    | SRL         |
| R    | SRA         |
| R    | OR          |
| R    | AND         |
| R    | XOR         |

### RV32M

| Type | Instruction |
| ---- | ----------- |
| R    | MUL         |
| R    | MULH        |
| R    | MULHSU      |
| R    | MULHU       |
| R    | DIV         |
| R    | DIVU        |
| R    | REM         |
| R    | REMU        |
