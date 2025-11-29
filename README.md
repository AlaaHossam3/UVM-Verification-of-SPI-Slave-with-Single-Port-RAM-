# UVM Verification of SPI Slave with Single Port RAM

## 📖 Overview
This project contains a comprehensive **SystemVerilog/UVM Verification Environment** for a generic SPI (Serial Peripheral Interface) Slave controller integrated with a Single Port RAM. 

The testbench is designed to validate the protocol compliance of the SPI interface and the data integrity of memory operations (Read/Write) under various randomized conditions.

## 🏗️ Project Architecture

### Phase 1: SPI Slave Verification
[cite_start]**Objective:** Create a UVM environment to verify the SPI Slave design compliance with SPI protocols[cite: 14].

* [cite_start]**Interface Signals:** `MOSI`, `MISO`, `SS_n`, `clk`, `rst_n`, `rx_data`, `rx_valid`, `tx_data`, `tx_valid` [cite: 15-23].
* **Key Checks:**
    * [cite_start]**Protocol Timing:** Validates `SS_n` assertion durations (1 cycle every 13 or 23 cycles depending on the operation)[cite: 31].
    * [cite_start]**Command Decoding:** Ensures only valid MOSI command sequences (000, 001, 110, 111) are processed[cite: 32].
    * [cite_start]**FSM Transitions:** Validates state transitions (e.g., IDLE $\rightarrow$ CHK_CMD $\rightarrow$ WRITE/READ) using assertions [cite: 52-57].

### Phase 2: Single-Port RAM Verification
[cite_start]**Objective:** Verify the RAM design with parameters `MEM_DEPTH: 256` and `ADDR_SIZE: 8`[cite: 60].

* [cite_start]**Interface Signals:** `din` (10-bit), `dout` (8-bit), `rx_valid`, `tx_valid`, `clk`, `rst`[cite: 62].
* **Key Checks:**
    * [cite_start]**Transaction Ordering:** Enforces rules such as "Write Address must be followed by Write Data" or "Read Address must be followed by Read Data" [cite: 70-71].
    * [cite_start]**Randomization Distribution:** Verifies complex probabilistic scenarios (e.g., 60% probability of Read Address vs. 40% Write Address after a Read Data operation)[cite: 76].
    * [cite_start]**Data Integrity:** Checks that `tx_valid` rises correctly after a read sequence and falls one clock cycle later[cite: 88].

### Phase 3: SPI Wrapper Verification (Integration)
[cite_start]**Objective:** Verify the end-to-end functionality of the SPI Wrapper by integrating the RAM and SPI Slave environments[cite: 94].

* [cite_start]**Strategy:** Reuses the Part 1 and Part 2 environments with passive agents[cite: 95].
* [cite_start]**System Assertions:** Ensures `MISO` stability and correct reset behavior across the integrated system[cite: 110, 112].

---

## ⚙️ Verification Features

### 🧪 Sequences
The testbench utilizes targeted sequences to stress-test the design:
* [cite_start]**Reset Sequence:** Ensures proper reset behavior[cite: 27].
* [cite_start]**Write-Only / Read-Only Sequences:** Validates unidirectional data flow[cite: 65].
* [cite_start]**Write-Read Sequence:** Randomized bidirectional traffic[cite: 65].
* [cite_start]**Main Sequence:** Handles randomized command generation for the SPI Slave[cite: 28].

### 🎯 Functional Coverage
Comprehensive coverage groups are implemented to ensure all scenarios are hit:
1.  [cite_start]**SPI Transitions:** Covers `MOSI` command bins (Write Addr, Write Data, Read Addr, Read Data) [cite: 40-44].
2.  [cite_start]**Timing Coverage:** Checks `SS_n` pulse durations ($1\rightarrow0[^{*}13]\rightarrow1$ and $1\rightarrow0[^{*}23]\rightarrow1$)[cite: 38, 39].
3.  [cite_start]**RAM Ordering:** Covers specific transitions, such as `din[9:8]` sequences (e.g., Write Addr $\rightarrow$ Write Data $\rightarrow$ Read Addr) [cite: 79-82].
4.  [cite_start]**Cross Coverage:** Correlation between `SS_n` and `MOSI` bins, and `din` values with `rx_valid`[cite: 45, 84].

### 🛡️ Assertions (SVA)
SystemVerilog Assertions are used to catch protocol violations immediately:
* [cite_start]**Reset Checks:** Ensures outputs (`MISO`, `rx_valid`, `dout`) are low when reset is asserted[cite: 47, 86].
* [cite_start]**Latency Checks:** Verifies that `rx_valid` asserts exactly 10 cycles after a valid command sequence[cite: 49].
* [cite_start]**Stability:** Checks that `tx_valid` remains deasserted during address phases[cite: 87].

---

## 📂 Repository Structure
[cite_start]The project is organized into three main folders corresponding to the design phases[cite: 135]:

```text
.
├── SPI_Slave/    # Design, UVM Code, Do Files, Coverage Reports
├── RAM/          # Design, UVM Code, Do Files, Coverage Reports
└── Wrapper/      # Integrated Design, Top-Level UVM Environment
