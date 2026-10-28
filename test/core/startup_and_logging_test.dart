import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/security/startup_guard.dart';
import 'package:frantend/core/utils/logger.dart';

void main() {
  group('StartupGuard (release hardening)', () {
    test('release + https + no insecure flag passes', () {
      expect(
        () => StartupGuard.validate(
          isRelease: true,
          apiBaseUrl: 'https://api.pakpos.pk/api/v1',
          allowInsecureSsl: false,
        ),
        returnsNormally,
      );
    });

    test('release with http:// fails with a clear message', () {
      expect(
        () => StartupGuard.validate(
          isRelease: true,
          apiBaseUrl: 'http://localhost:8000/api/v1',
          allowInsecureSsl: false,
        ),
        throwsA(
          isA<StartupConfigError>().having(
            (e) => e.message,
            'message',
            allOf(contains('API_BASE_URL'), contains('https://')),
          ),
        ),
      );
    });

    test('release with an empty or malformed URL fails', () {
      for (final url in ['', 'api.pakpos.pk', 'https://', '   ']) {
        expect(
          () => StartupGuard.validate(
            isRelease: true,
            apiBaseUrl: url,
            allowInsecureSsl: false,
          ),
          throwsA(isA<StartupConfigError>()),
          reason: url,
        );
      }
    });

    test('release with ALLOW_INSECURE_SSL fails even with https', () {
      expect(
        () => StartupGuard.validate(
          isRelease: true,
          apiBaseUrl: 'https://api.pakpos.pk/api/v1',
          allowInsecureSsl: true,
        ),
        throwsA(
          isA<StartupConfigError>().having(
            (e) => e.message,
            'message',
            contains('ALLOW_INSECURE_SSL'),
          ),
        ),
      );
    });

    test('debug/profile builds are not restricted', () {
      expect(
        () => StartupGuard.validate(
          isRelease: false,
          apiBaseUrl: 'http://localhost:8000/api/v1',
          allowInsecureSsl: true,
        ),
        returnsNormally,
      );
    });
  });

  group('AppLogger.redact', () {
    test('masks bearer tokens and JWTs', () {
      const jwt =
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.abcdefghijk';
      final out = AppLogger.redact('Authorization: Bearer $jwt and $jwt');
      expect(out, isNot(contains('eyJ')));
      expect(out, contains('[REDACTED'));
    });

    test('masks passwords, PINs and tokens in JSON and key=value', () {
      final out = AppLogger.redact(
        '{"password":"Secret123","pin_code":"123456","current_password":"abc",'
        '"access_token":"zzz9"} refresh_token=qwerty&pin=4321',
      );
      for (final secret in ['Secret123', '123456', 'abc"', 'zzz9', 'qwerty', '4321']) {
        expect(out, isNot(contains(secret)), reason: secret);
      }
      expect(out, contains('[REDACTED]'));
    });

    test('leaves ordinary text alone', () {
      const text = 'GET /products?limit=50 -> 200';
      expect(AppLogger.redact(text), text);
    });
  });
}
