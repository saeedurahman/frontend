import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/services/image_upload_service.dart';

import '../helpers/fake_http.dart';

void main() {
  late Dio dio;
  late ImageUploadService service;
  late File tempFile;

  setUp(() async {
    dio = Dio(BaseOptions(baseUrl: 'http://test'));
    service = ImageUploadService(dio: dio);

    // Create a temporary file for testing
    final tempDir = await Directory.systemTemp.createTemp('upload_test');
    tempFile = File('${tempDir.path}/test_image.jpg');
    await tempFile.writeAsBytes([1, 2, 3, 4]);
  });

  tearDown(() async {
    try {
      if (await tempFile.exists()) {
        await tempFile.parent.delete(recursive: true);
      }
    } catch (_) {}
  });

  test('Image upload success POST /uploads/image returns url', () async {
    dio.httpClientAdapter = FakeAdapter((options) {
      if (options.path == ApiConstants.uploadsImage && options.method == 'POST') {
        return jsonResponse({
          'url': 'http://test/uploads/test_image_123.jpg',
        }, status: 201);
      }
      return jsonResponse({}, status: 404);
    });

    final url = await service.uploadImage(tempFile);
    expect(url, 'http://test/uploads/test_image_123.jpg');
  });

  test('Image upload 413 throws friendly size limit message', () async {
    dio.httpClientAdapter = FakeAdapter((options) {
      if (options.path == ApiConstants.uploadsImage) {
        return jsonResponse(
          {'detail': 'File exceeds size limit'},
          status: 413,
        );
      }
      return jsonResponse({}, status: 404);
    });

    expect(
      () => service.uploadImage(tempFile),
      throwsA(
        isA<ImageUploadException>().having(
          (e) => e.message,
          'message',
          contains('Image is too large. Please select an image under 5 MB.'),
        ),
      ),
    );
  });

  test('Image upload 415 throws friendly unsupported format message', () async {
    dio.httpClientAdapter = FakeAdapter((options) {
      if (options.path == ApiConstants.uploadsImage) {
        return jsonResponse(
          {'detail': 'Only image/jpeg, image/png allowed'},
          status: 415,
        );
      }
      return jsonResponse({}, status: 404);
    });

    expect(
      () => service.uploadImage(tempFile),
      throwsA(
        isA<ImageUploadException>().having(
          (e) => e.message,
          'message',
          contains('Unsupported format. Please select a JPG, PNG, WebP or GIF.'),
        ),
      ),
    );
  });
}

