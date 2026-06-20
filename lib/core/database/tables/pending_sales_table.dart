import 'package:drift/drift.dart';

class PendingSalesTable extends Table {
  TextColumn get id => text()();

  TextColumn get payloadJson => text()();

  TextColumn get status =>
      text().withDefault(const Constant('pending_sync'))();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
