import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Persists a user-visible file (receipt PDF, export) and tells where.
abstract class FileSaverService {
  /// Writes [bytes] as [fileName] and returns the absolute path written.
  Future<String> saveBytes(String fileName, Uint8List bytes);
}

class WindowsFileSaverService implements FileSaverService {
  const WindowsFileSaverService();

  @override
  Future<String> saveBytes(String fileName, Uint8List bytes) async {
    final dir =
        await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, sanitizeFileName(fileName)));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  /// Strips path separators and characters Windows forbids in file names.
  static String sanitizeFileName(String name) {
    final cleaned =
        name.replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1f]'), '_').trim();
    return cleaned.isEmpty ? 'file' : cleaned;
  }
}
