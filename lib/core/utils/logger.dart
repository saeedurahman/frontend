import 'dart:developer' as developer;
import 'package:frantend/core/brand/app_brand.dart';

abstract final class AppLogger {
  static final List<(RegExp, String Function(Match))> _redactions = [
    // Authorization: Bearer xxx / Bearer xxx
    (
      RegExp(r'Bearer\s+[A-Za-z0-9\-._~+/]+=*', caseSensitive: false),
      (_) => 'Bearer [REDACTED]',
    ),
    // JWTs
    (
      RegExp(r'eyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]*'),
      (_) => '[REDACTED_JWT]',
    ),
    // "password": "x", 'pin_code': 1234, token=abc, current_password: x ...
    (
      RegExp(
        r'''(["']?(?:\w*password|\w*pin|pin_code|\w*token|secret|authorization)["']?\s*[:=]\s*)(?:"[^"]*"|'[^']*'|[^\s,&}\]]+)''',
        caseSensitive: false,
      ),
      (m) => '${m.group(1)}[REDACTED]',
    ),
  ];

  /// Masks tokens, passwords and PINs in free text.
  static String redact(String message) {
    var result = message;
    for (final (pattern, replace) in _redactions) {
      result = result.replaceAllMapped(pattern, replace);
    }
    return result;
  }

  static void debug(String message, {String? tag}) {
    developer.log(redact(message), name: tag ?? AppBrand.current.appName);
  }

  static void info(String message, {String? tag}) {
    developer.log(redact(message), name: tag ?? AppBrand.current.appName, level: 800);
  }

  static void warning(String message, {String? tag}) {
    developer.log(redact(message), name: tag ?? AppBrand.current.appName, level: 900);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      redact(message),
      name: AppBrand.current.appName,
      level: 1000,
      error: error == null ? null : redact(error.toString()),
      stackTrace: stackTrace,
    );
  }
}
