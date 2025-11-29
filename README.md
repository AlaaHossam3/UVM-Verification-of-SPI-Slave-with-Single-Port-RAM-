# UVM Verification of SPI Slave with Single Port RAM

## 📖 Overview
This project contains a comprehensive **SystemVerilog/UVM Verification Environment** for a SPI (Serial Peripheral Interface) Slave integrated with a Single Port RAM. 

## 🏗️ Project Architecture

### Phase 1: SPI Slave Verification
**Objective:** Create a UVM environment to verify the SPI Slave design compliance with SPI protocols.

* **Interface Signals:** `MOSI`, `MISO`, `SS_n`, `clk`, `rst_n`, `rx_data`, `rx_valid`, `tx_data`, `tx_valid`.
* **Key Checks:**
    * **Protocol Timing:** Validates `SS_n` assertion durations (1 cycle every 13 or 23 cycles depending on the operation).
    * **Command Decoding:** Ensures only valid MOSI command sequences (000, 001, 110, 111) are processed.
    * **FSM Transitions:** Validates state transitions (e.g., IDLE $\rightarrow$ CHK_CMD $\rightarrow$ WRITE/READ) using assertions.

### Phase 2: Single-Port RAM Verification
**Objective:** Verify the RAM design with parameters `MEM_DEPTH: 256` and `ADDR_SIZE: 8`.

* **Interface Signals:** `din` (10-bit), `dout` (8-bit), `rx_valid`, `tx_valid`, `clk`, `rst`.
* **Key Checks:**
    * **Transaction Ordering:** Enforces rules such as "Write Address must be followed by Write Data" or "Read Address must be followed by Read Data".
    * **Randomization Distribution:** Verifies complex probabilistic scenarios (e.g., 60% probability of Read Address vs. 40% Write Address after a Read Data operation).
    * **Data Integrity:** Checks that `tx_valid` rises correctly after a read sequence and falls one clock cycle later.

### Phase 3: SPI Wrapper Verification (Integration)
**Objective:** Verify the end-to-end functionality of the SPI Wrapper by integrating the RAM and SPI Slave environments.

* **Strategy:** Reuses the Part 1 and Part 2 environments with passive agents.
* **System Assertions:** Ensures `MISO` stability and correct reset behavior across the integrated system.

---

## ⚙️ Verification Features

### 🧪 Sequences
The testbench utilizes targeted sequences to stress-test the design:
* **Reset Sequence:** Ensures proper reset behavior.
* **Write-Only / Read-Only Sequences:** Validates unidirectional data flow.
* **Write-Read Sequence:** Randomized bidirectional traffic.
* **Main Sequence:** Handles randomized command generation for the SPI Slave.

### 🎯 Functional Coverage
Comprehensive coverage groups are implemented to ensure all scenarios are hit:
1.  **SPI Transitions:** Covers `MOSI` command bins (Write Addr, Write Data, Read Addr, Read Data).
2.  **Timing Coverage:** Checks `SS_n` pulse durations ($1\rightarrow0[^{*}13]\rightarrow1$ and $1\rightarrow0[^{*}23]\rightarrow1$).
3.  **RAM Ordering:** Covers specific transitions, such as `din[9:8]` sequences (e.g., Write Addr $\rightarrow$ Write Data $\rightarrow$ Read Addr).
4.  **Cross Coverage:** Correlation between `SS_n` and `MOSI` bins, and `din` values with `rx_valid`.

### 🛡️ Assertions (SVA)
SystemVerilog Assertions are used to catch protocol violations immediately:
* **Reset Checks:** Ensures outputs (`MISO`, `rx_valid`, `dout`) are low when reset is asserted.
* **Latency Checks:** Verifies that `rx_valid` asserts exactly 10 cycles after a valid command sequence.
* **Stability:** Checks that `tx_valid` remains deasserted during address phases.

---

## 🔌 System Level Diagram

The SPI Wrapper integrates the **SPI Slave** and **Single Port RAM**. The block diagram below illustrates the top-level interface and the internal signal mapping between the two sub-blocks.

<img width="2101" height="1030" alt="Image" src="https://github.com/user-attachments/assets/44718378-6de6-48a4-90cc-0331f169a78f" />
