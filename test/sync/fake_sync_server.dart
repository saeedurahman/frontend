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

  /// Flags the server puts on applied customer and supplier payments.
  List<String> paymentFlags = const [];

  /// What the server does with a `supplier.payment`: a ledger line, then the
  /// supplier's position and bills (oldest paid first) as it now stands.
  OpResult _supplierPayment(String opId, Map<String, dynamic> p) {
    final sid = '${p['supplier_id']}';
    final account = live['supplier_balance|$sid'];
    if (account == null) {
      return OpResult(
        opId: opId,
        status: 'rejected',
        error: const OpError(code: 'unknown_supplier', message: 'no supplier'),
      );
    }
    var paid = double.parse('${p['amount']}');
    final balance = double.parse('${account.data!['advance_amount']}') -
        double.parse('${account.data!['balance_owed']}') +
        paid;
    final position = {
      'id': sid,
      'supplier_id': sid,
      'balance_owed': (balance < 0 ? -balance : 0.0).toStringAsFixed(2),
      'advance_amount': (balance > 0 ? balance : 0.0).toStringAsFixed(2),
    };
    final id = '${p['id']}';
    put('supplier_ledger', id, {
      'id': id,
      'supplier_id': sid,
      'branch_id': p['branch_id'],
      'entry_type': 'payment',
      'amount': '${p['amount']}',
      'payment_source': p['payment_source'],
      'reference_no': p['reference'],
      'reference_type': 'manual',
      'notes': p['note'],
      'register_shift_id': p['register_shift_id'],
      'entry_at': p['paid_at'],
      'running_balance': balance.toStringAsFixed(2),
    });
    put('supplier_balance', sid, position);
    final open = live['supplier_open_items|$sid'];
    if (open != null) {
      final items = <Map<String, dynamic>>[];
      for (final raw in open.data!['items'] as List) {
        final item = Map<String, dynamic>.from(raw as Map);
        final left = double.parse('${item['remaining']}');
        final used = paid < left ? paid : left;
        paid -= used;
        if (left - used <= 0) continue;
        items.add({
          ...item,
          'remaining': (left - used).toStringAsFixed(2),
          'allocated': (double.parse('${item['allocated']}') + used)
              .toStringAsFixed(2),
        });
      }
      put('supplier_open_items', sid, {
        ...position,
        'terms_days': open.data!['terms_days'],
        'items': items,
      });
    }
    knownIds.add(id);
    return OpResult(
      opId: opId,
      status: 'applied',
      serverId: id,
      flags: paymentFlags,
    );
  }

  /// Names ignoring case and extra spaces, phones by their digits: neither may
  /// be another supplier's. Null when the values are free.
  OpResult? _duplicate(String opId, String id, Map<String, dynamic> values) {
    String name(Object? v) =>
        '${v ?? ''}'.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
    String digits(Object? v) => '${v ?? ''}'.replaceAll(RegExp(r'[^0-9]'), '');
    for (final change in live.values) {
      if (change.entity != 'supplier' || change.id == id) continue;
      final other = change.data!;
      final field = values.containsKey('name') &&
              name(other['name']) == name(values['name'])
          ? 'name'
          : digits(values['phone']).isNotEmpty &&
                  digits(other['phone']) == digits(values['phone'])
              ? 'phone'
              : null;
      if (field == null) continue;
      return OpResult(
        opId: opId,
        status: 'conflict',
        error: OpError(
          code: 'duplicate_supplier',
          message: 'Another supplier already has this $field',
          details: {'field': field, 'existing_supplier_id': change.id},
        ),
      );
    }
    return null;
  }

  OpResult _supplierCreate(String opId, Map<String, dynamic> p) {
    final id = '${p['id']}';
    if (knownIds.contains(id)) {
      return OpResult(
        opId: opId,
        status: 'conflict',
        error: const OpError(code: 'id_exists', message: 'exists'),
      );
    }
    final refused = _duplicate(opId, id, p);
    if (refused != null) return refused;
    final opening = p['opening_balance'] as Map?;
    final amount = double.parse('${opening?['amount'] ?? 0}') *
        (opening?['direction'] == 'we_owe_them' ? -1 : 1);
    put('supplier', id, {
      'id': id,
      'name': p['name'],
      for (final key in const [
        'phone',
        'email',
        'contact_person',
        'address',
        'city',
        'tax_id',
        'notes',
      ])
        key: p[key],
      'payment_terms_days': p['payment_terms_days'] ?? 30,
      'is_active': true,
    });
    final position = {
      'id': id,
      'supplier_id': id,
      'balance_owed': (amount < 0 ? -amount : 0.0).toStringAsFixed(2),
      'advance_amount': (amount > 0 ? amount : 0.0).toStringAsFixed(2),
      'has_older_entries': false,
      'oldest_included_entry_at': opening?['as_of_date'],
    };
    put('supplier_balance', id, position);
    put('supplier_open_items', id, {
      ...position,
      'terms_days': p['payment_terms_days'] ?? 30,
      'items': [
        if (amount < 0)
          {
            'document_type': 'opening_balance',
            'document_id': 'ob-$id',
            'date': opening!['as_of_date'],
            'total': (-amount).toStringAsFixed(2),
            'allocated': '0.00',
            'remaining': (-amount).toStringAsFixed(2),
          },
      ],
    });
    if (opening != null) {
      put('supplier_ledger', 'ob-$id', {
        'id': 'ob-$id',
        'supplier_id': id,
        'branch_id': opening['branch_id'],
        'entry_type': 'opening_balance',
        'amount': amount.toStringAsFixed(2),
        'source': 'opening',
        'entry_at': '${opening['as_of_date']}T00:00:00+00:00',
        'running_balance': amount.toStringAsFixed(2),
      });
    }
    return OpResult(opId: opId, status: 'applied', serverId: id);
  }

  OpResult _supplierUpdate(String opId, Map<String, dynamic> p) {
    final id = '${p['id']}';
    final held = live['supplier|$id'];
    if (held == null) {
      return OpResult(
        opId: opId,
        status: 'rejected',
        error: const OpError(
          code: 'unknown_supplier',
          message: 'no supplier',
          retryable: true,
        ),
      );
    }
    final fields = Map<String, dynamic>.from(p['fields'] as Map);
    final changed = {
      for (final key in const ['name', 'phone'])
        if (fields.containsKey(key) && fields[key] != held.data![key])
          key: fields[key],
    };
    final refused = _duplicate(opId, id, changed);
    if (refused != null) return refused;
    put('supplier', id, {...held.data!, ...fields});
    return OpResult(opId: opId, status: 'applied', serverId: id);
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
        put('customer', id, {...payload, 'is_active': true, 'balance': '0.00', 'balance_owed': '0.00'});
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
        put('customer', cid, {
          ...c.data!,
          'balance': newBal,
          'balance_owed': (-double.parse(newBal)).toStringAsFixed(2),
        });
        result = OpResult(
          opId: opId,
          status: 'applied',
          serverId: '${payload['id'] ?? opId}',
          flags: paymentFlags,
        );
      case 'supplier.payment':
        result = _supplierPayment(opId, payload);
      case 'supplier.create':
        result = _supplierCreate(opId, payload);
      case 'supplier.update':
        result = _supplierUpdate(opId, payload);
      case 'followup.create':
        final id = '${payload['id']}';
        knownIds.add(id);
        put('party_followup', id, {
          ...payload,
          'created_at': op['occurred_at'],
        });
        result = OpResult(opId: opId, status: 'applied', serverId: id);
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
        put('customer', '$customerId', {
          ...c.data!,
          'balance': bal.toStringAsFixed(2),
          'balance_owed': (-bal).toStringAsFixed(2),
        });
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
