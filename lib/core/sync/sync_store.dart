import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/utils/uuid_utils.dart';

/// What a committed change did to prices: which list (and product, when
/// known) it touched. A change of a customer's assigned list carries the
/// [customerId] instead. Screens re-resolve only what this concerns.
class PriceChange {
  const PriceChange({this.priceListId, this.productId, this.customerId});

  final String? priceListId;
  final String? productId;
  final String? customerId;

  @override
  bool operator ==(Object other) =>
      other is PriceChange &&
      other.priceListId == priceListId &&
      other.productId == productId &&
      other.customerId == customerId;

  @override
  int get hashCode => Object.hash(priceListId, productId, customerId);

  @override
  String toString() =>
      'PriceChange(list: $priceListId, product: $productId, customer: $customerId)';
}

/// Columns derived from an entity so lookups never parse JSON.
class IndexedEntity {
  const IndexedEntity({
    this.branchId,
    this.parentId,
    this.searchText,
    this.barcode,
    this.categoryId,
    this.active = true,
  });

  final bool active;
  final String? branchId;
  final String? parentId;
  final String? searchText;
  final String? barcode;
  final String? categoryId;

  static IndexedEntity of(String entity, Map<String, dynamic> data) {
    String? s(String key) {
      final v = data[key];
      return v == null ? null : '$v';
    }

    String search(Iterable<String?> parts) => parts
        .whereType<String>()
        .where((p) => p.isNotEmpty)
        .join(' ')
        .toLowerCase();

    final isActive = data['is_active'] != false && data['deleted_at'] == null;
    switch (entity) {
      case 'product':
        return IndexedEntity(
          searchText: search([s('name'), s('sku')]),
          categoryId: s('category_id'),
          active: isActive && data['is_sellable'] != false,
        );
      case 'product_variation':
        return IndexedEntity(
          parentId: s('product_id'),
          searchText: search([s('name'), s('sku')]),
          active: isActive,
        );
      case 'barcode':
        return IndexedEntity(parentId: s('product_id'), barcode: s('barcode'));
      case 'price_list_item':
        return IndexedEntity(parentId: s('product_id'));
      case 'party_followup':
        // Looked up per customer / supplier.
        return IndexedEntity(branchId: s('branch_id'), parentId: s('party_id'));
      case 'customer':
        return IndexedEntity(
          searchText: search([s('name'), s('phone'), s('email')]),
          active: isActive,
        );
      case 'cash_register':
        return IndexedEntity(
          branchId: s('branch_id'),
          searchText: search([s('name')]),
        );
      case 'modifier_group':
        return IndexedEntity(
          searchText: search([s('name')]),
          active: isActive,
        );
      case 'modifier':
        return IndexedEntity(
          parentId: s('modifier_group_id'),
          searchText: search([s('name')]),
          active: isActive,
        );
      case 'product_modifier_group':
        return IndexedEntity(parentId: s('product_id'), active: isActive);
      case 'customer_balance':
        return IndexedEntity(parentId: s('customer_id') ?? s('id'));
      case 'supplier':
        return IndexedEntity(
          searchText: search([s('name'), s('phone'), s('email')]),
          active: isActive,
        );
      case 'supplier_balance' || 'supplier_open_items':
        return IndexedEntity(parentId: s('supplier_id') ?? s('id'));
      case 'supplier_ledger':
        return IndexedEntity(
          branchId: s('branch_id'),
          parentId: s('supplier_id'),
        );
      case 'sale_summary':
        // Searchable by number, customer, receipt number and date.
        final customer = data['customer'];
        final sold = s('sold_at') ?? '';
        return IndexedEntity(
          branchId: s('branch_id'),
          parentId: s('customer_id'),
          searchText: search([
            s('sale_number'),
            s('number'),
            s('client_receipt_no'),
            s('customer_name') ??
                (customer is Map ? customer['name']?.toString() : null),
            customer is Map ? customer['phone']?.toString() : null,
            sold.length >= 10 ? sold.substring(0, 10) : sold,
          ]),
        );
      case 'register_shift':
        return IndexedEntity(
          branchId: s('branch_id'),
          parentId: s('cash_register_id'),
        );
      case 'stock_batch':
        return IndexedEntity(
          branchId: s('branch_id'),
          parentId: s('product_id'),
          searchText: search([s('batch_no')]),
        );
      case 'receipt_layout':
        return IndexedEntity(searchText: search([s('name')]), active: isActive);
      case 'receipt_layout_assignment':
        return IndexedEntity(branchId: s('branch_id'), parentId: s('layout_id'));
      default:
        return IndexedEntity(
          branchId: s('branch_id'),
          searchText: search([s('name')]),
        );
    }
  }
}

/// All reads and writes of the offline data layer.
///
/// Hand-written SQL on top of Drift's `customStatement` / `customSelect`
/// (no generated code). Every business write that must reach the server goes
/// through [transaction] together with its [enqueue] call, so a crash can
/// never leave a saved sale without its outbox row (or the other way round).
class SyncStore {
  SyncStore(this.db, {DateTime Function()? clock, DataChangeBus? bus})
      : _clock = clock ?? DateTime.now,
        _bus = bus ?? DataChangeBus.instance;

  /// Where changes to the screens' data are announced.
  final DataChangeBus _bus;
  final Set<DataTopic> _topicsInTx = {};
  final Set<String> _createdInTx = {};

  final GeneratedDatabase db;
  final DateTime Function() _clock;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  DateTime now() => _clock();

  /// Fires after every committed change (UI counters, scheduler).
  Stream<void> get changes => _changes.stream;

  /// Fires after an op was queued (the scheduler syncs at once).
  final StreamController<void> _enqueued = StreamController<void>.broadcast();
  Stream<void> get enqueued => _enqueued.stream;

  /// Runs [body] atomically; notifies listeners after the commit.
  Future<T> transaction<T>(Future<T> Function() body) async {
    var queued = false;
    final T result;
    try {
      result = await db.transaction(() async {
        final value = await body();
        queued = _queuedInTx;
        _queuedInTx = false;
        return value;
      });
    } catch (_) {
      // Rolled back: nothing changed, so nothing is announced.
      _topicsInTx.clear();
      _createdInTx.clear();
      rethrow;
    }
    final prices = _priceEventsInTx.toList();
    _priceEventsInTx.clear();
    final stock = _stockInTx;
    _stockInTx = false;
    final topics = {..._topicsInTx, if (stock) DataTopic.stock};
    final created = {..._createdInTx};
    _topicsInTx.clear();
    _createdInTx.clear();
    _bus.publish(topics, createdIds: created);
    if (!_changes.isClosed) _changes.add(null);
    if (!_priceChanges.isClosed) {
      for (final e in prices) {
        _priceChanges.add(e);
      }
    }
    if (stock && !_stockChanges.isClosed) _stockChanges.add(null);
    if (queued && !_enqueued.isClosed) _enqueued.add(null);
    return result;
  }

  bool _queuedInTx = false;

  /// Fires after a commit that touched a price list or one of its items
  /// (a pull, or a price saved on this device), so open screens re-read prices.
  ///
  /// One event per affected (list, product): consumers decide from the list
  /// id whether the change concerns them.
  final StreamController<PriceChange> _priceChanges =
      StreamController<PriceChange>.broadcast();
  Stream<PriceChange> get priceChanges => _priceChanges.stream;
  final Set<PriceChange> _priceEventsInTx = {};

  static const _priceEntities = {'price_list', 'price_list_item'};

  /// Records the price event a write of [entity] / [data] causes.
  void _notePrice(String entity, String id, Map<String, dynamic>? data) {
    switch (entity) {
      case 'price_list':
        _priceEventsInTx.add(PriceChange(priceListId: id));
      case 'price_list_item':
        _priceEventsInTx.add(PriceChange(
          priceListId: data?['price_list_id']?.toString(),
          productId: data?['product_id']?.toString(),
        ));
      case 'customer':
        _priceEventsInTx.add(PriceChange(customerId: id));
    }
  }

