import 'package:frantend/core/sync/sync_models.dart';

/// In-memory implementation of the backend "Offline sync" contract
/// (README): change feed with signed-looking cursors, paged snapshot,
/// idempotent push with per-op results, flags, and whole-request errors.
class FakeSyncServer implements SyncApi {
  // ── state ────────────────────────────────────────────────────────────
  int _seq = 0;
  final Map<String, SyncChange> live = {}; // 'entity|id' -> latest upsert
  final List<SyncChange> feed = [];
  final Map<String, OpResult> processed = {};
  final Map<String, Map<String, dynamic>> processedOps = {};
  final Set<String> knownIds = {};
  final Map<String, int> stock = {}; // product|branch -> qty
  int saleCounter = 0;
  String permissionsVersion = 'pv1';

  // ── knobs ────────────────────────────────────────────────────────────
  bool offline = false;
  bool revoked = false;
  int maxOps = 200;
  Duration? rateLimit;
  bool serverError = false;
  bool fullResyncNext = false;
  String fullResyncReason = 'cursor_expired';
  int snapshotPageSize = 500;

  /// Scripted outcomes keyed by op id or op type (consumed once if [once]).
  final Map<String, OpError> errors = {};
  final Map<String, String> errorStatus = {};
  final Set<String> errorsOnce = {};

  // ── recording ────────────────────────────────────────────────────────
  final List<List<String>> pushBatches = []; // op types per batch
  final List<Map<String, dynamic>> receivedOps = [];
  int pullCalls = 0;
  int snapshotCalls = 0;
  int pushCalls = 0;
  final List<String?> pullSinces = [];

  // ── data helpers ─────────────────────────────────────────────────────

  /// A server-side change that devices will receive.
  SyncChange put(String entity, String id, Map<String, dynamic> data) {
    final change = SyncChange(entity: entity, id: id, op: 'upsert', seq: ++_seq, data: data);
    feed.add(change);
    live['$entity|$id'] = change;
    knownIds.add(id);
    return change;
  }

  SyncChange remove(String entity, String id) {
    final change = SyncChange(entity: entity, id: id, op: 'delete', seq: ++_seq);
    feed.add(change);
    live.remove('$entity|$id');
    return change;
  }

  void setStock(String productId, String branchId, int qty) {
    stock['$productId|$branchId'] = qty;
    put('stock_level', 'sl-$productId-$branchId', {
      'id': 'sl-$productId-$branchId',
      'branch_id': branchId,
      'product_id': productId,
      'variation_id': null,
      'qty': qty.toStringAsFixed(4),
      'last_movement_at': '2026-10-29T08:00:00+00:00',
    });
  }

  String _cursor(int seq) => 'cur-$seq';
  int _parse(String? c) => c == null ? 0 : int.parse(c.substring(4));

  void _gate() {
    if (offline) throw const SyncUnreachableException('offline');
    if (revoked) throw const DeviceRevokedException('Device revoked');
    if (rateLimit != null) throw RateLimitedException(rateLimit!);
    if (serverError) throw const SyncServerException('boom', statusCode: 500);
  }

  // ── SyncApi ──────────────────────────────────────────────────────────

  @override
  Future<PullPage> pull({String? since, int limit = 500, String? branchId}) async {
    _gate();
    pullCalls++;
    pullSinces.add(since);
    if (fullResyncNext) {
      fullResyncNext = false;
      return PullPage(
        changes: const [],
        nextCursor: null,
        hasMore: false,
        permissionsVersion: permissionsVersion,
        fullResyncRequired: true,
        fullResyncReason: fullResyncReason,
      );
    }
    final from = _parse(since);
    final page = feed.where((c) => c.seq > from).take(limit).toList();
    final last = page.isEmpty ? from : page.last.seq;
    return PullPage(
      changes: page,
      nextCursor: _cursor(last),
      hasMore: feed.any((c) => c.seq > last),
      permissionsVersion: permissionsVersion,
    );
  }

  @override
  Future<SnapshotPage> snapshot({String? pageToken, int limit = 500}) async {
    _gate();
    snapshotCalls++;
    final all = live.values.toList()..sort((a, b) => a.seq.compareTo(b.seq));
    final start = pageToken == null ? 0 : int.parse(pageToken.substring(3));
    final size = limit < snapshotPageSize ? limit : snapshotPageSize;
    final page = all.skip(start).take(size).toList();
    final end = start + page.length;
    final more = end < all.length;
    return SnapshotPage(
      changes: page,
      nextPageToken: more ? 'pg-$end' : null,
      hasMore: more,
      cursor: _cursor(_seq),
      permissionsVersion: permissionsVersion,
    );
  }

  @override
  Future<PushResponse> push({
    required String batchId,
    required List<Map<String, dynamic>> ops,
  }) async {
    _gate();
    pushCalls++;
    if (ops.length > maxOps) {
      throw const BatchTooLargeException('batch_too_large');
    }
    pushBatches.add([for (final o in ops) '${o['type']}']);
    final results = <OpResult>[];
    final batchApplied = <String>{};
    for (final op in ops) {
      receivedOps.add(op);
      final result = _process(op, batchApplied);
      if (result.status == 'applied') batchApplied.add('${op['op_id']}');
      results.add(result);
    }
    return PushResponse(batchId: batchId, results: results);
  }

