import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:frantend/core/database/daos/pending_sales_dao.dart';
import 'package:frantend/core/database/daos/products_dao.dart';
import 'package:frantend/core/database/daos/sales_dao.dart';
import 'package:frantend/core/database/daos/sync_queue_dao.dart';
import 'package:frantend/core/database/tables/customers_table.dart';
import 'package:frantend/core/database/tables/held_orders_table.dart';
import 'package:frantend/core/database/tables/master_data_cache_table.dart';
import 'package:frantend/core/database/tables/pending_sales_table.dart';
import 'package:frantend/core/database/tables/products_table.dart';
import 'package:frantend/core/database/tables/sales_table.dart';
import 'package:frantend/core/database/tables/sync_queue_table.dart';
import 'package:frantend/core/database/tables/users_table.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SyncQueueTable,
    ProductsTable,
    MasterDataCacheTable,
    SalesTable,
    PendingSalesTable,
    HeldOrdersTable,
    CustomersTable,
    UsersTable,
  ],
  daos: [
    SyncQueueDao,
    ProductsDao,
    MasterDataCacheDao,
    SalesDao,
    PendingSalesDao,
    HeldOrdersDao,
  ],
)
@lazySingleton
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// In-memory database for unit tests (migration + cache tests).
  @visibleForTesting
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(masterDataCacheTable);
      }
      if (from < 3) {
        await m.createTable(pendingSalesTable);
      }
      if (from < 4) {
        await m.createTable(heldOrdersTable);
      }
      if (from < 5) {
        await m.addColumn(usersTable, usersTable.businessSlug);
        await m.addColumn(usersTable, usersTable.rolesJson);
        await m.addColumn(usersTable, usersTable.permissionKeysJson);
      }
    },
  );
}

/// Directory that holds app-private data (not the user's Documents folder).
///
/// On Windows, `getApplicationDocumentsDirectory()` resolves to the user's
/// Documents folder, which is frequently redirected into OneDrive. OneDrive's
/// "Files On-Demand" feature replaces local files with cloud placeholders,
/// and SQLite's direct file I/O fails against those placeholders with
/// `SqliteException(10): disk I/O error`. `getApplicationSupportDirectory()`
/// resolves to a private, non-synced app-data folder on every platform and
/// is the correct location for a database file.
Future<Directory> _resolveDatabaseDirectory() async {
  final dir = await getApplicationSupportDirectory();
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  return dir;
}

/// Renames a database file (plus its `-wal`/`-shm` siblings) out of the way
/// so a fresh database can be created instead of crashing the app forever.
///
/// This only runs when SQLite reports the file as unreadable/corrupt, which
/// can happen after a hard crash, forced shutdown, or disk failure while a
/// transaction was in flight. Losing the local cache in that rare case is
/// preferable to the app being permanently unable to start.
Future<void> _quarantineCorruptDatabase(File file) async {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  for (final suffix in ['', '-wal', '-shm', '-journal']) {
    final source = File('${file.path}$suffix');
    if (await source.exists()) {
      try {
        await source.rename('${source.path}.corrupt.$timestamp');
      } catch (_) {
        // If even renaming fails (e.g. file locked by another process),
        // fall through and let the caller surface the original error.
      }
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await _resolveDatabaseDirectory();
    final file = File(p.join(dir.path, 'frantend_pos.db'));

    // SQLite needs a writable temp directory for journal/rollback files.
    // The OS default can be unwritable in sandboxed or locked-down Windows
    // environments, which also surfaces as a disk I/O error.
    final tempDir = await getTemporaryDirectory();
    sqlite3.tempDirectory = tempDir.path;

    QueryExecutor openDatabase() {
      return NativeDatabase.createInBackground(
        file,
        setup: (rawDb) {
          // WAL mode + a busy timeout make concurrent DAO access from
          // multiple isolates/threads resilient instead of throwing
          // "database is locked"/disk I/O errors under contention.
          rawDb.execute('PRAGMA journal_mode=WAL;');
          rawDb.execute('PRAGMA busy_timeout=5000;');
          rawDb.execute('PRAGMA foreign_keys=ON;');
        },
      );
    }

    // Probe the raw file synchronously before handing it to Drift. This
    // catches a corrupt/unreadable database up front so it can be
    // quarantined, instead of surfacing on the first query the app runs.
    if (await file.exists()) {
      try {
        sqlite3.open(file.path).dispose();
      } on SqliteException catch (e) {
        final isCorruptOrUnreadable =
            e.extendedResultCode == 11 /* SQLITE_CORRUPT */ ||
            e.extendedResultCode == 26 /* SQLITE_NOTADB */ ||
            e.resultCode == 10 /* SQLITE_IOERR */;
        if (!isCorruptOrUnreadable) rethrow;
        await _quarantineCorruptDatabase(file);
      }
    }

    return openDatabase();
  });
}
