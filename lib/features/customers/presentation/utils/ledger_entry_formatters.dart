import 'package:frantend/core/utils/date_formatter.dart';

String formatLedgerEntryDate(String? value) {
  if (value == null || value.isEmpty) return '—';
  try {
    return DateFormatter.formatDateTime(DateTime.parse(value));
  } catch (_) {
    return value;
  }
}
