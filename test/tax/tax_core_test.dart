import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/utils/line_price_breakdown.dart';
import 'package:frantend/features/pos/domain/utils/payment_allocator.dart';
import 'package:frantend/features/pos/domain/utils/pos_calculations.dart';
import 'package:frantend/features/pos/domain/utils/tax_groups.dart';
import 'package:frantend/features/pos/domain/utils/tax_rate_resolver.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

Decimal d(String v) => Decimal.parse(v);

TaxRateModel rate(String id, String pct) => TaxRateModel(
      id: id,
      businessId: 'b',
      name: 'GST',
      rate: pct,
    );

CartItemModel line(String price, {String qty = '1', String? tax, bool exempt = false}) =>
    CartItemModel(
      productId: 'p$price$qty',
      productName: 'Item',
      unitPrice: d(price),
      qty: d(qty),
      taxRate: tax == null ? null : d(tax),
      taxExempt: exempt,
    );

void main() {
  tearDown(() => TaxSettingsHolder.current = TaxSettings.defaults);

  group('money formatter (one formatter everywhere)', () {
    test('always two decimals by default', () {
      expect(formatPKR(6), 'Rs. 6.00');
      expect(formatPKR(Decimal.parse('7.02')), 'Rs. 7.02');
      expect(formatPKR('14.04'), 'Rs. 14.04');
      expect(formatPKR(1234567.5), 'Rs. 1,234,567.50');
      expect(formatPKR(0), 'Rs. 0.00');
      expect(formatPKR(null), 'Rs. 0.00');
    });

    test('hide-zero drops .00 only on whole amounts', () {
      TaxSettingsHolder.current =
          const TaxSettings(hideZeroDecimals: true);
      expect(formatPKR(6), 'Rs. 6');
      expect(formatPKR('6.00'), 'Rs. 6');
      expect(formatPKR('7.02'), 'Rs. 7.02');
      expect(formatPKR('7.50'), 'Rs. 7.50');
      expect(formatPKR(1000), 'Rs. 1,000');
      expect(formatMoneyNumber('21.06'), '21.06');
    });

    test('explicit flag overrides the setting; negatives and rounding', () {
      expect(formatPKR(6, hideZeroDecimals: true), 'Rs. 6');
      TaxSettingsHolder.current = const TaxSettings(hideZeroDecimals: true);
      expect(formatPKR(6, hideZeroDecimals: false), 'Rs. 6.00');
      expect(formatPKR('-1.06'), 'Rs. -1.06');
      expect(formatPKR('0.005'), 'Rs. 0.01'); // half away from zero
      expect(formatSignedMoney('-0.04'), '-0.04');
      expect(formatSignedMoney('2'), '+2');
    });

    test('never rounds to whole rupees (the old Rs. 7 bug)', () {
      expect(formatPKR('7.02'), isNot('Rs. 7'));
      expect(formatPKR('21.06'), 'Rs. 21.06');
    });
  });

  group('TaxSettings', () {
    test('reads the pulled app_settings map, wrapped or plain', () {
      final s = TaxSettings.fromMap({
        'tax.enabled': true,
        'tax.prices_include_tax': {'value': true},
        'tax.rounding_mode': 'nearest_5',
        'tax.label': 'Sales Tax',
        'tax.default_rate_id': 'r1',
        'tax.show_breakdown_on_receipt': false,
        'ui.hide_zero_decimals': true,
      });
      expect(s.inclusive, isTrue);
      expect(s.roundingMode, 'nearest_5');
      expect(s.label, 'Sales Tax');
      expect(s.defaultRateId, 'r1');
      expect(s.showBreakdown, isFalse);
      expect(s.hideZeroDecimals, isTrue);
    });

    test('inclusive pricing only applies while tax is enabled', () {
      expect(
        const TaxSettings(enabled: false, includeTax: true).inclusive,
        isFalse,
      );
    });

    test('missing or bad values fall back to the server defaults', () {
      final s = TaxSettings.fromMap({'tax.rounding_mode': 'weird', 'tax.label': ' '});
      expect(s, TaxSettings.defaults);
      expect(TaxSettings.fromMap(null), TaxSettings.defaults);
    });

    test('changing mode, rounding or the on/off switch needs the warning', () {
      const base = TaxSettings();
      expect(base.changesPricingVs(base.copyWith(includeTax: true)), isTrue);
      expect(base.changesPricingVs(base.copyWith(roundingMode: 'nearest_1')), isTrue);
      expect(base.changesPricingVs(base.copyWith(label: 'VAT')), isFalse);
      expect(base.changesPricingVs(base.copyWith(hideZeroDecimals: true)), isFalse);
    });
  });

  group('quantity popup breakdown', () {
    final exclusive = const TaxSettings();
    final inclusive = const TaxSettings(includeTax: true);

    test('tax added on top: price, tax, total', () {
      expect(
        LinePriceBreakdown.lines(
          qty: d('2'),
          unitPrice: d('6'),
          taxRate: d('17'),
          tax: exclusive,
        ),
        ['Price 6.00 x 2 = 12.00', 'GST 17%: 2.04', 'Total 14.04'],
      );
    });

    test('price includes tax: tax shown inside, total unchanged', () {
      expect(
        LinePriceBreakdown.lines(
          qty: d('2'),
          unitPrice: d('6'),
          taxRate: d('17'),
          tax: inclusive,
        ),
        ['Price 6.00 x 2 = 12.00 (includes GST 17%: 1.74)', 'Total 12.00'],
      );
    });

    test('nothing for tax-free lines or when tax is off', () {
      expect(
        LinePriceBreakdown.lines(
            qty: d('2'), unitPrice: d('6'), taxRate: Decimal.zero, tax: exclusive),
        isEmpty,
      );
      expect(
        LinePriceBreakdown.lines(
          qty: d('2'),
          unitPrice: d('6'),
          taxRate: d('17'),
          tax: const TaxSettings(enabled: false),
        ),
        isEmpty,
      );
    });

    test('fractional quantity and rate keep readable text', () {
      expect(
        LinePriceBreakdown.lines(
          qty: d('0.5'),
          unitPrice: d('99.99'),
          taxRate: d('17.5'),
          tax: exclusive,
        ).first,
        'Price 99.99 x 0.5 = 50.00',
      );
    });
  });

  group('cart totals with the settings in force', () {
    test('the earlier bug: price 6 at 17% GST is 7.02 / 14.04 / 21.06', () {
      TaxSettingsHolder.current = const TaxSettings();
      for (final (qty, total) in [('1', '7.02'), ('2', '14.04'), ('3', '21.06')]) {
        final t = PosCalculations.computeAuthoritativeTotals(
          items: [line('6', qty: qty, tax: '17')],
          cartDiscountType: null,
          cartDiscountValue: Decimal.zero,
        );
        expect(t.totalAmount, d(total));
        expect(formatPKR(t.totalAmount), 'Rs. $total');
      }
    });

    test('rounding to the nearest Rs. 5 gives a signed rounding line', () {
      TaxSettingsHolder.current = const TaxSettings(roundingMode: 'nearest_5');
      final t = PosCalculations.computeAuthoritativeTotals(
        items: [line('6', qty: '3', tax: '17')], // 21.06 -> 20.00
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );
      expect(t.exactTotal, d('21.06'));
      expect(t.totalAmount, d('20.00'));
      expect(t.roundingAmount, d('-1.06'));
      expect(t.hasRounding, isTrue);
    });

    test('no rounding line when the total is already round', () {
      TaxSettingsHolder.current = const TaxSettings(roundingMode: 'nearest_1');
      final t = PosCalculations.computeAuthoritativeTotals(
        items: [line('100', tax: '0')],
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );
      expect(t.hasRounding, isFalse);
    });

    test('inclusive prices: total equals the shelf prices, tax is inside', () {
      TaxSettingsHolder.current = const TaxSettings(includeTax: true);
      final t = PosCalculations.computeAuthoritativeTotals(
        items: [line('6', qty: '2', tax: '17')],
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );
      expect(t.totalAmount, d('12.00'));
      expect(t.totalTax, d('1.74'));
      expect(t.netAmount, d('10.26'));
    });

    test('tax-exempt items and a disabled business carry no tax', () {
      TaxSettingsHolder.current = const TaxSettings();
      final exempt = PosCalculations.computeAuthoritativeTotals(
        items: [line('6', tax: '17', exempt: true)],
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );
      expect(exempt.totalTax, Decimal.zero);
      TaxSettingsHolder.current = const TaxSettings(enabled: false);
      final off = PosCalculations.computeAuthoritativeTotals(
        items: [line('6', tax: '17')],
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );
      expect(off.totalAmount, d('6.00'));
    });

    test('tax lines are grouped by rate', () {
      TaxSettingsHolder.current = const TaxSettings();
      final groups = PosCalculations.computeTaxGroups(
        items: [
          line('100', tax: '17'),
          line('50', tax: '17'),
          line('200', tax: '5'),
          line('10'),
        ],
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );
      expect(groups.map((g) => g.title('GST')), ['GST 5%', 'GST 17%']);
      expect(groups[0].tax, d('10.00'));
      expect(groups[1].tax, d('25.50'));
    });

    test('fixed cart discount is shared and the sent lines sum to the total', () {
      TaxSettingsHolder.current = const TaxSettings();
      final items = [line('100', tax: '17'), line('49.99', qty: '2', tax: '5')];
      final t = PosCalculations.computeAuthoritativeTotals(
        items: items,
        cartDiscountType: 'fixed',
        cartDiscountValue: d('33.33'),
      );
      expect(t.totalDiscount, d('33.33'));
    });
  });

  group('payment with a rounded total', () {
    test('cash covers the rounded amount due and change is from it', () {
      final a = PaymentAllocator.allocate(
        total: d('20.00'), // 21.06 rounded to nearest 5
        inputs: [
          PaymentInput(method: PaymentMethods.cash, entered: d('50')),
        ],
      );
      expect(a.canComplete, isTrue);
      expect(a.change, d('30.00'));
    });

    test('split payments add up to the rounded total, not the exact one', () {
      final a = PaymentAllocator.allocate(
        total: d('20.00'),
        inputs: [
          PaymentInput(method: PaymentMethods.card, entered: d('12.50')),
          PaymentInput(method: PaymentMethods.cash, entered: d('7.50')),
        ],
      );
      expect(a.canComplete, isTrue);
      expect(a.remaining, Decimal.zero);
      expect(a.change, Decimal.zero);
    });

    test('credit is the remainder of the rounded total', () {
      final a = PaymentAllocator.allocate(
        total: d('20.00'),
        inputs: [
          PaymentInput(method: PaymentMethods.cash, entered: d('5')),
          PaymentInput(method: PaymentMethods.credit, entered: Decimal.zero),
        ],
        credit: const CreditContext(hasCustomer: true),
      );
      expect(a.creditAmount, d('15.00'));
    });
  });

  group('product card tag and rate resolution', () {
    final r17 = rate('r17', '17.000');
    final r5 = rate('r5', '5.000');
    String? tag(TaxSettings t,
            {bool exempt = false, String? own, TaxRateModel? def}) =>
        TaxRateResolver.cardTag(
          tax: t,
          taxExempt: exempt,
          ownRateId: own,
          rates: [r17, r5],
          defaultRate: def ?? r17,
        );

    test('+17% GST when tax is added on top', () {
      expect(tag(const TaxSettings()), '+17% GST');
    });

    test('incl. tax when prices include tax', () {
      expect(tag(const TaxSettings(includeTax: true)), 'incl. tax');
    });

    test('own rate beats the default; tax-free and disabled show nothing', () {
      expect(tag(const TaxSettings(), own: 'r5'), '+5% GST');
      expect(tag(const TaxSettings(), exempt: true), isNull);
      expect(tag(const TaxSettings(enabled: false)), isNull);
      expect(tag(const TaxSettings(label: 'VAT')), '+17% VAT');
    });

    test('a zero rate shows no tag', () {
      expect(tag(const TaxSettings(), def: rate('z', '0.000')), isNull);
    });
  });

  test('TaxGroup groups by rate and ignores untaxed lines', () {
    final g = TaxGroup.group([
      (rate: d('17'), net: d('10'), tax: d('1.70')),
      (rate: d('17.000'), net: d('20'), tax: d('3.40')),
      (rate: d('0'), net: d('5'), tax: d('0')),
    ], label: 'GST');
    expect(g, hasLength(1));
    expect(g.single.tax, d('5.10'));
    expect(g.single.title('x'), 'GST 17%');
  });
}
