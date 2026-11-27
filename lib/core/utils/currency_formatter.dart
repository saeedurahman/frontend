import 'package:decimal/decimal.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:intl/intl.dart';
import 'package:frantend/core/utils/currency_label.dart';

final NumberFormat _twoDecimals = NumberFormat('#,##0.00', 'en_US');

final RegExp _thousands = RegExp(r'\B(?=(\d{3})+(?!\d))');

/// The one way money is shown in the app (POS card, calculator, cart, payment,
/// receipts, sale detail, lists, reports).
///
/// Always two decimals ("7.02", "6.00") and never rounded to whole rupees.
/// When the owner turned on "Hide .00 on whole amounts" (`ui.hide_zero_decimals`)
/// a whole amount loses its decimals ("6") while 7.02 stays "7.02".
///
/// Returns the number only, e.g. "1,234.50". [formatPKR] adds the label.
String formatMoneyNumber(dynamic amount, {bool? hideZeroDecimals}) {
  final hide = hideZeroDecimals ?? TaxSettingsHolder.current.hideZeroDecimals;
  final value = _toDecimal(amount);
  final negative = value < Decimal.zero;
  final abs = negative ? -value : value;
  // Round half away from zero to the cent on exact decimals (no double maths).
  final cents = (abs * Decimal.fromInt(100)).round();
  final whole = cents.toBigInt() ~/ BigInt.from(100);
  final fraction = (cents.toBigInt() % BigInt.from(100)).toInt();
  final wholeText = whole.toString().replaceAll(_thousands, ',');
  final body = hide && fraction == 0
      ? wholeText
      : '$wholeText.${fraction.toString().padLeft(2, '0')}';
  final isZero = whole == BigInt.zero && fraction == 0;
  return negative && !isZero ? '-$body' : body;
}

/// "Rs. 7.02" with the business's money label. See [formatMoneyNumber].
String formatPKR(dynamic amount, {bool? hideZeroDecimals}) =>
    '$currencyLabel ${formatMoneyNumber(amount, hideZeroDecimals: hideZeroDecimals)}';

/// Same as [formatPKR] with an explicit sign, for adjustments such as
/// "Rounding -1.06" / "+2.00" (no "Rs." prefix).
String formatSignedMoney(dynamic amount, {bool? hideZeroDecimals}) {
  final value = _toDecimal(amount);
  final text = formatMoneyNumber(value.abs(), hideZeroDecimals: hideZeroDecimals);
  if (value < Decimal.zero) return '-$text';
  if (value > Decimal.zero) return '+$text';
  return text;
}

String formatCompact(double amount) {
  final absolute = amount.abs();
  if (absolute >= 1000000000) {
    return '${(amount / 1000000000).toStringAsFixed(1)}B';
  }
  if (absolute >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(1)}M';
  }
  if (absolute >= 1000) {
    return '${(amount / 1000).toStringAsFixed(1)}K';
  }
  return _twoDecimals.format(amount).replaceAll(RegExp(r'\.00$'), '');
}

Decimal _toDecimal(dynamic value) {
  if (value == null) return Decimal.zero;
  if (value is Decimal) return value;
  if (value is int) return Decimal.fromInt(value);
  if (value is num) {
    if (value.isNaN || value.isInfinite) return Decimal.zero;
    return Decimal.tryParse(value.toString()) ??
        Decimal.tryParse(value.toStringAsFixed(6)) ??
        Decimal.zero;
  }
  return Decimal.tryParse(value.toString().trim()) ?? Decimal.zero;
}
