import 'package:drift/drift.dart';

/// Hand-written SQL for the offline data layer (schema v7).
///
/// These tables are deliberately *not* Drift table classes: no code
/// generation is needed (or possible here), and the generated
/// `app_database.g.dart` stays untouched. They are created through
/// `customStatement` in `AppDatabase.onCreate` / `onUpgrade(from < 7)`.
abstract final class SyncSchema {
  static const tables = <String>[
    'entities',
    'stock_levels',
    'deferred_changes',
    'outbox',
    'local_sales',
    'local_shifts',
    'sync_meta',
  ];

  /// Idempotent DDL (every statement is `IF NOT EXISTS`).
  static const ddl = <String>[
    // Generic mirror of every pulled entity (product, customer, tax_rate...).
    '''
CREATE TABLE IF NOT EXISTS entities (
  entity TEXT NOT NULL,
  id TEXT NOT NULL,
  business_id TEXT,
  branch_id TEXT,
  parent_id TEXT,
  data TEXT NOT NULL,
  search_text TEXT,
  barcode TEXT,
  category_id TEXT,
  active INTEGER NOT NULL DEFAULT 1,
  is_deleted INTEGER NOT NULL DEFAULT 0,
  seq INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (entity, id)
)''',
    'CREATE INDEX IF NOT EXISTS idx_entities_search ON entities (entity, is_deleted, active, search_text)',
    'CREATE INDEX IF NOT EXISTS idx_entities_barcode ON entities (entity, barcode) WHERE barcode IS NOT NULL',
    'CREATE INDEX IF NOT EXISTS idx_entities_category ON entities (entity, category_id) WHERE category_id IS NOT NULL',
    'CREATE INDEX IF NOT EXISTS idx_entities_parent ON entities (entity, parent_id) WHERE parent_id IS NOT NULL',
    // Server balances (pulled). Pending local sales are subtracted at read time.
    '''
CREATE TABLE IF NOT EXISTS stock_levels (
  id TEXT PRIMARY KEY,
  branch_id TEXT NOT NULL,
  product_id TEXT NOT NULL,
  variation_id TEXT,
  qty TEXT NOT NULL,
  last_movement_at TEXT,
  seq INTEGER NOT NULL DEFAULT 0
)''',
    'CREATE INDEX IF NOT EXISTS idx_stock_product ON stock_levels (branch_id, product_id)',
    // Pulled rows held back because a local edit to the same entity is pending.
    '''
CREATE TABLE IF NOT EXISTS deferred_changes (
  entity TEXT NOT NULL,
  id TEXT NOT NULL,
  op TEXT NOT NULL,
  data TEXT,
  seq INTEGER NOT NULL,
  PRIMARY KEY (entity, id)
)''',
    '''
CREATE TABLE IF NOT EXISTS outbox (
  op_id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  payload TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  attempts INTEGER NOT NULL DEFAULT 0,
  next_attempt_at INTEGER,
  error_code TEXT,
  error_message TEXT,
  retryable INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  occurred_at TEXT NOT NULL,
  depends_on TEXT NOT NULL DEFAULT '[]',
  entity TEXT,
  entity_id TEXT
)''',
    'CREATE INDEX IF NOT EXISTS idx_outbox_status ON outbox (status)',
    'CREATE INDEX IF NOT EXISTS idx_outbox_entity ON outbox (entity, entity_id)',
    '''
CREATE TABLE IF NOT EXISTS local_sales (
  id TEXT PRIMARY KEY,
  op_id TEXT NOT NULL,
  receipt_no TEXT NOT NULL,
  official_number TEXT,
  status TEXT NOT NULL DEFAULT 'completed',
  sync_state TEXT NOT NULL DEFAULT 'pending',
  branch_id TEXT NOT NULL,
  shift_id TEXT,
  customer_id TEXT,
  customer_name TEXT,
  user_id TEXT,
  subtotal TEXT NOT NULL,
  total_discount TEXT NOT NULL,
  total_tax TEXT NOT NULL,
  net_amount TEXT,
  exact_total TEXT,
  rounding_amount TEXT NOT NULL DEFAULT '0',
  tax_inclusive INTEGER NOT NULL DEFAULT 0,
  tax_rounding_mode TEXT NOT NULL DEFAULT 'none',
  tax_label TEXT,
  total_amount TEXT NOT NULL,
  total_paid TEXT NOT NULL,
  credit_amount TEXT NOT NULL DEFAULT '0',
  flags TEXT NOT NULL DEFAULT '[]',
  lines TEXT NOT NULL,
  payments TEXT NOT NULL,
  notes TEXT,
  sold_at TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  server_synced_at TEXT
)''',
    'CREATE INDEX IF NOT EXISTS idx_local_sales_state ON local_sales (sync_state)',
    'CREATE INDEX IF NOT EXISTS idx_local_sales_shift ON local_sales (shift_id)',
    'CREATE UNIQUE INDEX IF NOT EXISTS idx_local_sales_receipt ON local_sales (receipt_no)',
    '''
CREATE TABLE IF NOT EXISTS local_shifts (
  id TEXT PRIMARY KEY,
  register_id TEXT NOT NULL,
  register_name TEXT,
  branch_id TEXT,
  user_id TEXT,
  status TEXT NOT NULL DEFAULT 'open',
  opening_float TEXT NOT NULL DEFAULT '0',
  actual_cash TEXT,
  expected_cash TEXT,
  notes TEXT,
  opened_at TEXT NOT NULL,
  closed_at TEXT,
  sync_state TEXT NOT NULL DEFAULT 'pending',
  open_op_id TEXT,
  close_op_id TEXT
)''',
    'CREATE INDEX IF NOT EXISTS idx_local_shifts_status ON local_shifts (user_id, status)',
    '''
CREATE TABLE IF NOT EXISTS sync_meta (
  key TEXT PRIMARY KEY,
  value TEXT
)''',
  ];

