"""Deterministic RTL stimuli and golden results from the existing MAC model.

Includes every signed operand pair, stateful random sequences, both accumulator
wrap directions, and control combinations. Uses only the Python standard library.
"""
import json
import random
from pathlib import Path
from mac_reference import mac_step

SEED = 20261118

def generate(destination: Path) -> dict:
    rng = random.Random(SEED)
    acc = 0
    rows = []
    counts = {}
    positive_wraps = negative_wraps = 0

    def step(a=0, b=0, enable=True, clear=False, rst_n=True, group="directed"):
        nonlocal acc, positive_wraps, negative_wraps
        raw = acc + a * b
        active = rst_n and not clear and enable
        positive_wraps += int(active and raw > 8388607)
        negative_wraps += int(active and raw < -8388608)
        # A second mathematical check protects against mistakes in the oracle.
        expected = (0 if not rst_n or clear else
                    ((raw + 8388608) % 16777216 - 8388608) if enable else acc)
        acc = mac_step(acc, a, b, enable, clear, rst_n)
        assert acc == expected
        rows.append(f"{int(rst_n)} {int(clear)} {int(enable)} {a} {b} {acc}\n")
        counts[group] = counts.get(group, 0) + 1

    step(127, 127, rst_n=False)
    for clr in (False, True):
        for en in (False, True):
            step(-128, 127, en, clr, False)
    step(enable=False)
    for a, b in ((3, 4), (-2, 7), (127, -128), (-128, -128), (127, 127), (0, -128)):
        step(a, b)
    step(127, 127, enable=False)
    step(127, 127, enable=False, clear=True)
    step(3, 4)
    step(-128, -128, clear=True)
    # Each isolated product starts from a clean accumulator.
    for a in range(-128, 128):
        for b in range(-128, 128):
            step(clear=True, group="pair_clear")
            step(a, b, group="all_operand_pairs")
    step(clear=True, group="positive_wrap")
    for _ in range(513):
        step(-128, -128, group="positive_wrap")
    step(clear=True, group="negative_wrap")
    for _ in range(518):
        step(-128, 127, group="negative_wrap")
    # Reset a nonzero accumulator between rising clock edges.
    step(127, 127, clear=True, rst_n=False, group="midstream_reset")
    step(enable=False, group="midstream_reset")
    for _ in range(10000):
        step(rng.randint(-128, 127), rng.randint(-128, 127),
             rng.random() < 0.8, rng.random() < 0.02, rng.random() >= 0.01,
             group="random")
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text("".join(rows))
    summary = dict(seed=SEED, vectors=len(rows), groups=counts,
                   positive_wraps=positive_wraps, negative_wraps=negative_wraps)
    destination.with_suffix(".json").write_text(json.dumps(summary, indent=2) + "\n")
    return summary

if __name__ == "__main__":
    print(json.dumps(generate(Path("build/mac_vectors.txt")), sort_keys=True))
