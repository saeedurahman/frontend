import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueueTable])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  Future<int> insertEntry(SyncQueueTableCompanion entry) =>
      into(syncQueueTable).insert(entry);

  Future<List<SyncQueueTableData>> getPendingEntries() =>
      (select(syncQueueTable)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<List<SyncQueueTableData>> getFailedEntries() =>
      (select(syncQueueTable)..where((t) => t.status.equals('failed'))).get();

  Future<void> markAsSyncing(int id) => (update(syncQueueTable)
        ..where((t) => t.id.equals(id)))
      .write(const SyncQueueTableCompanion(status: Value('syncing')));

  Future<void> markAsSynced(int id) => (update(syncQueueTable)
        ..where((t) => t.id.equals(id)))
      .write(
    SyncQueueTableCompanion(
      status: const Value('synced'),
      syncedAt: Value(DateTime.now()),
    ),
  );

  Future<void> markAsFailed(int id) async {
    final entry = await (select(syncQueueTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (entry == null) return;

    await (update(syncQueueTable)..where((t) => t.id.equals(id))).write(
      SyncQueueTableCompanion(
        status: const Value('failed'),
        retryCount: Value(entry.retryCount + 1),
      ),
    );
  }

  Future<void> deleteSyncedOlderThan(Duration age) {
    final cutoff = DateTime.now().subtract(age);
    return (delete(syncQueueTable)
          ..where(
            (t) =>
                t.status.equals('synced') &
                t.syncedAt.isSmallerThanValue(cutoff),
          ))
        .go();
  }

  Stream<int> watchPendingCount() {
    final count = syncQueueTable.id.count();
    final query = selectOnly(syncQueueTable)
      ..addColumns([count])
      ..where(syncQueueTable.status.equals('pending'));
    return query.map((row) => row.read(count) ?? 0).watchSingle();
  }
}