  /// Columns added to `local_sales` in schema v8 (tax snapshot of the sale).
  /// Old rows keep the safe defaults (exclusive, no rounding, no label) and so
  /// display exactly as before.
  static const localSaleTaxColumns = <String, String>{
    'net_amount': 'TEXT',
    'exact_total': 'TEXT',
    'rounding_amount': "TEXT NOT NULL DEFAULT '0'",
    'tax_inclusive': 'INTEGER NOT NULL DEFAULT 0',
    'tax_rounding_mode': "TEXT NOT NULL DEFAULT 'none'",
    'tax_label': 'TEXT',
  };

  /// Idempotent: adds only the columns that are missing.
  static Future<void> addTaxSnapshotColumns(GeneratedDatabase db) async {
    final rows = await db.customSelect('PRAGMA table_info(local_sales)').get();
    final have = {for (final r in rows) r.read<String>('name')};
    for (final entry in localSaleTaxColumns.entries) {
      if (have.contains(entry.key)) continue;
      await db.customStatement(
        'ALTER TABLE local_sales ADD COLUMN ${entry.key} ${entry.value}',
      );
    }
  }

  static Future<void> create(GeneratedDatabase db) async {
    for (final statement in ddl) {
      await db.customStatement(statement);
    }
  }

  /// Meta keys that describe *this device*, not the tenant, and so survive a
  /// wipe (the receipt counter must never repeat a number).
  static const deviceMetaKeys = <String>{'receipt_counter'};

  /// Removes all tenant data. Receipt counters are kept.
  static Future<void> wipe(GeneratedDatabase db) async {
    for (final table in tables) {
      if (table == 'sync_meta') {
        final keep = deviceMetaKeys.map((k) => "'$k'").join(',');
        await db.customStatement('DELETE FROM sync_meta WHERE key NOT IN ($keep)');
      } else {
        await db.customStatement('DELETE FROM $table');
      }
    }
  }
}
