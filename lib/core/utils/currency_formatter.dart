import 'package:intl/intl.dart';

abstract final class CurrencyFormatter {
  static final NumberFormat _pkrFormat = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs. ',
    decimalDigits: 2,
  );

  static String formatPkr(num amount) => _pkrFormat.format(amount);

  static String formatPkrCompact(num amount) {
    if (amount >= 1000000) {
      return 'Rs. ${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return 'Rs. ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return formatPkr(amount);
  }
}
