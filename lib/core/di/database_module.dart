import 'package:frantend/core/database/app_database.dart';
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
  SalesDao salesDao(AppDatabase db) => db.salesDao;
}