  /// Fires after a commit that changed what the POS shows as stock: a pulled
  /// balance, a sale saved / synced / failed / discarded / voided on this
  /// device, a queued return, or a pull that confirmed earlier sales.
  final StreamController<void> _stockChanges = StreamController<void>.broadcast();
  Stream<void> get stockChanges => _stockChanges.stream;
  bool _stockInTx = false;

  void dispose() {
    unawaited(_priceChanges.close());
    unawaited(_stockChanges.close());
    unawaited(_changes.close());
    unawaited(_enqueued.close());
  }

  // ── low-level helpers ────────────────────────────────────────────────

  Future<List<Map<String, Object?>>> _rows(
    String sql, [
    List<Object?> args = const [],
  ]) async {
    final result = await db.customSelect(
      sql,
      variables: [for (final a in args) _variable(a)],
    ).get();
    return [for (final r in result) r.data];
  }

  Future<void> _exec(String sql, [List<Object?> args = const []]) =>
      db.customStatement(sql, args);

  static Variable _variable(Object? a) {
    if (a == null) return const Variable<String>(null);
    if (a is int) return Variable<int>(a);
    if (a is bool) return Variable<int>(a ? 1 : 0);
    return Variable<String>('$a');
  }

  // ── sync_meta ────────────────────────────────────────────────────────

  Future<String?> meta(String key) async {
    final rows = await _rows('SELECT value FROM sync_meta WHERE key = ?', [key]);
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<void> setMeta(String key, String? value) async {
    if (value == null) {
      await _exec('DELETE FROM sync_meta WHERE key = ?', [key]);
    } else {
      await _exec(
        'INSERT INTO sync_meta (key, value) VALUES (?, ?) '
        'ON CONFLICT(key) DO UPDATE SET value = excluded.value',
        [key, value],
      );
    }
  }

  Future<Map<String, dynamic>?> metaJson(String key) async {
    final raw = await meta(key);
    if (raw == null) return null;
    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return null;
    }
  }

  Future<void> setMetaJson(String key, Map<String, dynamic>? value) =>
      setMeta(key, value == null ? null : jsonEncode(value));

  static const cursorKey = 'cursor';
  static const snapshotCompleteKey = 'snapshot_complete';
  static const snapshotTokenKey = 'snapshot_token';
  static const snapshotCursorKey = 'snapshot_cursor';
  static const lastPullAtKey = 'last_pull_at';
  static const lastPushAtKey = 'last_push_at';
  static const permissionsFingerprintKey = 'permissions_fingerprint';
  static const leaseKey = 'lease';
  static const monotonicKey = 'monotonic_last_seen';
  static const receiptCounterKey = 'receipt_counter';
  static const deviceShortCodeKey = 'device_short_code';
  static const numberPrefixKey = 'receipt_number_prefix';
  static const discardLogKey = 'discard_log';
  static const stockUnconfirmedKey = 'stock_unconfirmed_sales';

  Future<bool> get hasSnapshot async => (await meta(snapshotCompleteKey)) == '1';

  /// Next device receipt number (1, 2, 3 ...), never reused, survives wipes.
  Future<int> nextReceiptNumber() async {
    final current = int.tryParse(await meta(receiptCounterKey) ?? '') ?? 0;
    final next = current + 1;
    await setMeta(receiptCounterKey, '$next');
    return next;
  }

  /// Keeps the register code / number prefix the server last told us about.
  /// Only non-empty codes replace the stored one (a missing field never wipes it).
  Future<void> rememberNumbering({String? shortCode, String? prefix}) async {
    final code = shortCode?.trim();
    if (code != null && code.isNotEmpty && code != await meta(deviceShortCodeKey)) {
      await setMeta(deviceShortCodeKey, code);
    }
    if (prefix != null && prefix != (await meta(numberPrefixKey) ?? '')) {
      await setMeta(numberPrefixKey, prefix);
    }
  }

  // ── entities ─────────────────────────────────────────────────────────

  static String key(String entity, String id) => '$entity|$id';

  /// `entity|id` of rows that have an unfinished local edit.
  Future<Set<String>> protectedKeys() async {
    final rows = await _rows(
      'SELECT DISTINCT entity, entity_id FROM outbox '
      "WHERE entity IS NOT NULL AND status IN ('pending','sending','failed','rejected')",
    );
    return {
      for (final r in rows) key(r['entity']! as String, r['entity_id']! as String),
    };
  }

  /// Applies pulled changes in order. A change for an entity with a pending
  /// local op is parked in `deferred_changes` instead of overwriting it.
  Future<int> applyChanges(
    Iterable<SyncChange> changes, {
    Set<String>? protectedRows,
  }) async {
    final guarded = protectedRows ?? await protectedKeys();
    var applied = 0;
    var hasPriceChanges = false;
    for (final c in changes) {
      if (c.entity == 'price_list_item') hasPriceChanges = true;
      if (guarded.contains(key(c.entity, c.id))) {
        await _exec(
          'INSERT INTO deferred_changes (entity, id, op, data, seq) '
          'VALUES (?,?,?,?,?) ON CONFLICT(entity, id) DO UPDATE SET '
          'op = excluded.op, data = excluded.data, seq = excluded.seq',
          [c.entity, c.id, c.op, c.data == null ? null : jsonEncode(c.data), c.seq],
        );
        continue;
      }
      await _applyOne(c);
      applied++;
    }
    if (hasPriceChanges) {
      await cleanupDuplicatePriceListItems();
    }
    return applied;
  }

  Future<void> _applyOne(SyncChange c) async {
    _topicsInTx.addAll(_entityTopics(c.entity));
    if (c.entity == 'stock_level') {
      _stockInTx = true;
      if (c.isDelete || c.data == null) {
        await _exec('DELETE FROM stock_levels WHERE id = ?', [c.id]);
        return;
      }
      final d = c.data!;
      await _exec(
        'INSERT INTO stock_levels (id, branch_id, product_id, variation_id, qty, '
        'last_movement_at, seq) VALUES (?,?,?,?,?,?,?) ON CONFLICT(id) DO UPDATE SET '
        'branch_id = excluded.branch_id, product_id = excluded.product_id, '
        'variation_id = excluded.variation_id, qty = excluded.qty, '
        'last_movement_at = excluded.last_movement_at, seq = excluded.seq',
        [
          c.id,
          '${d['branch_id']}',
          '${d['product_id']}',
          d['variation_id']?.toString(),
          '${d['qty'] ?? '0'}',
          d['last_movement_at']?.toString(),
          c.seq,
        ],
      );
      return;
    }
    if (c.isDelete || c.data == null) {
      if (_priceEntities.contains(c.entity)) {
        // Remember which list / product the row belonged to for the event.
        _notePrice(c.entity, c.id, await entity(c.entity, c.id));
      }
      await _exec('DELETE FROM entities WHERE entity = ? AND id = ?', [c.entity, c.id]);
      return;
    }
    if (c.entity == 'price_list_item') {
      await _dropPriceTwins(c.id, c.data!);
    }
    await putEntity(c.entity, c.id, c.data!, seq: c.seq);
  }

  /// The screens a pulled row of [entity] belongs to.
  static Set<DataTopic> _entityTopics(String entity) => switch (entity) {
        'customer' ||
        'customer_balance' =>
          const {DataTopic.customers, DataTopic.customerLedger},
        'supplier' ||
        'supplier_balance' ||
        'supplier_open_items' ||
        'supplier_ledger' =>
          const {DataTopic.suppliers, DataTopic.supplierLedger},
        'party_followup' => const {DataTopic.followups},
        'product' ||
        'product_variation' ||
        'barcode' =>
          const {DataTopic.products},
        'category' => const {DataTopic.categories},
        'brand' => const {DataTopic.brands},
        'unit' => const {DataTopic.units},
        'price_list' ||
        'price_list_item' =>
          const {DataTopic.priceLists},
        'tax_rate' => const {DataTopic.taxRates},
        'register_shift' ||
        'cash_register' ||
        'shift_summary' =>
          const {DataTopic.shifts},
        'sale_summary' => const {DataTopic.sales},
        'receipt_layout' ||
        'receipt_layout_assignment' =>
          const {DataTopic.receiptLayouts},
        _ => const {},
      };

