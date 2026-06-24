import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frantend/core/constants/app_config.dart';
import 'package:injectable/injectable.dart';

class ImageUploadException implements Exception {
  ImageUploadException(this.message);

  final String message;

  @override
  String toString() => message;
}

@lazySingleton
class ImageUploadService {
  ImageUploadService() : _dio = Dio();

  /// Plain Dio — no auth/retry/offline interceptors (uploads go to Cloudinary).
  final Dio _dio;

  Future<String> uploadImage(
    File imageFile, {
    String folder = AppConfig.cloudinaryProductsFolder,
  }) async {
    final cloudName = AppConfig.cloudinaryCloudName;
    final uploadPreset = AppConfig.cloudinaryUploadPreset;
    final url =
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
      'upload_preset': uploadPreset,
      'folder': folder,
    });

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        final secureUrl = response.data!['secure_url'];
        if (secureUrl is String && secureUrl.isNotEmpty) {
          return secureUrl;
        }
      }
      throw ImageUploadException('Image upload failed — no URL returned');
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? '${(e.response!.data as Map)['error']?['message'] ?? e.message}'
          : e.message;
      throw ImageUploadException(message ?? 'Image upload failed');
    }
  }
}
