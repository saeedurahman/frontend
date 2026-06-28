import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:frantend/core/database/daos/pending_sales_dao.dart';
import 'package:frantend/core/database/daos/products_dao.dart';
import 'package:frantend/core/database/daos/sales_dao.dart';
import 'package:frantend/core/database/daos/sync_queue_dao.dart';
import 'package:frantend/core/database/tables/customers_table.dart';
import 'package:frantend/core/database/tables/held_orders_table.dart';
import 'package:frantend/core/database/tables/master_data_cache_table.dart';
import 'package:frantend/core/database/tables/pending_sales_table.dart';
import 'package:frantend/core/database/tables/products_table.dart';
import 'package:frantend/core/database/tables/sales_table.dart';
import 'package:frantend/core/database/tables/sync_queue_table.dart';
import 'package:frantend/core/database/tables/users_table.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SyncQueueTable,
    ProductsTable,
    MasterDataCacheTable,
    SalesTable,
    PendingSalesTable,
    HeldOrdersTable,
    CustomersTable,
    UsersTable,
  ],
  daos: [
    SyncQueueDao,
    ProductsDao,
    MasterDataCacheDao,
    SalesDao,
    PendingSalesDao,
    HeldOrdersDao,
  ],
)
@lazySingleton
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(masterDataCacheTable);
      }
      if (from < 3) {
        await m.createTable(pendingSalesTable);
      }
      if (from < 4) {
        await m.createTable(heldOrdersTable);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'frantend_pos.db'));
    return NativeDatabase(file);
  });
}
