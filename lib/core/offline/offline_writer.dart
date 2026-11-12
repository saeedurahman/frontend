import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';

/// Who is acting (cashier) - resolved from the cached signed-in user.
class ActingUser {
  const ActingUser({required this.id, this.name, this.businessId, this.branchId});
  final String id;
  final String? name;
  final String? businessId;
  final String? branchId;
}

/// The one write path for POS work.
///
/// Every method does exactly two things in ONE database transaction: write
/// the local record the UI reads, and queue the matching outbox op. The sync
/// engine is then nudged by the store (`enqueued`). There is no separate
/// "online" code path, and a crash can never leave one without the other.
class OfflineWriter {
  OfflineWriter({
    required SyncStore store,
    required IdGenerator ids,
    required Future<String> Function() deviceId,
    required Future<ActingUser?> Function() actingUser,
  })  : _store = store,
        _ids = ids,
        _deviceId = deviceId,
        _actingUser = actingUser;

  final SyncStore _store;
  final IdGenerator _ids;
  final Future<String> Function() _deviceId;
  final Future<ActingUser?> Function() _actingUser;

  String _occurredAt() => _store.now().toUtc().toIso8601String();

  /// `D3F9-0001` style: 4 hex chars of the device id + a per-device counter.
  static String receiptNumber(String deviceId, int n) {
    final short = deviceId.replaceAll('-', '').padRight(4, '0').substring(0, 4);
    return 'D${short.toUpperCase()}-${n.toString().padLeft(4, '0')}';
  }

  Future<ActingUser> _user() async {
    final user = await _actingUser();
    if (user == null) throw StateError('No signed-in user');
    return user;
  }

  /// Op id of a not-yet-synced creating op, to use as `depends_on`.
  Future<String?> _pendingCreator(String type, String entity, String entityId) async {
    final ops = await _store.ops(statuses: OutboxStatus.unfinished);
    for (final o in ops) {
      if (o.type == type && o.entity == entity && o.entityId == entityId) {
        return o.opId;
      }
    }
    return null;
  }

  Future<String?> _pendingShiftOpen(String? shiftId) async {
    if (shiftId == null) return null;
    final shift = await _store.shift(shiftId);
    final opId = shift?['open_op_id'] as String?;
    if (opId == null) return null;
    final op = await _store.op(opId);
    return (op != null && op.status != OutboxStatus.applied) ? opId : null;
  }

  // ── sale ─────────────────────────────────────────────────────────────

