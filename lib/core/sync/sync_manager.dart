import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/database/daos/sync_queue_dao.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/core/sync/conflict_resolver.dart';
import 'package:frantend/core/sync/sync_queue.dart';
import 'package:frantend/core/utils/logger.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SyncManager {
  SyncManager({
    required DioClient dioClient,
    required NetworkInfo networkInfo,
    required SyncQueue syncQueue,
    required SyncQueueDao syncQueueDao,
    required ConflictResolver conflictResolver,
    required PreferencesStorage preferencesStorage,
  })  : _dio = dioClient.dio,
        _networkInfo = networkInfo,
        _syncQueue = syncQueue,
        _syncQueueDao = syncQueueDao,
        _conflictResolver = conflictResolver,
        _preferencesStorage = preferencesStorage {
    _connectivitySubscription =
        _networkInfo.onConnectivityChanged.listen((connected) {
      if (connected) {
        _connectivityController.add(null);
      }
    });
  }

  final Dio _dio;
  final NetworkInfo _networkInfo;
  final SyncQueue _syncQueue;
  final SyncQueueDao _syncQueueDao;
  final ConflictResolver _conflictResolver;
  final PreferencesStorage _preferencesStorage;

  final _connectivityController = StreamController<void>.broadcast();
  StreamSubscription<bool>? _connectivitySubscription;

  Stream<void> get onConnectivityRestored => _connectivityController.stream;

  Future<void> syncAll() async {
    if (!await _networkInfo.isConnected) {
      AppLogger.info('Sync skipped — offline');
      return;
    }

    await _pushPendingChanges();
    await _pullMasterData();
    await _preferencesStorage.setLastSyncAt(DateTime.now().toIso8601String());
  }

  Future<void> _pushPendingChanges() async {
    final pending = await _syncQueue.getPending();

    for (final entry in pending) {
      try {
        await _syncQueueDao.markAsSyncing(entry.id);

        final payload = jsonDecode(entry.payloadJson) as Map<String, dynamic>;
        final method = entry.method.toUpperCase();
        final endpoint = entry.endpoint.isNotEmpty
            ? entry.endpoint
            : '/${entry.entityType}';

        Response<dynamic> response;
        switch (method) {
          case 'POST':
            response = await _dio.post<dynamic>(endpoint, data: payload);
          case 'PUT':
            response = await _dio.put<dynamic>(
              '$endpoint/${entry.entityId}',
              data: payload,
            );
          case 'PATCH':
            response = await _dio.patch<dynamic>(
              '$endpoint/${entry.entityId}',
              data: payload,
            );
          case 'DELETE':
            response =
                await _dio.delete<dynamic>('$endpoint/${entry.entityId}');
          default:
            response = await _dio.post<dynamic>(endpoint, data: payload);
        }

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          await _syncQueueDao.markAsSynced(entry.id);
        } else {
          await _syncQueueDao.markAsFailed(entry.id);
        }
      } catch (e) {
        AppLogger.error('Sync push failed for entry ${entry.id}', error: e);
        await _syncQueueDao.markAsFailed(entry.id);
      }
    }
  }

  Future<void> _pullMasterData() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.syncPull,
        options: Options(extra: {'skip_offline_queue': true}),
      );
      final data = response.data;
      if (data != null) {
        _conflictResolver.resolve(local: data, remote: data);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
      AppLogger.warning('Master data pull failed: $e');
    } catch (e) {
      AppLogger.warning('Master data pull failed: $e');
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
  }
}
