// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_data_cache_dao.dart';

// ignore_for_file: type=lint
mixin _$MasterDataCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $MasterDataCacheTableTable get masterDataCacheTable =>
      attachedDatabase.masterDataCacheTable;
  MasterDataCacheDaoManager get managers => MasterDataCacheDaoManager(this);
}

class MasterDataCacheDaoManager {
  final _$MasterDataCacheDaoMixin _db;
  MasterDataCacheDaoManager(this._db);
  $$MasterDataCacheTableTableTableManager get masterDataCacheTable =>
      $$MasterDataCacheTableTableTableManager(
        _db.attachedDatabase,
        _db.masterDataCacheTable,
      );
}
