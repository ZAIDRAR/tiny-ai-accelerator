#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m unittest discover -s python -p 'test_*.py' -v
bash scripts/run_simulation.sh
python3 python/generate_vectors.py
iverilog -g2012 -Wall -s mac_vectors_tb -o build/mac_vectors.vvp rtl/mac.v testbench/mac_vectors_tb.v
vvp build/mac_vectors.vvp
