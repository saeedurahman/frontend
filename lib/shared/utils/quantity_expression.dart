import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:rational/rational.dart';

/// Why a typed quantity cannot be used.
enum QuantityError {
  invalid,
  divideByZero,
  notPositive,
  tooLarge,
  notWhole,
  insufficientStock,
}

class QuantityExpressionException implements Exception {
  const QuantityExpressionException(this.error, this.message);
  final QuantityError error;
  final String message;

  @override
  String toString() => message;
}

/// A tiny arithmetic evaluator for the quantity keypad: numbers joined by
/// `+ - × ÷` (also `x`, `*`, `/`), with × ÷ binding tighter than + -.
/// Hand-written and exact (rationals, never `double`); nothing is `eval`ed.
abstract final class QuantityExpression {
  static const add = '+';
  static const subtract = '-';
  static const multiply = '×';
  static const divide = '÷';
  static const operators = '+-×÷';

  static bool isOperator(String char) =>
      char.length == 1 && operators.contains(char);

  /// Canonical operator symbols, no spaces.
  static String normalize(String input) => input
      .replaceAll(RegExp(r'\s'), '')
      .replaceAll(RegExp('[xX*]'), multiply)
      .replaceAll('/', divide)
      .replaceAll('−', subtract);

  /// Drops operators left hanging at the end ("12+" is read as 12).
  static String stripTrailingOperators(String input) {
    var s = normalize(input);
    while (s.isNotEmpty && isOperator(s[s.length - 1])) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  static final _number = RegExp(r'^(\d+\.?\d*|\.\d+)$');

  /// Evaluates [input]; throws [QuantityExpressionException] when it is not
  /// a complete expression or divides by zero.
  static Decimal evaluate(String input) {
    const invalid = QuantityExpressionException(
      QuantityError.invalid,
      'Enter a valid quantity',
    );
    final s = normalize(input);
    if (s.isEmpty) throw invalid;

    final numbers = <Rational>[];
    final ops = <String>[];
    final current = StringBuffer();
    void closeNumber() {
      final text = current.toString();
      if (!_number.hasMatch(text)) throw invalid;
      numbers.add(Decimal.parse(text.endsWith('.') ? '${text}0' : text).toRational());
      current.clear();
    }

    for (var i = 0; i < s.length; i++) {
      final c = s[i];
      if (isOperator(c)) {
        closeNumber();
        ops.add(c);
      } else {
        current.write(c);
      }
    }
    closeNumber();

    // × and ÷ first, left to right.
    final terms = <Rational>[numbers.first];
    final sums = <String>[];
    for (var i = 0; i < ops.length; i++) {
      final right = numbers[i + 1];
      switch (ops[i]) {
        case multiply:
          terms[terms.length - 1] = terms.last * right;
        case divide:
          if (right == Rational.zero) {
            throw const QuantityExpressionException(
              QuantityError.divideByZero,
              'Cannot divide by zero',
            );
          }
          terms[terms.length - 1] = terms.last / right;
        default:
          sums.add(ops[i]);
          terms.add(right);
      }
    }
    var total = terms.first;
    for (var i = 0; i < sums.length; i++) {
      total = sums[i] == add ? total + terms[i + 1] : total - terms[i + 1];
    }
    return total.toDecimal(scaleOnInfinitePrecision: 6);
  }
}

/// Outcome of checking a quantity: either a usable [quantity] or an [error].
class QuantityCheck {
  const QuantityCheck.ok(Decimal this.quantity)
      : error = null,
        message = null;
  const QuantityCheck.failed(QuantityError this.error, String this.message)
      : quantity = null;

  final Decimal? quantity;
  final QuantityError? error;
  final String? message;

  bool get isOk => quantity != null;
}

/// What a sellable quantity may look like.
abstract final class QuantityRules {
  /// Quantities at or above this are refused as typing mistakes.
  static final Decimal limit = Decimal.fromInt(1000000);

  /// Decimal places kept for weight / volume style units.
  static const maxDecimals = 3;

  /// Checks a computed [value]. Decimal units keep up to [maxDecimals] places
  /// (rounded half up); other units must be whole numbers.
  static QuantityCheck check(Decimal value, {required bool allowDecimal}) {
    const tooLarge = QuantityCheck.failed(
      QuantityError.tooLarge,
      'Quantity is too large (max 999,999)',
    );
    if (value >= limit) return tooLarge;
    var qty = value;
    if (allowDecimal) {
      qty = DecimalUtils.fromRational(value.toRational(), fractionDigits: maxDecimals);
      if (qty >= limit) return tooLarge; // rounded up to the limit
    } else if (value != value.truncate()) {
      return const QuantityCheck.failed(
        QuantityError.notWhole,
        'Whole numbers only for this item',
      );
    }
    if (qty <= Decimal.zero) {
      return const QuantityCheck.failed(
        QuantityError.notPositive,
        'Quantity must be greater than 0',
      );
    }
    return QuantityCheck.ok(qty);
  }

  /// Evaluates what was typed. Nothing typed means 1; a trailing operator is
  /// ignored ("12+" is 12).
  static QuantityCheck parse(String input, {required bool allowDecimal}) {
    final text = QuantityExpression.stripTrailingOperators(input);
    if (text.isEmpty) return QuantityCheck.ok(Decimal.one);
    try {
      return check(QuantityExpression.evaluate(text), allowDecimal: allowDecimal);
    } on QuantityExpressionException catch (e) {
      return QuantityCheck.failed(e.error, e.message);
    }
  }

  static const _decimalUnits = {
    // weight
    'kg', 'kgs', 'kilo', 'kilogram', 'kilograms', 'g', 'gm', 'gms', 'gram',
    'grams', 'mg', 'lb', 'lbs', 'pound', 'pounds', 'oz', 'ounce', 'ounces',
    'ton', 'tons', 'tonne', 'maund', 'mann', 'ser', 'seer', 'pao', 'tola',
    // volume
    'l', 'lt', 'ltr', 'ltrs', 'litre', 'litres', 'liter', 'liters', 'ml',
    'gal', 'gallon', 'gallons',
    // length / area
    'm', 'mtr', 'meter', 'meters', 'metre', 'metres', 'cm', 'mm', 'ft',
    'foot', 'feet', 'in', 'inch', 'inches', 'yd', 'yard', 'yards', 'gaz',
    'sqft', 'sqm',
  };

  /// Whether a unit is sold in fractions (weight, volume, length). The unit
  /// data only carries a name and a symbol, so this goes by those; anything
  /// unknown (pcs, box, pack, plate ...) is whole numbers only.
  static bool unitAllowsDecimal({String? name, String? symbol}) {
    bool known(String? raw) {
      if (raw == null) return false;
      final key = raw.trim().toLowerCase().replaceAll('.', '');
      if (_decimalUnits.contains(key)) return true;
      // "Kilogram (kg)", "Litre - L"
      return key
          .split(RegExp('[^a-z]+'))
          .any((part) => part.length > 1 && _decimalUnits.contains(part));
    }

    return known(symbol) || known(name);
  }
}
