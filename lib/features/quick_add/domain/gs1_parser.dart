import 'barcode_normalizer.dart';

/// Things that looked wrong in a GS1 scan. None of them stops the scan: the
/// fields that did parse are still used.
enum Gs1Issue {
  /// The GTIN check digit does not add up.
  badGtinCheckDigit,

  /// AI 17 was not a real date (month 13, 31 February...).
  badExpiry,

  /// An application identifier we do not know ended the parse early.
  unknownAi,

  /// The string ended in the middle of a field.
  truncated,
}

/// What one GS1 element string carries (AI 01, 10, 17, 21).
class Gs1Scan {
  const Gs1Scan({
    required this.gtin,
    this.batch,
    this.expiry,
    this.expiryDayWasZero = false,
    this.serial,
    this.issues = const [],
  });

  /// AI 01, always 14 digits.
  final String gtin;

  /// AI 10, lot / batch number.
  final String? batch;

  /// AI 17, date only. Day `00` is the last day of that month.
  final DateTime? expiry;
  final bool expiryDayWasZero;

  /// AI 21, serial number (kept for completeness; Quick Add does not use it).
  final String? serial;
  final List<Gs1Issue> issues;

  /// The retail barcode of this item: a GTIN-14 whose indicator digit is 0 is
  /// the EAN-13 / UPC-A it wraps, so that is what the product is stored under.
  String get barcode => gtin.startsWith('0') ? gtin.substring(1) : gtin;

  @override
  String toString() => 'Gs1Scan($gtin, batch: $batch, expiry: $expiry, serial: $serial)';
}

/// Parses GS1 element strings from a scanner.
///
/// Both spellings are understood:
///   * bracketed (human readable): `(01)08964000370018(10)B17(17)270630`
///   * raw, with FNC1 sent as the ASCII group separator `\x1D` after a
///     variable-length field: `010896400037001810B17\x1D17270630`
///
/// Scanner decoration is tolerated: an AIM prefix (`]C1`, `]d2`, `]Q3`),
/// control characters and line ends around the code.
abstract final class Gs1Parser {
  static const gs = '\x1D';

  /// Fixed-length AIs (value length).
  static const _fixed = <String, int>{
    '00': 18,
    '01': 14,
    '02': 14,
    '11': 6,
    '12': 6,
    '13': 6,
    '15': 6,
    '16': 6,
    '17': 6,
    '20': 2,
  };

  /// Variable-length AIs (maximum value length).
  static const _variable = <String, int>{
    '10': 20,
    '21': 20,
    '22': 20,
    '30': 8,
    '37': 8,
    '240': 30,
    '241': 30,
    '242': 6,
    '243': 20,
    '250': 30,
    '251': 30,
    '253': 30,
    '254': 20,
    '400': 30,
    '401': 30,
    '420': 20,
    '421': 15,
    '90': 30,
    '91': 90,
    '92': 90,
    '93': 90,
    '94': 90,
    '95': 90,
    '96': 90,
    '97': 90,
    '98': 90,
    '99': 90,
  };

  static final _measure = RegExp(r'^3[1-6][0-9]{2}$');

  static bool _isControl(int u) => u < 0x20 || u == 0x7F;

  /// Strips scanner decoration from both ends (control characters, the group
  /// separator, spaces) and a leading AIM identifier.
  static String _clean(String input) {
    var s = input;
    var start = 0;
    var end = s.length;
    while (start < end && (_isControl(s.codeUnitAt(start)) || s[start] == ' ')) {
      start++;
    }
    while (end > start && (_isControl(s.codeUnitAt(end - 1)) || s[end - 1] == ' ')) {
      end--;
    }
    s = s.substring(start, end);
    if (s.length >= 3 &&
        s[0] == ']' &&
        RegExp(r'[A-Za-z]').hasMatch(s[1]) &&
        RegExp(r'[A-Za-z0-9]').hasMatch(s[2])) {
      s = s.substring(3);
    }
    return s;
  }

  /// True when [input] looks like an element string rather than a plain
  /// barcode (cheap check, used before the full parse).
  static bool looksLikeGs1(String input) {
    final s = _clean(input);
    if (s.contains('(01)')) return true;
    return s.length >= 16 && s.startsWith('01') && RegExp(r'^01[0-9]{14}').hasMatch(s);
  }

  /// The parsed scan, or null when [input] is not a GS1 string with a GTIN
  /// (a plain barcode, or garbage). [now] only pins the two-digit-year window.
  static Gs1Scan? parse(String input, {DateTime? now}) {
    final s = _clean(input);
    if (s.isEmpty) return null;
    final pairs = s.contains('(') ? _bracketed(s) : _raw(s);
    if (pairs == null) return null;
    return _build(pairs.values, pairs.issues, strict: !s.contains('('), now: now);
  }

  // ── element extraction ────────────────────────────────────────────────