  /// The screens a queued action of [type] shows up on (queued, sent, refused
  /// or discarded).
  static Set<DataTopic> opTopics(String type) => switch (type) {
        OpTypes.customerCreate =>
          const {DataTopic.customers, DataTopic.customerLedger},
        OpTypes.followupCreate => const {DataTopic.followups},
        OpTypes.supplierCreate ||
        OpTypes.supplierUpdate => const {
            DataTopic.suppliers,
            DataTopic.supplierLedger,
          },
        OpTypes.customerPayment => const {
            DataTopic.customers,
            DataTopic.customerLedger,
            DataTopic.shifts,
            DataTopic.cashMovements,
          },
        OpTypes.supplierPayment => const {
            DataTopic.suppliers,
            DataTopic.supplierLedger,
            DataTopic.purchases,
            DataTopic.shifts,
            DataTopic.cashMovements,
          },
        OpTypes.shiftOpen ||
        OpTypes.shiftClose =>
          const {DataTopic.shifts, DataTopic.cashMovements},
        OpTypes.saleCreate || OpTypes.saleVoid => const {
            DataTopic.sales,
            DataTopic.stock,
            DataTopic.customers,
            DataTopic.customerLedger,
            DataTopic.shifts,
            DataTopic.cashMovements,
          },
        OpTypes.expenseCreate => const {
            DataTopic.expenses,
            DataTopic.shifts,
            DataTopic.cashMovements,
          },
        OpTypes.returnCreate => const {
            DataTopic.returns,
            DataTopic.sales,
            DataTopic.stock,
            DataTopic.customers,
            DataTopic.customerLedger,
            DataTopic.shifts,
            DataTopic.cashMovements,
          },
        _ => const {},
      };

  Future<void> _noteOp(String opId) async {
    final o = await op(opId);
    if (o != null) _topicsInTx.addAll(opTopics(o.type));
  }

  /// Writes a row the server just answered a request with, and tells the open
  /// screens. Call inside [transaction].
  Future<void> putFromServer(
    String entity,
    String id,
    Map<String, dynamic> data,
  ) async {
    await putEntity(entity, id, data);
    _topicsInTx.addAll(_entityTopics(entity));
  }

  /// Removes a row the server says is gone, and tells the open screens. Call
  /// inside [transaction].
  Future<void> removeFromServer(String entity, String id) async {
    await deleteEntity(entity, id);
    _topicsInTx.addAll(_entityTopics(entity));
  }

  /// Insert or replace one entity row (used by pulls and by local creates).
  Future<void> putEntity(
    String entity,
    String id,
    Map<String, dynamic> data, {
    int seq = 0,
  }) async {
    if (entity == 'price_list_item') {
      await _dropPriceTwins(id, data);
    }
    final idx = IndexedEntity.of(entity, data);
    _notePrice(entity, id, data);
    await _exec(
      'INSERT OR REPLACE INTO entities (entity, id, business_id, branch_id, '
      'parent_id, data, search_text, barcode, category_id, active, is_deleted, seq) '
      'VALUES (?,?,?,?,?,?,?,?,?,?,0,?)',
      [
        entity,
        id,
        data['business_id']?.toString(),
        idx.branchId,
        idx.parentId,
        jsonEncode(data),
        idx.searchText,
        idx.barcode,
        idx.categoryId,
        idx.active ? 1 : 0,
        seq,
      ],
    );
  }

  /// Removes one entity row (local deletes of data the server already
  /// removed); the caller notes the price event.
  Future<void> deleteEntity(String entity, String id) =>
      _exec('DELETE FROM entities WHERE entity = ? AND id = ?', [entity, id]);

  /// Queues the price event for a removed price row.
  void notePriceRemoved(Map<String, dynamic> row) =>
      _notePrice('price_list_item', '${row['id']}', row);

  /// Queues the price event for a removed price list.
  void notePriceListRemoved(String listId) =>
      _notePrice('price_list', listId, null);

  static const priceListItemsDedupMigrationKey = 'migration_price_list_items_dedup_v1';

  static String? _normalizeVarId(Object? v) {
    if (v == null) return null;
    final s = '$v'.trim();
    return s.isEmpty || s == 'null' ? null : s;
  }

  /// One-time local DB cleanup/migration:
  /// For each (price_list_id, product_id, variation_id, min_qty), keeps only the newest row
  /// (by server seq / updated time) and removes placeholder and stale duplicate rows.
  Future<int> cleanupDuplicatePriceListItems({bool force = false}) async {
    if (!force) {
      final done = await meta(priceListItemsDedupMigrationKey);
      if (done == '1') return 0;
    }

    final rawRows = await _rows(
      "SELECT id, data, seq, rowid FROM entities WHERE entity = 'price_list_item' AND is_deleted = 0",
    );
    if (rawRows.isEmpty) {
      await setMeta(priceListItemsDedupMigrationKey, '1');
      return 0;
    }

    final groups = <String, List<Map<String, dynamic>>>{};
    for (final r in rawRows) {
      try {
        final data = _decode(r['data']);
        final listId = data['price_list_id']?.toString() ?? '';
        final productId = data['product_id']?.toString() ?? '';
        final varId = _normalizeVarId(data['variation_id']) ?? '';
        final minQty = _num(data['min_qty']);
        final key = '$listId|$productId|$varId|$minQty';

        final itemWithMeta = {
          ...data,
          '_entity_id': r['id']?.toString() ?? data['id']?.toString() ?? '',
          '_seq': (r['seq'] as num?)?.toInt() ?? 0,
          '_rowid': (r['rowid'] as num?)?.toInt() ?? 0,
        };
        (groups[key] ??= []).add(itemWithMeta);
      } catch (_) {}
    }

    var removed = 0;
    for (final slotItems in groups.values) {
      if (slotItems.length <= 1) continue;

      slotItems.sort((a, b) {
        final aId = '${a['_entity_id']}';
        final bId = '${b['_entity_id']}';
        final aIsPlaceholder = aId.contains('_');
        final bIsPlaceholder = bId.contains('_');
        if (!aIsPlaceholder && bIsPlaceholder) return -1;
        if (aIsPlaceholder && !bIsPlaceholder) return 1;

        final aSeq = a['_seq'] as int;
        final bSeq = b['_seq'] as int;
        if (aSeq != bSeq) return bSeq.compareTo(aSeq);

        final aTime = DateTime.tryParse('${a['updated_at'] ?? a['created_at'] ?? ''}');
        final bTime = DateTime.tryParse('${b['updated_at'] ?? b['created_at'] ?? ''}');
        if (aTime != null && bTime != null && aTime != bTime) {
          return bTime.compareTo(aTime);
        }

        final aRowid = a['_rowid'] as int;
        final bRowid = b['_rowid'] as int;
        return bRowid.compareTo(aRowid);
      });

      for (var i = 1; i < slotItems.length; i++) {
        final toDeleteId = slotItems[i]['_entity_id'] as String;
        await _exec(
          "DELETE FROM entities WHERE entity = 'price_list_item' AND id = ?",
          [toDeleteId],
        );
        removed++;
      }
    }

    await setMeta(priceListItemsDedupMigrationKey, '1');
    return removed;
  }

  /// A pulled or local price row is authoritative for its (list, product, variation,
  /// min_qty) slot: a row this device wrote earlier for the same slot under a
  /// different id would otherwise stay next to it and could still win the
  /// lookup with the old price.
  Future<void> _dropPriceTwins(String id, Map<String, dynamic> data) async {
    final productId = data['product_id']?.toString();
    if (productId == null) return;
    final listId = data['price_list_id']?.toString();
    if (listId == null) return;
    final targetVar = _normalizeVarId(data['variation_id']);
    final targetMinQty = _num(data['min_qty']);

    bool same(Map<String, dynamic> o) =>
        '${o['price_list_id']}' == listId &&
        _normalizeVarId(o['variation_id']) == targetVar &&
        _num(o['min_qty']) == targetMinQty;

    for (final o in await entities('price_list_item',
        where: 'parent_id = ?', args: [productId])) {
      if ('${o['id']}' != id && same(o)) {
        await _exec(
          'DELETE FROM entities WHERE entity = ? AND id = ?',
          ['price_list_item', '${o['id']}'],
        );
      }
    }
  }

