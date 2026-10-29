import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DatabaseModule {
  @lazySingleton
  MasterDataCacheDao masterDataCacheDao(AppDatabase db) =>
      db.masterDataCacheDao;

  @lazySingleton
  HeldOrdersDao heldOrdersDao(AppDatabase db) => db.heldOrdersDao;
}
