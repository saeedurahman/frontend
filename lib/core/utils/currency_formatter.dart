import 'package:intl/intl.dart';

final NumberFormat _pkrFormatter = NumberFormat.currency(
  locale: 'en_PK',
  symbol: '',
  decimalDigits: 0,
);

String formatPKR(dynamic amount) {
  final value = _toDouble(amount);
  return 'Rs. ${_pkrFormatter.format(value).trim()}';
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
  return amount.toStringAsFixed(0);
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