  static Decimal _num(Object? v) =>
      Decimal.tryParse('${v ?? 1}') ?? Decimal.one;

  /// Applies parked changes whose entity no longer has a pending local op.
  Future<int> releaseDeferred() async {
    final guarded = await protectedKeys();
    final rows = await _rows('SELECT * FROM deferred_changes ORDER BY seq');
    var released = 0;
    for (final r in rows) {
      final entity = r['entity']! as String;
      final id = r['id']! as String;
      if (guarded.contains(key(entity, id))) continue;
      final change = SyncChange(
        entity: entity,
        id: id,
        op: r['op']! as String,
        seq: (r['seq'] as int?) ?? 0,
        data: r['data'] == null
            ? null
            : Map<String, dynamic>.from(jsonDecode(r['data']! as String) as Map),
      );
      await _applyOne(change);
      await _exec('DELETE FROM deferred_changes WHERE entity = ? AND id = ?', [entity, id]);
      released++;
    }
    return released;
  }

  Future<Map<String, dynamic>?> entity(String entity, String id) async {
    final rows = await _rows(
      'SELECT data FROM entities WHERE entity = ? AND id = ? AND is_deleted = 0',
      [entity, id],
    );
    return rows.isEmpty ? null : _decode(rows.first['data']);
  }

  Future<List<Map<String, dynamic>>> entities(
    String entity, {
    String? where,
    List<Object?> args = const [],
    String orderBy = 'search_text',
    int? limit,
    int offset = 0,
  }) async {
    final rows = await _rows(
      'SELECT data FROM entities WHERE entity = ? AND is_deleted = 0'
      '${where == null ? '' : ' AND ($where)'} ORDER BY $orderBy'
      '${limit == null ? '' : ' LIMIT $limit OFFSET $offset'}',
      [entity, ...args],
    );
    return [for (final r in rows) _decode(r['data'])];
  }

  Future<int> countEntities(String entity, {String? where, List<Object?> args = const []}) async {
    final rows = await _rows(
      'SELECT COUNT(*) AS n FROM entities WHERE entity = ? AND is_deleted = 0'
      '${where == null ? '' : ' AND ($where)'}',
      [entity, ...args],
    );
    return (rows.first['n'] as int?) ?? 0;
  }

  Map<String, dynamic> _decode(Object? raw) =>
      Map<String, dynamic>.from(jsonDecode(raw! as String) as Map);

