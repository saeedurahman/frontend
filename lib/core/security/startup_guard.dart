/// Thrown when a release build starts with an unsafe configuration.
class StartupConfigError implements Exception {
  const StartupConfigError(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Release-mode configuration checks, run before any network call.
abstract final class StartupGuard {
  /// Throws [StartupConfigError] when a release build would talk plain HTTP or
  /// has TLS validation switched off. Debug/profile builds are not checked.
  static void validate({
    required bool isRelease,
    required String apiBaseUrl,
    required bool allowInsecureSsl,
  }) {
    if (!isRelease) return;

    if (allowInsecureSsl) {
      throw const StartupConfigError(
        'This build was compiled with ALLOW_INSECURE_SSL=true, which disables '
        'certificate checks. Rebuild without that flag.',
      );
    }

    final uri = Uri.tryParse(apiBaseUrl.trim());
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw StartupConfigError(
        'This build is not configured with a secure server address '
        '(API_BASE_URL must start with https://). '
        'Rebuild with --dart-define=API_BASE_URL=https://your-server/api/v1.',
      );
    }
  }
}
