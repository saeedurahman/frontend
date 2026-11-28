// Adding a supplier without internet against a REAL backend (its TEST
// database), wired like the app, one throw-away business.
//
//   LIVE_API_BASE=http://127.0.0.1:<port>/api/v1 flutter test test/live/supplier_create_offline_live_test.dart
//
// Story: the device syncs -> the cable is pulled -> a supplier is added with an
// opening balance and then edited, and a second one is added whose name the
// office takes meanwhile -> the cable goes back in, the outbox is sent -> the
// first supplier exists once, the second is refused as a duplicate and replaced
// by the office's one -> the supplier is paid -> hub and ledger agree on the
// server and on the device.
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_hub_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/suppliers/domain/supplier_text.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';

import '../helpers/khata_fakes.dart';
import '../helpers/refresh_contract.dart';
import 'live_backend.dart';
import 'live_device.dart';

T _ok<T>(Either<Failure, T> r, [String what = 'call']) => r.fold(
      (f) => fail('$what failed: ${f.code} ${f.message}'),
      (v) => v,
    );

Decimal _d(Object? value) => Decimal.parse('$value');

void main() {
  if (liveSkip != false) {
    test('live supplier create offline test', () {}, skip: liveSkip);
    return;
  }

  test(
      'a supplier added offline reaches the server once, can be paid, and '
      'hub and ledger agree', () async {
    final tenant =
        await LiveTenant.register(liveApiBase()!, label: 'Supplier Offline');
    final pc = await LiveDevice.start(tenant);
    final LiveDevice(:ids, :store, :suppliers, :khata) = pc;
    await pc.sync();

    // ── 1. Offline: two new suppliers through the real outbox ────────────
    pc.unplug();
    final hub = KhataHubCubit(khata, initialTab: PartyType.supplier);
    addTearDown(hub.close);
    await hub.load();

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final added = _ok(
      await suppliers.createSupplier({
        'name': 'Zafar Mills',
        'phone': '0311-7654321',
        'address_line1': '12 Anarkali',
        'payment_terms_days': 7,
        'opening_balance': {
          'amount': '800.00',
          'direction': 'we_owe_them',
          'as_of_date': khataIsoDay(yesterday),
          'branch_id': tenant.branchId,
        },
      }),
      'create offline',
    );
    _ok(
      await suppliers.updateSupplier(added.id, {'city': 'Lahore'}),
      'edit offline',
    );
    final second = _ok(
      await suppliers.createSupplier({'name': 'Karim Brothers'}),
      'second create offline',
    );

    await settle(hub);
    expect(hub.state.list!.offline, isTrue);
    expect(hub.state.list!.rows.single.id, added.id);
    expect(hub.state.list!.rows.single.balanceOwed, _d('800'));
    expect(await store.unsyncedSupplierIds(), {added.id, second.id});

    // ── 2. The office takes the second name; then the cable goes back ────
    pc.plugIn();
    final office = (await tenant.post('/suppliers', {
      'name': '  karim   BROTHERS ',
    }))['id'] as String;
    await pc.sync();
    await pc.sync();

    final refused = (await store.ops(statuses: OutboxStatus.unfinished));
    expect(
      refused.map((o) => (o.type, o.entityId, o.errorCode)),
      [(OpTypes.supplierCreate, second.id, SupplierText.duplicateCode)],
      reason: 'only the taken name is left: $refused',
    );
    final found = await store.duplicateSupplier(refused.single.opId);
    expect(found?.existingId, office);
    expect(found?.field, 'name');
    await store.transaction(
      () => store.useExistingSupplier(refused.single.opId),
    );
    await pc.sync();
    expect((await store.counts()).unfinished, 0);

    // The same name asked for online is refused in the server's words.
    final again = await suppliers.createSupplier({'name': 'Zafar Mills'});
    expect(
      again.fold((f) => f.code, (_) => null),
      SupplierText.duplicateCode,
    );

    final onServer = await tenant.get('/suppliers/${added.id}');
    expect(onServer['name'], 'Zafar Mills');
    expect(onServer['address_line1'], '12 Anarkali');
    expect(onServer['city'], 'Lahore');
    expect(onServer['payment_terms_days'], 7);
    final everyone = await tenant.getList('/suppliers');
    expect(
      {for (final s in everyone) (s as Map)['id']},
      {added.id, office},
      reason: 'each once, the refused one never',
    );
    expect(
      {
        for (final s in _ok(await suppliers.getSuppliers(), 'list')) s.id,
      },
      {added.id, office},
    );

    // ── 3. Pay it ────────────────────────────────────────────────────────
    final events = CountingKhataEvents();
    final ledger = SupplierLedgerCubit(
      GetSupplierUseCase(suppliers),
      GetSupplierLedgerUseCase(suppliers),
      ReverseSupplierPaymentUseCase(suppliers),
      FakeBranchResolver(tenant.branchId),
      events,
    );
    addTearDown(ledger.close);
    await ledger.load(added.id);
    await settle(ledger);
    expect(ledger.state.owed, _d('800'));
    expect(ledger.state.entries, hasLength(1));

    final paid = _ok(
      await suppliers.paySupplier(
        {
          'supplier_id': added.id,
          'amount': '300.00',
          'payment_source': 'bank',
          'branch_id': tenant.branchId,
        },
        idempotencyKey: ids.newId(),
      ),
      'payment',
    );
    expect(paid.queued, isFalse);
    await pc.sync();
    await ledger.load(added.id);
    await hub.refresh();
    await settle(ledger);
    await settle(hub);

    final balance = await tenant.get('/supplier-ledger/${added.id}/balance');
    expect(_d(balance['balance']), _d('-500'));
    expect(
      await tenant.getList('/supplier-ledger/${added.id}'),
      hasLength(2),
    );
    expect(ledger.state.owed, _d('500'));
    expect(ledger.state.entries, hasLength(2));
    expect(ledger.state.entries.where((e) => e.pending), isEmpty);
    expect(hub.state.list!.offline, isFalse);
    expect(hub.state.list!.rows.single.id, added.id);
    expect(hub.state.list!.rows.single.balanceOwed, _d('500'));

    // ── 4. Offline again: the device's own copy says the same ────────────
    pc.unplug();
    await ledger.load(added.id);
    await hub.refresh();
    await settle(ledger);
    await settle(hub);
    expect(ledger.state.supplier?.name, 'Zafar Mills');
    expect(ledger.state.owed, _d('500'));
    expect(ledger.state.entries, hasLength(2));
    expect(ledger.state.entries.first.runningBalance, _d('-500'));
    expect(ledger.state.olderNeedsInternet, isFalse);
    expect(hub.state.list!.rows.single.name, 'Zafar Mills');
    expect(hub.state.list!.rows.single.balanceOwed, _d('500'));
  }, timeout: const Timeout(Duration(minutes: 4)));
}
