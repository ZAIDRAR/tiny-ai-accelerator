# Reproducible simulation

From the root of the repository:

```bash
bash scripts/run_simulation.sh
```

Requirements: Icarus Verilog (`iverilog`, `vvp`). Optionally, GTKWave.

Save a dated verification report with simulator version, observed output, screenshots and any fixes. Do not upload a fabricated screenshot.

Python software model:

```bash
python3 -m unittest discover -s python -p 'test_*.py'
```
