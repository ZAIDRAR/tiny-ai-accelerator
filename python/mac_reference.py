"""24-bit signed wrapping MAC reference (software model; not RTL evidence)."""

INPUT_MIN, INPUT_MAX = -128, 127
ACC_BITS = 24

def wrap_signed(value: int, bits: int = ACC_BITS) -> int:
    """Wrap integer into signed two's-complement of the requested width."""
    mask = (1 << bits) - 1
    value &= mask
    return value - (1 << bits) if value & (1 << (bits - 1)) else value

def mac_step(acc: int, a: int, b: int, enable: bool = True,
             clear: bool = False, rst_n: bool = True) -> int:
    """Model MAC next state after a clock edge (or reset assertion)."""
    if not rst_n or clear:
        return 0
    if not enable:
        return wrap_signed(acc)
    if not (INPUT_MIN <= a <= INPUT_MAX and INPUT_MIN <= b <= INPUT_MAX):
        raise ValueError("MAC operands must be signed 8-bit integers")
    return wrap_signed(acc + a * b)

if __name__ == "__main__":
    acc = 0
    for a, b in [(3, 4), (-2, 7), (127, -128)]:
        acc = mac_step(acc, a, b)
        print(f"A={a:>4}, B={b:>4} -> ACC={acc}")
