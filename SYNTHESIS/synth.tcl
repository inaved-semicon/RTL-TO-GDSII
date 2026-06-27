# ------------------------------------------------------------
# USER CONFIGURABLE VARIABLES
# ------------------------------------------------------------
# LIB:
# Path to SKY130 liberty file.
# This file provides timing, area, and standard cell information.
#
# TOP:
# Top-level RTL module to synthesize.
#
# OUT_DIR:
# Directory where synthesized netlist will be generated.
#
# RPT_DIR:
# Directory where synthesis reports will be stored.
# ------------------------------------------------------------

set LIB        "../Tech_Lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
set TOP        "router_top"
set OUT_DIR    "Netlist"
set RPT_DIR    "Report"

# ------------------------------------------------------------
# Create output directories if not exist
#
# Prevents synthesis failure due to missing folders.
# Generated netlists and reports are stored here.
# ------------------------------------------------------------
file mkdir $OUT_DIR
file mkdir $RPT_DIR

# ------------------------------------------------------------
# Read standard cell library
#
# TWO MODES:
#
# 1. -lib
#    Load liberty for synthesis and technology mapping.
#
# 2. Normal liberty load
#    Used for timing/area estimation.
#
# This library becomes the implementation target.
# ------------------------------------------------------------
yosys read_liberty -lib $LIB

# ------------------------------------------------------------
# Read RTL files
#
# Import all Verilog source files from RTL directory.
# These files are parsed and converted into Yosys internal
# design representation.
# ------------------------------------------------------------
yosys read_verilog ../RTL/*.v

# ------------------------------------------------------------
# Set top module
#
# Defines the synthesis entry point.
# Yosys resolves hierarchy and verifies module connections.
#
# -check:
# Reports missing modules or hierarchy issues.
# ------------------------------------------------------------
yosys hierarchy -check -top $TOP

# ------------------------------------------------------------
# Process conversion
#
# Converts behavioral RTL constructs into hardware:
#
# always → logic network
# if/else → mux
# case → decoder
# registers → flip-flops
#
# Generates initial RTL netlist representation.
# ------------------------------------------------------------
yosys proc

# ------------------------------------------------------------
# Initial optimization
#
# Removes:
# - dead logic
# - redundant expressions
# - unused signals
#
# Simplifies logic before advanced transformations.
# ------------------------------------------------------------
yosys opt

# ------------------------------------------------------------
# FSM optimization
#
# Detects finite state machines automatically.
#
# Performs:
# - state extraction
# - state encoding optimization
# - FSM simplification
# ------------------------------------------------------------
yosys fsm

# ------------------------------------------------------------
# Re-optimize after FSM conversion
#
# Removes temporary logic introduced by FSM pass.
# ------------------------------------------------------------
yosys opt

# ------------------------------------------------------------
# Memory inference and optimization
#
# Converts memory-like structures into optimized
# internal memory representation.
#
# Important for:
# - FIFOs
# - arrays
# - RAM-style logic
# ------------------------------------------------------------
yosys memory

# ------------------------------------------------------------
# Re-optimize after memory handling
#
# Cleans additional logic generated during memory pass.
# ------------------------------------------------------------
yosys opt

# ------------------------------------------------------------
# Flatten hierarchy
#
# Merges all submodules into a single top-level module.
#
# Advantages:
# - easier optimization
# - better global mapping
#
# Result:
# Final netlist contains only TOP module.
# ------------------------------------------------------------
yosys flatten

# ------------------------------------------------------------
# Technology mapping preparation
#
# Converts generic RTL structures into forms that can
# later be mapped to actual SKY130 standard cells.
# ------------------------------------------------------------
yosys techmap

# ------------------------------------------------------------
# Cleanup before final mapping
#
# Reduces unnecessary logic before cell mapping.
# ------------------------------------------------------------
yosys opt

# ------------------------------------------------------------
# Flip-flop mapping
#
# Maps generic registers into SKY130 sequential cells.
#
# Example:
# $_DFF_P_ →
# sky130_fd_sc_hd__dfrtp_1
#
# -dont_use:
# Prevent unsupported or undesired cells.
# ------------------------------------------------------------
yosys dfflibmap -liberty $LIB -dont_use sky130_fd_sc_hd__edf*

# ------------------------------------------------------------
# Combinational logic mapping
#
# Uses ABC engine to convert generic gates into
# SKY130 combinational standard cells.
#
# Example:
# AND → NAND + INV
# OR  → NOR + INV
#
# Produces technology-mapped netlist.
# ------------------------------------------------------------
yosys abc -liberty $LIB -dont_use sky130_fd_sc_hd__lpflow*

# ------------------------------------------------------------
# Final cleanup
#
# Removes:
# - unused cells
# - dangling wires
# - temporary objects
#
# Produces clean synthesized design.
# ------------------------------------------------------------
yosys opt_clean
yosys clean

# ------------------------------------------------------------
# Consistency checks
#
# Detect:
# - floating wires
# - disconnected ports
# - structural issues
# ------------------------------------------------------------
yosys check

# ------------------------------------------------------------
# Generate synthesis statistics
#
# Uses liberty information to calculate:
# - area
# - cell usage
# - hierarchy summary
#
# Report stored in Report directory.
# ------------------------------------------------------------
yosys tee -o "$RPT_DIR/${TOP}_area.rpt" stat -liberty $LIB

# ------------------------------------------------------------
# Export synthesized gate-level netlist
#
# Output:
# Flattened technology-mapped Verilog.
#
# -noattr:
# Removes synthesis metadata for cleaner output.
# ------------------------------------------------------------
yosys write_verilog -noattr "$OUT_DIR/${TOP}_netlist.v"

