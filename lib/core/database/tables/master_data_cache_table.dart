import 'package:drift/drift.dart';

class MasterDataCacheTable extends Table {
  TextColumn get cacheKey => text()();

  TextColumn get jsonData => text()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {cacheKey};
}
