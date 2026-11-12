import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/utils/uuid_utils.dart';

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
  SyncStore(this.db, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

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
    final result = await db.transaction(() async {
      final value = await body();
      queued = _queuedInTx;
      _queuedInTx = false;
      return value;
    });
    if (!_changes.isClosed) _changes.add(null);
    if (queued && !_enqueued.isClosed) _enqueued.add(null);
    return result;
  }

  bool _queuedInTx = false;

  void dispose() {
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
  static const discardLogKey = 'discard_log';

  Future<bool> get hasSnapshot async => (await meta(snapshotCompleteKey)) == '1';

  /// Next device receipt number (1, 2, 3 ...), never reused, survives wipes.
  Future<int> nextReceiptNumber() async {
    final current = int.tryParse(await meta(receiptCounterKey) ?? '') ?? 0;
    final next = current + 1;
    await setMeta(receiptCounterKey, '$next');
    return next;
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
    for (final c in changes) {
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
    return applied;
  }

  Future<void> _applyOne(SyncChange c) async {
    if (c.entity == 'stock_level') {
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
      await _exec('DELETE FROM entities WHERE entity = ? AND id = ?', [c.entity, c.id]);
      return;
    }
    await putEntity(c.entity, c.id, c.data!, seq: c.seq);
  }

  /// Insert or replace one entity row (used by pulls and by local creates).
  Future<void> putEntity(
    String entity,
    String id,
    Map<String, dynamic> data, {
    int seq = 0,
  }) async {
    final idx = IndexedEntity.of(entity, data);
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

  /// Quantity sold on this device that the server has not confirmed yet, by
  /// `productId` and `productId:variationId`.
  Future<Map<String, Decimal>> pendingSaleQuantities(String branchId) async {
    final rows = await _rows(
      "SELECT lines FROM local_sales WHERE sync_state = 'pending' AND status = 'completed' "
      'AND branch_id = ?',
      [branchId],
    );
    final out = <String, Decimal>{};
    for (final r in rows) {
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

  Future<void> markApplied(String opId) => _exec(
        "UPDATE outbox SET status = 'applied', error_code = NULL, error_message = NULL, "
        'retryable = 0, next_attempt_at = NULL WHERE op_id = ?',
        [opId],
      );

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
  }) =>
      _exec(
        'UPDATE outbox SET status = ?, error_code = ?, error_message = ?, '
        'retryable = ?, next_attempt_at = NULL WHERE op_id = ?',
        [status, code, message, retryable, opId],
      );

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
    await _exec('DELETE FROM outbox WHERE op_id = ?', [opId]);
    if (o.type == OpTypes.saleCreate) {
      await _exec("UPDATE local_sales SET sync_state = 'discarded' WHERE op_id = ?", [opId]);
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
    final log = (await metaJson(discardLogKey)) ?? {'entries': <dynamic>[]};
    final entries = List<dynamic>.from(log['entries'] as List)
      ..add({
        'op_id': opId,
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

  Future<void> markSaleSynced(
    String id, {
    String? officialNumber,
    List<String> flags = const [],
  }) =>
      _exec(
        "UPDATE local_sales SET sync_state = 'synced', official_number = COALESCE(?, official_number), "
        'flags = ?, server_synced_at = ? WHERE id = ?',
        [officialNumber, jsonEncode(flags), _clock().toUtc().toIso8601String(), id],
      );

  Future<void> setSaleState(String id, String state) =>
      _exec('UPDATE local_sales SET sync_state = ? WHERE id = ?', [state, id]);

  Future<void> setSaleStatus(String id, String status) =>
      _exec('UPDATE local_sales SET status = ? WHERE id = ?', [status, id]);

  /// Credit still owed by a customer from sales the server has not seen.
  Future<Decimal> pendingCreditFor(String customerId) async {
    final rows = await _rows(
      "SELECT credit_amount FROM local_sales WHERE customer_id = ? AND sync_state = 'pending' "
      "AND status = 'completed'",
      [customerId],
    );
    return rows.fold<Decimal>(
      Decimal.zero,
      (sum, r) => sum + (Decimal.tryParse('${r['credit_amount']}') ?? Decimal.zero),
    );
  }

  /// Customer payments queued but not yet confirmed.
  Future<Decimal> pendingPaymentsFor(String customerId) async {
    final pending = await ops(statuses: OutboxStatus.unfinished);
    var total = Decimal.zero;
    for (final o in pending) {
      if (o.type == OpTypes.customerPayment && '${o.payload['customer_id']}' == customerId) {
        total += Decimal.tryParse('${o.payload['amount']}') ?? Decimal.zero;
      }
    }
    return total;
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
