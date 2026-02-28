# 5-Stage Pipelined RISC-V Processor (RV32I)

---

# Introduction to RISC-V ISA

## What is RISC-V?

RISC-V (pronounced *risk-five*) is an open-standard Instruction Set Architecture (ISA) based on Reduced Instruction Set Computing (RISC) principles. Unlike proprietary ISAs, RISC-V is free and open, enabling researchers, students, and industries to design and implement custom processors without licensing restrictions.

RISC-V defines the instruction set but does not define how the processor must be implemented. Therefore, it supports multiple microarchitectures such as:

- Single-cycle processors  
- Multi-cycle processors  
- 5-stage pipelined processors  
- Superscalar processors  
- Out-of-order processors  

This project implements a **5-stage pipelined processor based on the RV32I base integer ISA**.

---

# RV32I Base Integer Instruction Set

RV32I is the 32-bit base integer instruction set of RISC-V. It includes:

- 32 General Purpose Registers (x0–x31)
- Fixed 32-bit instruction length
- Load/store architecture
- Orthogonal and simple instruction formats

---

## Register File

| Register | ABI Name | Description |
|----------|----------|-------------|
| x0 | zero | Hardwired to 0 |
| x1 | ra | Return address |
| x2 | sp | Stack pointer |
| x3 | gp | Global pointer |
| x4 | tp | Thread pointer |
| x5–x7 | t0–t2 | Temporaries |
| x8 | s0/fp | Saved register / Frame pointer |
| x9 | s1 | Saved register |
| x10–x17 | a0–a7 | Function arguments |
| x18–x27 | s2–s11 | Saved registers |
| x28–x31 | t3–t6 | Temporaries |

---

# RISC-V Instruction Formats 

## R-Type Format (Register-Register)

```
| funct7 | rs2 | rs1 | funct3 | rd | opcode |
```

| Field  | Width (bits) |
|---------|-------------|
| funct7 | 7 |
| rs2 | 5 |
| rs1 | 5 |
| funct3 | 3 |
| rd | 5 |
| opcode | 7 |

---

## I-Type Format (Immediate & Loads)

```
| imm[11:0] | rs1 | funct3 | rd | opcode |
```

---

## S-Type Format (Store)

```
| imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode |
```

---

## B-Type Format (Branch)

```
| imm[12|10:5] | rs2 | rs1 | funct3 | imm[4:1|11] | opcode |
```

---

## U-Type Format (Upper Immediate)

```
| imm[31:12] | rd | opcode |
```

---

## J-Type Format (Jump)

```
| imm[20|10:1|11|19:12] | rd | opcode |
```

---

# RV32I Instruction Table # ##(A sub-set of the Base Integer Instructions set)##

## R-Type Instructions

| Instruction | funct7 | funct3 | Opcode | Operation |
|-------------|--------|--------|--------|-----------|
| add | 0000000 | 000 | 0110011 | rd = rs1 + rs2 |
| sub | 0100000 | 000 | 0110011 | rd = rs1 − rs2 |
| and | 0000000 | 111 | 0110011 | rd = rs1 & rs2 |
| or  | 0000000 | 110 | 0110011 | rd = rs1 \| rs2 |
| slt | 0000000 | 010 | 0110011 | rd = (rs1 < rs2) |

---

## I-Type Instructions

| Instruction | funct3 | Opcode | Operation |
|-------------|--------|--------|-----------|
| addi | 000 | 0010011 | rd = rs1 + imm |
| andi | 111 | 0010011 | rd = rs1 & imm |
| ori  | 110 | 0010011 | rd = rs1 \| imm |
| lw   | 010 | 0000011 | rd = Mem[rs1 + imm] |

---

## S-Type Instructions

| Instruction | funct3 | Opcode | Operation |
|-------------|--------|--------|-----------|
| sw | 010 | 0100011 | Mem[rs1 + imm] = rs2 |

---

## B-Type Instructions

| Instruction | funct3 | Opcode | Operation |
|-------------|--------|--------|-----------|
| beq | 000 | 1100011 | if (rs1 == rs2) branch |
| bne | 001 | 1100011 | if (rs1 != rs2) branch |

---

# Project: 5-Stage Pipelined RISC-V Processor

## Project Objective

To design and implement a complete **5-stage pipelined RV32I processor** with hazard detection and forwarding mechanisms.

Pipeline Structure:

```
IF → ID → EX → MEM → WB
```

---

# Pipeline Stages

## 1. Instruction Fetch (IF)

- Program Counter (PC)
- Instruction Memory
- PC + 4 Adder
- Branch Target MUX

---

## 2. Instruction Decode (ID)

- Control Unit
- Register File (32 × 32-bit)
- Immediate Generator
- Branch Comparator

---

## 3. Execute (EX)

- ALU Control Unit
- Arithmetic Logic Unit (ALU)
- ALU Source MUX
- Branch Target Adder

---

## 4. Memory Access (MEM)

- Data Memory

---

## 5. Write Back (WB)

- Writeback MUX
- Register File Write Port

---

# Hazard Handling

## Data Hazards (Forwarding Unit)

| Condition | ForwardA / ForwardB |
|------------|---------------------|
| EX/MEM.rd == ID/EX.rs | 10 |
| MEM/WB.rd == ID/EX.rs | 01 |
| Otherwise | 00 |

---

## Load-Use Hazard

Detected when:

```
ID_EX.MemRead == 1
AND
(ID_EX.rd == IF_ID.rs1 OR IF_ID.rs2)
```

Action Taken:
- Stall PC
- Stall IF/ID register
- Insert bubble in ID/EX

---

## Control Hazard

If branch is taken:
- Flush IF/ID register
- Update PC with branch target

---

# Verification Programs

| Program | Purpose |
|----------|----------|
| program_all.hex | Tests all instruction types |
| program_no_hazard.hex | Ideal pipeline execution |
| program_data_hazard.hex | Forwarding verification |
| program_load_hazard.hex | Stall verification |
| program_branch_taken.hex | Branch flush validation |
| program_branch_not_taken.hex | Fall-through verification |
| program_full_stress.hex | Combined hazard testing |

---

# Performance Analysis

- Ideal CPI ≈ 1 (after pipeline fill)
- Load-use hazard introduces 1 stall cycle
- Branch taken introduces 1 flush cycle
- Forwarding reduces unnecessary stalls

---

# Simulation Environment

- Tool: Xilinx Vivado
- Simulation Type: Behavioral Simulation
- Observed Signals:
  - PC
  - Instruction
  - ALU Result
  - MemRead / MemWrite
  - ForwardA / ForwardB
  - Stall
  - Flush
  - Writeback Data

---

# Conclusion

This project demonstrates a complete implementation of a 5-stage pipelined RV32I processor with accurate hazard detection, forwarding logic, and branch handling. The design adheres strictly to RISC-V ISA specifications and verifies correct pipeline behavior across multiple hazard scenarios.

---

# Author

VBK  
M.Tech – RISC-V Pipeline Design Project
