# 8-bit ALU in Verilog

A fully functional 8-bit Arithmetic Logic Unit designed in Verilog HDL.
Simulated and verified using Icarus Verilog and GTKWave.

Built as Project 1 of my chip design portfolio.
Goal: GPU and AI accelerator chip design.

---

## What is an ALU

An ALU (Arithmetic Logic Unit) is the calculator inside every processor.
Every addition, comparison, and logic operation your CPU does goes through the ALU.
This 8-bit ALU supports 8 operations selected by a 3-bit op code.

---

## Operations

| op code | Operation    | Description               |
|---------|--------------|---------------------------|
| 000     | ADD          | a + b, outputs carry flag |
| 001     | SUB          | a - b, outputs borrow flag|
| 010     | AND          | bitwise AND               |
| 011     | OR           | bitwise OR                |
| 100     | XOR          | bitwise XOR               |
| 101     | NOT          | bitwise NOT of a          |
| 110     | Shift Left   | a shifted left by 1 bit   |
| 111     | Shift Right  | a shifted right by 1 bit  |

---

## Ports

| Port     | Width  | Direction | Description          |
|----------|--------|-----------|----------------------|
| a        | 8-bit  | input     | first operand        |
| b        | 8-bit  | input     | second operand       |
| op       | 3-bit  | input     | operation selector   |
| result   | 8-bit  | output    | operation result     |
| zero     | 1-bit  | output    | high when result = 0 |
| carry    | 1-bit  | output    | high on ADD overflow |
| borrow   | 1-bit  | output    | high when a < b      |

---

## Output Flags

- **Zero flag** — goes high when result is 0. Used by CPUs to implement if(a==b)
- **Carry flag** — goes high when ADD overflows. Example: 255 + 1 = 0, carry = 1
- **Borrow flag** — goes high when SUB goes negative. Example: 3 - 10, borrow = 1

---

## Resource Utilization (Yosys 0.52, generic synthesis)

| Metric        | Value |
|---------------|-------|
| Total cells   | 248   |
| Wires         | 244   |
| Inputs        | 19 bits |
| Outputs       | 11 bits |

| Cell Type  | Count |
|------------|-------|
| $_ANDNOT_  | 96    |
| $_OR_      | 68    |
| $_NOR_     | 26    |
| $_XOR_     | 12    |
| $_XNOR_   | 10    |
| $_ORNOT_   | 9     |
| $_MUX_     | 8     |
| $_AND_     | 7     |
| $_NOT_     | 6     |
| $_NAND_    | 6     |

---

## Project Structure
├── rtl/
│ └── alu.v # ALU design — combinational logic
├── tb/
│ └── tb_alu.v # Testbench — all 8 ops + edge cases
└── sim/ # Simulation output (gitignored)
---

## How to Simulate

Requirements: Icarus Verilog, GTKWave

```bash
# step 1 — compile design and testbench
iverilog -o sim/alu_sim rtl/alu.v tb/tb_alu.v

# step 2 — run simulation
./sim/alu_sim

# step 3 — view waveform
gtkwave sim/dump.vcd
```

---

## What I Learned

- How to write combinational logic in Verilog using case statements
- How carry and borrow flags work using 9-bit arithmetic
- How to write a testbench with manual and random test cases
- How to debug using GTKWave waveforms
- How to use Icarus Verilog on WSL

---

## About

Second year EEE student at IIITM Gwalior.
Targeting GPU and AI accelerator chip design.

Tools used: Verilog HDL, Icarus Verilog, GTKWave, Yosys, VS Code, WSL2
