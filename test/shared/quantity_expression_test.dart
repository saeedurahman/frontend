import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/shared/utils/quantity_expression.dart';

Decimal d(String v) => Decimal.parse(v);

void main() {
  group('QuantityExpression.evaluate', () {
    Decimal eval(String s) => QuantityExpression.evaluate(s);

    test('a plain number', () {
      expect(eval('9'), d('9'));
      expect(eval('012'), d('12'));
      expect(eval('2.5'), d('2.5'));
      expect(eval('.5'), d('0.5'));
      expect(eval('5.'), d('5'));
    });

    test('every operator, in every accepted spelling', () {
      expect(eval('3x3'), d('9'));
      expect(eval('3X3'), d('9'));
      expect(eval('3*3'), d('9'));
      expect(eval('3×3'), d('9'));
      expect(eval('12+6'), d('18'));
      expect(eval('12-6'), d('6'));
      expect(eval('12−6'), d('6'));
      expect(eval('10/4'), d('2.5'));
      expect(eval('10÷4'), d('2.5'));
      expect(eval(' 12 + 6 '), d('18'));
    });

    test('decimals are exact, never floating point', () {
      expect(eval('0.1+0.2'), d('0.3'));
      expect(eval('1.5x4'), d('6'));
      expect(eval('2.25x3'), d('6.75'));
    });

    test('× and ÷ bind tighter than + and -; same level runs left to right', () {
      expect(eval('2+3x4'), d('14'));
      expect(eval('2x3+4'), d('10'));
      expect(eval('10-4/2'), d('8'));
      expect(eval('12/3x2'), d('8'));
      expect(eval('10-3-2'), d('5'));
      expect(eval('6x5+4x3-10/5'), d('40'));
    });

    test('a division that never ends is cut, not thrown', () {
      expect(eval('10/3'), d('3.333333'));
    });

    test('division by zero', () {
      for (final s in ['10/0', '5/0.0', '1+4/0']) {
        expect(
          () => eval(s),
          throwsA(isA<QuantityExpressionException>().having(
            (e) => e.error,
            'error',
            QuantityError.divideByZero,
          )),
          reason: s,
        );
      }
    });

    test('anything that is not a complete expression is refused', () {
      for (final s in [
        '', ' ', '+', '3+', 'x3', '3++3', '3xx3', '1.2.3', '.', 'abc', '3+a',
        '-5', '(2+3)', '2e3', '1,5',
      ]) {
        expect(
          () => eval(s),
          throwsA(isA<QuantityExpressionException>().having(
            (e) => e.error,
            'error',
            QuantityError.invalid,
          )),
          reason: '"$s"',
        );
      }
    });

    test('trailing operators can be dropped before evaluating', () {
      expect(QuantityExpression.stripTrailingOperators('12+'), '12');
      expect(QuantityExpression.stripTrailingOperators('3x/'), '3');
      expect(QuantityExpression.stripTrailingOperators('+'), '');
    });
  });

  group('QuantityRules.parse', () {
    QuantityCheck whole(String s) => QuantityRules.parse(s, allowDecimal: false);
    QuantityCheck fractional(String s) => QuantityRules.parse(s, allowDecimal: true);

    test('nothing typed means one', () {
      expect(whole('').quantity, Decimal.one);
      expect(fractional('  ').quantity, Decimal.one);
    });

    test('the examples from the counter', () {
      expect(whole('9').quantity, d('9'));
      expect(whole('3x3').quantity, d('9'));
      expect(whole('12+6').quantity, d('18'));
      expect(fractional('10/4').quantity, d('2.5'));
      expect(whole('12+').quantity, d('12'), reason: 'trailing operator ignored');
    });

    test('whole-number units refuse fractions, however they arise', () {
      expect(whole('2.5').error, QuantityError.notWhole);
      expect(whole('10/4').error, QuantityError.notWhole);
      expect(whole('10/4').message, 'Whole numbers only for this item');
      expect(whole('10/5').quantity, d('2'), reason: 'a whole result is fine');
      expect(whole('1.5x2').quantity, d('3'));
    });

    test('decimal units keep three places, rounded half up', () {
      expect(fractional('0.125').quantity, d('0.125'));
      expect(fractional('10/3').quantity, d('3.333'));
      expect(fractional('2/3').quantity, d('0.667'));
      expect(fractional('0.0005').quantity, d('0.001'));
      expect(fractional('1.25x2').quantity, d('2.5'));
    });

    test('zero and negative results are refused', () {
      for (final s in ['0', '0.0', '5-5', '3-8', '0x4']) {
        expect(whole(s).error, QuantityError.notPositive, reason: s);
        expect(fractional(s).error, QuantityError.notPositive, reason: s);
      }
      expect(fractional('0.0004').error, QuantityError.notPositive,
          reason: 'rounds to zero');
      expect(whole('0').message, 'Quantity must be greater than 0');
    });

    test('absurd values are refused', () {
      expect(whole('999999').quantity, d('999999'));
      expect(whole('1000000').error, QuantityError.tooLarge);
      expect(whole('1000x1000').error, QuantityError.tooLarge);
      expect(fractional('999999.9999').error, QuantityError.tooLarge,
          reason: 'would round up to the limit');
      expect(whole('1000000').message, contains('too large'));
    });

    test('broken input and division by zero come back as errors', () {
      expect(whole('3++3').error, QuantityError.invalid);
      expect(whole('1.2.3').error, QuantityError.invalid);
      expect(whole('8/0').error, QuantityError.divideByZero);
      expect(whole('8/0').message, 'Cannot divide by zero');
      expect(whole('8/0').isOk, isFalse);
    });
  });

  group('QuantityRules.unitAllowsDecimal', () {
    test('weight, volume and length units are sold in fractions', () {
      for (final (name, symbol) in [
        ('Kilogram', 'kg'),
        ('Kilogram', 'KG'),
        ('Gram', 'g'),
        ('Litre', 'L'),
        ('Liter', 'ltr'),
        ('Millilitre', 'ml'),
        ('Meter', 'm'),
        ('Weight', 'Kg.'),
        ('Kilogram (kg)', 'x'),
      ]) {
        expect(
          QuantityRules.unitAllowsDecimal(name: name, symbol: symbol),
          isTrue,
          reason: '$name / $symbol',
        );
      }
    });

    test('count units and unknown units are whole numbers only', () {
      for (final (name, symbol) in [
        ('Piece', 'pcs'),
        ('Box', 'box'),
        ('Pack', 'pk'),
        ('Plate', 'plt'),
        ('Dozen', 'dz'),
        ('Bottle', 'btl'),
        ('Tablet', 'tab'),
      ]) {
        expect(
          QuantityRules.unitAllowsDecimal(name: name, symbol: symbol),
          isFalse,
          reason: '$name / $symbol',
        );
      }
      expect(QuantityRules.unitAllowsDecimal(), isFalse);
    });
  });
}
