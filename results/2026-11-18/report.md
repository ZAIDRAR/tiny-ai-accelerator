# Signed MAC verification — 2026-11-18

## Scope and finding

Baseline: `83a67f9db21998d09ba335523487e561e3b1aad6`.
`rtl/mac.v` and `python/mac_reference.py` were retained unchanged. No functional RTL arithmetic or control bug was found in the exercised cases. The starter bench was valid but had coverage gaps: it did not exercise accumulator overflow, underflow, or reset asserted during operation between active clock edges.

## Executed checks

| Check | Observed result |
|---|---|
| Existing Python unit tests | 4 passed |
| Original RTL testbench | 7 arithmetic/control checks + initial reset check passed |
| Added cycle-by-cycle Python comparison | 142,123 cycles passed |
| Isolated products | All 65,536 signed 8-bit operand pairs, each preceded by clear |
| Random stateful portion | 10,000 cycles, seed 20261118 |
| Directed overflow / underflow | Both accumulator wrap directions exercised |
| Between-edge reset observations | 106 checks passed (includes held-low observations) |
| Synchronous behavior | No state change between active edges unless reset is asserted |
| Yosys checks | 0 structural problems; latch absence assertion passed |
| Generic synthesis | 832 generic cells, including 24 enabled asynchronous-reset flip-flops |

The stimulus generator uses the existing Python `mac_step` function and also checks it against an independent modulo expression. Inputs change at falling clock edges. The bench checks asynchronous behavior one nanosecond later and clocked results one nanosecond after the rising edge, after nonblocking updates. This avoids driving and checking the DUT in the same rising-edge scheduling region. The original reset test alone did not establish between-edge reset behavior; the new test does.

The exhaustive product check is not exhaustive over all 24-bit accumulator states or arbitrary control histories. Unknown X/Z inputs, analog metastability, reset recovery/removal and physical timing are not modeled.

## Numerical interpretation

Inputs are integers from -128 to 127. A signed 16-bit product is sign-extended into the 24-bit accumulator, which wraps modulo 2^24. There is no saturation. The mathematical product `(-128)*(-128)=16384`; after 512 such enabled updates from zero, the accumulator is `-8388608`, exactly the specified wrap behavior. The directed negative sequence similarly crosses the lower bound.

At each enabled rising edge, the result becomes the previous accumulator plus the current product. Architecturally the initiation interval is one clock and the update is visible after that edge in RTL simulation. This does not establish a physical operating frequency. The 10 ns bench period is a stimulus setting, not evidence of 100 MHz timing closure.

## Reproduce and evidence

Requirements: Python 3 (standard library), Bash, Icarus Verilog 12.0, Yosys 0.52.

```bash
bash scripts/run_verification.sh
bash scripts/run_synthesis.sh
```

- [Original run log](baseline-smoke.log)
- [Full regression log](verification.log)
- [Vector groups, seed and wrap counts](vectors.json)
- [Tool versions, baseline commit, source and vector hashes](provenance.json)
- [Yosys synthesis log](synthesis.log)
- [Actual starter waveform](mac-smoke.vcd)

The scripts regenerate vectors and build products. The original waveform is small enough to retain; the full regression does not create a large VCD. GTKWave GUI inspection has not been performed. Icarus reports an unspecified RTL-module timescale; the delay-free RTL is driven by explicitly timed benches.

## Resource interpretation and next milestone

The 832 cells are technology-independent Yosys primitives after `synth -noabc`: 359 AND, 135 OR, 282 XOR, 8 NOT, 24 muxes, and 24 enabled resettable flip-flops. No FPGA LUT/DSP inference, standard-cell mapping, placement, routing, static timing analysis, power estimation, or formal equivalence proof was performed.

Next specify an output-stationary 2×2 array: four instances of this MAC, operand scheduling, valid/clear rules, matrix boundaries, stalls and completion. First check exact integer matrix products, then investigate quantization error separately. The existing MAC alone is not a complete AI accelerator.
