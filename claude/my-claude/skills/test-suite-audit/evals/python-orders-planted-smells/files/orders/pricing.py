TAX_RATE = 0.09


def compute_tax(subtotal_cents: int) -> int:
    return round(subtotal_cents * TAX_RATE)


def apply_discount(subtotal_cents: int, code: str | None) -> int:
    if code == "WELCOME10":
        return subtotal_cents - subtotal_cents // 10
    if code == "FLAT500" and subtotal_cents >= 2000:
        return subtotal_cents - 500
    return subtotal_cents


def total_with_tax(subtotal_cents: int, code: str | None = None) -> int:
    discounted = apply_discount(subtotal_cents, code)
    return discounted + compute_tax(discounted)
