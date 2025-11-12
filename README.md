# Pattern Search Processor

### Authors
- Chung Lai Lee (z5210146)
- Yijie Zhao (z5270589)

---

## 1. Overview
This project implements a custom pattern search processor designed on an FPGA-based MPSoC platform.  
The processor uses a 32-bit instruction set and 16-bit data paths to perform efficient text pattern searching.  
It supports loading pattern data, input strings, and computing pattern occurrences through custom-designed instructions.  
The design demonstrates hardware–software co-design using VHDL in Vivado, achieving accurate pattern matching with a balance between simplicity and efficiency.

---

## 2. System Architecture
- **Instruction Size:** 32 bits  
- **Data Width:** 16 bits  
- **Registers:** 32 general-purpose 16-bit registers  
  - $0–$15: Control and variable registers  
  - $16–$31: Input string storage  
- **Instruction Memory:** 256 instructions (8-bit address space)  
- **Memory Components:**  
  - **PA:** Pattern Character Array  
  - **LA:** Pattern Length Array  
  - **OA:** Pattern Occurrence Array  

The MEM stage handles all memory-related operations, including storing and loading pattern data.  
A translation unit determines memory offsets, and the PNReg (Pattern Number Register) identifies which pattern to load for searching.

---

## 3. Instruction Set Architecture (ISA)

| Instruction | Description |
|--------------|-------------|
| **BNE R1 R2 imm** | Branch if R1 ≠ R2 |
| **ADD R1 R2 R3** | R3 ← R1 + R2 |
| **SOW R1 R2 imm** | Store occurrence: OA[R1+imm] ← R2 |
| **LOW R1 R2 imm** | Load occurrence: R2 ← OA[R1+imm] |
| **STB R1 X X** | Set PNReg = R1 |
| **LPA R1 R2 R3** | Load pattern from PA[offset + R2], auto-increment index |
| **LLA R1 R2 R3** | Load pattern length from LA |
| **LOA R1 R2 R3** | Load occurrence array from OA |
| **MVI R1 X R2** | Move value from reg_file[R1] to R2 |
| **END** | Halt execution |
| **JP X X imm** | Jump to PC + 1 + imm |

These custom instructions allow efficient control of pattern data loading, occurrence tracking, and conditional branching within the FPGA pipeline.

---

## 4. Register Summary

| Register | Purpose |
|-----------|----------|
| $0 | Constant 0 |
| $1 | Constant 1 |
| $2 | Constant -1 |
| $3 | Processed characters count |
| $4 | Current pattern character |
| $5 | Current pattern length |
| $6 | Current pattern number |
| $7 | Current pattern offset |
| $8 | Input base offset |
| $9 | Total number of patterns |
| $10 | Input string length |
| $11 | Base address of input string |
| $12 | Current input index |
| $13 | Current input character |
| $14 | Wildcard character (?) |
| $15 | Pattern occurrence count |
| $16–$31 | Input string storage |

The register configuration allows efficient management of both control logic and data storage within a compact hardware structure.

---

## 5. Search Logic and Data Flow
The processor executes text pattern searching through iterative loading and comparison of characters stored in PA and LA arrays.  
Each iteration loads a character via `LPA`, compares it with the corresponding input data, and records results using `SOW` and `LOW`.  
The `PNReg` defines which pattern to access, and the occurrence adder counts matched patterns.  
This design enables controlled sequential access and simplified hardware state transitions.

---

## 6. Design Notes
- The **translation unit** and **PNReg** manage pattern memory access and indexing.  
- **Instruction address translation** supports multiple function sequences such as input loading, pattern storage, and search.  
- **Forwarding and stalling** mechanisms were not implemented for `MVI`, requiring manual insertion of NOPs.  
- The software-based matching design trades off hardware complexity for simpler control flow.  
- Optimization could include implementing forwarding or hazard detection logic to reduce stall cycles.

---

## 7. Performance Metrics

| Metric | Value |
|--------|--------|
| Maximum Frequency | 82.8 MHz |
| LUT Utilization | 1.78% |
| FF Utilization | 0.74% |
| IO Utilization | 21.18% |

Although the achieved frequency is relatively high, system performance mainly depends on pattern length and matching complexity rather than raw clock rate.  
The design demonstrates efficient logic utilization and functional correctness within a constrained FPGA environment.

---

## 8. Example and Project Information
The following sequence demonstrates the main flow of loading pattern data, counting matches, and storing results:

LLA $9, $6, $5 # Load pattern length

LPA $5, $3, $4 # Load next pattern character

ADD $3, $1, $3 # Increment character count

SOW $6, $15, -1 # Store occurrence count

END


**Vivado Project Information**  
- **Project Name:** PatternSearchProcessor_COMP3211  
- **Language:** VHDL  
- **Target Platform:** FPGA-based MPSoC (Zynq Series)  
- **Design Tool:** Xilinx Vivado  
- **Top-Level Modules:** Control Unit, Datapath, Memory Units, Instruction Decoder, Register File  

---

## 9. Summary
This project successfully implements a custom pattern search processor using an FPGA-based MPSoC system.  
It integrates custom instruction design, pipeline structure, and memory management to execute pattern matching efficiently.  
The architecture prioritizes simplicity and flexibility, serving as a practical example of hardware–software co-design and embedded system development.

For detailed design diagrams, timing analysis, and implementation results, please refer to [COMP 3211 Final Report.pdf](https://github.com/user-attachments/files/23490879/COMP.3211.Final.Report.pdf)


