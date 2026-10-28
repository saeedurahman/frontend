import 'dart:io';

import 'package:frantend/core/utils/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Appends fatal/startup errors to `<app support>/logs/app.log` so a friendly
/// error screen can be shown while the details stay available for support.
abstract final class CrashLog {
  static const _maxBytes = 512 * 1024;

  static Future<File?> write(
    String context,
    Object error, [
    StackTrace? stackTrace,
  ]) async {
    try {
      final dir = await getApplicationSupportDirectory();
      final logDir = Directory(p.join(dir.path, 'logs'));
      if (!await logDir.exists()) await logDir.create(recursive: true);
      final file = File(p.join(logDir.path, 'app.log'));

      if (await file.exists() && await file.length() > _maxBytes) {
        await file.rename('${file.path}.1');
      }

      final entry = StringBuffer()
        ..writeln('--- ${DateTime.now().toIso8601String()} [$context]')
        ..writeln(AppLogger.redact(error.toString()))
        ..writeln(AppLogger.redact(stackTrace?.toString() ?? ''));
      await file.writeAsString(entry.toString(), mode: FileMode.append);
      return file;
    } catch (_) {
      return null; // logging must never take the app down
    }
  }
}
