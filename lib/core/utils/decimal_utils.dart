import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

abstract final class DecimalUtils {
  static Decimal parse(String value) => Decimal.parse(value);

  static Decimal fromNum(num value) => Decimal.parse(value.toString());

  static String format(Decimal value, {int fractionDigits = 2}) {
    return value.toStringAsFixed(fractionDigits);
  }

  static Decimal add(Decimal a, Decimal b) => a + b;

  static Decimal subtract(Decimal a, Decimal b) => a - b;

  static Decimal multiply(Decimal a, Decimal b) => a * b;

  static Decimal roundMoney(Decimal value, {int fractionDigits = 2}) {
    return Decimal.parse(value.toStringAsFixed(fractionDigits));
  }

  /// Exact rational -> fixed-scale decimal, rounding half away from zero
  /// (Python `ROUND_HALF_UP`). Never goes through `double`, so ties such as
  /// 1.005 round to 1.01 exactly like the backend pricing engine.
  static Decimal fromRational(Rational value, {int fractionDigits = 2}) {
    final factor = BigInt.from(10).pow(fractionDigits);
    final scaled = (value * Rational(factor)).round();
    return Rational(scaled, factor).toDecimal();
  }
}
