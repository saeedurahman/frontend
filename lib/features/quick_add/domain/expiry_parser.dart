/// Reads an expiry date typed in the Expiry cell.
///
/// Accepted (separators `/`, `-`, `.` or none):
///   `30/06/2027`, `30-6-27`, `2027-06-30`, `06/2027`, `6/27`, `0627`, `30062027`
///
/// A month and year without a day (`06/2027`, `0627`) means the LAST day of
/// that month, because that is how pack expiry dates are printed.
abstract final class ExpiryParser {
  /// Null when [text] is empty or not a real date.
  static DateTime? parse(String text, {DateTime? now}) {
    final t = text.trim();
    if (t.isEmpty) return null;
    final today = now ?? DateTime.now();

    final iso = RegExp(r'^(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})$').firstMatch(t);
    if (iso != null) {
      return _make(int.parse(iso.group(1)!), int.parse(iso.group(2)!), int.parse(iso.group(3)!));
    }

    final dmy = RegExp(r'^(\d{1,2})[-/.](\d{1,2})[-/.](\d{2}|\d{4})$').firstMatch(t);
    if (dmy != null) {
      return _make(_year(dmy.group(3)!, today), int.parse(dmy.group(2)!), int.parse(dmy.group(1)!));
    }

    final my = RegExp(r'^(\d{1,2})[-/.](\d{2}|\d{4})$').firstMatch(t);
    if (my != null) {
      return _monthEnd(_year(my.group(2)!, today), int.parse(my.group(1)!));
    }

    final digits = RegExp(r'^\d+$').hasMatch(t) ? t : null;
    if (digits != null) {
      if (digits.length == 4) {
        return _monthEnd(_year(digits.substring(2), today), int.parse(digits.substring(0, 2)));
      }
      if (digits.length == 6) {
        return _monthEnd(int.parse(digits.substring(2)), int.parse(digits.substring(0, 2)));
      }
      if (digits.length == 8) {
        return _make(
          int.parse(digits.substring(4)),
          int.parse(digits.substring(2, 4)),
          int.parse(digits.substring(0, 2)),
        );
      }
    }
    return null;
  }

  /// `30/06/2027`, the form the cell shows.
  static String format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  /// Two-digit years are 20xx (pack dates are never in the last century).
  static int _year(String y, DateTime today) {
    final n = int.parse(y);
    return y.length == 2 ? 2000 + n : n;
  }

  static DateTime? _monthEnd(int year, int month) {
    if (month < 1 || month > 12) return null;
    return DateTime(year, month + 1, 0);
  }

  static DateTime? _make(int year, int month, int day) {
    if (month < 1 || month > 12 || day < 1) return null;
    if (year < 2000 || year > 2200) return null;
    final last = DateTime(year, month + 1, 0).day;
    if (day > last) return null;
    return DateTime(year, month, day);
  }
}
