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

  static Decimal fromRational(Rational value, {int fractionDigits = 2}) {
    return Decimal.parse(value.toDouble().toStringAsFixed(fractionDigits));
  }
}
