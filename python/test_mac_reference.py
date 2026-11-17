"""Unit checks for the analytical MAC reference model."""
import unittest
from mac_reference import mac_step, wrap_signed

class TestMACReference(unittest.TestCase):
    def test_accumulation_and_negative_operands(self):
        acc = mac_step(0, 3, 4)
        self.assertEqual(acc, 12)
        acc = mac_step(acc, -2, 7)
        self.assertEqual(acc, -2)
        self.assertEqual(mac_step(acc, 127, -128), -16258)

    def test_controls(self):
        self.assertEqual(mac_step(19, 5, 6, enable=False), 19)
        self.assertEqual(mac_step(19, 5, 6, clear=True), 0)
        self.assertEqual(mac_step(19, 5, 6, rst_n=False), 0)

    def test_signed_extremes(self):
        self.assertEqual(mac_step(0, -128, -128), 16384)
        self.assertEqual(wrap_signed((1 << 23)), -(1 << 23))
        self.assertEqual(wrap_signed(-((1 << 23) + 1)), (1 << 23) - 1)

    def test_operand_range(self):
        with self.assertRaises(ValueError):
            mac_step(0, 128, 2)

if __name__ == "__main__":
    unittest.main()