  /// Drops the pulled copy (first snapshot / "Resync all data"), keeping rows
  /// that still have a pending local edit.
  Future<void> clearSyncedData() async {
    final keep = await protectedKeys();
    final kept = <Map<String, Object?>>[];
    for (final k in keep) {
      final parts = k.split('|');
      kept.addAll(await _rows('SELECT * FROM entities WHERE entity = ? AND id = ?', [parts[0], parts[1]]));
    }
    await _exec('DELETE FROM entities');
    await _exec('DELETE FROM stock_levels');
    _stockInTx = true;
    await _exec('DELETE FROM deferred_changes');
    for (final r in kept) {
      await _exec(
        'INSERT OR REPLACE INTO entities (entity, id, business_id, branch_id, parent_id, '
        'data, search_text, barcode, category_id, active, is_deleted, seq) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        [
          r['entity'], r['id'], r['business_id'], r['branch_id'], r['parent_id'],
          r['data'], r['search_text'], r['barcode'], r['category_id'], r['active'], r['is_deleted'], r['seq'],
        ],
      );
    }
  }

  /// Removes cached entities and stock levels for branches no longer in [allowedBranchIds].
  /// Does nothing when [allowedBranchIds] is empty (unrestricted).
  Future<void> purgeRevokedBranches(List<String> allowedBranchIds) async {
    if (allowedBranchIds.isEmpty) return;
    final placeholders = List.filled(allowedBranchIds.length, '?').join(',');
    await _exec(
      'DELETE FROM entities WHERE branch_id IS NOT NULL AND branch_id NOT IN ($placeholders)',
      allowedBranchIds,
    );
    await _exec(
      'DELETE FROM stock_levels WHERE branch_id NOT IN ($placeholders)',
      allowedBranchIds,
    );
  }

  // ── stock ────────────────────────────────────────────────────────────

  /// Pulled balance for a product (+variation) at a branch; null if unknown.
  Future<Decimal?> stockLevel(String branchId, String productId, {String? variationId}) async {
    final rows = await _rows(
      'SELECT qty FROM stock_levels WHERE branch_id = ? AND product_id = ? '
      'AND ${variationId == null ? 'variation_id IS NULL' : 'variation_id = ?'}',
      [branchId, productId, if (variationId != null) variationId],
    );
    if (rows.isEmpty) return null;
    return Decimal.tryParse(rows.first['qty']! as String);
  }

  Future<List<Map<String, Object?>>> stockLevels(String branchId, {List<String>? productIds}) async {
    final rows = await _rows('SELECT * FROM stock_levels WHERE branch_id = ?', [branchId]);
    if (productIds == null) return rows;
    final wanted = productIds.toSet();
    return rows.where((r) => wanted.contains(r['product_id'])).toList();
  }

  /// Quantity sold on this device that the pulled balances do not include
  /// yet, by `productId` and `productId:variationId`.
  ///
  /// A sale counts while it is `pending`, and after the server accepted it
  /// until the next completed pull ([stockUnconfirmedSales]): the push answer
  /// arrives before the balance that contains the sale, and dropping the sale
  /// in between would show the old, higher stock for a moment. Once that pull
  /// is in, the sale is in the pulled balance and is never subtracted again.
  Future<Map<String, Decimal>> pendingSaleQuantities(String branchId) async {
    final out = <String, Decimal>{};
    for (final r in await _pendingSaleRows(branchId)) {
      for (final line in jsonDecode(r['lines']! as String) as List) {
        final l = line as Map;
        final qty = Decimal.tryParse('${l['qty']}') ?? Decimal.zero;
        final product = '${l['product_id']}';
        out[product] = (out[product] ?? Decimal.zero) + qty;
        if (l['variation_id'] != null) {
          final vk = '$product:${l['variation_id']}';
          out[vk] = (out[vk] ?? Decimal.zero) + qty;
        }
      }
    }
    return out;
  }

  /// Local sales whose effect is not in the pulled balances yet.
  Future<List<Map<String, Object?>>> _pendingSaleRows(String branchId) async {
    final unconfirmed = await stockUnconfirmedSales();
    return [
      for (final r in await _rows(
        "SELECT id, sync_state, lines FROM local_sales WHERE status = 'completed' "
        "AND branch_id = ? AND sync_state IN ('pending','synced')",
        [branchId],
      ))
        if (r['sync_state'] == 'pending' || unconfirmed.contains(r['id'])) r,
    ];
  }

  /// Key of one batch of one product, as used by [pendingBatchQuantities].
  static String batchKey(
    String productId,
    String? variationId,
    String? batchNo,
    String? expiry,
  ) =>
      '$productId|${variationId ?? ''}|${batchNo ?? ''}|${expiry ?? ''}';

  /// Quantity per batch (see [batchKey]) taken by sales that are not in the
  /// pulled `stock_batch` quantities yet; the POS subtracts it so a second
  /// sale never picks stock the first one already took.
  Future<Map<String, Decimal>> pendingBatchQuantities(String branchId) async {
    final out = <String, Decimal>{};
    for (final r in await _pendingSaleRows(branchId)) {
      for (final line in jsonDecode(r['lines']! as String) as List) {
        final l = line as Map;
        final batches = l['batches'];
        if (batches is! List) continue;
        for (final b in batches) {
          if (b is! Map) continue;
          final key = batchKey(
            '${l['product_id']}',
            l['variation_id'] == null ? null : '${l['variation_id']}',
            b['batch_no'] == null ? null : '${b['batch_no']}',
            b['expiry_date'] == null ? null : '${b['expiry_date']}',
          );
          out[key] = (out[key] ?? Decimal.zero) +
              (Decimal.tryParse('${b['qty']}') ?? Decimal.zero);
        }
      }
    }
    return out;
  }

  /// Ids of sales the server accepted whose effect on stock has not been
  /// pulled yet.
  Future<Set<String>> stockUnconfirmedSales() async {
    final raw = await meta(stockUnconfirmedKey);
    if (raw == null || raw.isEmpty) return <String>{};
    try {
      return {for (final id in jsonDecode(raw) as List) '$id'};
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> _setStockUnconfirmed(Set<String> ids) =>
      setMeta(stockUnconfirmedKey, ids.isEmpty ? null : jsonEncode(ids.toList()));

  /// A completed pull delivered the balances that contain [saleIds]: they
  /// stop being subtracted. Call in the transaction of the pull's last page.
  Future<void> confirmStockFor(Set<String> saleIds) async {
    if (saleIds.isEmpty) return;
    final current = await stockUnconfirmedSales();
    final left = current.difference(saleIds);
    if (left.length == current.length) return;
    await _setStockUnconfirmed(left);
    _stockInTx = true;
  }

  // ── customers ────────────────────────────────────────────────────────

  /// Ids of customers created on this device that the server has not
  /// accepted yet ("Not synced yet").
  Future<Set<String>> unsyncedCustomerIds() async {
    final rows = await _rows(
      'SELECT entity_id FROM outbox WHERE type = ? AND entity_id IS NOT NULL '
      "AND status IN ('pending','sending','failed','rejected')",
      [OpTypes.customerCreate],
    );
    return {for (final r in rows) r['entity_id']! as String};
  }

  // ── outbox ───────────────────────────────────────────────────────────

  /// Queues an op. Call inside [transaction], next to the local write.
  Future<void> enqueue({
    required String opId,
    required String type,
    required Map<String, dynamic> payload,
    required String occurredAt,
    List<String> dependsOn = const [],
    String? entity,
    String? entityId,
  }) async {
    await _exec(
      'INSERT INTO outbox (op_id, type, payload, status, attempts, created_at, '
      'occurred_at, depends_on, entity, entity_id) VALUES (?,?,?,?,0,?,?,?,?,?)',
      [
        opId,
        type,
        jsonEncode(payload),
        OutboxStatus.pending,
        _clock().millisecondsSinceEpoch,
        occurredAt,
        jsonEncode(dependsOn),
        entity,
        entityId,
      ],
    );
    _queuedInTx = true;
    _topicsInTx.addAll(opTopics(type));
    if ((type == OpTypes.customerCreate || type == OpTypes.supplierCreate) &&
        entityId != null) {
      _createdInTx.add(entityId);
    }
    if (type == OpTypes.returnCreate || type == OpTypes.saleVoid) {
      _stockInTx = true;
    }
  }

  Future<OutboxOp?> op(String opId) async {
    final rows = await _rows('SELECT * FROM outbox WHERE op_id = ?', [opId]);
    return rows.isEmpty ? null : OutboxOp.fromRow(rows.first);
  }

  Future<List<OutboxOp>> ops({List<String>? statuses}) async {
    final rows = await _rows(
      'SELECT * FROM outbox'
      '${statuses == null ? '' : " WHERE status IN (${statuses.map((s) => "'$s'").join(',')})"}'
      ' ORDER BY rowid',
    );
    return [for (final r in rows) OutboxOp.fromRow(r)];
  }

  Future<OutboxCounts> counts() async {
    final rows = await _rows('SELECT status, COUNT(*) AS n FROM outbox GROUP BY status');
    var pending = 0, sending = 0, failed = 0;
    for (final r in rows) {
      final n = (r['n'] as int?) ?? 0;
      switch (r['status']) {
        case OutboxStatus.pending:
          pending += n;
        case OutboxStatus.sending:
          sending += n;
        case OutboxStatus.failed:
        case OutboxStatus.rejected:
          failed += n;
      }
    }
    return OutboxCounts(pending: pending, sending: sending, failed: failed);
  }

  /// Ops ready to send, in outbox order, honouring `depends_on`:
  /// an op is eligible only when each dependency is already `applied` or is
  /// earlier in this same batch. An op whose dependency failed is moved to
  /// `failed` (`dependency_failed`) instead of being sent.
  Future<List<OutboxOp>> nextBatch(int limit) async {
    final nowMs = _clock().millisecondsSinceEpoch;
    final all = await ops();
    final byId = {for (final o in all) o.opId: o};
    final batch = <OutboxOp>[];
    final inBatch = <String>{};
    for (final o in all) {
      if (batch.length >= limit) break;
      if (o.status != OutboxStatus.pending) continue;
      if (o.nextAttemptAt != null && o.nextAttemptAt!.millisecondsSinceEpoch > nowMs) continue;
      var ready = true;
      for (final dep in o.dependsOn) {
        final d = byId[dep];
        if (d == null || d.status == OutboxStatus.applied || inBatch.contains(dep)) continue;
        if (d.needsAttention) {
          await markFailed(
            o.opId,
            code: 'dependency_failed',
            message: 'An earlier item this depends on has not been accepted yet.',
            status: OutboxStatus.failed,
            retryable: true,
          );
        }
        ready = false;
        break;
      }
      if (!ready) continue;
      batch.add(o);
      inBatch.add(o.opId);
    }
    return batch;
  }

  Future<void> markSending(Iterable<String> opIds) async {
    for (final id in opIds) {
      await _exec(
        "UPDATE outbox SET status = 'sending', attempts = attempts + 1 WHERE op_id = ?",
        [id],
      );
    }
  }

  /// App start: a `sending` op's response may have been lost; send it again
  /// (the server answers a known op id with `duplicate`).
  Future<int> resetSending() async {
    final n = await counts();
    await _exec("UPDATE outbox SET status = 'pending' WHERE status = 'sending'");
    return n.sending;
  }

  /// Returns a `sending` op to `pending` without counting the attempt
  /// (whole-request failures: offline, 5xx, 429, 413).
  Future<void> releaseUnsent(Iterable<String> opIds, {Duration? delay}) async {
    final at = delay == null ? null : _clock().add(delay).millisecondsSinceEpoch;
    for (final id in opIds) {
      await _exec(
        "UPDATE outbox SET status = 'pending', attempts = MAX(attempts - 1, 0), "
        'next_attempt_at = ? WHERE op_id = ? AND status = \'sending\'',
        [at, id],
      );
    }
  }

  Future<void> markApplied(String opId) async {
    await _noteOp(opId);
    await _exec(
      "UPDATE outbox SET status = 'applied', error_code = NULL, error_message = NULL, "
      'retryable = 0, next_attempt_at = NULL WHERE op_id = ?',
      [opId],
    );
  }

  /// Retryable outcome: back to `pending` after a backoff step.
  Future<void> scheduleRetry(
    String opId, {
    required String code,
    required String message,
    required Duration delay,
  }) =>
      _exec(
        "UPDATE outbox SET status = 'pending', error_code = ?, error_message = ?, "
        'retryable = 1, next_attempt_at = ? WHERE op_id = ?',
        [code, message, _clock().add(delay).millisecondsSinceEpoch, opId],
      );

  Future<void> markFailed(
    String opId, {
    required String code,
    required String message,
    String status = OutboxStatus.rejected,
    bool retryable = false,
  }) async {
    await _noteOp(opId);
    await _exec(
      'UPDATE outbox SET status = ?, error_code = ?, error_message = ?, '
      'retryable = ?, next_attempt_at = NULL WHERE op_id = ?',
      [status, code, message, retryable, opId],
    );
  }

  /// Gives a *finally rejected* op a new op id.
  ///
  /// The server remembers the outcome of every op id it rejected for good
  /// (README: "a re-send returns the same stored answer"), so sending the same
  /// id again could never succeed even after the cause was fixed. The content
  /// is unchanged; only the idempotency key is new. Everything that points at
  /// the old id (dependants, the local sale / shift) is updated.
  Future<String> _reissue(String opId) async {
    final newId = UuidUtils.v4();
    await _exec('UPDATE outbox SET op_id = ? WHERE op_id = ?', [newId, opId]);
    for (final o in await ops()) {
      if (!o.dependsOn.contains(opId)) continue;
      final updated = [for (final d in o.dependsOn) d == opId ? newId : d];
      await _exec('UPDATE outbox SET depends_on = ? WHERE op_id = ?', [jsonEncode(updated), o.opId]);
    }
    await _exec('UPDATE local_sales SET op_id = ? WHERE op_id = ?', [newId, opId]);
    await _exec('UPDATE local_shifts SET open_op_id = ? WHERE open_op_id = ?', [newId, opId]);
    await _exec('UPDATE local_shifts SET close_op_id = ? WHERE close_op_id = ?', [newId, opId]);
    return newId;
  }

  Future<void> _resetToPending(String opId) => _exec(
        "UPDATE outbox SET status = 'pending', attempts = 0, next_attempt_at = NULL, "
        'error_code = NULL, error_message = NULL WHERE op_id = ?',
        [opId],
      );

  /// User "Retry": back to `pending` now, plus anything blocked behind it.
  /// Returns the op's (possibly new) id. Call inside [transaction].
  Future<String> retryOp(String opId) async {
    var op = await this.op(opId);
    if (op == null || !op.needsAttention) return opId;
    final id = op.status == OutboxStatus.rejected ? await _reissue(opId) : opId;
    await _resetToPending(id);
    _topicsInTx.addAll(opTopics(op.type));

    final unblocked = {id};
    var changed = true;
    while (changed) {
      changed = false;
      for (final o in await ops()) {
        if (unblocked.contains(o.opId)) continue;
        if (o.errorCode == 'dependency_failed' &&
            o.needsAttention &&
            o.dependsOn.any(unblocked.contains)) {
          final next = o.status == OutboxStatus.rejected ? await _reissue(o.opId) : o.opId;
          await _resetToPending(next);
          unblocked.add(next);
          changed = true;
        }
      }
    }
    _queuedInTx = true;
    return id;
  }

  /// Retry everything that needs attention.
  Future<int> retryAllFailed() async {
    final failed = await ops(statuses: OutboxStatus.needsAttention);
    for (final o in failed) {
      await retryOp(o.opId);
    }
    return failed.length;
  }

  /// User "Discard": the op never reaches the server. Local effects are
  /// marked, not erased: a discarded sale stays in the sales list flagged
  /// `discarded` so the cash it represents is not silently lost.
  Future<void> discardOp(String opId, {required String reason}) async {
    final o = await op(opId);
    if (o == null) return;
    // What was recorded for a supplier that will never exist goes with it.
    if (o.type == OpTypes.supplierCreate && o.entityId != null) {
      for (final other in await supplierDependants(o.entityId!)) {
        await discardOp(other.opId, reason: reason);
      }
      // Money spent stays on record, without the supplier.
      for (final other in await ops(statuses: OutboxStatus.unfinished)) {
        if (other.opId != o.opId &&
            '${other.payload['supplier_id']}' == o.entityId) {
          await _repointSupplier(other, o.opId, 'supplier_id', null);
        }
      }
    }
    await _exec('DELETE FROM outbox WHERE op_id = ?', [opId]);
    _topicsInTx.addAll(opTopics(o.type));
    if (o.type == OpTypes.saleCreate) {
      await _exec("UPDATE local_sales SET sync_state = 'discarded' WHERE op_id = ?", [opId]);
      _stockInTx = true;
    }
    if (o.type == OpTypes.shiftOpen) {
      await _exec("UPDATE local_shifts SET sync_state = 'discarded', status = 'closed' WHERE open_op_id = ?", [opId]);
    }
    if (o.type == OpTypes.shiftClose) {
      await _exec("UPDATE local_shifts SET sync_state = 'synced', status = 'open', closed_at = NULL WHERE close_op_id = ?", [opId]);
    }
    if (o.type == OpTypes.customerCreate && o.entityId != null) {
      await _exec("DELETE FROM entities WHERE entity = 'customer' AND id = ?", [o.entityId]);
    }
    if (o.type == OpTypes.followupCreate && o.entityId != null) {
      await _exec("DELETE FROM entities WHERE entity = 'party_followup' AND id = ?", [o.entityId]);
    }
    if (o.type == OpTypes.supplierPayment && o.entityId != null) {
      await _deleteLocalLedgerRow(o.entityId!);
    }
    if (o.type == OpTypes.supplierCreate && o.entityId != null) {
      await _forgetUncreatedSupplier(o);
    }
    if (o.type == OpTypes.supplierUpdate && o.entityId != null) {
      await _undoSupplierEdits(o.entityId!);
    }
    await _logDiscard(o, reason);
  }

  Future<void> _logDiscard(OutboxOp o, String reason) async {
    final log = (await metaJson(discardLogKey)) ?? {'entries': <dynamic>[]};
    final entries = List<dynamic>.from(log['entries'] as List)
      ..add({
        'op_id': o.opId,
        'type': o.type,
        'at': _clock().toUtc().toIso8601String(),
        'reason': reason,
        'error_code': o.errorCode,
      });
    await setMetaJson(discardLogKey, {
      'entries': entries.length > 100 ? entries.sublist(entries.length - 100) : entries,
    });
  }

  Future<List<Map<String, dynamic>>> discardLog() async {
    final log = await metaJson(discardLogKey);
    return [
      for (final e in (log?['entries'] as List? ?? const []))
        Map<String, dynamic>.from(e as Map),
    ];
  }

  /// Keeps the table small: applied ops older than [keep] are dropped.
  Future<void> purgeApplied({Duration keep = const Duration(days: 7)}) => _exec(
        "DELETE FROM outbox WHERE status = 'applied' AND created_at < ?",
        [_clock().subtract(keep).millisecondsSinceEpoch],
      );

  /// Local held-only count is added by the PendingWorkGuard.
  Future<int> unfinishedCount() async => (await counts()).unfinished;

  // ── local sales ──────────────────────────────────────────────────────

  Future<void> insertSale(Map<String, Object?> row) async {
    final cols = row.keys.toList();
    await _exec(
      'INSERT INTO local_sales (${cols.join(',')}) VALUES (${cols.map((_) => '?').join(',')})',
      [for (final c in cols) row[c]],
    );
    _stockInTx = true;
  }

  /// A sale on this device already uses [receiptNo].
  Future<bool> receiptNoTaken(String receiptNo) async {
    final rows = await _rows(
      'SELECT 1 AS x FROM local_sales WHERE receipt_no = ? LIMIT 1',
      [receiptNo],
    );
    return rows.isNotEmpty;
  }

  Future<Map<String, Object?>?> sale(String id) async {
    final rows = await _rows('SELECT * FROM local_sales WHERE id = ?', [id]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<Map<String, Object?>?> saleByOp(String opId) async {
    final rows = await _rows('SELECT * FROM local_sales WHERE op_id = ?', [opId]);
    return rows.isEmpty ? null : rows.first;
  }

  Future<List<Map<String, Object?>>> sales({String? syncState, String? shiftId, int limit = 200}) =>
      _rows(
        'SELECT * FROM local_sales WHERE 1=1'
        '${syncState == null ? '' : ' AND sync_state = ?'}'
        '${shiftId == null ? '' : ' AND shift_id = ?'}'
        ' ORDER BY created_at DESC LIMIT $limit',
        [if (syncState != null) syncState, if (shiftId != null) shiftId],
      );

  /// The server accepted the sale. Its quantities keep being subtracted from
  /// the pulled stock until the next completed pull (see
  /// [pendingSaleQuantities]).
  Future<void> markSaleSynced(
    String id, {
    String? officialNumber,
    List<String> flags = const [],
  }) async {
    await _exec(
      "UPDATE local_sales SET sync_state = 'synced', official_number = COALESCE(?, official_number), "
      'flags = ?, server_synced_at = ? WHERE id = ?',
      [officialNumber, jsonEncode(flags), _clock().toUtc().toIso8601String(), id],
    );
    await _setStockUnconfirmed({...await stockUnconfirmedSales(), id});
    _stockInTx = true;
  }

  Future<void> setSaleState(String id, String state) async {
    await _exec('UPDATE local_sales SET sync_state = ? WHERE id = ?', [state, id]);
    _stockInTx = true;
  }

  Future<void> setSaleStatus(String id, String status) async {
    await _exec('UPDATE local_sales SET status = ? WHERE id = ?', [status, id]);
    _stockInTx = true;
  }

  /// Credit still owed by a customer from sales the server has not seen.
  ///
  /// Counts sales still `pending`, and sales the server accepted whose effect
  /// on the customer's balance has not been pulled yet (same rule as stock,
  /// see [stockUnconfirmedSales]), so the balance never jumps back for the
  /// moment between the push answer and the next pull.
  Future<Decimal> pendingCreditFor(String customerId) async {
    final unconfirmed = await stockUnconfirmedSales();
    final rows = await _rows(
      'SELECT id, sync_state, credit_amount FROM local_sales WHERE customer_id = ? '
      "AND status = 'completed' AND sync_state IN ('pending','synced')",
      [customerId],
    );
    var total = Decimal.zero;
    for (final r in rows) {
      if (r['sync_state'] != 'pending' && !unconfirmed.contains(r['id'])) continue;
      total += Decimal.tryParse('${r['credit_amount']}') ?? Decimal.zero;
    }
    return total;
  }

  /// Payment ops of [type] whose money is not in the pulled balances yet:
  /// still in the outbox, or accepted by the server but not yet pulled back.
  /// Oldest first.
  Future<List<OutboxOp>> _uncountedPayments(String type) async {
    final awaiting = await unconfirmedPaymentOps();
    final all = await ops(statuses: [...OutboxStatus.unfinished, OutboxStatus.applied]);
    return [
      for (final o in all)
        if (o.type == type &&
            (o.status != OutboxStatus.applied || awaiting.contains(o.opId)))
          o,
    ];
  }

  /// The money of [payments] added up.
  static Decimal paymentTotal(Iterable<OutboxOp> payments) => payments.fold(
        Decimal.zero,
        (sum, o) =>
            sum + (Decimal.tryParse('${o.payload['amount']}') ?? Decimal.zero),
      );

  /// This customer's payments the pulled account does not include yet.
  Future<List<OutboxOp>> uncountedCustomerPayments(String customerId) async => [
        for (final o in await _uncountedPayments(OpTypes.customerPayment))
          if ('${o.payload['customer_id']}' == customerId) o,
      ];

  /// Customer payments queued but not yet confirmed.
  Future<Decimal> pendingPaymentsFor(String customerId) async => paymentTotal([
        for (final o in await _uncountedPayments(OpTypes.customerPayment))
          if ('${o.payload['customer_id']}' == customerId) o,
      ]);

  // ── suppliers ────────────────────────────────────────────────────────

  /// Ids of suppliers added or changed on this device that the server has not
  /// accepted yet ("Not synced yet").
  Future<Set<String>> unsyncedSupplierIds() async {
    final rows = await _rows(
      'SELECT entity_id FROM outbox WHERE type IN (?, ?) '
      'AND entity_id IS NOT NULL '
      "AND status IN ('pending','sending','failed','rejected')",
      [OpTypes.supplierCreate, OpTypes.supplierUpdate],
    );
    return {for (final r in rows) r['entity_id']! as String};
  }

  /// The ops of [type] for this supplier that the server has not accepted,
  /// oldest first.
  Future<List<OutboxOp>> unfinishedSupplierOps(
    String supplierId,
    String type,
  ) async => [
        for (final o in await ops(statuses: OutboxStatus.unfinished))
          if (o.type == type && o.entityId == supplierId) o,
      ];

  /// New suppliers the pulled copy does not account for yet: still waiting,
  /// or accepted since the last completed pull.
  Future<List<OutboxOp>> pendingSupplierCreates({String? supplierId}) async => [
        for (final o in await _uncountedPayments(OpTypes.supplierCreate))
          if (supplierId == null || o.entityId == supplierId) o,
      ];

  /// Everything queued that only makes sense if the server gets [supplierId].
  Future<List<OutboxOp>> supplierDependants(String supplierId) async => [
        for (final o in await ops(statuses: OutboxStatus.unfinished))
          if ((o.type == OpTypes.supplierPayment &&
                  '${o.payload['supplier_id']}' == supplierId) ||
              (o.type == OpTypes.followupCreate &&
                  '${o.payload['party_id']}' == supplierId) ||
              (o.type == OpTypes.supplierUpdate && o.entityId == supplierId))
            o,
      ];

  /// Sends [o] for the supplier [to] (null: for none) in the [party] field of
  /// its payload, and no longer after [createOpId].
  Future<void> _repointSupplier(
    OutboxOp o,
    String createOpId,
    String party,
    String? to,
  ) async {
    final payload = {...o.payload, party: to}
      ..removeWhere((key, value) => key == party && value == null);
    // A new id: the server keeps its answer to an id it already refused.
    final id = await _reissue(o.opId);
    await _exec(
      'UPDATE outbox SET payload = ?, depends_on = ? WHERE op_id = ?',
      [
        jsonEncode(payload),
        jsonEncode([
          for (final d in o.dependsOn)
            if (d != createOpId) d,
        ]),
        id,
      ],
    );
    await _resetToPending(id);
    _topicsInTx.addAll(opTopics(o.type));
    _queuedInTx = true;
    if (o.entity != null && o.entityId != null) {
      final row = await entity(o.entity!, o.entityId!);
      if (row != null) {
        await putEntity(o.entity!, o.entityId!, {...row, party: to});
      }
    }
  }

  static String _supplierBaseKey(String id) => 'supplier_base_$id';

  /// Keeps the supplier as it was before the first edit waiting to be sent,
  /// so a discarded edit can be undone.
  Future<void> keepSupplierBase(String id, Map<String, dynamic> row) async {
    if (await meta(_supplierBaseKey(id)) != null) return;
    await setMetaJson(_supplierBaseKey(id), row);
  }

  /// Drops it once no edit is waiting any more.
  Future<void> dropSupplierBase(String id) async {
    final waiting = await unfinishedSupplierOps(id, OpTypes.supplierUpdate);
    if (waiting.isEmpty) await setMeta(_supplierBaseKey(id), null);
  }

  /// The row as it was, with the edits still waiting put back on top.
  Future<void> _undoSupplierEdits(String id) async {
    final base = await metaJson(_supplierBaseKey(id));
    if (base != null && await entity('supplier', id) != null) {
      var row = base;
      for (final o in await unfinishedSupplierOps(id, OpTypes.supplierUpdate)) {
        final fields = o.payload['fields'];
        if (fields is Map) {
          row = {...row, ...Map<String, dynamic>.from(fields)};
        }
      }
      await putEntity('supplier', id, row);
    }
    await dropSupplierBase(id);
  }

  Future<void> _forgetUncreatedSupplier(OutboxOp create) async {
    final id = create.entityId!;
    await deleteEntity('supplier', id);
    await setMeta(_supplierBaseKey(id), null);
    await setMeta(_duplicateKey(create.opId), null);
  }

  /// Changes what a queued op will send and puts it back in the queue under a
  /// new id. Call inside [transaction].
  Future<String> amendAndRetry(
    String opId,
    Map<String, dynamic> payload,
  ) async {
    await _exec(
      'UPDATE outbox SET payload = ? WHERE op_id = ?',
      [jsonEncode(payload), opId],
    );
    await setMeta(_duplicateKey(opId), null);
    return retryOp(opId);
  }

  /// Removes an op whose content another queued op now carries, or that no
  /// longer applies.
  Future<void> removeSuperseded(String opId) async {
    await _noteOp(opId);
    await _exec('DELETE FROM outbox WHERE op_id = ?', [opId]);
  }

  static String _duplicateKey(String opId) => 'supplier_duplicate_$opId';

  /// The server refused this op because another supplier has the name or the
  /// phone: which one.
  Future<void> noteDuplicateSupplier(
    String opId, {
    required String existingId,
    required String field,
  }) =>
      setMetaJson(_duplicateKey(opId), {'id': existingId, 'field': field});

  Future<({String existingId, String field})?> duplicateSupplier(
    String opId,
  ) async {
    final row = await metaJson(_duplicateKey(opId));
    final id = row?['id']?.toString();
    return id == null ? null : (existingId: id, field: '${row!['field']}');
  }

  /// A new supplier was refused as a duplicate and the user chose the one that
  /// already exists: payments, expenses and notes recorded for the new one are
  /// sent for that one instead; the new one, its opening balance and its edits
  /// are dropped. Returns false when there is nothing to move to. Call inside
  /// [transaction].
  Future<bool> useExistingSupplier(String createOpId) async {
    final create = await op(createOpId);
    final found = await duplicateSupplier(createOpId);
    final from = create?.entityId;
    if (create == null || from == null || found == null) return false;
    final to = found.existingId;

    final waiting = await ops(statuses: OutboxStatus.unfinished);
    for (final o in waiting) {
      if (o.opId == createOpId) continue;
      if (o.type == OpTypes.supplierUpdate && o.entityId == from) {
        await removeSuperseded(o.opId);
        continue;
      }
      final isNote = o.type == OpTypes.followupCreate &&
          '${o.payload['party_id']}' == from;
      if (!isNote && '${o.payload['supplier_id']}' != from) continue;
      await _repointSupplier(
        o,
        createOpId,
        isNote ? 'party_id' : 'supplier_id',
        to,
      );
    }
    await removeSuperseded(createOpId);
    await _forgetUncreatedSupplier(create);
    await _logDiscard(create, 'Replaced by an existing supplier');
    _queuedInTx = true;
    return true;
  }

  /// Supplier payments of this device that the pulled balances, bills and
  /// ledger do not account for yet (all suppliers, or [supplierId] only).
  Future<List<OutboxOp>> pendingSupplierPayments({String? supplierId}) async => [
        for (final o in await _uncountedPayments(OpTypes.supplierPayment))
          if (supplierId == null || '${o.payload['supplier_id']}' == supplierId) o,
      ];

  /// Marks a `supplier_ledger` row written by this device; the server's row
  /// of the same id replaces it, without the mark.
  static const localRowKey = '_local';

  Future<void> _deleteLocalLedgerRow(String id) async {
    final row = await entity('supplier_ledger', id);
    if (row?[localRowKey] != true) return;
    await deleteEntity('supplier_ledger', id);
  }

  static const balanceUnconfirmedKey = 'balance_unconfirmed_payments';

  /// Customer payments the server flagged when this device sent them.
  static const flaggedPaymentsKey = 'flagged_payments';

  Future<void> noteFlaggedPayment(OutboxOp op, List<String> flags) async {
    final toSupplier = op.type == OpTypes.supplierPayment;
    final party = toSupplier ? 'supplier' : 'customer';
    final partyId = op.payload['${party}_id']?.toString();
    final row = partyId == null ? null : await entity(party, partyId);
    final name = row?['name']?.toString();
    final entry = FlaggedPayment(
      opId: op.opId,
      amount: '${op.payload['amount'] ?? '0'}',
      flags: flags,
      toSupplier: toSupplier,
      customerName: toSupplier ? null : name,
      supplierName: toSupplier ? name : null,
      takenAt: DateTime.tryParse(op.occurredAt),
    );
    final all = [
      for (final p in await flaggedPayments())
        if (p.opId != op.opId) p,
      entry,
    ];
    await setMetaJson(flaggedPaymentsKey, {
      'entries': [
        for (final p in all.skip(all.length > 100 ? all.length - 100 : 0))
          p.toJson(),
      ],
    });
  }

  /// Oldest first.
  Future<List<FlaggedPayment>> flaggedPayments() async {
    final log = await metaJson(flaggedPaymentsKey);
    return [
      for (final e in (log?['entries'] as List? ?? const []))
        FlaggedPayment.fromJson(Map<String, dynamic>.from(e as Map)),
    ];
  }

  /// Ids of customer and supplier payment ops the server accepted whose
  /// effect on the balance has not been pulled yet.
  Future<Set<String>> unconfirmedPaymentOps() async {
    final raw = await meta(balanceUnconfirmedKey);
    if (raw == null || raw.isEmpty) return <String>{};
    try {
      return {for (final id in jsonDecode(raw) as List) '$id'};
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> _setUnconfirmedPayments(Set<String> ids) =>
      setMeta(balanceUnconfirmedKey, ids.isEmpty ? null : jsonEncode(ids.toList()));

  /// The server accepted [opId] (a payment): its amount keeps being applied
  /// to the pulled balance until the next completed pull.
  Future<void> noteBalanceUnconfirmed(String opId) async =>
      _setUnconfirmedPayments({...await unconfirmedPaymentOps(), opId});

  /// A completed pull delivered balances that contain [opIds].
  Future<void> confirmPaymentsFor(Set<String> opIds) async {
    if (opIds.isEmpty) return;
    final current = await unconfirmedPaymentOps();
    final left = current.difference(opIds);
    if (left.length == current.length) return;
    await _setUnconfirmedPayments(left);
    for (final opId in current.intersection(opIds)) {
      final o = await op(opId);
      if (o == null) continue;
      if (o.type != OpTypes.supplierPayment &&
          o.type != OpTypes.supplierCreate) {
        continue;
      }
      // A row the pull did not replace (older than the history it sends, or
      // not allowed to see) is no longer "waiting to sync".
      if (o.type == OpTypes.supplierPayment && o.entityId != null) {
        await _deleteLocalLedgerRow(o.entityId!);
      }
      _topicsInTx.addAll(opTopics(o.type));
    }
  }

  // ── local shifts ─────────────────────────────────────────────────────

  Future<void> upsertShift(Map<String, Object?> row) async {
    final cols = row.keys.toList();
    await _exec(
      'INSERT INTO local_shifts (${cols.join(',')}) VALUES (${cols.map((_) => '?').join(',')}) '
      'ON CONFLICT(id) DO UPDATE SET ${cols.where((c) => c != 'id').map((c) => '$c = excluded.$c').join(', ')}',
      [for (final c in cols) row[c]],
    );
  }

  /// Every shift this device opened (newest first), for the shift history.
  Future<List<Map<String, Object?>>> shifts({int limit = 500}) => _rows(
        "SELECT * FROM local_shifts WHERE sync_state != 'discarded' "
        'ORDER BY opened_at DESC LIMIT $limit',
      );

  Future<Map<String, Object?>?> shift(String id) async {
    final rows = await _rows('SELECT * FROM local_shifts WHERE id = ?', [id]);
    return rows.isEmpty ? null : rows.first;
  }

  /// The user's open shift on this device (newest first).
  Future<Map<String, Object?>?> openShiftFor(String userId, {String? registerId}) async {
    final rows = await _rows(
      "SELECT * FROM local_shifts WHERE user_id = ? AND status = 'open' "
      "AND sync_state != 'discarded'${registerId == null ? '' : ' AND register_id = ?'} "
      'ORDER BY opened_at DESC LIMIT 1',
      [userId, if (registerId != null) registerId],
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> updateShift(String id, Map<String, Object?> changes) async {
    final cols = changes.keys.toList();
    await _exec(
      'UPDATE local_shifts SET ${cols.map((c) => '$c = ?').join(', ')} WHERE id = ?',
      [for (final c in cols) changes[c], id],
    );
  }
}
