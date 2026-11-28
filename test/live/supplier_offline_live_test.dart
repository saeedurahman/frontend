// The supplier khata offline against a REAL backend (its TEST database), wired
// like the app: the offline suppliers repository, the khata repository, a device
// store with its outbox and the real sync engine, one throw-away business.
//
//   LIVE_API_BASE=http://127.0.0.1:<port>/api/v1 flutter test test/live/supplier_offline_live_test.dart
//
// Story: goods are received on credit -> the device syncs -> the cable is pulled
// -> a shift is opened and the supplier is paid twice (drawer and bank) -> every
// screen shows it at once -> the cable goes back in, the outbox is sent -> the
// ledger, balance, shift cash and hub totals agree on the server and on the
// device, with nothing counted twice.

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_hub_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_overview_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';

import '../helpers/khata_fakes.dart';
import '../helpers/refresh_contract.dart';
import 'live_backend.dart';
import 'live_device.dart';

const _errors = ErrorHandler();

T _ok<T>(Either<Failure, T> r, [String what = 'call']) => r.fold(
      (f) => fail('$what failed: ${f.code} ${f.message}'),
      (v) => v,
    );

Decimal _d(Object? value) => Decimal.parse('$value');

void main() {
  if (liveSkip != false) {
    test('live supplier offline test', () {}, skip: liveSkip);
    return;
  }

  test(
      'two supplier payments made offline reach the server once: ledger, '
      'balance, shift cash and hub totals agree', () async {
    final tenant =
        await LiveTenant.register(liveApiBase()!, label: 'Khata Offline');

    final pc = await LiveDevice.start(tenant);
    final LiveDevice(
      :ids,
      :store,
      :writer,
      :catalog,
      :suppliers,
      :khata,
      :sync,
      :unplug,
      :plugIn,
    ) = pc;
    final shiftsOnServer = CashRegisterRepositoryImpl(
      remoteDataSource: CashRegisterRemoteDataSourceImpl(tenant.client),
      errorHandler: _errors,
    );

    // ── 1. Online: a supplier we owe 1000, a counter, one sync ───────────
    final supplierId = (await tenant.post('/suppliers', {
      'name': 'Haji Traders Offline',
      'phone': '3001234567',
    }))['id'] as String;
    final productId = (await tenant.post('/products', {
      'name': 'Rice ${DateTime.now().millisecondsSinceEpoch}',
      'base_unit_id': tenant.unitId,
      'product_type': 'standard',
      'tracking_type': 'none',
    }))['id'] as String;
    await tenant.post('/purchases/receipts', {
      'branch_id': tenant.branchId,
      'supplier_id': supplierId,
      'received_at': DateTime.now().toUtc().toIso8601String(),
      'lines': [
        {'product_id': productId, 'qty_received': '10', 'cost_per_unit': '100'},
      ],
    });
    final register = _ok(
      await shiftsOnServer.createRegister(
        {'name': 'Counter', 'branch_id': tenant.branchId},
      ),
      'register',
    );
    await sync();
    // Names and phones come with the sync, no screen has to be opened first.
    expect(
      (await store.entity('supplier', supplierId))?['name'],
      'Haji Traders Offline',
    );

    // ── 2. The cable is pulled, with the screens open ────────────────────
    unplug();
    final events = CountingKhataEvents();
    final ledger = SupplierLedgerCubit(
      GetSupplierUseCase(suppliers),
      GetSupplierLedgerUseCase(suppliers),
      ReverseSupplierPaymentUseCase(suppliers),
      FakeBranchResolver(tenant.branchId),
      events,
    );
    final hub = KhataHubCubit(khata, initialTab: PartyType.supplier);
    final tile = KhataOverviewCubit(khata);
    addTearDown(ledger.close);
    addTearDown(hub.close);
    addTearDown(tile.close);
    await ledger.load(supplierId);
    await hub.load();
    await tile.load();
    Future<void> settleAll() async {
      await settle(ledger);
      await settle(hub);
      await settle(tile);
    }

    await settleAll();
    expect(ledger.state.owed, _d('1000'));
    expect(ledger.state.entries, hasLength(1));
    expect(ledger.state.asOf, isNotNull);
    expect(hub.state.list!.offline, isTrue);
    expect(hub.state.list!.rows.single.name, 'Haji Traders Offline');
    expect(hub.state.list!.rows.single.balanceOwed, _d('1000'));
    expect(tile.state.data!.value.payable.total, _d('1000'));

    // ── 3. Two payments offline, through the real outbox ─────────────────
    Future<Either<Failure, SupplierPaymentResult>> pay(
      String amount,
      String source, {
      String? reference,
    }) =>
        suppliers.paySupplier(
          {
            'supplier_id': supplierId,
            'amount': amount,
            'payment_source': source,
            if (reference != null) 'reference': reference,
            'branch_id': tenant.branchId,
          },
          idempotencyKey: ids.newId(),
        );

    final noShift = await pay('300.00', 'drawer');
    expect(
      noShift.fold((f) => f.code, (_) => null),
      KhataText.noOpenShiftCode,
    );

    final shiftId = '${(await writer.openShift(
      registerId: register.id,
      openingFloat: _d('5000'),
    ))['id']}';
    final cash = _ok(await pay('300.00', 'drawer'), 'drawer payment offline');
    final bank = _ok(
      await pay('200.00', 'bank', reference: 'TX-OFF-1'),
      'bank payment offline',
    );
    expect(cash.queued, isTrue);
    expect(bank.queued, isTrue);
    expect(cash.registerShiftId, shiftId);
    expect(bank.registerShiftId, isNull);

    await settleAll();
    expect(ledger.state.owed, _d('500'));
    expect(ledger.state.entries, hasLength(3));
    expect(ledger.state.entries.where((e) => e.pending), hasLength(2));
    expect(hub.state.list!.rows.single.balanceOwed, _d('500'));
    expect(tile.state.data!.value.payable.total, _d('500'));
    final waiting = _ok(
      await khata.openItems(PartyType.supplier, supplierId),
      'bills offline',
    ).value;
    expect(waiting.balanceOwed, _d('500'));
    expect(waiting.pendingPaid, _d('500'));
    expect(
      waiting.items.single.remaining,
      _d('1000'),
      reason: 'the bills stay as the server last said',
    );
    expect(
      _d((await catalog.shiftSummary(shiftId)).expectedCash),
      _d('4700'),
      reason: 'only the drawer payment leaves the till',
    );
    await expectLater(
      tenant.get('/supplier-ledger/$supplierId/balance'),
      throwsA(isA<DioException>()),
      reason: 'the cable is out',
    );

    // ── 4. Back online: send, pull, and every screen follows ─────────────
    plugIn();
    await sync();
    await sync();
    final counts = await store.counts();
    expect(counts.unfinished, 0, reason: 'not accepted: $counts');
    expect(await store.pendingSupplierPayments(), isEmpty);
    expect(await store.flaggedPayments(), isEmpty);
    await ledger.load(supplierId);
    await hub.refresh();
    await tile.load();
    await settleAll();

    final onServer = await tenant.get('/supplier-ledger/$supplierId/balance');
    expect(_d(onServer['balance']), _d('-500'));
    final rows = (await tenant.getList('/supplier-ledger/$supplierId'))
        .cast<Map<dynamic, dynamic>>();
    expect(rows, hasLength(3), reason: 'each payment arrived once');
    final payments = [
      for (final r in rows)
        if (r['entry_type'] == 'payment') r,
    ];
    expect(
      {for (final r in payments) r['id']},
      {cash.id, bank.id},
      reason: 'the ids made on the device are the ledger ids',
    );
    expect(
      {for (final r in payments) (r['payment_source'], _d(r['amount']))},
      {('drawer', _d('300')), ('bank', _d('200'))},
    );

    final summary = _ok(
      await shiftsOnServer.getShiftSummary(shiftId),
      'shift summary',
    );
    expect(summary.expectedCashDecimal, _d('4700'));
    expect(
      summary.cashMovements.map((m) => (m.source, _d(m.amount))),
      [('supplier_payment', _d('300'))],
    );

    expect(ledger.state.owed, _d('500'));
    expect(ledger.state.entries, hasLength(3));
    expect(ledger.state.entries.where((e) => e.pending), isEmpty);
    expect(hub.state.list!.offline, isFalse);
    expect(hub.state.list!.rows.single.balanceOwed, _d('500'));
    expect(hub.state.list!.page.balanceOwed, _d('500'));
    expect(tile.state.data!.value.payable.total, _d('500'));
    expect(tile.state.data!.value.payable.count, 1);

    // ── 5. Offline again: the device's own copy says the same ────────────
    unplug();
    await ledger.load(supplierId);
    await hub.refresh();
    await tile.load();
    await settleAll();
    expect(ledger.state.owed, _d('500'));
    expect(ledger.state.entries, hasLength(3));
    expect(ledger.state.entries.where((e) => e.pending), isEmpty);
    expect(ledger.state.entries.first.runningBalance, _d('-500'));
    expect(hub.state.list!.rows.single.balanceOwed, _d('500'));
    expect(tile.state.data!.value.payable.total, _d('500'));
    final bills = _ok(
      await khata.openItems(PartyType.supplier, supplierId),
      'bills after sync',
    ).value;
    expect(bills.balanceOwed, _d('500'));
    expect(bills.pendingPaid, isNull);
    expect(bills.items.single.remaining, _d('500'));
    expect(
      _d((await catalog.shiftSummary(shiftId)).expectedCash),
      _d('4700'),
    );
  }, timeout: const Timeout(Duration(minutes: 4)));
}
