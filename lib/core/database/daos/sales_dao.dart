import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/tables/sales_table.dart';

part 'sales_dao.g.dart';

@DriftAccessor(tables: [SalesTable])
class SalesDao extends DatabaseAccessor<AppDatabase> with _$SalesDaoMixin {
  SalesDao(super.db);

  Future<List<SalesTableData>> getAllSales() => select(salesTable).get();

  Future<SalesTableData?> getSaleById(String id) =>
      (select(salesTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertSale(SalesTableCompanion sale) =>
      into(salesTable).insertOnConflictUpdate(sale);

  Future<List<SalesTableData>> getPendingSyncSales() =>
      (select(salesTable)..where((t) => t.syncStatus.equals('pending'))).get();

  Future<void> markSaleSynced(String id) => (update(salesTable)
        ..where((t) => t.id.equals(id)))
      .write(
    SalesTableCompanion(
      syncStatus: const Value('synced'),
      syncedAt: Value(DateTime.now()),
    ),
  );
}
