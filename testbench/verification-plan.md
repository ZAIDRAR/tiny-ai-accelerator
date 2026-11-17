# MAC Verification Plan

## Starter scenarios
- [ ] Asynchronous active-low reset sets accumulator to zero
- [ ] Positive × positive accumulation
- [ ] Negative × positive accumulation
- [ ] Positive × negative accumulation
- [ ] Negative × negative extreme case
- [ ] Disabled MAC retains its current accumulator
- [ ] Clear has priority over enable
- [ ] Zero multiplier leaves accumulator unchanged

## Future extensions
- [ ] Test wraparound on overflow and underflow
- [ ] Generate reproducible randomized vectors
- [ ] Compare against Python model cycle by cycle
- [ ] Check behavior during asynchronous reset assertion
- [ ] Analyze synthesis results with an explicit target library
- [ ] Consider saturation, scaling and rounding for quantized ML

Until a run is recorded under `results/`, these tests are not marked verified.
