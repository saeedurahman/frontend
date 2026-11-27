import 'dart:typed_data';

import 'package:frantend/core/platform/file_saver_service.dart';

/// What happened to a file handed to [FileShareService].
class SharedFile {
  const SharedFile({this.shared = false, this.savedPath});

  /// The system's share sheet took the file.
  final bool shared;

  /// Where the file was saved instead, for the user to attach by hand.
  final String? savedPath;
}

/// Hands a file to another app.
///
/// A phone opens its share sheet with the file attached. Windows cannot attach
/// a file to a WhatsApp chat, so the desktop version saves it and shows the
/// folder.
abstract class FileShareService {
  /// True where a file can be given straight to another app.
  bool get canShareFiles;

  Future<SharedFile> share(String fileName, Uint8List bytes, {String? text});
}

class DesktopFileShareService implements FileShareService {
  const DesktopFileShareService(this._files);

  final FileSaverService _files;

  @override
  bool get canShareFiles => false;

  @override
  Future<SharedFile> share(
    String fileName,
    Uint8List bytes, {
    String? text,
  }) async {
    final path = await _files.saveBytes(fileName, bytes);
    await _files.openFolder(path);
    return SharedFile(savedPath: path);
  }
}
