[![OS](https://img.shields.io/badge/OS-Ubuntu-orange)](#)
[![tool](https://img.shields.io/badge/Tools-iverilog%20%7C%20gtkWAVE%20%7C%20yosys%20%7C%20Fault%20%7C%20Quaigh%20%7C%20OpenSTA%20%7C%20OpenROAD%20%7C%20klayout%20%7C%20Magic-blue)](#)
[![language](https://img.shields.io/badge/Language-Verilog%20%7C%20tcl-red)](#)

# RTL to GDSII — Router ASIC Implementation (Open Source)

Complete end-to-end ASIC implementation flow for a Router Design using open-source and industry-style methodology.

This repository demonstrates how to go from:

Specification → RTL → Simulation → Synthesis → STA → DFT → STA → Physical Design → Signoff → GDSII


## Project Overview

This repository contains:

- Router1x3 Design Specification
- Complete RTL source
- Testbenches
- Step-by-step execution guides
- Scripts
- Reports
- Generated outputs

Users follow documented steps to reproduce the entire flow.


## Design Information

| Parameter | Value |
|----------|------|
| Design | Router |
| Top Module | router_top |
| Language | Verilog |
| Flow | RTL → GDSII |
| Target | ASIC |
| Libraries | Sky130 |


# Tools Installation Verification

Before starting the flow, verify that all required tools are installed correctly.

- [iverilog](https://github.com/steveicarus/iverilog.git): Verilog simulation and compilation  
- [gtkWAVE](https://github.com/gtkwave/gtkwave.git): Waveform visualization and debugging  
- [yosys](https://github.com/YosysHQ/yosys.git): RTL synthesis to gate-level netlist  
- [Fault](https://github.com/AUCOHL/Fault.git): DFT and ATPG framework  
- [Quaigh](https://github.com/Coloquinte/quaigh.git): Logic simplification and analysis tools
- [OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA.git): Static timing analysis  
- [OpenROAD](https://github.com/The-OpenROAD-Project/OpenROAD.git): Physical design (PnR)
- [klayout](https://github.com/KLayout/klayout.git): Layout viewing and verification  
- [Magic](https://github.com/RTimothyEdwards/magic.git): GDS Generation, DRC, LVS


# Getting Started

Clone Repository
```bash
https://github.com/inaved-semicon/RTL-TO-GDSII.git
cd RTL-TO-GDSII
```

This repository includes a `Makefile` to remove all generated outputs from previous runs.

Before starting the flow from scratch, execute:

```bash
make clean
```

This command removes all generated files, including:

* Simulation outputs
* Synthesized netlists and reports
* DFT outputs and logs
* STA reports
* Physical Design results
* Generated GDS files

Source files such as RTL, Testbenches, scripts, and documentation are preserved.

Running `make clean` ensures a clean working environment for reproducing the complete RTL-to-GDSII flow.


# Step 1 : Study Design Specification
Begin by understanding the design specification and expected functionality.

Review:

- Design requirements
- Functional behavior
- Interfaces and data flow
- Expected operation

→ Refer to [SPECIFICATION](Specification/README.md)

# Step 2 : RTL Generation
Convert design [specifications](Specification/Specifications.md) into synthesizable RTL (Verilog) that defines hardware functionality and module behavior.

The RTL implementation for this project is already provided in the [`RTL/`](RTL/) directory.

A clear understanding of the RTL is recommended before moving to the next stages of the RTL → GDSII flow.

# Step 3 : Functional Verification
Verify that the provided RTL behaves according to the design specification.

Verify that the provided RTL behaves according to the design specification.

Write the Testbench to:

- Compile the RTL
- Run simulation
- Validate functional behavior
- Observe waveforms
- Debug mismatches if required

The Testbench for this project is already provided in the [`Testbench/`](Testbench/) directory.

→ Detailed instructions are available at [SIMULATION_GUIDE](Simulation/README.md).

# Step 4 : Logic Synthesis
Convert the verified RTL into a gate-level netlist using the target technology library.

**This stage performs:**
- RTL elaboration
- Logic optimization
- Technology mapping
- Gate-level netlist generation

**Outputs:**
- Synthesized netlist
- Area report

For detailed explanation, scripts, commands, and result analysis:

→ Refer to [SYNTHESIS_GUIDE](SYNTHESIS/README.md)

# Step 5 — Static Timing Analysis (STA)

Static Timing Analysis (STA) verifies whether the synthesized design meets timing requirements without requiring simulation vectors.

This stage includes:

* Clock definition and constraints
* Timing path analysis
* Setup time verification
* Hold time verification
* Critical path identification
* Timing report generation

STA in this project is performed using the OpenSTA tool.

Outputs:

* Timing reports
* Setup analysis reports
* Hold analysis reports
* Critical path information

For detailed explanation, setup, commands, constraints, and report analysis:

→ Refer to [PRE_STA_GUIDE](PRE_DFT_STA/README.md)

# Step 6 : Design for Testability (DFT)
Insert test structures into the synthesized design to improve controllability, observability, and manufacturing test coverage.

This stage includes:

- Scan Chain insertion
- Automatic Test Pattern Generatio(ATPG)
- Boundry Scan Insertion (JTAG)
- Scan Chain validation
- Tap Controller validation
- Test vector validation

DFT in this project is implemented using the Fault open-source DFT framework.

Outputs:

- JTAG inserted netlist
- Testbench for dft logic validation


For detailed explanation, setup, commands, and result analysis:

→ Refer to [DFT_GUIDE](DFT/README.md)

# Step 7 — Static Timing Analysis (STA)

Static Timing Analysis (STA) is performed again to check new violation after DFT.

For detailed explanation, setup, commands, constraints, and report analysis:

→ Refer to [STA_GUIDE](POST_DFT_STA/README.md)

# Step 8 — Physical Design (RTL-to-GDSII)

Physical Design transforms the timing-clean gate-level netlist into a manufacturable chip layout.

This stage includes:

- Floorplanning
- Power Planning
- Placement
- Clock Tree Synthesis (CTS)
- Routing
- Timing Optimization
- Design Rule Checks (DRC)
- Layout Generation (GDSII)

Physical implementation in this project is performed using the OpenROAD flow and SKY130 PDK.

Outputs:

- Floorplan database
- Placement database
- CTS database
- Routed design
- Timing reports
- DEF files
- Final GDSII layout

For detailed setup, scripts, commands, reports, and implementation flow:

→ Refer to [PD_GUIDE](PD/README.md)


