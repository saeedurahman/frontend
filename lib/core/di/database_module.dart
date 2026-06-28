import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:frantend/core/database/daos/pending_sales_dao.dart';
import 'package:frantend/core/database/daos/products_dao.dart';
import 'package:frantend/core/database/daos/sales_dao.dart';
import 'package:frantend/core/database/daos/sync_queue_dao.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DatabaseModule {
  @lazySingleton
  SyncQueueDao syncQueueDao(AppDatabase db) => db.syncQueueDao;

  @lazySingleton
  ProductsDao productsDao(AppDatabase db) => db.productsDao;

  @lazySingleton
  MasterDataCacheDao masterDataCacheDao(AppDatabase db) =>
      db.masterDataCacheDao;

  @lazySingleton
  SalesDao salesDao(AppDatabase db) => db.salesDao;

  @lazySingleton
  PendingSalesDao pendingSalesDao(AppDatabase db) => db.pendingSalesDao;

  @lazySingleton
  HeldOrdersDao heldOrdersDao(AppDatabase db) => db.heldOrdersDao;
}
