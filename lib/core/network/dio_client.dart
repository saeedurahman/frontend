import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/interceptors/auth_interceptor.dart';
import 'package:frantend/core/network/interceptors/logging_interceptor.dart';
import 'package:frantend/core/network/interceptors/offline_interceptor.dart';
import 'package:frantend/core/network/interceptors/retry_interceptor.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/core/sync/sync_queue.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DioClient {
  DioClient({
    required SecureStorage secureStorage,
    required NetworkInfo networkInfo,
    required SyncQueue syncQueue,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.accept,
        },
      ),
    );

    final authInterceptor = AuthInterceptor(
      secureStorage,
      dio: _dio,
      onUnauthorized: () async {
        await secureStorage.clearAll();
      },
    );

    _dio.interceptors.addAll([
      authInterceptor,
      OfflineInterceptor(
        networkInfo: networkInfo,
        syncQueue: syncQueue,
      ),
      RetryInterceptor(dio: _dio, retries: 3),
      LoggingInterceptor(),
    ]);
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
