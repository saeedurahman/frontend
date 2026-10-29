import 'package:flutter/foundation.dart';

/// Single source of truth for every user-visible product name.
///
/// The same code base ships as the Windows desktop app (PakPOS) and, later,
/// as the mobile app (Pak Khata). Nothing outside this file may hard-code a
/// product name; read [AppBrand.current] instead.
///
/// Pick the brand at build time with
/// `--dart-define=APP_BRAND=pakkhata` (default: `pakpos`).
@immutable
class AppBrand {
  const AppBrand({
    required this.key,
    required this.appName,
    required this.shortName,
    required this.supportLabel,
    required this.packageName,
    required this.executableName,
  });

  /// Stable identifier used by `--dart-define=APP_BRAND=<key>`.
  final String key;

  /// Full product name: window title, app title, about.
  final String appName;

  /// Compact name for tight spots (sidebar, chips, lock screen).
  final String shortName;

  /// Who the user contacts for help, e.g. "PakPOS Support".
  final String supportLabel;

  /// Application id / bundle id placeholder (replace before store release).
  final String packageName;

  /// Windows executable base name placeholder (no extension).
  final String executableName;

  /// Line printed under the receipt footer text.
  String get receiptPoweredBy => 'Powered by $appName';

  static const pakPos = AppBrand(
    key: 'pakpos',
    appName: 'PakPOS',
    shortName: 'PakPOS',
    supportLabel: 'PakPOS Support',
    packageName: 'com.example.pakpos',
    executableName: 'pakpos',
  );

  static const pakKhata = AppBrand(
    key: 'pakkhata',
    appName: 'Pak Khata',
    shortName: 'Pak Khata',
    supportLabel: 'Pak Khata Support',
    packageName: 'com.example.pakkhata',
    executableName: 'pakkhata',
  );

  static const all = <AppBrand>[pakPos, pakKhata];

  static const String _definedKey =
      String.fromEnvironment('APP_BRAND', defaultValue: 'pakpos');

  static AppBrand fromKey(String? key) {
    final wanted = key?.trim().toLowerCase();
    for (final brand in all) {
      if (brand.key == wanted) return brand;
    }
    return pakPos;
  }

  static AppBrand _current = fromKey(_definedKey);

  /// The brand in effect for this build.
  static AppBrand get current => _current;

  /// Switches the active brand (startup or tests).
  static void use(AppBrand brand) => _current = brand;

  @visibleForTesting
  static void reset() => _current = fromKey(_definedKey);

  @override
  bool operator ==(Object other) => other is AppBrand && other.key == key;

  @override
  int get hashCode => key.hashCode;
}
