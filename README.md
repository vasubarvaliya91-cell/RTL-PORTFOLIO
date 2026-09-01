# Verilog Chip Design Portfolio

Second year EEE student at IIITM Gwalior.  
Targeting GPU and AI accelerator chip design.  
Tools: Verilog HDL · Icarus Verilog · GTKWave · Yosys · VS Code · WSL2

---

## Projects

| # | Project | Status |
|---|---------|--------|
| 1 | 8-bit ALU | ✅ Complete |
| 2 | UART Transmitter | ✅ Complete |
| 3 | UART Receiver | ✅ Complete |

---

## Project 1 — 8-bit ALU

A fully functional 8-bit Arithmetic Logic Unit designed in Verilog HDL.  
Simulated and verified using Icarus Verilog and GTKWave.

### Operations

| Opcode | Operation   | Description                |
|--------|-------------|----------------------------|
| 000    | ADD         | a + b, outputs carry flag  |
| 001    | SUB         | a - b, outputs borrow flag |
| 010    | AND         | bitwise AND                |
| 011    | OR          | bitwise OR                 |
| 100    | XOR         | bitwise XOR                |
| 101    | NOT         | bitwise NOT of a           |
| 110    | Shift Left  | a shifted left by 1 bit    |
| 111    | Shift Right | a shifted right by 1 bit   |

### Ports

| Port   | Width | Direction | Description          |
|--------|-------|-----------|----------------------|
| a      | 8-bit | input     | first operand        |
| b      | 8-bit | input     | second operand       |
| op     | 3-bit | input     | operation selector   |
| result | 8-bit | output    | operation result     |
| zero   | 1-bit | output    | high when result = 0 |
| carry  | 1-bit | output    | high on ADD overflow |
| borrow | 1-bit | output    | high when a < b      |

### Output Flags

- **Zero flag** — goes high when result is 0. Used by CPUs to implement if(a==b)
- **Carry flag** — goes high when ADD overflows. Example: 255 + 1 = 0, carry = 1
- **Borrow flag** — goes high when SUB goes negative. Example: 3 - 10, borrow = 1

### Resource Utilization (Yosys 0.52, generic synthesis)

| Metric      | Value   |
|-------------|---------|
| Total cells | 248     |
| Wires       | 244     |
| Inputs      | 19 bits |
| Outputs     | 11 bits |
| Flip Flops  | 0 (purely combinational) |

| Cell Type  | Count |
|------------|-------|
| $_ANDNOT_  | 96    |
| $_OR_      | 68    |
| $_NOR_     | 26    |
| $_XOR_     | 12    |
| $_XNOR_    | 10    |
| $_ORNOT_   | 9     |
| $_MUX_     | 8     |
| $_AND_     | 7     |
| $_NOT_     | 6     |
| $_NAND_    | 6     |

### How to Simulate

```bash
iverilog -o sim/alu_sim alu_module/rtl/alu.v alu_module/tb/tb_alu.v
./sim/alu_sim
gtkwave sim/dump.vcd
```

---

## Project 2 — UART Transmitter

FSM-based UART transmitter. Takes an 8-bit parallel byte and sends it serially one bit at a time.

### How it works

- 4 states: IDLE → START → DATA → STOP → IDLE
- Sends LSB first (standard UART convention)
- Start bit = LOW, Stop bit = HIGH, Idle = HIGH
- Baud rate configurable via `CLKS_PER_BIT` parameter (default 9600 @ 50MHz)
- `done` pulses HIGH for one clock cycle when transmission completes

### Ports

| Port     | Width | Direction | Description              |
|----------|-------|-----------|--------------------------|
| clk      | 1-bit | input     | system clock             |
| rst_n    | 1-bit | input     | active low reset         |
| tx_start | 1-bit | input     | pulse high to begin TX   |
| tx_data  | 8-bit | input     | byte to transmit         |
| tx       | 1-bit | output    | serial output line       |
| done     | 1-bit | output    | pulses high when TX done |

### Resource Utilization (Yosys 0.52, generic synthesis)

| Metric      | Value |
|-------------|-------|
| Total cells | 133   |
| Flip Flops  | 21    |

