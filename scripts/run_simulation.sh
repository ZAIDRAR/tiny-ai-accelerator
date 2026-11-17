#!/usr/bin/env bash
set -euo pipefail
mkdir -p build
iverilog -g2012 -Wall -s mac_tb -o build/mac_tb.vvp rtl/mac.v testbench/mac_tb.v
vvp build/mac_tb.vvp
echo "Waveform: build/mac_waveforms.vcd"
echo "Open with: gtkwave build/mac_waveforms.vcd"
