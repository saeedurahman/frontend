import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/tables/pending_sales_table.dart';

part 'pending_sales_dao.g.dart';

@DriftAccessor(tables: [PendingSalesTable])
class PendingSalesDao extends DatabaseAccessor<AppDatabase>
    with _$PendingSalesDaoMixin {
  PendingSalesDao(super.db);

  Future<void> insertPendingSale(PendingSalesTableCompanion sale) =>
      into(pendingSalesTable).insertOnConflictUpdate(sale);

  Future<List<PendingSalesTableData>> getPendingSales() =>
      (select(pendingSalesTable)
            ..where((t) => t.status.equals('pending_sync')))
          .get();
}
