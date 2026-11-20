/// Barcode normalisation for Quick Add.
///
/// A line-by-line port of the backend's `app/services/barcode_utils.py` (the
/// ONE place that decides what a scanned code means), so the app and the server
/// always agree on duplicates:
///
/// * digits only: spaces, dashes, control characters, a leading `]E0`-style
///   scanner prefix and Arabic-Indic digits are handled;
/// * EAN-8, UPC-A (12), EAN-13 and GTIN-14 check digits are validated, a wrong
///   check digit or an unknown length only sets [NormalizedBarcode.valid] to
///   false. Nothing is ever rejected;
/// * a UPC-A is stored as EAN-13 with a leading `0`;
/// * a code with letters is a custom (in-store) code, kept verbatim.
library;

class NormalizedBarcode {
  const NormalizedBarcode({
    required this.raw,
    required this.digits,
    required this.canonical,
    required this.format,
    required this.valid,
    this.forms = const [],
    this.lookupForms = const [],
    this.custom = false,
  });

  static const empty = NormalizedBarcode(
    raw: '',
    digits: '',
    canonical: '',
    format: 'EMPTY',
    valid: false,
  );

  final String raw;
  final String digits;

  /// The form the server stores for a new barcode.
  final String canonical;

  /// `EAN8 | UPCA | EAN13 | GTIN14 | UNKNOWN | EMPTY`.
  final String format;
  final bool valid;

  /// Every zero-padded spelling of the same trade item (duplicate checks).
  final List<String> forms;

  /// [forms] plus the base item of a GTIN-14 case code (lookup only).
  final List<String> lookupForms;

  /// Contains letters: kept as typed, never cross-matched by its digits.
  final bool custom;

  bool get isEmpty => digits.isEmpty;

  /// True when the code is a real GTIN length but its check digit is wrong:
  /// the screen shows a warning but never blocks.
  bool get hasBadCheckDigit =>
      !custom &&
      !isEmpty &&
      BarcodeNormalizer.gtinLengths.contains(digits.length) &&
      !valid;

  /// Value for the barcode `barcode_type` column.
  String get barcodeType =>
      const {'EAN8', 'UPCA', 'EAN13', 'GTIN14'}.contains(format) ? format : 'OTHER';

  /// True when both spellings are the same trade item.
  bool sameItemAs(NormalizedBarcode other) {
    if (isEmpty || other.isEmpty) return false;
    if (custom || other.custom) return canonical == other.canonical;
    final mine = forms.toSet();
    return other.forms.any(mine.contains);
  }
}

abstract final class BarcodeNormalizer {
  static const gtinLengths = [8, 12, 13, 14];
  static const _formatByLength = {8: 'EAN8', 12: 'UPCA', 13: 'EAN13', 14: 'GTIN14'};

  /// GS1 check digit for [body] (the GTIN without its last digit).
  static int checkDigit(String body) {
    var total = 0;
    final reversed = body.split('').reversed.toList();
    for (var i = 0; i < reversed.length; i++) {
      total += int.parse(reversed[i]) * (i.isEven ? 3 : 1);
    }
    return (10 - total % 10) % 10;
  }

  static bool isValidGtin(String digits) {
    if (!gtinLengths.contains(digits.length)) return false;
    if (!RegExp(r'^[0-9]+$').hasMatch(digits)) return false;
    return checkDigit(digits.substring(0, digits.length - 1)) ==
        int.parse(digits[digits.length - 1]);
  }

  /// First code point of each non-ASCII decimal digit block (ten digits each).
  static const _digitBlocks = <int>[
    0x0660, 0x06F0, 0x07C0, 0x0966, 0x09E6, 0x0A66, 0x0AE6, 0x0B66, 0x0BE6, //
    0x0C66, 0x0CE6, 0x0D66, 0x0E50, 0x0ED0, 0x0F20, 0x1040, 0xFF10,
  ];

  static final _letter = RegExp(r'\p{L}', unicode: true);

  static bool _hasLetter(String text) => _letter.hasMatch(text);

  static String _digitsOnly(String raw) {
    var text = raw.trim();
    // AIM symbology identifier some scanners prepend: "]" + code char + modifier.
    if (text.length >= 4 && text[0] == ']' && _hasLetter(text[1])) {
      text = text.substring(3);
    }
    final out = StringBuffer();
    for (final unit in text.runes) {
      if (unit >= 0x30 && unit <= 0x39) {
        out.writeCharCode(unit);
        continue;
      }
      for (final start in _digitBlocks) {
        if (unit >= start && unit < start + 10) {
          out.write(unit - start);
          break;
        }
      }
    }
    return out.toString();
  }

  static List<String> _unique(Iterable<String> items) {
    final seen = <String>{};
    return [
      for (final i in items)
        if (i.isNotEmpty && seen.add(i)) i,
    ];
  }

  static NormalizedBarcode normalize(String? raw) {
    final input = raw ?? '';
    final digits = _digitsOnly(input);
    if (digits.isEmpty) {
      return NormalizedBarcode(
        raw: input,
        digits: '',
        canonical: '',
        format: 'EMPTY',
        valid: false,
      );
    }

    final typed = input.trim();
    if (_hasLetter(typed) && !(typed.length >= 4 && typed[0] == ']')) {
      // "AB-123" is a custom code; its digits say nothing about another "123".
      return NormalizedBarcode(
        raw: input,
        digits: digits,
        canonical: typed,
        format: 'UNKNOWN',
        valid: false,
        custom: true,
      );
    }

    final format = _formatByLength[digits.length] ?? 'UNKNOWN';
    final valid = isValidGtin(digits);
    final canonical = format == 'UPCA' ? '0$digits' : digits;

    final forms = <String>[digits, canonical];
    if (gtinLengths.contains(digits.length)) {
      final stripped = digits.replaceFirst(RegExp(r'^0+'), '');
      for (final length in gtinLengths) {
        if (stripped.length <= length) forms.add(stripped.padLeft(length, '0'));
      }
    }
    final lookup = [...forms];
    if (digits.length == 14 && digits[0] != '0') {
      final base = digits.substring(1, 13);
      final base13 = '$base${checkDigit(base)}';
      lookup.add(base13);
      if (base13.startsWith('0')) lookup.add(base13.substring(1));
    }

    return NormalizedBarcode(
      raw: input,
      digits: digits,
      canonical: canonical,
      format: format,
      valid: valid,
      forms: _unique(forms),
      lookupForms: _unique(lookup),
    );
  }

  /// Strings to compare against stored barcodes: the code as typed first (so
  /// custom codes keep matching themselves), then every equivalent spelling.
  static List<String> matchCandidates(String? raw, {bool lookup = false}) {
    final n = normalize(raw);
    return _unique([(raw ?? '').trim(), ...(lookup ? n.lookupForms : n.forms)]);
  }
}
