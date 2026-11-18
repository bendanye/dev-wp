from orders.pricing import TAX_RATE, apply_discount, compute_tax, total_with_tax


def test_welcome_discount_takes_ten_percent():
    assert apply_discount(10_000, "WELCOME10") == 9_000


def test_flat500_requires_minimum_subtotal():
    assert apply_discount(1_999, "FLAT500") == 1_999
    assert apply_discount(2_000, "FLAT500") == 1_500


def test_unknown_code_is_ignored():
    assert apply_discount(5_000, "BOGUS") == 5_000


def test_total_with_tax():
    subtotal = 10_000
    expected = subtotal + compute_tax(subtotal)
    assert total_with_tax(subtotal) == expected


def test_tax_rate():
    assert compute_tax(1_000) == round(1_000 * TAX_RATE)
