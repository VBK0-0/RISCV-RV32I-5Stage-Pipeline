# RISCV-RV32I-5Stage-Pipeline
Design of 5-stage pipelined RISC-V processor (IF, ID, EX, MEM, WB) compliant with RV32I ISA

## Pipeline Datapath
<img width="1576" height="968" alt="image" src="https://github.com/user-attachments/assets/df21d6db-0cac-48fb-af70-de32828ae396" />
Source: MERL DSU

## Implemented Instruction Set (RV32I Subset)

This project implements a subset of the **RISC-V RV32I Instruction Set Architecture**, covering arithmetic, immediate, memory access, and branch instructions.

---

### R-Type Instructions

| Sl. No. | Address | Binary Instruction (32-bit) | Assembly | Description |
|--------|---------|-----------------------------|----------|-------------|
| 1 | 0x00000000 | 0000000 00010 00001 000 00011 0110011 | ADD x3, x1, x2 | Adds contents of x1 and x2 |
| 2 | 0x00000004 | 0100000 00010 00001 000 00011 0110011 | SUB x3, x1, x2 | Subtracts x2 from x1 |
| 3 | 0x00000008 | 0000000 00010 00001 111 00011 0110011 | AND x3, x1, x2 | Bitwise AND operation |
| 4 | 0x0000000C | 0000000 00010 00001 110 00011 0110011 | OR x3, x1, x2 | Bitwise OR operation |
| 5 | 0x00000010 | 0000000 00010 00001 010 00011 0110011 | SLT x3, x1, x2 | Set x3 = 1 if x1 < x2 (signed) |

---

### I-Type Instructions

| Sl. No. | Address | Binary Instruction (32-bit) | Assembly | Description |
|--------|---------|-----------------------------|----------|-------------|
| 6 | 0x00000014 | 000000000101 00001 000 00011 0010011 | ADDI x3, x1, 5 | Adds immediate value to x1 |
| 7 | 0x00000018 | 000000000101 00001 111 00011 0010011 | ANDI x3, x1, 5 | Bitwise AND with immediate |
| 8 | 0x0000001C | 000000000101 00001 110 00011 0010011 | ORI x3, x1, 5 | Bitwise OR with immediate |
| 9 | 0x00000020 | 000000000101 00001 010 00011 0010011 | Set x3 = 1 if x1 < immediate |

---

### Load and Store Instructions

| Sl. No. | Address | Binary Instruction (32-bit) | Assembly | Description |
|--------|---------|-----------------------------|----------|-------------|
| 10 | 0x00000024 | 000000000000 00001 010 00011 0000011 | LW x3, 0(x1) | Load word from memory |
| 11 | 0x00000028 | 0000000 00011 00001 010 00000 0100011 | SW x3, 0(x1) | Store word to memory |

---

### Branch Instruction

| Sl. No. | Address | Binary Instruction (32-bit) | Assembly | Description |
|--------|---------|-----------------------------|----------|-------------|
| 12 | 0x0000002C | 0000000 00010 00001 000 00000 1100011 | BEQ x1, x2, label | Branch if x1 equals x2 |

---

### Instruction Coverage Summary

- **R-Type**: ADD, SUB, AND, OR, SLT  
- **I-Type**: ADDI, ANDI, ORI, SLTI  
- **Memory**: LW, SW  
- **Branch**: BEQ  

---

### Notes

- Architecture: RV32I (subset)
- Pipeline: 5-stage (IF, ID, EX, MEM, WB)
- No support for jumps, shifts, or CSR instructions
- Designed for educational and academic use only
