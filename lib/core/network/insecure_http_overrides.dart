import 'dart:io';

import 'package:flutter/foundation.dart';

/// Dev-only HTTP client override for HTTPS endpoints with untrusted certs.
///
/// Windows desktop often fails to verify image hosts (e.g. local HTTPS storage
/// or SSL-inspecting antivirus) while the API still works over plain HTTP.
class InsecureHttpOverrides extends HttpOverrides {
  /// Raw value of `--dart-define=ALLOW_INSECURE_SSL`. A release build with
  /// this set refuses to start (see StartupGuard).
  static const bool insecureFlag =
      bool.fromEnvironment('ALLOW_INSECURE_SSL', defaultValue: false);

  static bool get enabled {
    if (kIsWeb) return false;
    // Never in release, even if the flag was passed.
    if (kReleaseMode) return false;
    return kDebugMode || insecureFlag;
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => enabled;
  }
}

void configureHttpOverrides() {
  if (InsecureHttpOverrides.enabled) {
    HttpOverrides.global = InsecureHttpOverrides();
  }
}
