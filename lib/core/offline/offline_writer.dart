import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/offline/sale_line_modifiers.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';
import 'package:frantend/features/suppliers/domain/supplier_text.dart';

/// Drawer money was recorded with no open shift on this device.
class NoOpenShiftException implements Exception {
  const NoOpenShiftException();
}

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

  /// `C1-0042`: the register code the server gave this device + a per-device
  /// counter (optionally behind the business `receipt.number_prefix`).
  ///
  /// Until the device has been told its code (a new install that has never
  /// reached the server) it falls back to the old hash-like prefix
  /// (`D3F9-0001`). The two forms can never collide: the code never starts
  /// with `D` + four hex characters.
  static String receiptNumber(
    String deviceId,
    int n, {
    String? shortCode,
    String prefix = '',
  }) {
    final counter = n.toString().padLeft(4, '0');
    final code = shortCode?.trim();
    if (code != null && code.isNotEmpty) {
      return '${prefix.trim()}${code.toUpperCase()}-$counter';
    }
    final short = deviceId.replaceAll('-', '').padRight(4, '0').substring(0, 4);
    return 'D${short.toUpperCase()}-$counter';
  }

  /// Next number nobody has used yet. The counter never goes back (it
  /// survives a data wipe); the loop only skips numbers that already exist on
  /// this device, e.g. after the owner renamed the register code to one this
  /// device used before.
  Future<String> _nextReceiptNumber(String deviceId) async {
    final code = await _store.meta(SyncStore.deviceShortCodeKey);
    final prefix = await _store.meta(SyncStore.numberPrefixKey) ?? '';
    for (var i = 0; i < 10000; i++) {
      final n = await _store.nextReceiptNumber();
      final number = receiptNumber(deviceId, n, shortCode: code, prefix: prefix);
      if (!await _store.receiptNoTaken(number)) return number;
    }
    throw StateError('Could not find a free receipt number');
  }

  /// The device's own allocation, as the server expects it on a sale line.
  static List<Map<String, dynamic>> _batchesOf(Object? raw) {
    if (raw is! List) return const [];
    return [
      for (final b in raw)
        if (b is Map && b['qty'] != null)
          {
            'batch_no': b['batch_no'],
            'expiry_date': b['expiry_date'],
            'qty': '${b['qty']}',
          },
    ];
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

    // The mode this sale is made in is frozen on the sale (the server treats
    // it as a snapshot and flags differences instead of re-pricing).
    final tax = TaxSettingsHolder.current;
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
        inclusive: tax.inclusive,
      );
      amounts.add(calc);
      // `unit_price` already includes the modifiers (the contract the server
      // checks); the modifiers are recorded next to it, never added again.
      final modifiers = SaleLineModifier.listFrom(l['modifiers']);
      final batches = _batchesOf(l['batches']);
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
        'net_amount': DecimalUtils.format(calc.netAmount),
        'notes': l['notes'],
        'line_order': l['line_order'] ?? order,
        if (modifiers.isNotEmpty)
          'modifiers': [for (final m in modifiers) m.toPayload()],
        if (batches.isNotEmpty) 'batches': batches,
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
    final totals = PricingEngine.totalsOf(amounts, roundingMode: tax.roundingMode);

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
      'tax_inclusive': tax.inclusive,
      'tax_rounding_mode': tax.roundingMode,
      'tax_label': tax.label,
      'rounding_amount': DecimalUtils.format(totals.roundingAmount),
      'total_amount': DecimalUtils.format(totals.totalAmount),
      'lines': lines,
      'payments': payments,
      if (body['credit_override'] == true) 'credit_override': true,
    };

    return _store.transaction(() async {
      final receipt = await _nextReceiptNumber(deviceId);
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
        'subtotal': DecimalUtils.format(totals.subtotal),
        'total_discount': DecimalUtils.format(totals.totalDiscount),
        'total_tax': DecimalUtils.format(totals.totalTax),
        'net_amount': DecimalUtils.format(totals.netAmount),
        'exact_total': DecimalUtils.format(totals.exactTotal),
        'rounding_amount': DecimalUtils.format(totals.roundingAmount),
        'tax_inclusive': tax.inclusive ? 1 : 0,
        'tax_rounding_mode': tax.roundingMode,
        'tax_label': tax.label,
        'total_amount': DecimalUtils.format(totals.totalAmount),
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
    required String paymentSource,
    String? registerShiftId,
    String? referenceNo,
    String? notes,
    String? branchId,
  }) async {
    final ledgerId = _ids.newId();
    final payload = <String, dynamic>{
      'id': ledgerId,
      'customer_id': customerId,
      'amount': DecimalUtils.format(amount),
      'payment_source': paymentSource,
      // A payment with no branch is business-wide on the server, so the
      // branch it was taken in always travels with it.
      if (branchId != null && branchId.isNotEmpty) 'branch_id': branchId,
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

  // ── suppliers ────────────────────────────────────────────────────────

  /// Saves a new supplier on this device and queues `supplier.create`: the row
  /// and the op in one transaction. [body] is the `POST /suppliers` body, with
  /// an optional `opening_balance`. Returns the row as the sync feed sends it.
  ///
  /// Throws [SupplierInputException] or [DuplicateSupplierException].
  Future<Map<String, dynamic>> createSupplier(Map<String, dynamic> body) async {
    final user = await _user();
    final id = _ids.newId();
    final occurredAt = _occurredAt();
    final fields = SupplierRules.fields(body)
      ..removeWhere((_, value) => value == '');
    final problems = SupplierRules.problems({'name': '', ...fields});
    if (problems.isNotEmpty) throw SupplierInputException(problems);
    final opening = body['opening_balance'];
    final payload = <String, dynamic>{
      'id': id,
      ...fields,
      if (opening is Map) 'opening_balance': Map<String, dynamic>.from(opening),
    };
    final row = <String, dynamic>{
      'id': id,
      'business_id': user.businessId,
      'payment_terms_days': 30,
      ...fields,
      'is_active': true,
      'created_at': occurredAt,
      'updated_at': occurredAt,
    };
    await _store.transaction(() async {
      await _refuseDuplicate(id, fields);
      await _store.putEntity('supplier', id, row);
      await _store.enqueue(
        opId: _ids.opId(),
        type: OpTypes.supplierCreate,
        payload: payload,
        occurredAt: occurredAt,
        entity: 'supplier',
        entityId: id,
      );
    });
    return row;
  }

  /// Saves an edit on this device and queues `supplier.update` with only the
  /// fields that changed. An edit of a new supplier the server has refused is
  /// put into its `supplier.create` instead. Returns the row as it now is.
  ///
  /// Throws [SupplierInputException], [DuplicateSupplierException] or
  /// [SupplierNotOnDeviceException].
  Future<Map<String, dynamic>> updateSupplier(
    String id,
    Map<String, dynamic> body,
  ) async {
    final occurredAt = _occurredAt();
    final asked = SupplierRules.fields(body);
    return _store.transaction(() async {
      final current = await _store.entity('supplier', id);
      if (current == null) throw const SupplierNotOnDeviceException();
      final fields = <String, dynamic>{
        for (final e in asked.entries)
          if ('${e.value}' != '${current[e.key] ?? ''}') e.key: e.value,
      };
      if (fields.isEmpty) return current;
      final problems = SupplierRules.problems(fields);
      if (problems.isNotEmpty) throw SupplierInputException(problems);
      await _refuseDuplicate(id, fields);
      final next = {...current, ...fields, 'updated_at': occurredAt};

      final create = (await _store.unfinishedSupplierOps(
        id,
        OpTypes.supplierCreate,
      ))
          .firstOrNull;
      if (create != null && create.needsAttention) {
        await _store.amendAndRetry(
          create.opId,
          {...create.payload, ...fields}..removeWhere((_, v) => v == ''),
        );
      } else {
        // Edits the server refused go again with this one.
        var send = fields;
        for (final o in await _store.unfinishedSupplierOps(
          id,
          OpTypes.supplierUpdate,
        )) {
          if (!o.needsAttention) continue;
          send = {
            ...Map<String, dynamic>.from(o.payload['fields'] as Map),
            ...send,
          };
          await _store.removeSuperseded(o.opId);
        }
        if (create == null) await _store.keepSupplierBase(id, current);
        await _store.enqueue(
          opId: _ids.opId(),
          type: OpTypes.supplierUpdate,
          payload: {'id': id, 'fields': send},
          occurredAt: occurredAt,
          dependsOn: [if (create != null) create.opId],
          entity: 'supplier',
          entityId: id,
        );
      }
      await _store.putEntity('supplier', id, next);
      return next;
    });
  }

  /// The server keeps names and phones unique; what this device holds is
  /// checked before anything is queued.
  Future<void> _refuseDuplicate(
    String id,
    Map<String, dynamic> fields,
  ) async {
    final name = fields.containsKey('name')
        ? SupplierRules.nameKey(fields['name'])
        : null;
    final phone = SupplierRules.phoneKey(fields['phone']);
    if (name == null && phone == null) return;
    for (final other in await _store.entities('supplier', orderBy: 'id')) {
      if ('${other['id']}' == id) continue;
      final field = name != null && SupplierRules.nameKey(other['name']) == name
          ? 'name'
          : phone != null && SupplierRules.phoneKey(other['phone']) == phone
              ? 'phone'
              : null;
      if (field != null) {
        throw DuplicateSupplierException(
          field: field,
          existingId: '${other['id']}',
          existingName: '${other['name']}',
        );
      }
    }
  }

  // ── supplier payments ────────────────────────────────────────────────

  /// Saves a payment to a supplier on this device and queues
  /// `supplier.payment`: the account line and the op in one transaction.
  /// [body] is the `POST /suppliers/payments` body; [id] becomes the ledger
  /// row's id on the server too. Returns the queued payload.
  ///
  /// Money from the cash drawer goes with this user's open shift on this
  /// device, and its branch; without one this throws [NoOpenShiftException].
  /// Every other source needs no shift. Saving the same [id] twice queues it
  /// once.
  Future<Map<String, dynamic>> recordSupplierPayment(
    Map<String, dynamic> body, {
    String? id,
  }) async {
    final user = await _user();
    final ledgerId = id ?? _ids.newId();
    final supplierId = '${body['supplier_id']}';
    final source = '${body['payment_source']}';
    final occurredAt = _occurredAt();
    String? text(String key) {
      final value = body[key]?.toString().trim();
      return value == null || value.isEmpty ? null : value;
    }

    return _store.transaction(() async {
      for (final o in await _store.ops()) {
        if (o.type == OpTypes.supplierPayment && o.payload['id'] == ledgerId) {
          return o.payload;
        }
      }
      final shift = source == 'drawer'
          ? await _store.openShiftFor(user.id)
          : null;
      if (source == 'drawer' && shift == null) {
        throw const NoOpenShiftException();
      }
      final shiftId = shift?['id'] as String?;
      final branchId = shift?['branch_id'] as String? ?? text('branch_id');
      final payload = <String, dynamic>{
        'id': ledgerId,
        'supplier_id': supplierId,
        'amount': DecimalUtils.format(Decimal.parse('${body['amount']}')),
        'payment_source': source,
        if (text('reference') != null) 'reference': text('reference'),
        if (text('note') != null) 'note': text('note'),
        'paid_at': text('paid_at') ?? occurredAt,
        if (branchId != null) 'branch_id': branchId,
        if (shiftId != null) 'register_shift_id': shiftId,
      };
      final deps = <String>[
        ?await _pendingCreator(OpTypes.supplierCreate, 'supplier', supplierId),
        ?await _pendingShiftOpen(shiftId),
      ];
      await _store.putEntity('supplier_ledger', ledgerId, {
        'id': ledgerId,
        'business_id': user.businessId,
        'supplier_id': supplierId,
        'branch_id': branchId,
        'entry_type': 'payment',
        'amount': payload['amount'],
        'payment_source': source,
        'reference_no': text('reference'),
        'reference_type': 'manual',
        'reference_id': supplierId,
        'notes': text('note'),
        'register_shift_id': shiftId,
        'entry_at': payload['paid_at'],
        'created_at': occurredAt,
        SyncStore.localRowKey: true,
      });
      await _store.enqueue(
        opId: _ids.opId(),
        type: OpTypes.supplierPayment,
        payload: payload,
        occurredAt: occurredAt,
        dependsOn: deps,
        entity: 'supplier_ledger',
        entityId: ledgerId,
      );
      return payload;
    });
  }

  // ── khata follow-ups ─────────────────────────────────────────────────

  /// Saves a promise, reminder or note locally and queues `followup.create`.
  /// [body] is the `POST /khata/followups` body; the row is returned as it is
  /// shown until the server has it.
  Future<Map<String, dynamic>> createFollowup(Map<String, dynamic> body) async {
    final user = await _user();
    final id = _ids.newId();
    final payload = <String, dynamic>{...body, 'id': id};
    final partyType = '${body['party_type']}';
    final partyId = '${body['party_id']}';
    final occurredAt = _occurredAt();
    final row = <String, dynamic>{
      ...payload,
      'created_at': occurredAt,
      'created_by': user.id,
    };
    await _store.transaction(() async {
      // A customer or supplier made offline must reach the server first.
      final deps = <String>[
        if (partyType == 'customer')
          ?await _pendingCreator(OpTypes.customerCreate, 'customer', partyId),
        if (partyType == 'supplier')
          ?await _pendingCreator(OpTypes.supplierCreate, 'supplier', partyId),
      ];
      await _store.putEntity('party_followup', id, row);
      await _store.enqueue(
        opId: _ids.opId(),
        type: OpTypes.followupCreate,
        payload: payload,
        occurredAt: occurredAt,
        dependsOn: deps,
        entity: 'party_followup',
        entityId: id,
      );
    });
    return row;
  }

  // ── expenses ─────────────────────────────────────────────────────────

  /// Returns the id of the queued op (the only id the expense has until the
  /// server gives it one).
  Future<String> createExpense(Map<String, dynamic> body) async {
    final opId = _ids.opId();
    final supplierId = body['supplier_id']?.toString();
    await _store.transaction(() async {
      final deps = <String>[
        if (supplierId != null)
          ?await _pendingCreator(
            OpTypes.supplierCreate,
            'supplier',
            supplierId,
          ),
      ];
      await _store.enqueue(
        opId: opId,
        type: OpTypes.expenseCreate,
        payload: Map<String, dynamic>.from(body)..remove('id'),
        occurredAt: _occurredAt(),
        dependsOn: deps,
      );
    });
    return opId;
  }

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
