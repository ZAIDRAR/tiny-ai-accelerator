# MAC Verification Plan

## Starter scenarios
- [x] Asynchronous active-low reset sets accumulator to zero
- [x] Positive × positive accumulation
- [x] Negative × positive accumulation
- [x] Positive × negative accumulation
- [x] Negative × negative extreme case
- [x] Disabled MAC retains its current accumulator
- [x] Clear has priority over enable
- [x] Zero multiplier leaves accumulator unchanged

## Future extensions
- [x] Test wraparound on overflow and underflow
- [x] Generate reproducible randomized vectors
- [x] Compare against Python model cycle by cycle
- [x] Check behavior during asynchronous reset assertion
- [ ] Analyze synthesis results with an explicit target library
- [ ] Consider saturation, scaling and rounding for quantized ML

Verified items refer to the [2026-11-18 audit](../results/2026-11-18/report.md). Target-library analysis and physical hardware remain pending; generic synthesis has been executed.