  OpResult _process(Map<String, dynamic> op, Set<String> batchApplied) {
    final opId = '${op['op_id']}';
    final type = '${op['type']}';

    final previous = processed[opId];
    if (previous != null) {
      return OpResult(
        opId: opId,
        status: 'duplicate',
        serverId: previous.serverId,
        officialNumber: previous.officialNumber,
        flags: previous.flags,
        originalStatus: previous.status,
      );
    }

    // Scripted failures (by op id first, then by type).
    final key = errors.containsKey(opId) ? opId : (errors.containsKey(type) ? type : null);
    if (key != null) {
      final error = errors[key]!;
      if (errorsOnce.remove(key)) errors.remove(key);
      final status = errorStatus[key] ?? 'rejected';
      final r = OpResult(opId: opId, status: status, error: error);
      if (!error.retryable) processed[opId] = r;
      return r;
    }

    for (final dep in List<String>.from(op['depends_on'] as List? ?? const [])) {
      final done = processed[dep];
      if (done != null && done.status != 'applied') {
        return OpResult(
          opId: opId,
          status: 'rejected',
          error: const OpError(code: 'dependency_failed', message: 'dependency failed'),
        );
      }
      if (done == null && !batchApplied.contains(dep)) {
        return OpResult(
          opId: opId,
          status: 'rejected',
          error: const OpError(
            code: 'dependency_missing',
            message: 'dependency not synced',
            retryable: true,
          ),
        );
      }
    }

    final payload = Map<String, dynamic>.from(op['payload'] as Map);
    OpResult result;
    switch (type) {
      case 'customer.create':
        final id = '${payload['id']}';
        if (knownIds.contains(id)) {
          result = OpResult(
            opId: opId,
            status: 'conflict',
            error: const OpError(code: 'id_exists', message: 'exists'),
          );
          break;
        }
        put('customer', id, {...payload, 'is_active': true, 'balance': '0.00'});
        result = OpResult(opId: opId, status: 'applied', serverId: id);
      case 'shift.open':
        final id = '${payload['id']}';
        knownIds.add(id);
        result = OpResult(opId: opId, status: 'applied', serverId: id);
      case 'shift.close':
        result = OpResult(opId: opId, status: 'applied', serverId: '${payload['shift_id']}');
      case 'sale.create':
        result = _sale(opId, payload);
      case 'sale.void':
        result = OpResult(opId: opId, status: 'applied', serverId: '${payload['sale_id']}');
      case 'customer.payment':
        final cid = '${payload['customer_id']}';
        final c = live['customer|$cid'];
        if (c == null) {
          result = OpResult(
            opId: opId,
            status: 'rejected',
            error: const OpError(code: 'unknown_customer', message: 'no customer', retryable: true),
          );
          break;
        }
        final newBal = (double.parse('${c.data!['balance']}') + double.parse('${payload['amount']}'))
            .toStringAsFixed(2);
        put('customer', cid, {...c.data!, 'balance': newBal});
        result = OpResult(opId: opId, status: 'applied', serverId: '${payload['id'] ?? opId}');
      case 'expense.create':
        result = OpResult(opId: opId, status: 'applied', serverId: opId, officialNumber: 'EXP-1');
      case 'return.create':
        result = OpResult(opId: opId, status: 'applied', serverId: opId, officialNumber: 'RET-1');
      default:
        result = OpResult(
          opId: opId,
          status: 'rejected',
          error: const OpError(code: 'unsupported_op_type', message: 'no'),
        );
    }
    if (result.status != 'rejected' || result.error?.retryable == false) {
      processed[opId] = result;
    }
    processedOps[opId] = op;
    return result;
  }

  OpResult _sale(String opId, Map<String, dynamic> p) {
    final id = '${p['id']}';
    final branch = '${p['branch_id']}';
    for (final l in (p['lines'] as List)) {
      final pid = '${(l as Map)['product_id']}';
      if (!knownIds.contains(pid)) {
        return OpResult(
          opId: opId,
          status: 'rejected',
          error: OpError(code: 'unknown_product', message: 'Unknown product(s): $pid'),
        );
      }
    }
    final flags = <String>[];
    for (final l in (p['lines'] as List)) {
      final m = l as Map;
      final key = '${m['product_id']}|$branch';
      final left = (stock[key] ?? 0) - double.parse('${m['qty']}').round();
      stock[key] = left;
      if (left < 0) flags.add('oversold');
      setStock('${m['product_id']}', branch, left);
    }
    final customerId = p['customer_id'];
    if (customerId != null) {
      final c = live['customer|$customerId'];
      var credit = 0.0;
      for (final pay in (p['payments'] as List)) {
        if ((pay as Map)['payment_method'] == 'credit') credit += double.parse('${pay['amount']}');
      }
      if (c != null && credit > 0) {
        final bal = double.parse('${c.data!['balance']}') - credit; // negative = owes
        put('customer', '$customerId', {...c.data!, 'balance': bal.toStringAsFixed(2)});
        final limit = double.tryParse('${c.data!['credit_limit']}') ?? 0;
        if (limit > 0 && -bal > limit) flags.add('credit_limit_exceeded');
      }
    }
    final number = 'INV-20261029-${(++saleCounter).toString().padLeft(4, '0')}';
    knownIds.add(id);
    return OpResult(
      opId: opId,
      status: 'applied',
      serverId: id,
      officialNumber: number,
      flags: flags,
    );
  }

  @override
  Future<List<FlaggedSale>> flags({String? flag, int skip = 0, int limit = 100}) async {
    _gate();
    final out = <FlaggedSale>[];
    for (final e in processed.entries) {
      if (e.value.flags.isEmpty) continue;
      if (flag != null && !e.value.flags.contains(flag)) continue;
      out.add(FlaggedSale(
        id: e.value.serverId ?? e.key,
        saleNumber: e.value.officialNumber ?? '',
        flags: e.value.flags,
        totalAmount: '0',
        cashierName: 'Cashier',
      ));
    }
    return out;
  }
}
