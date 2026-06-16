import 'package:drift/drift.dart';

class UsersTable extends Table {
  TextColumn get id => text()();

  TextColumn get email => text()();

  TextColumn get name => text()();

  TextColumn get role => text()();

  TextColumn get businessId => text().nullable()();

  TextColumn get branchId => text().nullable()();

  TextColumn get pinHash => text().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
