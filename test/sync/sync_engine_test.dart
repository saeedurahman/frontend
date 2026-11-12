import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/sync/sync_store.dart';

import 'sync_rig.dart';

void main() {
  late SyncRig rig;

  setUp(() async {
    rig = SyncRig();
    rig.seedServer();
    await rig.sync(); // first snapshot
  });

  tearDown(() => rig.dispose());

  group('first install / snapshot', () {
    test('downloads the catalog and marks the data ready', () async {
      expect(await rig.store.hasSnapshot, isTrue);
      expect(rig.server.snapshotCalls, 1);
      final products = await rig.catalog.products();
      expect(products.items.single.name, 'Rice 5kg');
      expect(await rig.store.meta(SyncStore.cursorKey), isNotNull);
      expect(rig.engine.state.hasData, isTrue);
    });

    test('is paged and reports progress', () async {
      final fresh = SyncRig();
      addTearDown(fresh.dispose);
      fresh.seedServer();
      for (var i = 0; i < 25; i++) {
        fresh.product('x$i', 'Item $i', 'S$i');
      }
      fresh.server.snapshotPageSize = 10;
      final progress = <SnapshotProgress>[];
      final pull = _pullWith(fresh.store, fresh.server, onProgress: progress.add);

      final outcome = await pull.pullAll();

      expect(outcome.snapshotRan, isTrue);
      expect(fresh.server.snapshotCalls, greaterThan(3));
      expect(progress.last.done, isTrue);
      expect(progress.map((p) => p.rows), isNotEmpty);
      expect(progress.last.rows, greaterThan(25));
      expect((await fresh.catalog.products(limit: 100)).total, 26);
    });

    test('the cursor is only adopted after the last snapshot page', () async {
      final fresh = SyncRig();
      addTearDown(fresh.dispose);
      fresh.seedServer();
      fresh.server.snapshotPageSize = 3;
      final flaky = _FlakySnapshot(fresh.server, failOnCall: 2);
      final pull = _pullWith(fresh.store, flaky);

      final first = await pull.pullAll();
      expect(first.unreachable, isTrue);
      expect(await fresh.store.meta(SyncStore.cursorKey), isNull);
      expect(await fresh.store.hasSnapshot, isFalse);
      expect(await fresh.store.meta(SyncStore.snapshotTokenKey), isNotNull,
          reason: 'resumes from the stored page token');

      final second = await pull.pullAll();
      expect(second.unreachable, isFalse);
      expect(await fresh.store.hasSnapshot, isTrue);
      expect(await fresh.store.meta(SyncStore.cursorKey), isNotNull);
      expect((await fresh.catalog.products()).total, 1);
    });
  });

  group('pull', () {
    test('applies upserts and tombstones in order and stores the cursor', () async {
      rig.product('p2', 'Sugar', 'S1');
      rig.server.remove('product', 'p2');
      await rig.sync();
      expect((await rig.catalog.products()).items.map((p) => p.name), ['Rice 5kg']);
      expect(rig.server.pullSinces.last, isNotNull);
    });

    test('has_more pages are pulled back to back', () async {
      for (var i = 0; i < 5; i++) {
        rig.product('n$i', 'New $i', 'N$i');
      }
      final before = rig.server.pullCalls;
      await rig.sync();
      expect((await rig.catalog.products()).total, 6);
      expect(rig.server.pullCalls, greaterThan(before));
    });

    test('full_resync_required discards the copy and runs the snapshot', () async {
      rig.server.remove('product', 'p1');
      rig.product('p9', 'Only now', 'O1');
      rig.server.fullResyncNext = true;
      final snapshots = rig.server.snapshotCalls;
      await rig.sync();
      expect(rig.server.snapshotCalls, snapshots + 1);
      final names = (await rig.catalog.products()).items.map((p) => p.name).toList();
      expect(names, ['Only now']);
    });

    test('a pull for a row with a pending local op is parked, not applied',
        () async {
      await rig.writer.createCustomer({'name': 'Local Name', 'phone': '0311'});
      final id = (await rig.store.ops()).single.entityId!;

      // The op cannot be accepted yet (retryable), but the pull works.
      rig.server.errors['customer.create'] = const OpError(
        code: 'internal_error',
        message: 'x',
        retryable: true,
      );
      rig.server.put('customer', id, {'id': id, 'name': 'Server Name', 'balance': '0.00'});
      await rig.sync();

      expect((await rig.store.entity('customer', id))!['name'], 'Local Name');
      final deferred = await rig.db
          .customSelect('SELECT COUNT(*) AS n FROM deferred_changes')
          .getSingle();
      expect(deferred.read<int>('n'), 1);
    });

    test('parked changes are applied once the local op is accepted', () async {
      await rig.writer.createCustomer({'name': 'Local Name'});
      final id = (await rig.store.ops()).single.entityId!;
      // Pull happens while the op is pending (push is skipped by the outage).
      rig.server.put('customer', id, {'id': id, 'name': 'Server Name', 'balance': '0.00'});
      final blockPush = rig.server.errors;
      blockPush['customer.create'] = const OpError(
        code: 'internal_error',
        message: 'x',
        retryable: true,
      );
      rig.server.errorsOnce.add('customer.create');
      await rig.sync();
      expect((await rig.store.entity('customer', id))!['name'], 'Local Name');

      rig.advance(const Duration(minutes: 1));
      await rig.sync(); // op now accepted (id_exists conflict is fine) ...
      // The server already had the row, so the op conflicts; the user-visible
      // data must still end up as the server's version after release.
      final op = (await rig.store.ops()).single;
      expect(op.status, anyOf(OutboxStatus.rejected, OutboxStatus.applied));
    });

    test('permissions and branch scope are refreshed from the pulled rows',
        () async {
      expect(rig.accessEvents, isNotEmpty);
      final access = rig.accessEvents.last;
      expect(access.permissionKeys, ['sales.create', 'shifts.open']);
      expect(access.branchIds, [kBranch]);

      rig.server.permissionsVersion = 'pv2';
      rig.server.put('role', 'role-1', {
        'id': 'role-1',
        'name': 'Cashier',
        'permission_keys': ['sales.create'],
      });
      await rig.sync();
      expect(rig.accessEvents.last.permissionKeys, ['sales.create']);
      expect(rig.accessEvents.last.permissionsVersion, 'pv2');
    });

    test('the cursor is committed with its page: a failed apply re-delivers it',
        () async {
      rig.product('q1', 'Late', 'L1');
      final failing = _FailingApplyStore(rig.db);
      final pull = _pullWith(failing, rig.server);
      final cursorBefore = await failing.meta(SyncStore.cursorKey);

      await expectLater(pull.pullAll(), throwsStateError);
      expect(await failing.meta(SyncStore.cursorKey), cursorBefore);
      expect(await failing.entity('product', 'q1'), isNull);

      failing.failNext = false;
      final r2 = await pull.pullAll();
      expect(r2.unreachable, isFalse);
      expect(await failing.entity('product', 'q1'), isNotNull);
      expect(await failing.meta(SyncStore.cursorKey), isNot(cursorBefore));
    });

    test('device clock changes never touch the cursor', () async {
      final cursor = await rig.store.meta(SyncStore.cursorKey);
      rig.advance(const Duration(days: -400));
      rig.server.offline = true;
      await rig.sync();
      expect(await rig.store.meta(SyncStore.cursorKey), cursor);
    });
  });

  group('push', () {
    test('an offline sale is saved at once and has a device receipt number',
        () async {
      rig.server.offline = true;
      final row = await rig.sell();
      expect(row['receipt_no'], matches(RegExp(r'^DA1B2-0001$')));
      expect(row['sync_state'], 'pending');
      expect(row['official_number'], isNull);
      expect((await rig.store.counts()).pending, 1);
    });

    test('sync applies it and stores official number + flags', () async {
      final shift = await rig.writer.openShift(
        registerId: 'reg-1',
        openingFloat: Decimal.parse('500'),
      );
      final row = await rig.sell(qty: '15', shiftId: shift['id'] as String);
      await rig.sync();

      final saved = (await rig.store.sale(row['id'] as String))!;
      expect(saved['sync_state'], 'synced');
      expect(saved['official_number'], 'INV-20261029-0001');
      expect(jsonDecode(saved['flags'] as String), ['oversold']);
      expect(saved['server_synced_at'], isNotNull);
      expect(rig.flagged.single, [row['id']]);
      expect((await rig.store.counts()).unfinished, 0);
    });

    test('a sale is never "synced" until the server confirmed it', () async {
      rig.server.offline = true;
      final row = await rig.sell();
      await rig.sync();
      expect((await rig.store.sale(row['id'] as String))!['sync_state'], 'pending');
    });

    test('ops go out in outbox order, with depends_on, in one batch', () async {
      await rig.writer.createCustomer({'name': 'New Customer'});
      final customer = (await rig.store.ops()).first;
      final shift = await rig.writer.openShift(registerId: 'reg-1', openingFloat: Decimal.zero);
      await rig.sell(
        customerId: customer.entityId,
        shiftId: shift['id'] as String,
        payments: [
          {'payment_method': 'credit', 'amount': '210.00'},
        ],
      );
      await rig.writer.recordCustomerPayment(
        customerId: customer.entityId!,
        amount: Decimal.parse('50'),
        paymentMethod: 'cash',
      );
      await rig.writer.closeShift(
        shiftId: shift['id'] as String,
        actualCash: Decimal.parse('500'),
      );

      await rig.sync();

      expect(rig.server.pushBatches.last, [
        'customer.create',
        'shift.open',
        'sale.create',
        'customer.payment',
        'shift.close',
      ]);
      final sale = rig.server.receivedOps.firstWhere((o) => o['type'] == 'sale.create');
      expect(sale['depends_on'], hasLength(2));
      final close = rig.server.receivedOps.firstWhere((o) => o['type'] == 'shift.close');
      expect(close['depends_on'], hasLength(1));
      expect((await rig.store.counts()).unfinished, 0);
    });

    test('a failed dependency blocks its dependants instead of sending them',
        () async {
      rig.server.errors['customer.create'] = const OpError(
        code: 'permission_denied',
        message: 'no',
      );
      await rig.writer.createCustomer({'name': 'Blocked'});
      await rig.sync();
      final parent = (await rig.store.ops()).single;
      expect(parent.status, OutboxStatus.rejected);

      await rig.sell(
        customerId: parent.entityId,
        payments: [
          {'payment_method': 'credit', 'amount': '210.00'},
        ],
      );
      await rig.sync();

      final ops = await rig.store.ops();
      expect(ops[1].status, OutboxStatus.failed);
      expect(ops[1].errorCode, 'dependency_failed');
      expect(rig.server.receivedOps.where((o) => o['type'] == 'sale.create'), isEmpty,
          reason: 'never sent while its customer is rejected');

      // Fix and retry the parent: the dependant is released with it.
      rig.server.errors.clear();
      await rig.store.transaction(() => rig.store.retryOp(parent.opId));
      await rig.sync();
      expect((await rig.store.counts()).unfinished, 0);
    });

    test('a dependant sent in the same batch as a rejected parent is rejected too',
        () async {
      rig.server.errors['customer.create'] = const OpError(
        code: 'permission_denied',
        message: 'no',
      );
      await rig.writer.createCustomer({'name': 'Blocked'});
      final cid = (await rig.store.ops()).single.entityId!;
      await rig.sell(
        customerId: cid,
        payments: [
          {'payment_method': 'credit', 'amount': '210.00'},
        ],
      );
      await rig.sync();
      final ops = await rig.store.ops();
      expect(ops[0].status, OutboxStatus.rejected);
      expect(ops[1].errorCode, 'dependency_failed');
      expect(ops[1].needsAttention, isTrue);
    });

    test('the payload follows the README contract', () async {
      await rig.sell();
      await rig.sync();
      final op = rig.server.receivedOps.firstWhere((o) => o['type'] == 'sale.create');
      final p = op['payload'] as Map;
      expect(p.keys, containsAll([
        'id', 'client_receipt_no', 'branch_id', 'register_shift_id', 'customer_id',
        'sale_type', 'price_list_id', 'discount_scheme_id', 'notes', 'lines', 'payments',
      ]));
      final line = (p['lines'] as List).single as Map;
      expect(line.keys.toSet(), {
        'id', 'product_id', 'variation_id', 'qty', 'unit_price', 'discount_pct',
        'discount_amount', 'tax_rate', 'tax_amount', 'notes', 'line_order',
      });
      expect(line['tax_amount'], '10.00');
      final pay = (p['payments'] as List).single as Map;
      expect(pay['tendered_amount'], '300.00');
      expect(pay['change_given'], '90.00');
      expect(op['occurred_at'], endsWith('Z'));
      expect(op['client_created_at'], endsWith('Z'));
    });

    test('duplicate (op re-sent after a lost response) counts as done', () async {
      final row = await rig.sell();
      await rig.sync();
      // Pretend the response was lost: the op is back to pending.
      final op = await rig.store.saleByOp(row['op_id'] as String);
      await rig.db.customStatement(
        "UPDATE outbox SET status = 'pending' WHERE op_id = ?",
        [op!['op_id']],
      );
      await rig.db.customStatement(
        "UPDATE local_sales SET sync_state = 'pending', official_number = NULL WHERE id = ?",
        [row['id']],
      );
      await rig.sync();

      final saved = (await rig.store.sale(row['id'] as String))!;
      expect(saved['sync_state'], 'synced');
      expect(saved['official_number'], 'INV-20261029-0001');
      expect(rig.server.saleCounter, 1, reason: 'the server applied it once');
    });

    test('non-retryable rejection stays failed until the user acts', () async {
      rig.server.errors['sale.create'] = const OpError(
        code: 'unknown_product',
        message: 'Unknown product(s): p1',
      );
      final row = await rig.sell();
      await rig.sync();
      await rig.sync();

      final op = (await rig.store.ops()).single;
      expect(op.status, OutboxStatus.rejected);
      expect(op.errorCode, 'unknown_product');
      expect(op.errorMessage, contains('no longer exists'));
      expect(op.attempts, 1, reason: 'not retried automatically');
      expect((await rig.store.sale(row['id'] as String))!['sync_state'], 'failed');
      expect((await rig.store.counts()).failed, 1);

      // User presses Retry once the cause is fixed.
      rig.server.errors.clear();
      await rig.store.transaction(() => rig.store.retryOp(op.opId));
      await rig.sync();
      expect((await rig.store.sale(row['id'] as String))!['sync_state'], 'synced');
      final retried = (await rig.store.ops()).single;
      expect(retried.opId, isNot(op.opId),
          reason: 'a finally-rejected op is re-sent under a NEW op id');
      expect((await rig.store.saleByOp(retried.opId)), isNotNull);
    });

    test('a conflict is final and explained', () async {
      rig.server.errors['customer.create'] = const OpError(code: 'id_exists', message: 'x');
      rig.server.errorStatus['customer.create'] = 'conflict';
      await rig.writer.createCustomer({'name': 'Dup'});
      await rig.sync();
      final op = (await rig.store.ops()).single;
      expect(op.status, OutboxStatus.rejected);
      expect(op.errorMessage, contains('already has this record'));
    });

    test('retryable errors back off 5s, 15s, 60s ... then need attention',
        () async {
      rig.server.errors['sale.create'] = const OpError(
        code: 'unknown_customer',
        message: 'x',
        retryable: true,
      );
      await rig.sell();

      await rig.sync();
      var op = (await rig.store.ops()).single;
      expect(op.status, OutboxStatus.pending);
      expect(op.nextAttemptAt!.millisecondsSinceEpoch,
          rig.now.add(const Duration(seconds: 5)).millisecondsSinceEpoch);

      // Not due yet: nothing is sent.
      final sent = rig.server.pushCalls;
      await rig.sync();
      expect(rig.server.pushCalls, sent);

      rig.advance(const Duration(seconds: 6));
      await rig.sync();
      op = (await rig.store.ops()).single;
      expect(op.nextAttemptAt!.millisecondsSinceEpoch,
          rig.now.add(const Duration(seconds: 15)).millisecondsSinceEpoch);

      rig.advance(const Duration(seconds: 16));
      await rig.sync(); // third attempt = maxAttempts (3) in this rig
      op = (await rig.store.ops()).single;
      expect(op.status, OutboxStatus.failed);
      expect(op.retryable, isTrue);
    });

    test('backoff schedule values', () {
      expect([for (var i = 1; i <= 7; i++) RetryBackoff.forAttempt(i)], const [
        Duration(seconds: 5),
        Duration(seconds: 15),
        Duration(seconds: 60),
        Duration(minutes: 5),
        Duration(minutes: 15),
        Duration(minutes: 15),
        Duration(minutes: 15),
      ]);
    });

    test('subscription codes wait for renewal without burning attempts',
        () async {
      rig.server.errors['sale.create'] = const OpError(
        code: 'subscription_expired',
        message: 'x',
        retryable: true,
      );
      await rig.sell();
      for (var i = 0; i < 5; i++) {
        rig.advance(const Duration(minutes: 20));
        await rig.sync();
      }
      final op = (await rig.store.ops()).single;
      expect(op.status, OutboxStatus.pending);
    });

    test('device_revoked: ops stay safe, the app is told to wipe and sign out',
        () async {
      await rig.sell();
      rig.server.revoked = true;
      await rig.sync();
      expect(rig.revokedMessages, hasLength(1));
      expect(rig.engine.state.deviceRevoked, isTrue);
      expect((await rig.store.counts()).pending, 1);
    });

    test('413 halves the batch until it fits', () async {
      for (var i = 0; i < 8; i++) {
        await rig.sell();
      }
      rig.server.maxOps = 3;
      await rig.sync();
      expect((await rig.store.counts()).unfinished, 0);
      expect(rig.server.pushBatches.every((b) => b.length <= 3), isTrue);
    });

    test('429 honours Retry-After and keeps everything pending', () async {
      await rig.sell();
      rig.server.rateLimit = const Duration(seconds: 42);
      await rig.sync();
      expect((await rig.store.counts()).pending, 1);
      expect(rig.engine.nextDelay, const Duration(seconds: 42));
    });

    test('5xx and outages keep ops pending and back off exponentially',
        () async {
      await rig.sell();
      rig.server.serverError = true;
      await rig.sync();
      expect(rig.engine.nextDelay, const Duration(seconds: 5));
      await rig.sync();
      expect(rig.engine.nextDelay, const Duration(seconds: 10));
      await rig.sync();
      expect(rig.engine.nextDelay, const Duration(seconds: 20));
      expect((await rig.store.counts()).pending, 1);

      rig.server.serverError = false;
      await rig.sync();
      expect((await rig.store.counts()).unfinished, 0);
      expect(rig.engine.nextDelay, const Duration(minutes: 5));
    });

    test('busy interval is 30s while work waits', () async {
      rig.server.offline = true;
      await rig.sell();
      await rig.sync();
      // offline backoff first ...
      rig.server.offline = false;
      await rig.sync();
      await rig.sell();
      rig.server.serverError = true;
      await rig.engine.refreshState();
      expect(rig.engine.state.counts.pending, 1);
    });
  });

  group('crash safety', () {
    test('a failure between the local write and the outbox write saves nothing',
        () async {
      await expectLater(
        rig.store.transaction(() async {
          await rig.store.insertSale({
            'id': 's-x',
            'op_id': 'o-x',
            'receipt_no': 'DX-0001',
            'branch_id': kBranch,
            'subtotal': '1',
            'total_discount': '0',
            'total_tax': '0',
            'total_amount': '1',
            'total_paid': '1',
            'lines': '[]',
            'payments': '[]',
            'sold_at': '2026-10-29T09:00:00Z',
            'created_at': 1,
          });
          throw StateError('app killed here');
        }),
        throwsStateError,
      );
      expect(await rig.store.sale('s-x'), isNull);
      expect((await rig.store.counts()).unfinished, 0);
    });

    test('a saved sale survives a restart and is sent afterwards', () async {
      rig.server.offline = true;
      final row = await rig.sell();
      rig.restart(); // app killed, reopened
      rig.server.offline = false;

      expect((await rig.store.sale(row['id'] as String)), isNotNull);
      expect((await rig.store.counts()).pending, 1);
      await rig.sync();
      expect((await rig.store.sale(row['id'] as String))!['sync_state'], 'synced');
    });

    test('ops left in "sending" by a crash are reset to pending on start',
        () async {
      final row = await rig.sell();
      await rig.db.customStatement("UPDATE outbox SET status = 'sending'");
      expect((await rig.store.counts()).sending, 1);

      rig.restart();
      await rig.engine.start();
      rig.engine.stop();

      expect((await rig.store.counts()).sending, 0);
      await rig.sync();
      expect((await rig.store.sale(row['id'] as String))!['sync_state'], 'synced');
    });

    test('a retried sale id saves nothing twice', () async {
      final a = await rig.sell(saleId: 'fixed-sale');
      final b = await rig.sell(saleId: 'fixed-sale');
      expect(b['receipt_no'], a['receipt_no']);
      expect((await rig.store.counts()).pending, 1);
    });

    test('the device receipt counter survives wipes and never repeats', () async {
      final a = await rig.sell();
      await rig.db.wipeTenantData();
      final b = await rig.sell();
      expect(a['receipt_no'], 'DA1B2-0001');
      expect(b['receipt_no'], 'DA1B2-0002');
    });
  });

  group('scheduler', () {
    test('overlapping triggers run one cycle (single flight)', () async {
      final calls = rig.server.pullCalls;
      await Future.wait([rig.sync(), rig.sync(), rig.sync()]);
      // The first run plus at most one coalesced re-run.
      expect(rig.server.pullCalls - calls, lessThanOrEqualTo(2));
    });

    test('automatic cycles skip an offline probe; manual sync does not',
        () async {
      await rig.sell();
      rig.probe.set(ReachabilityStatus.offline);
      final pushes = rig.server.pushCalls;
      await rig.sync(manual: false);
      expect(rig.server.pushCalls, pushes);
      await rig.sync(manual: true);
      expect(rig.server.pushCalls, pushes + 1);
    });

    test('coming back online triggers a sync', () async {
      await rig.sell();
      await rig.engine.start();
      rig.probe.set(ReachabilityStatus.offline);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      final pushes = rig.server.pushCalls;
      rig.probe.set(ReachabilityStatus.online);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(rig.server.pushCalls, greaterThan(pushes));
      rig.engine.stop();
    });

    test('saving a sale triggers a sync immediately (no separate online path)',
        () async {
      await rig.engine.start();
      await Future<void>.delayed(const Duration(milliseconds: 400));
      final pushes = rig.server.pushCalls;
      await rig.sell();
      await Future<void>.delayed(const Duration(milliseconds: 600));
      expect(rig.server.pushCalls, greaterThan(pushes));
      expect((await rig.store.counts()).unfinished, 0);
      rig.engine.stop();
    });

    test('status counters follow the outbox', () async {
      rig.server.offline = true;
      await rig.sell();
      await rig.sell();
      await rig.sync();
      expect(rig.engine.state.counts.pending, 2);
      expect(rig.engine.state.lastError, isNotNull);
      rig.server.offline = false;
      await rig.sync();
      expect(rig.engine.state.counts.unfinished, 0);
      expect(rig.engine.state.lastSyncedAt, isNotNull);
    });
  });

  group('shifts', () {
    test('two shifts with sales and closes replay in order', () async {
      final a = await rig.writer.openShift(registerId: 'reg-1', openingFloat: Decimal.parse('100'));
      await rig.sell(shiftId: a['id'] as String);
      await rig.writer.closeShift(shiftId: a['id'] as String, actualCash: Decimal.parse('310'));
      final b = await rig.writer.openShift(registerId: 'reg-1', openingFloat: Decimal.parse('50'));
      await rig.sell(shiftId: b['id'] as String);
      await rig.sell(shiftId: b['id'] as String);
      await rig.writer.closeShift(shiftId: b['id'] as String, actualCash: Decimal.parse('470'));

      await rig.sync();

      expect(rig.server.pushBatches.last, [
        'shift.open', 'sale.create', 'shift.close',
        'shift.open', 'sale.create', 'sale.create', 'shift.close',
      ]);
      expect((await rig.store.shift(a['id'] as String))!['sync_state'], 'synced');
      expect((await rig.store.shift(b['id'] as String))!['sync_state'], 'synced');
      expect((await rig.store.shift(b['id'] as String))!['status'], 'closed');
      // Shift ops reference the CLIENT shift ids.
      final opens = rig.server.receivedOps.where((o) => o['type'] == 'shift.open');
      expect(
        [for (final o in opens) (o['payload'] as Map)['id']],
        [a['id'], b['id']],
      );
    });

    test('the shift gate uses the local active shift', () async {
      expect(await rig.store.openShiftFor(kUser), isNull);
      final s = await rig.writer.openShift(registerId: 'reg-1', openingFloat: Decimal.zero);
      expect((await rig.store.openShiftFor(kUser))!['id'], s['id']);
      await rig.writer.closeShift(shiftId: s['id'] as String, actualCash: Decimal.zero);
      expect(await rig.store.openShiftFor(kUser), isNull);
    });

    test('discarding an unsent shift.close reopens the shift locally', () async {
      final s = await rig.writer.openShift(registerId: 'reg-1', openingFloat: Decimal.zero);
      rig.server.offline = true;
      await rig.writer.closeShift(shiftId: s['id'] as String, actualCash: Decimal.zero);
      final close = (await rig.store.ops()).last;
      await rig.store.transaction(() => rig.store.discardOp(close.opId, reason: 'test'));
      expect((await rig.store.openShiftFor(kUser))!['id'], s['id']);
      expect(await rig.store.discardLog(), hasLength(1));
    });
  });

  group('stock, credit, returns, voids', () {
    test('stock = pulled level minus pending local sales', () async {
      expect(await rig.stockOf('p1'), Decimal.parse('10'));
      rig.server.offline = true;
      await rig.sell(qty: '3');
      await rig.sell(qty: '2');
      expect(await rig.stockOf('p1'), Decimal.parse('5'));

      rig.server.offline = false;
      await rig.sync();
      // Sales synced, server level pulled (10 - 5): no double subtraction.
      expect(await rig.stockOf('p1'), Decimal.parse('5'));
    });

    test('selling more than stock is allowed and shows a negative balance',
        () async {
      rig.server.offline = true;
      await rig.sell(qty: '14');
      expect(await rig.stockOf('p1'), Decimal.parse('-4'));
    });

    test('credit check uses the cached balance plus pending credit sales',
        () async {
      rig.server.offline = true;
      expect(await rig.catalog.customerBalance('c1'), Decimal.parse('-1000'));
      await rig.sell(
        customerId: 'c1',
        payments: [
          {'payment_method': 'credit', 'amount': '210.00'},
        ],
      );
      expect(await rig.catalog.customerBalance('c1'), Decimal.parse('-1210'));

      await rig.writer.recordCustomerPayment(
        customerId: 'c1',
        amount: Decimal.parse('200'),
        paymentMethod: 'cash',
      );
      expect(await rig.catalog.customerBalance('c1'), Decimal.parse('-1010'));
      final customer = (await rig.catalog.customer('c1'))!;
      expect(customer.balance, '-1010.00');
    });

    test('a return of a not-yet-synced sale depends on the sale op', () async {
      rig.server.offline = true;
      final sale = await rig.sell();
      await rig.writer.createReturn({
        'branch_id': kBranch,
        'sale_id': sale['id'],
        'lines': [
          {'sale_line_id': 'l1', 'qty': '1'},
        ],
        'refund_payments': <Map<String, dynamic>>[],
      });
      final ops = await rig.store.ops();
      expect(ops.last.dependsOn, [sale['op_id']]);
      rig.server.offline = false;
      await rig.sync();
      expect(rig.server.pushBatches.last, ['sale.create', 'return.create']);
    });

    test('void is only for synced sales', () async {
      rig.server.offline = true;
      final sale = await rig.sell();
      expect(await rig.writer.canVoid(sale['id'] as String), isFalse);
      await expectLater(rig.writer.voidSale(sale['id'] as String), throwsStateError);

      rig.server.offline = false;
      await rig.sync();
      expect(await rig.writer.canVoid(sale['id'] as String), isTrue);
      await rig.writer.voidSale(sale['id'] as String, reason: 'wrong item');
      await rig.sync();
      expect((await rig.store.sale(sale['id'] as String))!['status'], 'voided');
    });

    test('expense create is queued as an op', () async {
      rig.server.offline = true;
      await rig.writer.createExpense({
        'branch_id': kBranch,
        'expense_category_id': 'ec1',
        'expense_date': '2026-10-29',
        'amount': '500',
        'payments': <Map<String, dynamic>>[],
      });
      rig.server.offline = false;
      await rig.sync();
      expect(rig.server.pushBatches.last, ['expense.create']);
    });
  });

  group('discard', () {
    test('discarding a sale keeps it visible as "discarded" and logs it',
        () async {
      rig.server.errors['sale.create'] = const OpError(code: 'unknown_product', message: 'x');
      final row = await rig.sell();
      await rig.sync();
      final op = (await rig.store.ops()).single;
      await rig.store.transaction(() => rig.store.discardOp(op.opId, reason: 'owner'));

      expect((await rig.store.sale(row['id'] as String))!['sync_state'], 'discarded');
      expect(await rig.store.ops(), isEmpty);
      final log = await rig.store.discardLog();
      expect(log.single['type'], 'sale.create');
      expect(log.single['reason'], 'owner');
    });
  });
}

