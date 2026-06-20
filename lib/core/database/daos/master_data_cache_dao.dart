import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/tables/master_data_cache_table.dart';

part 'master_data_cache_dao.g.dart';

@DriftAccessor(tables: [MasterDataCacheTable])
class MasterDataCacheDao extends DatabaseAccessor<AppDatabase>
    with _$MasterDataCacheDaoMixin {
  MasterDataCacheDao(super.db);

  Future<void> upsertCache(String key, String jsonData) =>
      into(masterDataCacheTable).insertOnConflictUpdate(
        MasterDataCacheTableCompanion.insert(
          cacheKey: key,
          jsonData: jsonData,
          cachedAt: DateTime.now(),
        ),
      );

  Future<String?> getCache(String key) async {
    final row = await (select(masterDataCacheTable)
          ..where((t) => t.cacheKey.equals(key)))
        .getSingleOrNull();
    return row?.jsonData;
  }
}
