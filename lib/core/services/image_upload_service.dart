import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

class ImageUploadException implements Exception {
  ImageUploadException(this.message);

  final String message;

  @override
  String toString() => message;
}

@lazySingleton
class ImageUploadService {
  ImageUploadService({DioClient? dioClient, Dio? dio})
      : _dio = dio ?? dioClient?.dio ?? Dio();

  final Dio _dio;

  Future<String> uploadImage(
    File imageFile, {
    String? folder,
  }) async {
    final fileName = imageFile.path.split(RegExp(r'[\\/]')).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.uploadsImage,
        data: formData,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final url = response.data!['url'];
        if (url is String && url.isNotEmpty) {
          return url;
        }
      }
      throw ImageUploadException('Image upload failed — no URL returned');
    } on DioException catch (e) {
      if (e.response?.statusCode == 413) {
        throw ImageUploadException(
            'Image is too large. Please select an image under 5 MB.');
      }
      if (e.response?.statusCode == 415) {
        throw ImageUploadException(
            'Unsupported format. Please select a JPG, PNG, WebP or GIF.');
      }
      final data = e.response?.data;
      String? detail;
      if (data is Map) {
        detail = data['detail']?.toString() ?? data['message']?.toString();
      }
      throw ImageUploadException(detail ?? e.message ?? 'Image upload failed');
    }
  }
}
