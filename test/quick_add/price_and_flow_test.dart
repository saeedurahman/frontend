import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/quick_add/domain/expiry_parser.dart';
import 'package:frantend/features/quick_add/domain/price_suggestion.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/domain/quick_add_settings.dart';

Decimal d(String s) => Decimal.parse(s);

void main() {
  group('suggested price', () {
    Decimal? suggest(String cost, String margin, String rounding) =>
        PriceSuggestion.fromCost(
          cost: d(cost),
          marginPercent: d(margin),
          rounding: rounding,
        );

    test('the worked example: cost 80, margin 15% -> 92', () {
      expect(suggest('80', '15', 'nearest_1'), d('92'));
    });

    test('nearest 1 rounds half up', () {
      expect(suggest('50', '15', 'nearest_1'), d('58')); // 57.5
      expect(suggest('10', '12', 'nearest_1'), d('11')); // 11.2
    });

    test('nearest 5', () {
      expect(suggest('80', '15', 'nearest_5'), d('90')); // 92 -> 90
      expect(suggest('50', '15', 'nearest_5'), d('60')); // 57.5 -> 60
      expect(suggest('100', '2.5', 'nearest_5'), d('105')); // 102.5 -> 105 (half up)
    });

    test('nearest 10', () {
      expect(suggest('80', '15', 'nearest_10'), d('90'));
      expect(suggest('85', '15', 'nearest_10'), d('100')); // 97.75
    });

    test('none keeps paisa, rounded half up to 2 places', () {
      expect(suggest('80', '15', 'none'), d('92'));
      expect(suggest('33.33', '15', 'none'), d('38.33')); // 38.3295
      expect(suggest('1.005', '0', 'none'), d('1.01'));
    });

    test('margin 0 gives the cost, big margins work', () {
      expect(suggest('80', '0', 'nearest_1'), d('80'));
      expect(suggest('80', '1000', 'nearest_1'), d('880'));
    });

    test('no cost, zero or negative cost: nothing to suggest', () {
      expect(PriceSuggestion.fromCost(cost: null, marginPercent: d('15'), rounding: 'none'), isNull);
      expect(suggest('0', '15', 'none'), isNull);
      expect(suggest('-5', '15', 'none'), isNull);
    });

    test('an unknown rounding mode falls back to nearest 1', () {
      expect(suggest('80', '15', 'banana'), d('92'));
    });

    test('MRP wins over cost + margin', () {
      expect(
        PriceSuggestion.forRow(mrp: d('120'), cost: d('80'), marginPercent: d('15'), rounding: 'nearest_1'),
        d('120'),
      );
      expect(
        PriceSuggestion.forRow(mrp: d('0'), cost: d('80'), marginPercent: d('15'), rounding: 'nearest_1'),
        d('92'),
      );
    });
  });

  group('settings', () {
    test('defaults match the server', () {
      final s = QuickAddSettings.fromMap(null);
      expect(s.askCost, isTrue);
      expect(s.askExpiry, isFalse);
      expect(s.defaultMarginPercent, d('15'));
      expect(s.rounding, 'nearest_1');
      expect(s.requireBatch, isFalse);
    });

    test('reads wrapped values and ignores bad ones', () {
      final s = QuickAddSettings.fromMap({
        'quick_add.ask_cost': {'value': false},
        'quick_add.ask_expiry': true,
        'pricing.default_margin_percent': {'value': 22.5},
        'pricing.suggested_price_rounding': 'nearest_5',
        'inventory.require_batch': {'value': true},
      });
      expect(s.askCost, isFalse);
      expect(s.askExpiry, isTrue);
      expect(s.defaultMarginPercent, d('22.5'));
      expect(s.rounding, 'nearest_5');
      expect(s.requireBatch, isTrue);

      final bad = QuickAddSettings.fromMap({
        'pricing.default_margin_percent': 'lots',
        'pricing.suggested_price_rounding': 'banana',
        'quick_add.ask_cost': 'yes',
      });
      expect(bad.defaultMarginPercent, d('15'));
      expect(bad.rounding, 'nearest_1');
      expect(bad.askCost, isTrue);

      expect(
        QuickAddSettings.fromMap({'pricing.default_margin_percent': 5000}).defaultMarginPercent,
        d('15'),
      );
    });

    test('the value map sends numbers as numbers', () {
      final map = QuickAddSettings(defaultMarginPercent: d('20')).toValueMap();
      expect(map['pricing.default_margin_percent'], 20);
      expect(QuickAddSettings(defaultMarginPercent: d('12.5')).toValueMap()['pricing.default_margin_percent'], 12.5);
    });

    test('the live example the settings card shows', () {
      final s = QuickAddSettings(defaultMarginPercent: d('15'));
      expect(s.suggest(cost: d('80')), d('92'));
    });
  });

  group('expiry parser', () {
    final now = DateTime(2026, 11, 20);
    DateTime? p(String s) => ExpiryParser.parse(s, now: now);

    test('full dates', () {
      expect(p('30/06/2027'), DateTime(2027, 6, 30));
      expect(p('30-6-27'), DateTime(2027, 6, 30));
      expect(p('2027-06-30'), DateTime(2027, 6, 30));
      expect(p('30062027'), DateTime(2027, 6, 30));
    });

    test('month and year mean the last day', () {
      expect(p('06/2027'), DateTime(2027, 6, 30));
      expect(p('6/27'), DateTime(2027, 6, 30));
      expect(p('0627'), DateTime(2027, 6, 30));
      expect(p('02/2028'), DateTime(2028, 2, 29));
    });

    test('rubbish is null', () {
      expect(p(''), isNull);
      expect(p('soon'), isNull);
      expect(p('31/04/2027'), isNull);
      expect(p('13/2027'), isNull);
      expect(p('00/27'), isNull);
    });

    test('round trip', () {
      expect(ExpiryParser.format(DateTime(2027, 6, 5)), '05/06/2027');
      expect(p(ExpiryParser.format(DateTime(2027, 6, 5))), DateTime(2027, 6, 5));
    });
  });

  group('keyboard flow', () {
    final settings = QuickAddSettings();
    QuickAddRow newRow({String name = '', Decimal? cost, bool track = false, String batch = '', DateTime? expiry}) =>
        QuickAddRow(
          id: 'r',
          barcode: '8964000370018',
          name: name,
          cost: cost,
          trackExpiry: track,
          batchNo: batch,
          expiry: expiry,
        );
    final known = QuickAddRow(
      id: 'k',
      barcode: '8964000370018',
      name: 'Lux',
      productId: 'p1',
      cost: d('50'),
      salePrice: d('70'),
    );

    test('new item: Name -> Cost -> Sale price -> scan field', () {
      final r = newRow();
      expect(QuickAddFlow.firstStop(r, settings, QuickAddMode.openingStock), QuickAddField.name);
      expect(QuickAddFlow.nextAfter(newRow(name: 'Soap'), QuickAddField.name, settings, QuickAddMode.openingStock),
          QuickAddField.cost);
      expect(QuickAddFlow.nextAfter(newRow(name: 'Soap', cost: d('5')), QuickAddField.cost, settings, QuickAddMode.openingStock),
          QuickAddField.salePrice);
      expect(QuickAddFlow.nextAfter(newRow(name: 'Soap', cost: d('5')), QuickAddField.salePrice, settings, QuickAddMode.openingStock),
          isNull);
    });

    test('ask_cost off skips the cost cell', () {
      final s = QuickAddSettings(askCost: false);
      expect(QuickAddFlow.nextAfter(newRow(name: 'Soap'), QuickAddField.name, s, QuickAddMode.openingStock),
          QuickAddField.salePrice);
    });

    test('pharmacy: batch and expiry come after the sale price, unless scanned', () {
      final r = newRow(name: 'Panadol', cost: d('5'), track: true);
      expect(QuickAddFlow.nextAfter(r, QuickAddField.salePrice, settings, QuickAddMode.openingStock), QuickAddField.batch);
      expect(QuickAddFlow.nextAfter(r, QuickAddField.batch, settings, QuickAddMode.openingStock), QuickAddField.expiry);
      expect(QuickAddFlow.nextAfter(r, QuickAddField.expiry, settings, QuickAddMode.openingStock), isNull);

      final scanned = newRow(name: 'Panadol', cost: d('5'), track: true, batch: 'B1', expiry: DateTime(2027, 6, 30));
      expect(QuickAddFlow.nextAfter(scanned, QuickAddField.salePrice, settings, QuickAddMode.openingStock), isNull);
    });

    test('known item with a cost goes straight back to the scan field', () {
      expect(QuickAddFlow.firstStop(known, settings, QuickAddMode.openingStock), isNull);
    });

    test('known item: purchase mode asks the cost paid; unknown cost asks it too', () {
      expect(QuickAddFlow.firstStop(known, settings, QuickAddMode.purchase), QuickAddField.cost);
      expect(QuickAddFlow.firstStop(known.copyWith(clearCost: true), settings, QuickAddMode.openingStock), QuickAddField.cost);
      expect(QuickAddFlow.nextAfter(known, QuickAddField.cost, settings, QuickAddMode.purchase), isNull);
    });

    test('other cells return to the scan field', () {
      expect(QuickAddFlow.nextAfter(newRow(name: 'x'), QuickAddField.qty, settings, QuickAddMode.openingStock), isNull);
    });
  });

  group('validation', () {
    final settings = QuickAddSettings();
    final now = DateTime(2026, 11, 20);
    Map<QuickAddField, String> check(QuickAddRow r,
            {QuickAddSettings? s, QuickAddMode mode = QuickAddMode.openingStock}) =>
        QuickAddValidator.validate(r, settings: s ?? settings, mode: mode, now: now);
    QuickAddRow row({String name = 'Soap', String qty = '1', Decimal? cost, Decimal? price, bool track = false, String batch = '', DateTime? expiry}) =>
        QuickAddRow(id: 'r', barcode: '123', name: name, qty: d(qty), cost: cost, salePrice: price, trackExpiry: track, batchNo: batch, expiry: expiry);

    test('a good row has no errors', () {
      expect(check(row(cost: d('5'), price: d('7'))), isEmpty);
    });

    test('a new item needs a name, a known one does not', () {
      expect(check(row(name: ' ')).keys, contains(QuickAddField.name));
      expect(check(QuickAddRow(id: 'k', barcode: '1', productId: 'p')), isEmpty);
    });

    test('negative numbers are refused', () {
      expect(check(row(qty: '-1')).keys, contains(QuickAddField.qty));
      expect(check(row(cost: d('-1'))).keys, contains(QuickAddField.cost));
      expect(check(row(price: d('-1'))).keys, contains(QuickAddField.salePrice));
    });

    test('price 0 and qty 0 are allowed (needs details later / no stock)', () {
      expect(check(row(qty: '0', price: d('0'))), isEmpty);
    });

    test('purchase mode needs the cost that was paid', () {
      expect(check(row(), mode: QuickAddMode.purchase).keys, contains(QuickAddField.cost));
      expect(check(row(cost: d('5')), mode: QuickAddMode.purchase), isEmpty);
      expect(check(row(qty: '0'), mode: QuickAddMode.purchase), isEmpty);
    });

    test('expiry is required for tracked items with stock', () {
      expect(check(row(track: true)).keys, contains(QuickAddField.expiry));
      expect(check(row(track: true, expiry: DateTime(2027, 6, 30))), isEmpty);
      expect(check(row(track: true, qty: '0')), isEmpty, reason: 'no stock, no expiry needed');
    });

    test('an expiry date in the past is refused', () {
      expect(check(row(track: true, expiry: DateTime(2026, 11, 19))).keys, contains(QuickAddField.expiry));
      expect(check(row(track: true, expiry: DateTime(2026, 11, 20))), isEmpty, reason: 'today is fine');
    });

    test('batch is required only when the shop setting says so', () {
      expect(check(row()), isEmpty);
      final strict = QuickAddSettings(requireBatch: true);
      expect(check(row(), s: strict).keys, contains(QuickAddField.batch));
      expect(check(row(batch: 'B1'), s: strict), isEmpty);
    });
  });
}
