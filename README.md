# Tiny AI Accelerator — Learning Project

**Status:** Existing MAC RTL verified by simulation and generic synthesis on
2026-11-18. The original tests and 142,123 Python-reference cycles passed.
See the [verification report](results/2026-11-18/report.md). The 2×2 array and
physical FPGA implementation remain planned.

This project explores digital circuits that perform multiply-and-accumulate (MAC) operations used in neural-network inference. It is part of the [Semiconductor Engineering Learning Journey](https://github.com/ZAIDRAR/semiconductor-learning-journey).

## Scope and milestones

| Milestone | Deliverable | Status |
|---|---|---|
| 1 | Signed 8 × 8 MAC with 24-bit accumulator | RTL verified in the documented regression |
| 2 | Self-checking testbench, waveforms, edge cases | 7 starter checks + reset check; 142,123 reference cycles passed |
| 3 | Python numerical reference model | 4 unit tests passed; used for RTL comparison |
| 4 | Processing-element interface and dataflow specification | Planned |
| 5 | Small 2×2 processing array | Planned |
| 6 | Synthesis and PPA/resource study | Generic synthesis verified; target-specific PPA pending |

## Initial MAC specification

A clocked MAC computes:

```text
on each enabled clock: ACC <- wrap24(ACC + signed(A) * signed(B))
```

- `A`, `B`: signed 8-bit two's-complement
- `ACC`: signed 24-bit two's-complement
- Asynchronous active-low reset, synchronous clear, and enable
- On a rising clock edge: reset has priority, then clear, then enable
- Overflow wraps modulo 2^24; no saturation is implemented
- The MAC is **not** a complete AI processor or a systolic array

## Folder guide

- [architecture/README.md](architecture/README.md) — datapath, precision and future array concept
- [rtl/mac.v](rtl/mac.v) — starter synthesizable Verilog MAC
- [testbench/mac_tb.v](testbench/mac_tb.v) — self-checking starter testbench
- [testbench/verification-plan.md](testbench/verification-plan.md) — cases to verify
- [python/mac_reference.py](python/mac_reference.py) — reference arithmetic behavior
- [scripts/run_simulation.sh](scripts/run_simulation.sh) — run Icarus Verilog locally
- [results/README.md](results/README.md) — actual simulation evidence once obtained
- [reports/experiment-template.md](reports/experiment-template.md) — report template

## First local test

With Icarus Verilog installed, from the repository root:

```bash
bash scripts/run_simulation.sh
```

The starter run generates `build/mac_waveforms.vcd`. A dated copy is included
with the verification evidence. GTKWave GUI review remains a learner task.

Run the expanded regression with `bash scripts/run_verification.sh` and generic
synthesis with `bash scripts/run_synthesis.sh` (Yosys required). The regression
generates deterministic vectors using seed `20261118` and checks RTL against
the existing Python model on every cycle, including both wrap directions.

Optional software-model test:

```bash
python3 -m unittest discover -s python -p 'test_*.py'
```

## Engineering method

1. Predict the numeric results from signed arithmetic.
2. Run the RTL testbench and check the accumulator on each clock.
3. Save actual tool versions, waveforms, and test results.
4. Compare the RTL output with Python reference behavior.
5. Only then start a 2×2 array design with explicit dataflow and latency.

**Do not mistake starter code for measured hardware performance.**
