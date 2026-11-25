import 'dart:io';
import 'dart:typed_data';

import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';

/// What happened when the owner chose a file.
sealed class PickedFile {
  const PickedFile();
}

class PickedOk extends PickedFile {
  const PickedOk(this.file);
  final ImportFile file;
}

/// Not a .csv / .xlsx file.
class PickedWrongType extends PickedFile {
  const PickedWrongType(this.name);
  final String name;
}

class PickedUnreadable extends PickedFile {
  const PickedUnreadable(this.name);
  final String name;
}

/// Chooses a file with the system dialog and reads it into memory. A class of
/// its own so tests can hand the dialog a file without a native window.
class ImportFilePicker {
  ImportFilePicker(this._files);

  final FileSaverService _files;

  /// Null when the owner cancelled.
  Future<PickedFile?> pick() async {
    final path = await _files.pickFile(
      extensions: const ['csv', 'xlsx'],
      label: 'Spreadsheets (.xlsx, .csv)',
    );
    if (path == null) return null;
    return fromPath(path);
  }

  Future<PickedFile> fromPath(String path) async {
    final name = path.split(RegExp(r'[\\/]')).last;
    final kind = ImportFileKind.fromFileName(name);
    if (kind == null) return PickedWrongType(name);
    try {
      final bytes = await _files.readFile(path).readAsBytes();
      return PickedOk(ImportFile(name: name, bytes: bytes, kind: kind));
    } on FileSystemException {
      return PickedUnreadable(name);
    }
  }

  /// A file dropped on the window: [readBytes] reads it (an `XFile`).
  Future<PickedFile> fromDrop(
    String name,
    Future<List<int>> Function() readBytes,
  ) async {
    final kind = ImportFileKind.fromFileName(name);
    if (kind == null) return PickedWrongType(name);
    try {
      final raw = await readBytes();
      final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
      return PickedOk(ImportFile(name: name, bytes: bytes, kind: kind));
    } catch (_) {
      return PickedUnreadable(name);
    }
  }
}
