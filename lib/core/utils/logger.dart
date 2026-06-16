import 'dart:developer' as developer;

abstract final class AppLogger {
  static void debug(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'Frantend');
  }

  static void info(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'Frantend', level: 800);
  }

  static void warning(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'Frantend', level: 900);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'Frantend',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