| Cell Type      | Count |
|----------------|-------|
| $_ANDNOT_      | 32    |
| $_OR_          | 25    |
| $_ORNOT_       | 11    |
| $_NAND_        | 10    |
| $_MUX_         | 10    |
| $_DFF_PN0_     | 15    |
| $_DFFE_PN0P_   | 5     |
| $_XOR_         | 10    |
| $_XNOR_        | 5     |
| $_AND_         | 3     |
| $_NOR_         | 3     |
| $_NOT_         | 3     |
| $_DFF_PN1_     | 1     |

### How to Simulate

```bash
iverilog -o sim/run uart_tx/rtl/uart_tx.v uart_tx/tb/uart_tx_tb.v
./sim/run
gtkwave sim/dump.vcd
```

---

## Project 3 — UART Receiver

FSM-based UART receiver. Reads incoming serial bits and reconstructs the 8-bit byte.

### How it works

- 4 states: IDLE → START → DATA → STOP → IDLE
- Detects start bit by watching for falling edge on `tx` line (HIGH → LOW)
- Samples each bit at the **middle** of the bit period for noise immunity
- Reconstructs byte LSB first into `tx_data` output register
- `done` pulses HIGH for one clock cycle when full byte is received

### Ports

| Port    | Width | Direction | Description                   |
|---------|-------|-----------|-------------------------------|
| clk     | 1-bit | input     | system clock                  |
| rst_n   | 1-bit | input     | active low reset              |
| tx      | 1-bit | input     | serial input line             |
| tx_data | 8-bit | output    | reconstructed received byte   |
| done    | 1-bit | output    | pulses high when RX complete  |

### Resource Utilization (Yosys 0.52, generic synthesis)

| Metric      | Value |
|-------------|-------|
| Total cells | 276   |
| Flip Flops  | 28    |

| Cell Type      | Count |
|----------------|-------|
| $_ANDNOT_      | 87    |
| $_OR_          | 75    |
| $_ORNOT_       | 28    |
| $_NAND_        | 21    |
| $_DFF_PN0_     | 15    |
| $_XOR_         | 14    |
| $_DFFE_PN0N_   | 8     |
| $_DFFE_PN0P_   | 5     |
| $_NOR_         | 7     |
| $_NOT_         | 6     |
| $_AND_         | 4     |
| $_XNOR_        | 3     |
| $_MUX_         | 3     |

### How to Simulate

```bash
iverilog -o sim/run uart_rx/rtl/uart_rx.v uart_rx/tb/uart_rx_tb.v
./sim/run
gtkwave sim/dump.vcd
```

---

## Portfolio Comparison

| Module  | Total Cells | Flip Flops | Type         |
|---------|-------------|------------|--------------|
| ALU     | 248         | 0          | Combinational |
| UART TX | 133         | 21         | Sequential    |
| UART RX | 276         | 28         | Sequential    |

---

## Project Structure

```
ALU-VERILOG/
├── README.md
├── alu_module/
│   ├── rtl/
│   │   └── alu.v
│   ├── tb/
│   │   └── tb_alu.v
│   └── sim/
│       └── yosys_report.txt
├── uart_tx/
│   ├── rtl/
│   │   └── uart_tx.v
│   ├── tb/
│   │   └── uart_tx_tb.v
│   └── sim/
│       └── yosys_report.txt
└── uart_rx/
    ├── rtl/
    │   └── uart_rx.v
    ├── tb/
    │   └── uart_rx_tb.v
    └── sim/
        └── yosys_report.txt
```

---

## What I Learned

- Combinational vs sequential logic in Verilog
- FSM design with two always block style (state register + next state logic)
- Baud rate timing — converting clock frequency to bit periods
- Mid-bit sampling in UART RX for noise immunity
- Writing self-checking testbenches with `$display` assertions
- Synthesis and resource utilization analysis with Yosys
- GTKWave waveform debugging
- Full EDA workflow: RTL → Simulation → Synthesis

---

## Tools

| Tool          | Purpose                        |
|---------------|--------------------------------|
| Verilog HDL   | Hardware description language  |
| Icarus Verilog| Simulation compiler            |
| GTKWave       | Waveform viewer                |
| Yosys 0.52    | Synthesis and cell count       |
| VS Code       | Editor                         |
| WSL2 Ubuntu   | Linux environment on Windows   |
| Git + GitHub  | Version control                |
