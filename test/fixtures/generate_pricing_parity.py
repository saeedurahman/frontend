"""Generates test/fixtures/pricing_parity.json by RUNNING the backend engine.

    python test/fixtures/generate_pricing_parity.py D:\\flutter\\sas\\backend

The Dart test (test/pos/pricing_engine_parity_test.dart) feeds the same inputs
to PricingEngine and expects identical Decimal strings. Re-run this when the
backend pricing_engine.py changes.
"""
import itertools
import json
import os
import sys
from decimal import Decimal

backend = sys.argv[1] if len(sys.argv) > 1 else r"D:\flutter\sas\backend"
sys.path.insert(0, backend)

from app.services import pricing_engine as pe  # noqa: E402


def s(v):
    return format(v, "f") if isinstance(v, Decimal) else v


def line_out(a):
    return {k: s(v) for k, v in a.items()}


cases = []


def add_cart(name, lines, inclusive, rounding, cart_discount="0"):
    per, totals = pe.price_cart(
        [
            {
                "qty": Decimal(l["qty"]),
                "unit_price": Decimal(l["unit_price"]),
                "discount_pct": Decimal(l.get("discount_pct", "0")),
                "discount_amount": Decimal(l.get("discount_amount", "0")),
                "tax_rate": Decimal(l["tax_rate"]),
            }
            for l in lines
        ],
        inclusive=inclusive,
        rounding_mode=rounding,
        cart_discount=Decimal(cart_discount),
    )
    cases.append(
        {
            "name": name,
            "inclusive": inclusive,
            "rounding": rounding,
            "cart_discount": cart_discount,
            "lines": lines,
            "expected_lines": [line_out(p) for p in per],
            "expected_totals": {k: s(v) for k, v in totals.items()},
        }
    )


# 1. Every single-line combination (the bug case: 6 at 17% is in here).
prices = ["6", "99.99", "1250.5"]
discounts = [
    {},
    {"discount_pct": "10"},
    {"discount_amount": "1.5"},
]
for rate, qty, price, disc, inclusive in itertools.product(
    ["0", "5", "10", "17"], ["1", "2", "3", "0.5"], prices, discounts, [False, True]
):
    line = {"qty": qty, "unit_price": price, "tax_rate": rate, **disc}
    add_cart(
        f"single r{rate} q{qty} p{price} {sorted(disc)} inc={inclusive}",
        [line],
        inclusive,
        "none",
    )

# 2. Modifiers raise the unit price (6 + 2.50 + 1.25), mixed rates.
mods = [
    {"qty": "2", "unit_price": "9.75", "tax_rate": "17"},
    {"qty": "1", "unit_price": "250", "tax_rate": "5", "discount_pct": "5"},
    {"qty": "3", "unit_price": "33.33", "tax_rate": "0"},
]
for inclusive, rounding in itertools.product([False, True], pe.ROUNDING_MODES):
    add_cart(f"modifiers mixed inc={inclusive} {rounding}", mods, inclusive, rounding)

# 3. Fixed cart discounts spread over several lines.
cart = [
    {"qty": "1", "unit_price": "100", "tax_rate": "17"},
    {"qty": "2", "unit_price": "49.99", "tax_rate": "5"},
    {"qty": "0.5", "unit_price": "301", "tax_rate": "10", "discount_amount": "3"},
    {"qty": "3", "unit_price": "6", "tax_rate": "0"},
]
for inclusive, rounding, cd in itertools.product(
    [False, True], pe.ROUNDING_MODES, ["0", "10", "33.33", "1000", "5000"]
):
    add_cart(f"cart discount {cd} inc={inclusive} {rounding}", cart, inclusive, rounding, cd)

# 4. Rounding to the step on the grand total, including exact halves.
rounding_cases = []
for exact in ["0", "0.49", "0.50", "1.50", "2.5", "2.49", "7.50", "12.50",
              "14.04", "15.00", "17.50", "22.50", "25.00", "1234.56", "1235.50",
              "1237.50", "-0.50", "-2.50", "-7.50", "-12.50", "-14.04"]:
    for mode in pe.ROUNDING_MODES:
        total, amount = pe.round_total(Decimal(exact), mode)
        rounding_cases.append(
            {"exact": exact, "mode": mode, "total": s(total), "amount": s(amount)}
        )

# 5. Cart discount distribution on its own.
dist_cases = []
for amounts, disc in [
    (["100", "100", "100"], "100"),
    (["33.33", "66.67"], "10"),
    (["0.01", "0.01", "0.01"], "0.02"),
    (["50", "0", "50"], "30"),
    (["10"], "99"),
    (["1", "2", "3", "4", "5", "6", "7"], "13.37"),
]:
    shares = pe.distribute_cart_discount([Decimal(a) for a in amounts], Decimal(disc))
    dist_cases.append({"amounts": amounts, "discount": disc, "shares": [s(x) for x in shares]})

out = {
    "carts": cases,
    "rounding": rounding_cases,
    "distribution": dist_cases,
}
path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "pricing_parity.json")
with open(path, "w", encoding="utf-8") as f:
    json.dump(out, f, indent=1)
print(f"wrote {path}: {len(cases)} carts, {len(rounding_cases)} rounding, {len(dist_cases)} distribution")
