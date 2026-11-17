import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';

/// Parity with the backend: test/fixtures/pricing_parity.json was produced by
/// RUNNING backend `app/services/pricing_engine.py`
/// (`python test/fixtures/generate_pricing_parity.py <backend dir>`), so every
/// number below is what the server computes.
Decimal d(Object? v) => Decimal.parse('$v');

void main() {
  final fixtures = jsonDecode(
    File('test/fixtures/pricing_parity.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  group('PricingEngine == backend pricing_engine.py', () {
    final carts = (fixtures['carts'] as List).cast<Map<String, dynamic>>();

    test('fixture covers the matrix', () {
      expect(carts.length, greaterThan(300));
    });

    for (final c in carts) {
      test(c['name'] as String, () {
        final lines = [
          for (final l in (c['lines'] as List).cast<Map<String, dynamic>>())
            PricingLine(
              qty: d(l['qty']),
              unitPrice: d(l['unit_price']),
              taxRate: d(l['tax_rate']),
              discountPct:
                  l['discount_pct'] == null ? null : d(l['discount_pct']),
              discountAmount:
                  l['discount_amount'] == null ? null : d(l['discount_amount']),
            ),
        ];
        final (per, totals) = PricingEngine.priceCart(
          lines,
          inclusive: c['inclusive'] as bool,
          roundingMode: c['rounding'] as String,
          cartDiscount: d(c['cart_discount']),
        );
        final expectedLines =
            (c['expected_lines'] as List).cast<Map<String, dynamic>>();
        expect(per.length, expectedLines.length);
        for (var i = 0; i < per.length; i++) {
          final e = expectedLines[i];
          expect(per[i].lineSubtotal, d(e['line_subtotal']), reason: 'subtotal $i');
          expect(per[i].effectiveDiscount, d(e['effective_discount']),
              reason: 'discount $i');
          expect(per[i].netAmount, d(e['net_amount']), reason: 'net $i');
          expect(per[i].taxAmount, d(e['tax_amount']), reason: 'tax $i');
          expect(per[i].lineTotal, d(e['line_total']), reason: 'total $i');
        }
        final e = (c['expected_totals'] as Map).cast<String, dynamic>();
        final got = totals.toMap();
        for (final key in e.keys) {
          expect(got[key], d(e[key]), reason: key);
        }
      });
    }
  });

  group('round_total (half away from zero, signed rounding)', () {
    for (final r in (fixtures['rounding'] as List).cast<Map<String, dynamic>>()) {
      test('${r['exact']} ${r['mode']}', () {
        final (total, amount) =
            PricingEngine.roundTotal(d(r['exact']), r['mode'] as String);
        expect(total, d(r['total']));
        expect(amount, d(r['amount']));
      });
    }
  });

  group('distribute_cart_discount', () {
    for (final r
        in (fixtures['distribution'] as List).cast<Map<String, dynamic>>()) {
      test('${r['amounts']} - ${r['discount']}', () {
        final shares = PricingEngine.distributeCartDiscount(
          [for (final a in r['amounts'] as List) d(a)],
          d(r['discount']),
        );
        expect(shares, [for (final s in r['shares'] as List) d(s)]);
      });
    }
  });

  test('the original bug: price 6 at 17% GST shows 7.02 / 14.04 / 21.06', () {
    for (final (qty, total) in [(1, '7.02'), (2, '14.04'), (3, '21.06')]) {
      final a = PricingEngine.calculateLineTotal(
        qty: Decimal.fromInt(qty),
        unitPrice: Decimal.fromInt(6),
        discountPct: Decimal.zero,
        discountAmount: Decimal.zero,
        taxRate: Decimal.fromInt(17),
      );
      expect(a.lineTotal, d(total));
    }
  });
}
