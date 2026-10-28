import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/domain/utils/pos_calculations.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';
import 'package:rational/rational.dart';

Decimal d(String v) => Decimal.parse(v);

CartItemModel item(
  String id,
  String price, {
  String qty = '1',
  String? amount,
  String? pct,
  String? tax,
}) =>
    CartItemModel(
      productId: id,
      productName: id,
      unitPrice: d(price),
      qty: d(qty),
      itemDiscountAmount: amount == null ? null : d(amount),
      itemDiscountPct: pct == null ? null : d(pct),
      taxRate: tax == null ? null : d(tax),
    );

List<Decimal> split(List<CartItemModel> items, String value) =>
    PosCalculations.distributeFixedCartDiscount(
      items: items,
      cartDiscountType: 'fixed',
      cartDiscountValue: d(value),
    );

Decimal sum(List<Decimal> v) => v.fold(Decimal.zero, (a, b) => a + b);

void main() {
  group('fixed cart discount distribution (Decimal)', () {
    test('shares add up exactly, remainder lands without going negative', () {
      final shares =
          split([item('a', '10'), item('b', '10'), item('c', '10')], '10');
      expect(sum(shares), d('10'));
      expect(shares.every((s) => s >= Decimal.zero), isTrue);
    });

    test('a tiny last line never produces a negative remainder', () {
      final items = [item('a', '0.03'), item('b', '0.03'), item('c', '0.01')];
      final shares = split(items, '0.07');
      expect(sum(shares), d('0.07'));
      expect(shares.every((s) => s >= Decimal.zero), isTrue);
    });

    test('each line is capped at its own subtotal', () {
      final items = [item('a', '5'), item('b', '95')];
      final shares = split(items, '100');
      expect(shares[0], d('5'));
      expect(shares[1], d('95'));
    });

    test('discount larger than the cart is capped at the cart total', () {
      final items = [item('a', '20'), item('b', '30')];
      final shares = split(items, '500');
      expect(sum(shares), d('50'));
    });

    test("respects the room left after a line's own fixed discount", () {
      final items = [item('a', '100', amount: '90'), item('b', '100')];
      final shares = split(items, '60');
      expect(shares[0] + d('90') <= d('100'), isTrue);
      expect(sum(shares), d('60'));
    });

    test('percentage and zero discounts allocate nothing', () {
      final items = [item('a', '10')];
      expect(
        PosCalculations.distributeFixedCartDiscount(
          items: items,
          cartDiscountType: 'percentage',
          cartDiscountValue: d('10'),
        ),
        [Decimal.zero],
      );
      expect(split(items, '0'), [Decimal.zero]);
    });

    test('built lines never discount more than the line subtotal', () {
      final items = [item('a', '5'), item('b', '5')];
      final lines = PosCalculations.buildSaleLines(
        items: items,
        cartDiscountType: 'fixed',
        cartDiscountValue: d('999'),
      );
      for (final line in lines) {
        expect(
          Decimal.parse('${line['discount_amount']}') <=
              Decimal.parse('${line['unit_price']}') *
                  Decimal.parse('${line['qty']}'),
          isTrue,
        );
      }
      final totals = PosCalculations.computeAuthoritativeTotals(
        items: items,
        cartDiscountType: 'fixed',
        cartDiscountValue: d('999'),
      );
      expect(totals.totalAmount, Decimal.zero);
    });
  });

  group('rounding is half-up and exact (no double)', () {
    test('fromRational rounds ties like Python ROUND_HALF_UP', () {
      expect(DecimalUtils.fromRational(Rational.parse('1.005')), d('1.01'));
      expect(DecimalUtils.fromRational(Rational.parse('2.675')), d('2.68'));
      expect(DecimalUtils.fromRational(Rational.parse('0.004')), d('0.00'));
    });
  });

  // Expected values were produced by running the backend's
  // app/services/pricing_engine.py with the same inputs.
  group('parity with backend pricing_engine', () {
    LineAmounts line(
      String qty,
      String price,
      String pct,
      String amt,
      String tax,
    ) =>
        PricingEngine.calculateLineTotal(
          qty: d(qty),
          unitPrice: d(price),
          discountPct: d(pct),
          discountAmount: d(amt),
          taxRate: d(tax),
        );

    test('percentage tie rounds up (10.05 @ 10%)', () {
      final r = line('1', '10.05', '10', '0', '0');
      expect(r.effectiveDiscount, d('1.01'));
      expect(r.lineTotal, d('9.04'));
    });

    test('qty * price tie rounds up (3 x 0.335)', () {
      expect(line('3', '0.335', '0', '0', '0').lineSubtotal, d('1.01'));
    });

    test('discount then tax (100 @10% disc, 15.5% tax)', () {
      final r = line('1', '100', '10', '0', '15.5');
      expect(r.taxAmount, d('13.95'));
      expect(r.lineTotal, d('103.95'));
    });

    test('(2 x 19.99, 7.5%, 17% tax)', () {
      final r = line('2', '19.99', '7.5', '0', '17');
      expect(r.effectiveDiscount, d('3.00'));
      expect(r.taxAmount, d('6.29'));
      expect(r.lineTotal, d('43.27'));
    });

    test('tax tie (33.35 @ 15%)', () {
      final r = line('1', '33.35', '0', '0', '15');
      expect(r.taxAmount, d('5.00'));
      expect(r.lineTotal, d('38.35'));
    });

    test('line discount is max(pct, amount), never the sum', () {
      final r = line('1', '100', '10', '30', '0');
      expect(r.effectiveDiscount, d('30.00'));
      expect(r.lineTotal, d('70.00'));
    });

    test('sale totals match the backend for the five-line fixture', () {
      final lines = [
        line('1', '10.05', '10', '0', '0'),
        line('3', '0.335', '0', '0', '0'),
        line('1', '100', '10', '0', '15.5'),
        line('2', '19.99', '7.5', '0', '17'),
        line('1', '33.35', '0', '0', '15'),
      ];
      final t = PricingEngine.calculateSaleTotals(lines);
      expect(t['subtotal'], d('184.39'));
      expect(t['total_discount'], d('14.01'));
      expect(t['total_tax'], d('25.24'));
      expect(t['total_amount'], d('195.62'));
    });
  });

  group('cart percentage semantics (matches backend per-line max rule)', () {
    test("cart % is added to each line's percentage and sent as discount_pct",
        () {
      final lines = PosCalculations.buildSaleLines(
        items: [item('a', '100', pct: '5')],
        cartDiscountType: 'percentage',
        cartDiscountValue: d('10'),
      );
      expect(lines.single['discount_pct'], '15.00');
      expect(lines.single['discount_amount'], '0.00');
    });

    test('cart % cannot push a line over 100%', () {
      final lines = PosCalculations.buildSaleLines(
        items: [item('a', '100', pct: '95')],
        cartDiscountType: 'percentage',
        cartDiscountValue: d('50'),
      );
      expect(lines.single['discount_pct'], '100.00');
    });

    test('a larger fixed line discount wins over the cart % (backend max rule)',
        () {
      final totals = PosCalculations.computeAuthoritativeTotals(
        items: [item('a', '100', amount: '30')],
        cartDiscountType: 'percentage',
        cartDiscountValue: d('10'),
      );
      expect(totals.totalDiscount, d('30.00'));
    });

    test('cart % on a plain line = subtotal * pct', () {
      final totals = PosCalculations.computeAuthoritativeTotals(
        items: [item('a', '19.99', qty: '2')],
        cartDiscountType: 'percentage',
        cartDiscountValue: d('7.5'),
      );
      expect(totals.totalDiscount, d('3.00'));
    });
  });
}
