#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build
yosys -p 'read_verilog rtl/mac.v; synth -top mac -noabc; check -assert; select -assert-none t:$_DLATCH_* t:$dlatch; stat; write_json build/mac-generic.json'
