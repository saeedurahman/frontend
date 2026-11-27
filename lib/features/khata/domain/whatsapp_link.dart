/// Opening a WhatsApp chat with a ready message (`wa.me`).
///
/// Pure, so the number and link rules are tested without a device.
library;

abstract final class WhatsAppLink {
  /// Windows refuses very long links; past this the text is copied instead.
  static const maxUrlLength = 2000;

  static const _dialCodes = {
    'PK': '92',
    'IN': '91',
    'BD': '880',
    'AF': '93',
    'AE': '971',
    'SA': '966',
    'QA': '974',
    'OM': '968',
    'KW': '965',
    'BH': '973',
    'GB': '44',
    'US': '1',
    'CA': '1',
    'MY': '60',
    'TR': '90',
  };

  /// The country dial code for a business's `country_code` (Pakistan when
  /// unknown).
  static String dialCodeFor(String? countryCode) =>
      _dialCodes[(countryCode ?? '').trim().toUpperCase()] ?? '92';

  /// [phone] as the digits `wa.me` wants (E.164 without the plus), or null
  /// when it can't be a phone number.
  ///
  /// `+92 300 1234567`, `00923001234567`, `923001234567`, `0300-1234567` and
  /// `3001234567` all become `923001234567` for a Pakistani business.
  static String? digits(String? phone, {String dialCode = '92'}) {
    final raw = (phone ?? '').trim();
    // Letters mean it is not a number at all.
    if (raw.isEmpty || RegExp(r'[A-Za-z]').hasMatch(raw)) return null;
    var d = raw.replaceAll(RegExp(r'\D'), '');
    if (d.isEmpty) return null;
    if (!raw.startsWith('+')) {
      if (d.startsWith('00')) {
        d = d.substring(2);
      } else if (d.startsWith('0')) {
        d = '$dialCode${d.substring(1)}';
      } else if (d.startsWith(dialCode) && d.length >= dialCode.length + 8) {
        // Already carries the country code.
      } else if (d.length >= 7 && d.length <= 10) {
        d = '$dialCode$d';
      }
    } else if (d.startsWith('${dialCode}0')) {
      // "+92 0300 ..." : the trunk zero doesn't travel abroad.
      d = '$dialCode${d.substring(dialCode.length + 1)}';
    }
    if (d.length < 8 || d.length > 15 || d.startsWith('0')) return null;
    return d;
  }

  static Uri chat(String digits, {String text = ''}) => Uri.parse(
        text.isEmpty
            ? 'https://wa.me/$digits'
            // Spaces as %20 and new lines as %0A, as wa.me expects.
            : 'https://wa.me/$digits?text=${Uri.encodeComponent(text)}',
      );

  static bool fits(Uri url) => url.toString().length <= maxUrlLength;
}
