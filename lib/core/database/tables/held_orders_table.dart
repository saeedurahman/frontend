import 'package:drift/drift.dart';

class HeldOrdersTable extends Table {
  TextColumn get id => text()();

  TextColumn get label => text()();

  DateTimeColumn get createdAt => dateTime()();

  TextColumn get cartItemsJson => text()();

  TextColumn get customerId => text().nullable()();

  TextColumn get customerName => text().nullable()();

  TextColumn get cartDiscountType => text().nullable()();

  TextColumn get cartDiscountValue => text().nullable()();

  IntColumn get itemCount => integer()();

  TextColumn get totalAmount => text()();

  @override
  Set<Column> get primaryKey => {id};
}