  /// Saves a sale locally and queues `sale.create`. [body] is the cart body
  /// from `PosSaleRequestBuilder` (+ client sale `id`).
  ///
  /// Idempotent per sale id: saving the same id twice returns the first row.
  Future<Map<String, Object?>> saveSale(Map<String, dynamic> body) async {
    final user = await _user();
    final deviceId = await _deviceId();
    final saleId = (body['id'] as String?) ?? _ids.saleId();

    final existing = await _store.sale(saleId);
    if (existing != null) return existing;

    // Names are local-only (receipts); they are stripped from the payload.
    final names = <String, String>{};
    for (final raw in (body['lines'] as List)) {
      final l = raw as Map;
      final pid = '${l['product_id']}';
      final product = await _store.entity('product', pid);
      names[pid] = '${product?['name'] ?? 'Item'}';
      if (l['variation_id'] != null) {
        final v = await _store.entity('product_variation', '${l['variation_id']}');
        if (v != null) names['$pid:${l['variation_id']}'] = '${v['name']}';
      }
    }

    final lines = <Map<String, dynamic>>[];
    final localLines = <Map<String, dynamic>>[];
    final amounts = <LineAmounts>[];
    var order = 0;
    for (final raw in (body['lines'] as List)) {
      final l = Map<String, dynamic>.from(raw as Map);
      order++;
      final qty = Decimal.parse('${l['qty']}');
      final price = Decimal.parse('${l['unit_price']}');
      final pct = Decimal.tryParse('${l['discount_pct'] ?? 0}') ?? Decimal.zero;
      final amt = Decimal.tryParse('${l['discount_amount'] ?? 0}') ?? Decimal.zero;
      final rate = Decimal.tryParse('${l['tax_rate'] ?? 0}') ?? Decimal.zero;
      final calc = PricingEngine.calculateLineTotal(
        qty: qty,
        unitPrice: price,
        discountPct: pct,
        discountAmount: amt,
        taxRate: rate,
      );
      amounts.add(calc);
      final line = <String, dynamic>{
        'id': _ids.newId(),
        'product_id': l['product_id'],
        'variation_id': l['variation_id'],
        'qty': DecimalUtils.format(qty),
        'unit_price': DecimalUtils.format(price),
        'discount_pct': DecimalUtils.format(pct),
        'discount_amount': DecimalUtils.format(amt),
        'tax_rate': DecimalUtils.format(rate),
        'tax_amount': DecimalUtils.format(calc.taxAmount),
        'notes': l['notes'],
        'line_order': l['line_order'] ?? order,
      };
      lines.add(line);
      final pid = '${l['product_id']}';
      localLines.add({
        ...line,
        'line_total': DecimalUtils.format(calc.lineTotal),
        'product_name': names[l['variation_id'] == null ? pid : '$pid:${l['variation_id']}'] ??
            names[pid],
        'variation_name':
            l['variation_id'] == null ? null : names['$pid:${l['variation_id']}'],
      });
    }
    final totals = PricingEngine.calculateSaleTotals(amounts);

    final payments = <Map<String, dynamic>>[];
    var credit = Decimal.zero;
    var paid = Decimal.zero;
    for (final raw in (body['payments'] as List? ?? const [])) {
      final p = Map<String, dynamic>.from(raw as Map);
      final amount = Decimal.parse('${p['amount']}');
      if (p['payment_method'] == 'credit') {
        credit += amount;
      } else {
        paid += amount;
      }
      payments.add({
        'payment_method': p['payment_method'],
        'amount': DecimalUtils.format(amount),
        if (p['tendered_amount'] != null) 'tendered_amount': p['tendered_amount'],
        if (p['change_given'] != null) 'change_given': p['change_given'],
        if (p['reference_no'] != null) 'reference_no': p['reference_no'],
      });
    }

    final customerId = body['customer_id'] as String?;
    final customer =
        customerId == null ? null : await _store.entity('customer', customerId);
    final occurredAt = _occurredAt();
    final opId = _ids.opId();

    final payload = <String, dynamic>{
      'id': saleId,
      'client_receipt_no': '', // set inside the transaction
      'branch_id': body['branch_id'],
      'register_shift_id': body['register_shift_id'],
      'customer_id': customerId,
      'sale_type': body['sale_type'] ?? 'pos',
      'price_list_id': body['price_list_id'],
      'discount_scheme_id': body['discount_scheme_id'],
      'notes': body['notes'],
      'lines': lines,
      'payments': payments,
    };

    return _store.transaction(() async {
      final receipt = receiptNumber(deviceId, await _store.nextReceiptNumber());
      payload['client_receipt_no'] = receipt;
      final deps = <String>[
        ?await _pendingShiftOpen(body['register_shift_id'] as String?),
        if (customerId != null)
          ?await _pendingCreator(OpTypes.customerCreate, 'customer', customerId),
      ];
      await _store.insertSale({
        'id': saleId,
        'op_id': opId,
        'receipt_no': receipt,
        'status': 'completed',
        'sync_state': 'pending',
        'branch_id': '${body['branch_id']}',
        'shift_id': body['register_shift_id'],
        'customer_id': customerId,
        'customer_name': customer?['name'],
        'user_id': user.id,
        'subtotal': DecimalUtils.format(totals['subtotal']!),
        'total_discount': DecimalUtils.format(totals['total_discount']!),
        'total_tax': DecimalUtils.format(totals['total_tax']!),
        'total_amount': DecimalUtils.format(totals['total_amount']!),
        'total_paid': DecimalUtils.format(paid + credit),
        'credit_amount': DecimalUtils.format(credit),
        'flags': '[]',
        'lines': jsonEncode(localLines),
        'payments': jsonEncode(payments),
        'notes': body['notes'],
        'sold_at': occurredAt,
        'created_at': _store.now().millisecondsSinceEpoch,
      });
      await _store.enqueue(
        opId: opId,
        type: OpTypes.saleCreate,
        payload: payload,
        occurredAt: occurredAt,
        dependsOn: deps,
        entity: customerId == null ? null : 'customer',
        entityId: customerId,
      );
      return (await _store.sale(saleId))!;
    });
  }

