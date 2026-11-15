import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart' as fs;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Persists a user-visible file (receipt PDF, export) and tells where.
abstract class FileSaverService {
  /// Converts any file:// URI or raw path to a canonical absolute local file path,
  /// ensuring correct separator characters and optional default extension.
  static String normalizeFilePath(String path, {String? defaultExtension}) {
    var raw = path.trim();
    if (raw.startsWith('file://')) {
      try {
        raw = Uri.parse(raw).toFilePath(windows: Platform.isWindows);
      } catch (_) {
        raw = raw.replaceFirst(RegExp(r'^file://+'), '');
      }
    } else if (raw.startsWith('file:')) {
      try {
        raw = Uri.parse(raw).toFilePath(windows: Platform.isWindows);
      } catch (_) {
        raw = raw.replaceFirst(RegExp(r'^file:+'), '');
      }
    }

    var normalized = p.normalize(raw);

    if (defaultExtension != null && defaultExtension.isNotEmpty) {
      final ext = defaultExtension.startsWith('.')
          ? defaultExtension
          : '.$defaultExtension';
      if (!normalized.toLowerCase().endsWith(ext.toLowerCase())) {
        normalized = '$normalized$ext';
      }
    }

    return normalized;
  }

  /// Prompts the user to choose a save destination upfront. Returns null if cancelled.
  Future<String?> chooseSavePath(
    String suggestedName, {
    List<String> extensions = const [],
  });

  /// Writes [bytes] to the given absolute file [path].
  Future<String> saveBytesToPath(String path, Uint8List bytes);

  /// Opens a native Save File dialog and writes [bytes] to the chosen location.
  /// Returns the absolute path written, or null if the user cancelled.
  Future<String?> saveFileWithDialog(
    String suggestedName,
    Uint8List bytes, {
    List<String> extensions = const [],
  });

  /// Writes [bytes] as [fileName] directly to Downloads (or Documents fallback).
  /// Returns the absolute path written.
  Future<String> saveBytes(String fileName, Uint8List bytes);

  /// Opens a native Open File dialog to pick a file (e.g. CSV).
  /// Returns the path picked, or null if cancelled.
  Future<String?> pickFile({List<String> extensions = const [], String? label});

  /// Opens the file with the operating system's default viewer/application.
  Future<void> openFile(String filePath);

  /// Opens the folder containing [filePath] in the native file explorer (Windows explorer /select).
  Future<void> openFolder(String filePath);

  /// Reads a file from disk.
  File readFile(String path);
}

class WindowsFileSaverService implements FileSaverService {
  const WindowsFileSaverService();

  @override
  Future<String?> chooseSavePath(
    String suggestedName, {
    List<String> extensions = const [],
  }) async {
    final cleanName = sanitizeFileName(suggestedName);
    String? rawPath;
    try {
      final fs.FileSaveLocation? location = await fs.getSaveLocation(
        suggestedName: cleanName,
        acceptedTypeGroups: extensions.isNotEmpty
            ? [fs.XTypeGroup(label: cleanName, extensions: extensions)]
            : const <fs.XTypeGroup>[],
      );
      rawPath = location?.path;
    } catch (e) {
      debugPrint('[ExportFlow] chooseSavePath getSaveLocation fallback: $e');
      final dir =
          await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
      rawPath = p.join(dir.path, cleanName);
    }
    debugPrint(
      '[ExportFlow] chooseSavePath rawPath: "$rawPath" (runtimeType=${rawPath.runtimeType})',
    );
    if (rawPath == null) return null;
    final ext = extensions.isNotEmpty ? extensions.first : null;
    final normalized = FileSaverService.normalizeFilePath(
      rawPath,
      defaultExtension: ext,
    );
    debugPrint('[ExportFlow] chooseSavePath normalized: "$normalized"');
    return normalized;
  }

  @override
  Future<String> saveBytesToPath(String path, Uint8List bytes) async {
    final normalized = FileSaverService.normalizeFilePath(path);
    final parent = Directory(p.dirname(normalized));
    if (!parent.existsSync()) {
      debugPrint(
        '[ExportFlow] saveBytesToPath creating missing parent directory: "${parent.path}"',
      );
      await parent.create(recursive: true);
    }
    final file = File(normalized);
    await file.writeAsBytes(bytes, flush: true);
    final exists = await file.exists();
    final length = exists ? await file.length() : 0;
    debugPrint(
      '[ExportFlow] saveBytesToPath: written $length bytes to "$normalized" (exists=$exists)',
    );
    if (!exists || length == 0) {
      throw FileSystemException(
        'File could not be written or is empty',
        normalized,
      );
    }
    return file.path;
  }

  @override
  Future<String?> saveFileWithDialog(
    String suggestedName,
    Uint8List bytes, {
    List<String> extensions = const [],
  }) async {
    final path = await chooseSavePath(suggestedName, extensions: extensions);
    if (path == null) return null;
    return saveBytesToPath(path, bytes);
  }

  @override
  Future<String> saveBytes(String fileName, Uint8List bytes) async {
    final dir =
        await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    final targetPath = p.join(dir.path, sanitizeFileName(fileName));
    return saveBytesToPath(targetPath, bytes);
  }

  @override
  Future<String?> pickFile({
    List<String> extensions = const [],
    String? label,
  }) async {
    final fs.XFile? file = await fs.openFile(
      acceptedTypeGroups: extensions.isNotEmpty
          ? [fs.XTypeGroup(label: label ?? 'Files', extensions: extensions)]
          : const <fs.XTypeGroup>[],
    );
    return file?.path;
  }

  @override
  Future<void> openFile(String filePath) async {
    if (!Platform.isWindows) return;
    try {
      await Process.run('explorer.exe', [filePath]);
    } catch (_) {}
  }

  @override
  Future<void> openFolder(String filePath) async {
    if (!Platform.isWindows) return;
    try {
      await Process.run('explorer.exe', ['/select,$filePath']);
    } catch (_) {}
  }

  @override
  File readFile(String path) => File(path);

  /// Strips path separators and characters Windows forbids in file names.
  static String sanitizeFileName(String name) {
    final cleaned = name
        .replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1f]'), '_')
        .trim();
    return cleaned.isEmpty ? 'file' : cleaned;
  }
}
