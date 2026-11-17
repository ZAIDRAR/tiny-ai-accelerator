# Tiny AI Accelerator — Learning Project

**Status:** Project initialized. Starter MAC RTL and testbench are provided but have **not yet been simulator-verified**.

This project explores digital circuits that perform multiply-and-accumulate (MAC) operations used in neural-network inference. It is part of the [Semiconductor Engineering Learning Journey](https://github.com/ZAIDRAR/semiconductor-learning-journey).

## Scope and milestones

| Milestone | Deliverable | Status |
|---|---|---|
| 1 | Signed 8 × 8 MAC with 24-bit accumulator | Starter RTL added; simulation pending |
| 2 | Self-checking testbench, waveforms, edge cases | Starter testbench added; execution pending |
| 3 | Python numerical reference model | Reference implementation added |
| 4 | Processing-element interface and dataflow specification | Planned |
| 5 | Small 2×2 processing array | Planned |
| 6 | Synthesis and PPA/resource study | Planned |

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

A waveform should be written to `build/mac_waveforms.vcd` when simulation works. View it with GTKWave. The output has not yet been run or verified here.

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
