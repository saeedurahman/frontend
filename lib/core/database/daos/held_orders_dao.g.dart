// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'held_orders_dao.dart';

// ignore_for_file: type=lint
mixin _$HeldOrdersDaoMixin on DatabaseAccessor<AppDatabase> {
  $HeldOrdersTableTable get heldOrdersTable => attachedDatabase.heldOrdersTable;
  HeldOrdersDaoManager get managers => HeldOrdersDaoManager(this);
}

class HeldOrdersDaoManager {
  final _$HeldOrdersDaoMixin _db;
  HeldOrdersDaoManager(this._db);
  $$HeldOrdersTableTableTableManager get heldOrdersTable =>
      $$HeldOrdersTableTableTableManager(
        _db.attachedDatabase,
        _db.heldOrdersTable,
      );
}
