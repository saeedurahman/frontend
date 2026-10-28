import 'package:frantend/core/error/failures.dart';
import 'package:url_launcher/url_launcher.dart';

typedef UrlOpener = Future<bool> Function(Uri uri);

Future<bool> defaultUrlOpener(Uri uri) =>
    launchUrl(uri, mode: LaunchMode.externalApplication);

/// Builds the links behind the Call / WhatsApp / Email buttons.
abstract final class ContactLinks {
  static String _digits(String value) =>
      value.replaceAll(RegExp(r'[^0-9]'), '');

  /// `tel:+923001234567`
  static Uri? call(SubscriptionContact contact) {
    final phone = contact.phone;
    if (phone == null) return null;
    final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    return cleaned.isEmpty ? null : Uri(scheme: 'tel', path: cleaned);
  }

  /// `https://wa.me/923001234567` (wa.me wants digits only, no `+`).
  static Uri? whatsapp(SubscriptionContact contact) {
    final number = contact.whatsapp ?? contact.phone;
    if (number == null) return null;
    final digits = _digits(number);
    return digits.isEmpty ? null : Uri.parse('https://wa.me/$digits');
  }

  static Uri? email(SubscriptionContact contact) {
    final email = contact.email;
    return email == null ? null : Uri(scheme: 'mailto', path: email);
  }
}
