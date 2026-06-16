import 'package:drift/drift.dart';

class ProductsTable extends Table {
  TextColumn get id => text()();

  TextColumn get tenantId => text()();

  TextColumn get name => text()();

  TextColumn get sku => text().nullable()();

  TextColumn get barcode => text().nullable()();

  RealColumn get price => real()();

  RealColumn get cost => real().withDefault(const Constant(0))();

  RealColumn get stock => real().withDefault(const Constant(0))();

  TextColumn get category => text().nullable()();

  TextColumn get imageUrl => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
