import 'package:drift/drift.dart';

class SalesTable extends Table {
  TextColumn get id => text()();

  TextColumn get tenantId => text()();

  TextColumn get branchId => text()();

  TextColumn get customerId => text().nullable()();

  RealColumn get subtotal => real()();

  RealColumn get tax => real().withDefault(const Constant(0))();

  RealColumn get discount => real().withDefault(const Constant(0))();

  RealColumn get total => real()();

  TextColumn get paymentMethod => text()();

  TextColumn get itemsJson => text()();

  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
