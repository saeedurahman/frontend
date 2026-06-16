import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/core/sync/sync_queue.dart';
import 'package:frantend/core/utils/logger.dart';

class OfflineInterceptor extends Interceptor {
  OfflineInterceptor({
    required NetworkInfo networkInfo,
    required SyncQueue syncQueue,
  })  : _networkInfo = networkInfo,
        _syncQueue = syncQueue;

  final NetworkInfo _networkInfo;
  final SyncQueue _syncQueue;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skip_offline_queue'] == true) {
      return handler.next(options);
    }

    final connected = await _networkInfo.isConnected;
    if (connected) {
      return handler.next(options);
    }

    final method = options.method.toUpperCase();

    if (method == 'GET') {
      AppLogger.info('Offline GET — serving from local cache: ${options.path}');
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'Offline — use local datasource for GET requests',
        ),
      );
    }

    if (method == 'POST' || method == 'PUT' || method == 'PATCH' || method == 'DELETE') {
      final operation = _mapMethodToOperation(method);
      final entityType = _extractEntityType(options.path);
      final entityId = options.extra['entity_id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final payload = options.data is String
          ? options.data as String
          : jsonEncode(options.data ?? {});

      await _syncQueue.enqueue(
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        payloadJson: payload,
        endpoint: options.path,
        method: method,
      );

      AppLogger.info('Queued offline $method ${options.path}');

      return handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          statusCode: 202,
          data: {
            'success': true,
            'offline': true,
            'message': 'Queued for sync when online',
            'entity_id': entityId,
          },
        ),
      );
    }

    handler.next(options);
  }

  SyncOperation _mapMethodToOperation(String method) {
    switch (method) {
      case 'POST':
        return SyncOperation.create;
      case 'PUT':
      case 'PATCH':
        return SyncOperation.update;
      case 'DELETE':
        return SyncOperation.delete;
      default:
        return SyncOperation.update;
    }
  }

  String _extractEntityType(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return 'unknown';
    return segments.first;
  }
}
