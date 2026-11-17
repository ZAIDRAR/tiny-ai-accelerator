# MAC Datapath and Roadmap

## Current MAC design

```text
 signed A[7:0] ─┐
                × ── product[15:0] ── sign extend ──┐
 signed B[7:0] ─┘                                    + ── ACC[23:0]
                                              ACC ───┘      |
                                                          register
                                                      reset/clear/enable
```

The accumulator is updated on each positive clock edge when `enable=1` and `clear=0`. It holds otherwise. A low `rst_n` resets it asynchronously.

## Number formats

- Input operands: signed 8-bit integers (range -128 through 127)
- Product: signed 16-bit integer
- Accumulator: signed 24-bit integer (range -8,388,608 through 8,388,607)
- Accumulation: wraparound modulo 2^24; not saturating or floating point
- Initial values are integers, not quantized floating-point neural-network outputs

## Future 2×2 architecture — NOT IMPLEMENTED

A later stage can connect four processing elements and introduce operand forwarding, activation timing, cycle-by-cycle dataflow, and a controller. Before implementation specify:

- stationary dataflow strategy
- pipeline latency and reset semantics
- valid/control signals and accumulation length
- matrix dimensions, tensor layout and operand scheduling
- accuracy, overflow and throughput measures

The current `rtl/mac.v` is only the first computational building block.
