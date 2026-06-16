import 'package:drift/drift.dart';

class SyncQueueTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get entityType => text()();

  TextColumn get entityId => text()();

  TextColumn get operation => text()();

  TextColumn get payloadJson => text()();

  TextColumn get endpoint => text().withDefault(const Constant(''))();

  TextColumn get method => text().withDefault(const Constant('POST'))();

  TextColumn get status =>
      text().withDefault(const Constant('pending'))();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get syncedAt => dateTime().nullable()();
}
