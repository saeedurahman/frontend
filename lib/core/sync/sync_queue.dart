import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/daos/sync_queue_dao.dart';
import 'package:injectable/injectable.dart';

enum SyncOperation { create, update, delete }

@lazySingleton
class SyncQueue {
  SyncQueue(this._dao);

  final SyncQueueDao _dao;

  Future<int> enqueue({
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    required String payloadJson,
    String endpoint = '',
    String method = 'POST',
  }) {
    return _dao.insertEntry(
      SyncQueueTableCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        operation: operation.name,
        payloadJson: payloadJson,
        endpoint: Value(endpoint),
        method: Value(method),
        status: const Value('pending'),
      ),
    );
  }

  Future<List<SyncQueueTableData>> getPending() => _dao.getPendingEntries();

  Stream<int> watchPendingCount() => _dao.watchPendingCount();
}