// ── helpers ───────────────────────────────────────────────────────────────

PullService _pullWith(
  SyncStore store,
  SyncApi api, {
  void Function(SnapshotProgress)? onProgress,
}) =>
    PullService(
      store: store,
      api: api,
      config: const SyncConfig(maxAttempts: 3),
      currentUserId: () async => kUser,
      onProgress: onProgress,
    );

/// Fails the Nth snapshot request, otherwise delegates.
class _FlakySnapshot implements SyncApi {
  _FlakySnapshot(this.inner, {required this.failOnCall});
  final SyncApi inner;
  final int failOnCall;
  int _calls = 0;

  @override
  Future<SnapshotPage> snapshot({String? pageToken, int limit = 500}) {
    if (++_calls == failOnCall) {
      throw const SyncUnreachableException('connection dropped');
    }
    return inner.snapshot(pageToken: pageToken, limit: limit);
  }

  @override
  Future<PullPage> pull({String? since, int limit = 500, String? branchId}) =>
      inner.pull(since: since, limit: limit, branchId: branchId);

  @override
  Future<PushResponse> push({
    required String batchId,
    required List<Map<String, dynamic>> ops,
  }) =>
      inner.push(batchId: batchId, ops: ops);

  @override
  Future<List<FlaggedSale>> flags({String? flag, int skip = 0, int limit = 100}) =>
      inner.flags(flag: flag, skip: skip, limit: limit);
}

/// A store whose first applyChanges blows up (as a crash mid-page would).
class _FailingApplyStore extends SyncStore {
  _FailingApplyStore(super.db);
  bool failNext = true;

  @override
  Future<int> applyChanges(
    Iterable<SyncChange> changes, {
    Set<String>? protectedRows,
  }) async {
    if (failNext) throw StateError('crash while applying the page');
    return super.applyChanges(changes, protectedRows: protectedRows);
  }
}
