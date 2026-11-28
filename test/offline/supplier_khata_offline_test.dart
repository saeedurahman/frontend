// The supplier khata without internet: the real repositories, the real outbox
// and sync engine, a fake sync server and an HTTP server that refuses every
// connection.

import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/offline/repos/offline_suppliers_repository.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/domain/text/entry_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_hub_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_overview_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/party_khata_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_line.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:frantend/features/sync/domain/op_describer.dart';
import 'package:frantend/features/sync/presentation/pages/flags_page.dart';

import '../helpers/fake_rest.dart';
import '../helpers/khata_fakes.dart';
import '../helpers/offline_world.dart';
import '../helpers/refresh_contract.dart';
import '../helpers/supplier_world.dart';
import '../sync/sync_rig.dart';

class _NoSalesFlags extends Fake implements SyncApi {
  @override
  Future<List<FlaggedSale>> flags({
    String? flag,
    int skip = 0,
    int limit = 100,
  }) async =>
      const [];
}

/// A connection that was made, with no answer coming back.
class _NoAnswer extends UnreachableAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.receiveTimeout,
    );
  }
}

void main() {
  late SupplierWorld w;

  setUp(() async {
    w = SupplierWorld();
    await w.seed();
    w.world.goOffline();
  });

  tearDown(() => w.world.dispose());

  group('reading offline', () {
    test('the list and the supplier come from the device', () async {
      final list = (await w.suppliers.getSuppliers()).getOrElse(() => []);
      expect(list.single.name, 'Haji Traders');
      final one = await w.suppliers.getSupplier('s1');
      expect(one.getOrElse(() => throw StateError('x')).phone, '03001234567');
    });

    test('the balance and the account say when they are from', () async {
      final balance = (await w.suppliers.getSupplierBalance('s1'))
          .getOrElse(() => throw StateError('x'));
      expect(d(balance.balance), d('-1000'));
      expect(balance.asOf, isNotNull);

      final page = await w.ledger();
      expect(page.items.map((e) => e.id), ['l2', 'l1']);
      expect(page.balance, d('-1000'));
      expect(page.offline, isTrue);
      expect(page.asOf, isNotNull);
    });

    test('pending bills keep their order and count their age here', () async {
      final data = (await w.khata.openItems(PartyType.supplier, 's1'))
          .getOrElse(() => throw StateError('x'));
      expect(data.offline, isTrue);
      expect(data.asOf, isNotNull);
      expect(data.value.balanceOwed, d('1000'));
      expect(data.value.items.map((i) => i.documentId), ['d1', 'd2']);
      expect(data.value.items.first.ageDays, 28);
      expect(data.value.items.first.overdueDays, 14);
    });

    test('the To pay tab and the payable total come from the device', () async {
      final answer = (await w.khata.hub(
        const HubQuery(party: PartyType.supplier),
      ))
          .getOrElse(() => throw StateError('x'));
      expect(answer.offline, isTrue);
      expect(answer.asOf, isNotNull);
      expect(answer.value.items.single.name, 'Haji Traders');
      expect(answer.value.items.single.balanceOwed, d('1000'));
      expect((await w.hub('haji')).items, hasLength(1));
      expect((await w.hub('nobody')).items, isEmpty);

      final overview = await w.overview();
      expect(overview.offline, isTrue);
      expect(overview.value.payable.total, d('1000'));
      expect(overview.value.payable.count, 1);
      expect(
        overview.value.receivable.known,
        isFalse,
        reason: 'nothing kept about customers: no figure, not zero',
      );
    });

    test('a full resync brings the suppliers again', () async {
      w.world.goOnline();
      w.rig.server.fullResyncNext = true;
      await w.rig.sync();
      w.world.goOffline();
      final list = (await w.suppliers.getSuppliers()).getOrElse(() => []);
      expect(list.single.name, 'Haji Traders');
    });

    test('with nothing saved the answer is a plain sentence', () async {
      final empty = SupplierWorld()..world.goOffline();
      addTearDown(empty.world.dispose);
      final results = [
        await empty.suppliers.getSuppliers(),
        await empty.suppliers.getSupplier('s1'),
        await empty.suppliers.getSupplierBalance('s1'),
        await empty.suppliers.getLedger('s1'),
      ];
      for (final result in results) {
        final failure = result.fold((f) => f, (_) => null);
        expect(failure?.message, UserErrorMessage.offline);
        expectPlainLanguage(failure?.message);
      }
    });

    test('a server that refuses the connection falls back as well', () async {
      w.world.goOnline();
      expect(await w.balance(), d('-1000'));
      expect((await w.ledger()).offline, isTrue);
    });
  });

  group('paying offline', () {
    test('the payment shows at once everywhere and bills stay as pulled',
        () async {
      final result = (await w.pay('300'))
          .getOrElse(() => throw StateError('not saved'));
      expect(result.queued, isTrue);
      expect(result.balanceKnown, isTrue);
      expect(result.balance, d('-700'));

      final op = (await w.queued()).single;
      expect(op.type, OpTypes.supplierPayment);
      expect(op.payload['amount'], '300.00');
      expect(op.payload, isNot(contains('register_shift_id')));

      expect(await w.balance(), d('-700'));
      final page = await w.ledger();
      expect(page.items, hasLength(3));
      expect(page.items.first.pending, isTrue);
      expect(page.items.first.runningBalance, d('-700'));
      expect(page.balance, d('-700'));
      final line = LedgerLine.fromSupplier(page.items.first);
      expect(line.pending, isTrue);
      expect(line.canReverse, isFalse);
      expect(line.sourceLabel, 'Bank');

      final bills = await w.bills();
      expect(bills.balanceOwed, d('700'));
      expect(bills.pendingPaid, d('300'));
      expect(
        bills.items.map((i) => i.remaining),
        [d('600'), d('400')],
        reason: 'which bill is paid is for the server to say',
      );
      expect((await w.hub()).items.single.balanceOwed, d('700'));
      expect((await w.overview()).value.payable.total, d('700'));
    });

    test('paying everything takes the supplier off the To pay tab', () async {
      await w.pay('300');
      await w.pay('700');
      expect((await w.hub()).items, isEmpty);
      final overview = await w.overview();
      expect(overview.value.payable.total, Decimal.zero);
      expect(overview.value.payable.count, 0);
    });

    test('nothing is counted twice, before or after the sync', () async {
      await w.pay('300');
      await w.pay('200', source: 'easypaisa');
      expect(await w.balance(), d('-500'));

      // Sent, but the new figures have not been pulled yet.
      w.world.goOnline();
      await w.rig.push.pushAll();
      w.world.goOffline();
      expect(await w.queued(), isEmpty);
      expect(await w.balance(), d('-500'));
      expect((await w.ledger()).items, hasLength(4));

      w.world.goOnline();
      await w.rig.sync();
      await w.rig.sync();
      w.world.goOffline();
      expect(await w.rig.store.pendingSupplierPayments(), isEmpty);
      expect(await w.balance(), d('-500'));
      final page = await w.ledger();
      expect(page.items, hasLength(4));
      expect(page.items.where((e) => e.pending), isEmpty);
      expect((await w.bills()).balanceOwed, d('500'));
      expect((await w.bills()).pendingPaid, isNull);
      expect((await w.hub()).items.single.balanceOwed, d('500'));
      expect(
        w.rig.server.receivedOps.where((o) => o['type'] == 'supplier.payment'),
        hasLength(2),
      );
    });

    test('an online answer gets only the unsent payments on top', () async {
      await w.pay('300');
      var owed = '1000.00';
      final server = FakeRest()
        ..on(
          'GET',
          ApiConstants.supplierBalance('{id}'),
          (_) => {
            'supplier_id': 's1',
            'balance': '-$owed',
            'balance_owed': owed,
            'is_advance': false,
          },
        );
      final online = w.onlineWith(server);
      w.world.goOnline();
      Future<Decimal> asked() async => d(
            (await online.getSupplierBalance('s1'))
                .getOrElse(() => throw StateError('x'))
                .balance,
          );
      expect(await asked(), d('-700'));
      // Accepted by the server: its answer holds the payment now.
      await w.rig.push.pushAll();
      owed = '700.00';
      expect(await asked(), d('-700'));
    });

    test('the same attempt saved twice is one payment', () async {
      const key = '11111111-2222-4333-8444-555555555555';
      await w.pay('300', key: key);
      await w.pay('300', key: key);
      expect(await w.queued(), hasLength(1));
      expect(await w.balance(), d('-700'));
    });

    test('cash from the drawer needs an open shift, other money does not',
        () async {
      final refused = await w.pay('300', source: 'drawer');
      final failure = refused.fold((f) => f, (_) => null);
      expect(failure?.code, KhataText.noOpenShiftCode);
      expect(failure?.message, KhataText.needsShiftBody);
      expect(await w.queued(), isEmpty);
      expect((await w.ledger()).items, hasLength(2));

      expect((await w.pay('100', source: 'owner_pocket')).isRight(), isTrue);

      final shift = await w.openShift();
      final before = (await w.rig.catalog.shiftSummary(shift)).expectedCash;
      final paid = (await w.pay('300', source: 'drawer'))
          .getOrElse(() => throw StateError('not saved'));
      expect(paid.registerShiftId, shift);
      final op = (await w.queued()).last;
      expect(op.payload['register_shift_id'], shift);
      final shiftOpen = (await w.queued())
          .singleWhere((o) => o.type == OpTypes.shiftOpen);
      expect(op.dependsOn, contains(shiftOpen.opId));
      final after = await w.rig.catalog.shiftSummary(shift);
      expect(d(after.expectedCash), d(before) - d('300'));

      // Money from elsewhere leaves the drawer alone.
      await w.pay('50');
      final again = await w.rig.catalog.shiftSummary(shift);
      expect(d(again.expectedCash), d(after.expectedCash));
    });

    test('the dialog asks for a shift, opens one and saves the payment',
        () async {
      final shifts = FakeShiftGuard();
      final cubit = w.paymentCubit(shifts);
      addTearDown(cubit.close);
      await cubit.init(supplierId: 's1');
      expect(cubit.state.supplierName, 'Haji Traders');
      expect(cubit.state.balance, d('-1000'));
      expect(cubit.state.balanceAsOf, isNotNull);
      expect(cubit.state.error, isNull);

      cubit.setAmount('300');
      cubit.setSource(PaymentSource.drawer);
      await pumpEventQueue();
      expect(cubit.state.needsShift, isTrue);
      expect(cubit.state.canSubmit, isFalse);

      // The one tap: a real shift on this device.
      final shift = await w.openShift();
      shifts.openResult = Right(shift);
      expect(await cubit.openShift(), isTrue);
      expect(cubit.state.canSubmit, isTrue);
      expect(await cubit.submit(), isTrue);
      expect(cubit.state.result?.queued, isTrue);
      expect(cubit.state.result?.balance, d('-700'));
    });

    test('an account not saved here can still be paid, with no figures made up',
        () async {
      final cubit = w.paymentCubit(FakeShiftGuard());
      addTearDown(cubit.close);
      await cubit.init(supplierId: 's-new', supplierName: 'New Co');
      expect(cubit.state.balanceKnown, isFalse);
      expect(cubit.state.error, isNull);
      cubit.setAmount('50');
      expect(cubit.state.isAdvance, isFalse);
      expect(await cubit.submit(), isTrue);
      expect(cubit.state.result?.queued, isTrue);
      expect(cubit.state.result?.balanceKnown, isFalse);
    });

    test('a payment that may have arrived is not queued as well', () async {
      final unsure = SupplierWorld(adapter: _NoAnswer());
      addTearDown(unsure.world.dispose);
      await unsure.seed();
      const key = '11111111-2222-4333-8444-555555555555';
      final first = await unsure.pay('300', key: key);
      expect(
        first.fold((f) => f, (_) => null),
        isA<UnconfirmedPaymentFailure>(),
      );
      expect(await unsure.queued(), isEmpty);
      // Even once the connection is known to be gone.
      unsure.world.goOffline();
      final again = await unsure.pay('300', key: key);
      expect(
        again.fold((f) => f, (_) => null),
        isA<UnconfirmedPaymentFailure>(),
      );
      expect(await unsure.queued(), isEmpty);
      expectPlainLanguage(again.fold((f) => f.message, (_) => null));
    });

    test('only a connection that was never made counts as not sent', () {
      final request = RequestOptions(path: '/x');
      DioException error(DioExceptionType type, [Object? cause]) =>
          DioException(requestOptions: request, type: type, error: cause);
      expect(
        OfflineSuppliersRepository.neverSent(
          error(DioExceptionType.connectionTimeout),
        ),
        isTrue,
      );
      expect(
        OfflineSuppliersRepository.neverSent(
          error(
            DioExceptionType.connectionError,
            const SocketException(
              'refused',
              osError: OSError('refused', 1225),
            ),
          ),
        ),
        isTrue,
      );
      for (final type in [
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ]) {
        expect(OfflineSuppliersRepository.neverSent(error(type)), isFalse);
      }
    });
  });

  group('what needs the internet', () {
    test('a reversal says so in plain words and keeps nothing', () async {
      final cubit = w.ledgerCubit();
      addTearDown(cubit.close);
      await cubit.load('s1');
      final message = await cubit.reversePayment('l1', 'Typed twice');
      expect(message, KhataText.offlineReverse);
      expect(await w.queued(), isEmpty);
    });

    test('the server code online_only_operation has plain words', () {
      expect(
        KhataText.forCode(KhataText.onlineOnlyCode),
        KhataText.onlineOnly,
      );
      expect(EntryText.forCode(KhataText.onlineOnlyCode), EntryText.offline);
      final synced = SyncErrorText.explain(
        KhataText.onlineOnlyCode,
        'raw server words',
      );
      expect(synced, isNot(contains('_')));
      expect(synced, isNot(contains('raw server words')));
    });
  });

  group('sync pages', () {
    test('a queued supplier payment reads like a sentence', () async {
      await w.openShift();
      await w.pay('300', source: 'drawer');
      final op = (await w.queued())
          .singleWhere((o) => o.type == OpTypes.supplierPayment);
      final text = OpDescriber.describe(op);
      expect(text.title, allOf(startsWith('Supplier payment'), contains('300')));
      expect(text.subtitle, startsWith('Cash drawer'));
      expect(text.subtitle, isNot(contains('owner_pocket')));
    });

    test('a refused payment is explained and stays on the account', () async {
      w.rig.server.errors['supplier.payment'] = const OpError(
        code: 'paid_at_in_future',
        message: 'raw server words',
      );
      await w.pay('300');
      w.world.goOnline();
      await w.rig.sync();
      w.world.goOffline();
      final op = (await w.rig.store.ops()).singleWhere(
        (o) => o.type == OpTypes.supplierPayment,
      );
      expect(op.needsAttention, isTrue);
      final words = SyncErrorText.explain('paid_at_in_future', op.errorMessage);
      expect(words, isNot(contains('raw server words')));
      expect(words, isNot(contains('_')));
      final line = (await w.ledger()).items.first;
      expect(line.pending, isTrue);
      expect(line.needsAttention, isTrue);

      // Discarding it puts the account back.
      await w.rig.store.discardOp(op.opId, reason: 'Paid by hand instead');
      expect(await w.balance(), d('-1000'));
      expect((await w.ledger()).items, hasLength(2));
    });

    testWidgets('a flagged supplier payment is named as one', (tester) async {
      // Sync work uses real time and the database.
      final kept = await tester.runAsync(() async {
        w.rig.server.paymentFlags = const ['shift_mismatch'];
        await w.openShift();
        await w.pay('300', source: 'drawer');
        w.world.goOnline();
        await w.rig.sync();
        await w.rig.sync();
        return w.rig.store.flaggedPayments();
      });
      expect(kept!.single.toSupplier, isTrue);
      expect(kept.single.supplierName, 'Haji Traders');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlagsPage(
              allowed: true,
              api: _NoSalesFlags(),
              payments: () async => kept,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(
        find.textContaining('Supplier payment to Haji Traders'),
        findsOneWidget,
      );
      expect(
        find.text(SyncErrorText.supplierPaymentFlag('shift_mismatch')),
        findsOneWidget,
      );
      expect(find.textContaining('shift_mismatch'), findsNothing);
      expect(find.textContaining('Customer payment'), findsNothing);
    });
  });

  group('screens refresh together', () {
    late SupplierLedgerCubit ledger;
    late SuppliersListCubit list;
    late KhataHubCubit hub;
    late KhataOverviewCubit tile;
    late PartyKhataCubit party;

    setUp(() async {
      ledger = w.ledgerCubit();
      list = w.listCubit();
      hub = KhataHubCubit(w.khata, initialTab: PartyType.supplier);
      tile = KhataOverviewCubit(w.khata);
      party = PartyKhataCubit(
        w.khata,
        partyType: PartyType.supplier,
        partyId: 's1',
      );
    });

    tearDown(() async {
      await ledger.close();
      await list.close();
      await hub.close();
      await tile.close();
      await party.close();
    });

    Future<void> openAll() async {
      await ledger.load('s1');
      await list.load();
      await hub.load();
      await tile.load();
      await party.load();
    }

    Future<void> settleAll() async {
      for (final cubit in <Cubit<Object?>>[ledger, list, hub, tile, party]) {
        await settle(cubit);
      }
    }

    void expectOwed(String amount) {
      final owed = d(amount);
      expect(ledger.state.owed, owed, reason: 'account');
      final row = (list.state as SuppliersListLoaded).allItems.single;
      expect(d(row.balance!), -owed, reason: 'supplier list');
      expect(hub.state.list!.rows.single.balanceOwed, owed, reason: 'hub');
      expect(
        tile.state.data!.value.payable.total,
        owed,
        reason: 'dashboard tile',
      );
      expect(
        party.state.bills!.value.balanceOwed,
        owed,
        reason: 'party page',
      );
    }

    test('after a payment saved here', () async {
      await expectPaymentShowsAtOnce<SupplierLedgerState>(
        ledger: ledger,
        open: () => ledger.load('s1'),
        pay: () async => w.pay('300'),
        read: (s) => s.balance == null
            ? null
            : (rows: [for (final e in s.entries) e.id], balance: s.balance!),
        balanceAfter: d('-700'),
      );
      await openAll();
      expect((list.state as SuppliersListLoaded).asOf, isNotNull);
      await w.pay('100');
      await settleAll();
      expectOwed('600');
    });

    test('after a pull and after a reversal from the server', () async {
      await openAll();
      await w.pay('300');
      await settleAll();
      expectOwed('700');

      // The payment is sent and the figures pulled: no screen moves twice.
      w.world.goOnline();
      await w.rig.sync();
      await w.rig.sync();
      await settleAll();
      expectOwed('700');
      expect(ledger.state.entries.where((e) => e.pending), isEmpty);

      // Someone reverses it at the office.
      final paid = ledger.state.entries.first;
      w.rig.server.put('supplier_ledger', 'rev-1', {
        'id': 'rev-1',
        'supplier_id': 's1',
        'branch_id': kBranch,
        'entry_type': 'reversal',
        'amount': '-300.00',
        'reversal_of_id': paid.id,
        'entry_at': '2026-10-29T10:00:00+00:00',
        'running_balance': '-1000.00',
      });
      w.rig.server.put('supplier_balance', 's1', {
        'id': 's1',
        'supplier_id': 's1',
        'balance_owed': '1000.00',
        'advance_amount': '0.00',
      });
      final open = w.rig.server.live['supplier_open_items|s1']!.data!;
      w.rig.server.put('supplier_open_items', 's1', {
        ...open,
        'balance_owed': '1000.00',
      });
      await w.rig.sync();
      await settleAll();
      expectOwed('1000');
      expect(ledger.state.entries.first.id, 'rev-1');
    });
  });
}
