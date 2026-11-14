import 'package:image_picker/image_picker.dart';

/// Platform adapter for picking images from device gallery or camera.
abstract class ImagePickerService {
  Future<String?> pickImage({ImageSource source = ImageSource.gallery});
}

class WindowsImagePickerService implements ImagePickerService {
  const WindowsImagePickerService();

  @override
  Future<String?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source);
    return file?.path;
  }
}
