import 'package:decimal/decimal.dart';
import 'package:frantend/shared/utils/quantity_expression.dart';

/// Reads what the owner typed or tapped on the calculator keypad into a plain
/// money amount: `250`, `250.5`, or a sum such as `1200+350`.
abstract final class MoneyInput {
  static bool hasOperator(String raw) =>
      raw.split('').any(QuantityExpression.isOperator);

  /// The amount as `123.45` (two decimals), or null while the text is empty,
  /// incomplete (`12+`) or not a number.
  static String? resolve(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    try {
      final value = hasOperator(text)
          ? QuantityExpression.evaluate(text)
          : Decimal.tryParse(text.endsWith('.') ? '${text}0' : text);
      if (value == null || value <= Decimal.zero) return null;
      if (!hasOperator(text)) {
        // Typed digits are kept as typed so "too many decimals" can be shown.
        final dot = text.indexOf('.');
        if (dot >= 0 && text.length - dot - 1 > 2) return text;
        return value.toStringAsFixed(2);
      }
      return value.round(scale: 2).toStringAsFixed(2);
    } on QuantityExpressionException {
      return null;
    }
  }

  /// Digits as shown to the user for [value], without trailing zeros.
  static String plain(Decimal value) {
    final text = value.toStringAsFixed(2);
    return text.endsWith('.00') ? text.substring(0, text.length - 3) : text;
  }
}
