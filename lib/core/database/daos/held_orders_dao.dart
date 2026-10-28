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

  Future<void> saveHeldOrder(HeldOrderModel order, {HeldOrderScope? scope}) =>
      into(heldOrdersTable).insertOnConflictUpdate(
        HeldOrderStorageMapper.toCompanion(order, scope: scope),
      );

  /// Parked orders of one cashier at one branch of one business. Rows
  /// without a scope (parked before scoping existed) are never returned.
  Future<List<HeldOrderModel>> getHeldOrdersFor(HeldOrderScope scope) async {
    final rows = await (select(heldOrdersTable)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
    return [
      for (final row in rows)
        if (HeldOrderStorageMapper.scopeOf(row) == scope)
          HeldOrderStorageMapper.fromRow(row),
    ];
  }

  /// Only returns the order when it belongs to [scope].
  Future<HeldOrderModel?> getHeldOrderForScope(
    String id,
    HeldOrderScope scope,
  ) async {
    final row = await (select(heldOrdersTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null || HeldOrderStorageMapper.scopeOf(row) != scope) {
      return null;
    }
    return HeldOrderStorageMapper.fromRow(row);
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