  // ── customers ────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> body) async {
    final user = await _user();
    final id = _ids.customerId();
    final nowIso = _occurredAt();
    final payload = <String, dynamic>{
      'id': id,
      'name': '${body['name']}',
      if (body['phone'] != null && '${body['phone']}'.isNotEmpty) 'phone': body['phone'],
      if (body['email'] != null && '${body['email']}'.isNotEmpty) 'email': body['email'],
      if (body['tax_id'] != null) 'tax_id': body['tax_id'],
      if (body['address_line1'] != null) 'address_line1': body['address_line1'],
      if (body['city'] != null) 'city': body['city'],
      'credit_limit': '${body['credit_limit'] ?? '0'}',
    };
    final entity = <String, dynamic>{
      ...payload,
      'business_id': user.businessId,
      'is_active': true,
      'balance': '0.00',
      'created_at': nowIso,
      'updated_at': nowIso,
    };
    await _store.transaction(() async {
      await _store.putEntity('customer', id, entity);
      await _store.enqueue(
        opId: _ids.opId(),
        type: OpTypes.customerCreate,
        payload: payload,
        occurredAt: nowIso,
        entity: 'customer',
        entityId: id,
      );
    });
    return entity;
  }

  /// Customer pays off balance. Returns the ledger entry id.
  Future<String> recordCustomerPayment({
    required String customerId,
    required Decimal amount,
    required String paymentMethod,
    String? registerShiftId,
    String? referenceNo,
    String? notes,
  }) async {
    final ledgerId = _ids.newId();
    final payload = <String, dynamic>{
      'id': ledgerId,
      'customer_id': customerId,
      'amount': DecimalUtils.format(amount),
      'payment_method': paymentMethod,
      if (registerShiftId != null) 'register_shift_id': registerShiftId,
      if (referenceNo != null && referenceNo.isNotEmpty) 'reference_no': referenceNo,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };
    await _store.transaction(() async {
      final deps = <String>[
        ?await _pendingCreator(OpTypes.customerCreate, 'customer', customerId),
        ?await _pendingShiftOpen(registerShiftId),
      ];
      await _store.enqueue(
        opId: _ids.opId(),
        type: OpTypes.customerPayment,
        payload: payload,
        occurredAt: _occurredAt(),
        dependsOn: deps,
        entity: 'customer',
        entityId: customerId,
      );
    });
    return ledgerId;
  }

  // ── expenses ─────────────────────────────────────────────────────────

  Future<void> createExpense(Map<String, dynamic> body) =>
      _store.transaction(() async {
        await _store.enqueue(
          opId: _ids.opId(),
          type: OpTypes.expenseCreate,
          payload: Map<String, dynamic>.from(body)..remove('id'),
          occurredAt: _occurredAt(),
        );
      });

  // ── shifts ───────────────────────────────────────────────────────────

  /// Opens a shift locally; the op references the client shift id.
  Future<Map<String, Object?>> openShift({
    required String registerId,
    String? registerName,
    String? branchId,
    required Decimal openingFloat,
    String? notes,
  }) async {
    final user = await _user();
    final id = _ids.shiftId();
    final at = _occurredAt();
    final opId = _ids.opId();
    return _store.transaction(() async {
      await _store.upsertShift({
        'id': id,
        'register_id': registerId,
        'register_name': registerName,
        'branch_id': branchId ?? user.branchId,
        'user_id': user.id,
        'status': 'open',
        'opening_float': DecimalUtils.format(openingFloat),
        'notes': notes,
        'opened_at': at,
        'sync_state': 'pending',
        'open_op_id': opId,
      });
      await _store.enqueue(
        opId: opId,
        type: OpTypes.shiftOpen,
        payload: {
          'id': id,
          'cash_register_id': registerId,
          'opening_float': DecimalUtils.format(openingFloat),
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
        occurredAt: at,
      );
      return (await _store.shift(id))!;
    });
  }

  Future<void> closeShift({
    required String shiftId,
    required Decimal actualCash,
    String? notes,
  }) async {
    final at = _occurredAt();
    final opId = _ids.opId();
    await _store.transaction(() async {
      final deps = <String>[?await _pendingShiftOpen(shiftId)];
      await _store.updateShift(shiftId, {
        'status': 'closed',
        'actual_cash': DecimalUtils.format(actualCash),
        'closed_at': at,
        'sync_state': 'pending',
        'close_op_id': opId,
      });
      await _store.enqueue(
        opId: opId,
        type: OpTypes.shiftClose,
        payload: {
          'shift_id': shiftId,
          'actual_cash': DecimalUtils.format(actualCash),
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
        occurredAt: at,
        dependsOn: deps,
      );
    });
  }

  // ── returns / voids ──────────────────────────────────────────────────

  /// Return of a synced or still-local sale (the client sale id is the
  /// server sale id, so `depends_on` the sale's own op when it is pending).
  Future<String> createReturn(Map<String, dynamic> body) async {
    final id = _ids.returnId();
    final saleId = body['sale_id'] as String?;
    await _store.transaction(() async {
      final deps = <String>[];
      if (saleId != null) {
        final sale = await _store.sale(saleId);
        final opId = sale?['op_id'] as String?;
        if (opId != null) {
          final op = await _store.op(opId);
          if (op != null && op.status != OutboxStatus.applied) deps.add(opId);
        }
      }
      await _store.enqueue(
        opId: _ids.opId(),
        type: OpTypes.returnCreate,
        payload: Map<String, dynamic>.from(body)..remove('id'),
        occurredAt: _occurredAt(),
        dependsOn: deps,
      );
    });
    return id;
  }

  /// `sale.void` is only for sales the server already has.
  Future<bool> canVoid(String saleId) async {
    final local = await _store.sale(saleId);
    return local == null || local['sync_state'] == 'synced';
  }

  Future<void> voidSale(String saleId, {String? reason}) async {
    if (!await canVoid(saleId)) {
      throw StateError('This sale has not reached the server yet.');
    }
    await _store.transaction(() async {
      await _store.enqueue(
        opId: _ids.opId(),
        type: OpTypes.saleVoid,
        payload: {'sale_id': saleId, if (reason != null) 'reason': reason},
        occurredAt: _occurredAt(),
        entity: 'sale',
        entityId: saleId,
      );
    });
  }
}