  static ({Map<String, String> values, List<Gs1Issue> issues})? _bracketed(String s) {
    final values = <String, String>{};
    final matches = RegExp(r'\((\d{2,4})\)([^(]*)').allMatches(s);
    if (matches.isEmpty) return null;
    for (final m in matches) {
      final ai = m.group(1)!;
      final value = m.group(2)!.split(gs).first.trim();
      if (value.isEmpty) continue;
      values.putIfAbsent(ai, () => value);
    }
    return (values: values, issues: <Gs1Issue>[]);
  }

  static ({Map<String, String> values, List<Gs1Issue> issues})? _raw(String s) {
    final values = <String, String>{};
    final issues = <Gs1Issue>[];
    var i = 0;
    while (i < s.length) {
      if (s[i] == gs) {
        i++;
        continue;
      }
      // Longest identifier first: 4-digit measures, then 3, then 2.
      String? ai;
      for (final len in const [4, 3, 2]) {
        if (i + len > s.length) continue;
        final candidate = s.substring(i, i + len);
        if (len == 4 ? _measure.hasMatch(candidate) : (_fixed.containsKey(candidate) || _variable.containsKey(candidate))) {
          ai = candidate;
          break;
        }
      }
      if (ai == null) {
        issues.add(Gs1Issue.unknownAi);
        break;
      }
      final valueStart = i + ai.length;
      if (_measure.hasMatch(ai) || _fixed.containsKey(ai)) {
        final len = _measure.hasMatch(ai) ? 6 : _fixed[ai]!;
        if (valueStart + len > s.length) {
          issues.add(Gs1Issue.truncated);
          break;
        }
        values.putIfAbsent(ai, () => s.substring(valueStart, valueStart + len));
        i = valueStart + len;
      } else {
        final max = _variable[ai]!;
        final sep = s.indexOf(gs, valueStart);
        var end = sep == -1 ? s.length : sep;
        if (end - valueStart > max) end = valueStart + max;
        if (end == valueStart) {
          issues.add(Gs1Issue.truncated);
          break;
        }
        values.putIfAbsent(ai, () => s.substring(valueStart, end));
        i = end;
      }
    }
    return (values: values, issues: issues);
  }

  // ── interpretation ────────────────────────────────────────────────────

  static Gs1Scan? _build(
    Map<String, String> values,
    List<Gs1Issue> issues, {
    required bool strict,
    DateTime? now,
  }) {
    var gtin = values['01'] ?? values['02'];
    if (gtin == null) return null;
    gtin = gtin.replaceAll(RegExp(r'\s'), '');
    if (!RegExp(r'^[0-9]+$').hasMatch(gtin) || gtin.length > 14) return null;
    gtin = gtin.padLeft(14, '0');

    final allIssues = [...issues];
    final checkOk = BarcodeNormalizer.isValidGtin(gtin);
    // A raw string without brackets is only trusted when it is clean: this is
    // what keeps a plain numeric code that happens to start with 01 a plain code.
    if (strict && (!checkOk || issues.isNotEmpty)) return null;
    if (!checkOk) allIssues.add(Gs1Issue.badGtinCheckDigit);

    DateTime? expiry;
    var dayZero = false;
    final rawExpiry = values['17'];
    if (rawExpiry != null) {
      final parsed = parseDate(rawExpiry, now: now);
      if (parsed == null) {
        allIssues.add(Gs1Issue.badExpiry);
      } else {
        expiry = parsed.date;
        dayZero = parsed.dayWasZero;
      }
    }

    return Gs1Scan(
      gtin: gtin,
      batch: values['10'],
      expiry: expiry,
      expiryDayWasZero: dayZero,
      serial: values['21'],
      issues: allIssues,
    );
  }

  /// `YYMMDD` of a GS1 date AI. Day `00` means the last day of the month. The
  /// two-digit year follows the GS1 rule: the year within 49 years before to
  /// 50 years after [now].
  static ({DateTime date, bool dayWasZero})? parseDate(String yymmdd, {DateTime? now}) {
    if (!RegExp(r'^[0-9]{6}$').hasMatch(yymmdd)) return null;
    final yy = int.parse(yymmdd.substring(0, 2));
    final mm = int.parse(yymmdd.substring(2, 4));
    var dd = int.parse(yymmdd.substring(4, 6));
    if (mm < 1 || mm > 12) return null;

    final today = now ?? DateTime.now();
    var year = (today.year ~/ 100) * 100 + yy;
    if (year - today.year > 50) {
      year -= 100;
    } else if (year - today.year <= -50) {
      year += 100;
    }

    final lastDay = DateTime(year, mm + 1, 0).day;
    final zero = dd == 0;
    if (zero) dd = lastDay;
    if (dd < 1 || dd > lastDay) return null;
    return (date: DateTime(year, mm, dd), dayWasZero: zero);
  }
}
