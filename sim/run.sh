#!/bin/bash

# Clean previous runs
echo "Cleaning previous simulation data..."
rm -rf simv* csrc* vcs* DVEfiles* *.vpd transcript work xrun* *.log *.key *.svf *.fsdb

# Compile using VCS
echo "Compiling with VCS..."
vcs -full64 -sverilog +acc +vpi +vcs+lic+wait \
  -timescale=1ns/1ps \
  -debug_access+all \
  -l compile.log \
  -f filelist.f \
  -o simv

# Run
echo "Running simulation..."
./simv +UVM_TESTNAME=parallel_to_serial_base_test +UVM_VERBOSITY=UVM_MEDIUM | tee run.log
