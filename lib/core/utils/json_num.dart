import 'dart:convert';

import 'package:frantend/core/utils/logger.dart';

/// Tolerant readers for API JSON.
///
/// The backend serialises `Decimal`/`Numeric` columns as strings
/// (`"12.50"`), may send ints where Dart expects doubles, and may send
/// `null` for optional values. A hard `as num` cast turns any of those into a
/// crash, so every number read from an API payload goes through here.
abstract final class JsonNum {
  /// `int` from a num, a numeric string (`"3"`, `"3.0"`) or null.
  static int? intOrNull(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.isFinite ? value.toInt() : null;
    if (value is String) {
      final s = value.trim();
      if (s.isEmpty) return null;
      return int.tryParse(s) ?? double.tryParse(s)?.toInt();
    }
    return null;
  }

  static int intOr(Object? value, [int fallback = 0]) =>
      intOrNull(value) ?? fallback;

  /// `double` from a num, a numeric string (`"12.50"`) or null.
  static double? doubleOrNull(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final s = value.trim();
      return s.isEmpty ? null : double.tryParse(s);
    }
    return null;
  }

  static double doubleOr(Object? value, [double fallback = 0]) =>
      doubleOrNull(value) ?? fallback;

  /// Any scalar as a string (ids, fingerprints such as `permissions_version`).
  static String? stringOrNull(Object? value) {
    if (value == null) return null;
    final s = value.toString();
    return s.isEmpty ? null : s;
  }
}

/// A server response that could not be turned into a model.
class ResponseParseException implements Exception {
  const ResponseParseException(this.endpoint, this.detail);

  final String endpoint;
  final String detail;

  /// Safe to show to the user.
  String get userMessage =>
      'The server sent a response this version of the app could not read. '
      'Please update the app or contact support.';

  @override
  String toString() => 'ResponseParseException($endpoint: $detail)';
}

/// Parses API payloads without ever letting a cast error escape as a crash.
abstract final class ApiParse {
  static const _secretKeys = {
    'access_token',
    'refresh_token',
    'token',
    'password',
    'pin_code',
    'pin',
    'lease',
    'signature',
  };

  /// Runs [parse]; on any non-parse-exception error logs the failing field and
  /// a redacted copy of [json], then throws [ResponseParseException].
  ///
  /// [expected] optionally describes the payload (`'user.id': 'string'`, ...)
  /// so the log can name the exact offending field. Allowed kinds: `string`,
  /// `int`, `num`, `bool`, `list`, `map`; a trailing `?` allows null.
  static T guard<T>(
    String endpoint,
    Object? json,
    T Function(Map<String, dynamic> json) parse, {
    Map<String, String> expected = const {},
  }) {
    if (json is! Map) {
      AppLogger.error('Parse failure [$endpoint]: body is not a JSON object');
      throw ResponseParseException(endpoint, 'body is not a JSON object');
    }
    final map = Map<String, dynamic>.from(json);
    try {
      return parse(map);
    } on ResponseParseException {
      rethrow;
    } catch (e, st) {
      final bad = mismatches(map, expected);
      AppLogger.error(
        'Parse failure [$endpoint]: '
        '${bad.isEmpty ? 'field unknown ($e)' : 'bad field(s): ${bad.join('; ')}'}'
        ' | response: ${jsonEncode(redactBody(map))}',
        error: e,
        stackTrace: st,
      );
      throw ResponseParseException(
        endpoint,
        bad.isEmpty ? '$e' : bad.join('; '),
      );
    }
  }

  /// Fields of [json] that do not match [expected] (dotted paths).
  static List<String> mismatches(
    Map<String, dynamic> json,
    Map<String, String> expected,
  ) {
    final out = <String>[];
    expected.forEach((path, kind) {
      Object? v = json;
      for (final part in path.split('.')) {
        v = v is Map ? v[part] : null;
      }
      final nullable = kind.endsWith('?');
      final base = nullable ? kind.substring(0, kind.length - 1) : kind;
      if (v == null) {
        if (!nullable) out.add('$path missing (expected $base)');
        return;
      }
      final ok = switch (base) {
        'string' => v is String,
        'int' => v is int,
        'num' => v is num,
        'bool' => v is bool,
        'list' => v is List,
        'map' => v is Map,
        _ => true,
      };
      if (!ok) out.add('$path expected $base got ${v.runtimeType}');
    });
    return out;
  }

  /// Copy of [value] with credentials and the signed lease masked.
  static Object? redactBody(Object? value) {
    if (value is Map) {
      return {
        for (final e in value.entries)
          '${e.key}': _secretKeys.contains('${e.key}'.toLowerCase())
              ? '[REDACTED]'
              : redactBody(e.value),
      };
    }
    if (value is List) return [for (final v in value) redactBody(v)];
    return value;
  }
}
