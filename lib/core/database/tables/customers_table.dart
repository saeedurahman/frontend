import 'package:drift/drift.dart';

class CustomersTable extends Table {
  TextColumn get id => text()();

  TextColumn get tenantId => text()();

  TextColumn get name => text()();

  TextColumn get phone => text().nullable()();

  TextColumn get email => text().nullable()();

  RealColumn get balance => real().withDefault(const Constant(0))();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
