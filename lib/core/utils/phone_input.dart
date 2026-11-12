import 'package:flutter/services.dart';

/// Phone entry helpers.
///
/// The field holds only the *national* digits; the country dial code is shown
/// by the picker. intl_phone_field caps the text at the country's
/// `maxLength` (10 for PK) **counting a typed trunk `0` or a pasted `+92`**, so
/// `03442259592` was cut to `0344225959` and sent as `+920344225959`. We
/// normalise first and let nothing cut digits afterwards.
abstract final class PhoneInput {
  /// E.164 allows at most 15 digits including the country code.
  static const maxE164Digits = 15;

  /// National digits of [raw]: digits only, with a pasted country code
  /// (`+92…`, `0092…`) and the national trunk prefix (`0`) removed.
  static String nationalDigits(
    String raw, {
    required String dialCode,
    String? trunkPrefix,
  }) {
    final hasPlus = raw.trim().startsWith('+');
    var digits = raw.replaceAll(RegExp(r'\D'), '');
    if (hasPlus && digits.startsWith(dialCode)) {
      digits = digits.substring(dialCode.length);
    } else if (digits.startsWith('00$dialCode')) {
      digits = digits.substring(2 + dialCode.length);
    }
    if (trunkPrefix != null &&
        trunkPrefix.isNotEmpty &&
        digits.startsWith(trunkPrefix)) {
      digits = digits.substring(trunkPrefix.length);
    }
    final room = maxE164Digits - dialCode.length;
    return digits.length > room ? digits.substring(0, room) : digits;
  }

  /// `+<dial><national>`, digits only after the plus.
  static String toE164(String dialCode, String national) =>
      '+$dialCode${national.replaceAll(RegExp(r'\D'), '')}';

  /// Normalises an already-assembled number to `+digits` (no spaces/dashes).
  static String cleanE164(String complete) {
    final digits = complete.replaceAll(RegExp(r'\D'), '');
    return digits.isEmpty ? '' : '+$digits';
  }
}

/// Keeps the field's text equal to [PhoneInput.nationalDigits].
class NationalPhoneFormatter extends TextInputFormatter {
  const NationalPhoneFormatter({required this.dialCode, this.trunkPrefix});

  final String dialCode;
  final String? trunkPrefix;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = PhoneInput.nationalDigits(
      newValue.text,
      dialCode: dialCode,
      trunkPrefix: trunkPrefix,
    );
    if (text == newValue.text) return newValue;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
