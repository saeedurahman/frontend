import 'dart:io';

import 'package:flutter/foundation.dart';

/// Dev-only HTTP client override for HTTPS endpoints with untrusted certs.
///
/// Windows desktop often fails to verify image hosts (e.g. local HTTPS storage
/// or SSL-inspecting antivirus) while the API still works over plain HTTP.
class InsecureHttpOverrides extends HttpOverrides {
  static bool get enabled {
    if (kIsWeb) return false;
    return kDebugMode ||
        const bool.fromEnvironment('ALLOW_INSECURE_SSL', defaultValue: false);
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
