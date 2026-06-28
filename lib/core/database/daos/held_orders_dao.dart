import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/tables/held_orders_table.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';

part 'held_orders_dao.g.dart';

@DriftAccessor(tables: [HeldOrdersTable])
class HeldOrdersDao extends DatabaseAccessor<AppDatabase>
    with _$HeldOrdersDaoMixin {
  HeldOrdersDao(super.db);

  Future<void> saveHeldOrder(HeldOrderModel order) =>
      into(heldOrdersTable)
          .insertOnConflictUpdate(HeldOrderStorageMapper.toCompanion(order));

  Future<List<HeldOrderModel>> getAllHeldOrders() async {
    final rows = await (select(heldOrdersTable)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
    return rows.map(HeldOrderStorageMapper.fromRow).toList();
  }

  Future<HeldOrderModel?> getHeldOrderById(String id) async {
    final row = await (select(heldOrdersTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : HeldOrderStorageMapper.fromRow(row);
  }

  Future<void> deleteHeldOrder(String id) =>
      (delete(heldOrdersTable)..where((t) => t.id.equals(id))).go();
}
