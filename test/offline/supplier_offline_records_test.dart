// Suppliers without internet: names and phones from the device's own copy,
// adding and editing through the real outbox, what happens when a name is
// already taken, and where the device's part of an account ends.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/widgets/customer_ledger_table.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_hub_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/opening_balance_cubit.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/supplier_text.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/supplier_form_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:frantend/features/sync/domain/op_describer.dart';
import 'package:frantend/features/sync/presentation/pages/failed_items_page.dart';
import 'package:frantend/shared/widgets/sync/not_synced_badge.dart';

import '../helpers/fake_http.dart';
import '../helpers/fake_rest.dart';
import '../helpers/offline_world.dart';
import '../helpers/refresh_contract.dart';
import '../helpers/supplier_world.dart';
import '../sync/sync_rig.dart';

void main() {
  late SupplierWorld w;

  setUp(() async {
    w = SupplierWorld();
    await w.seed();
    w.world.goOffline();
  });

  tearDown(() => w.world.dispose());

  Future<List<SupplierModel>> all() async =>
      (await w.suppliers.getSuppliers())
          .getOrElse(() => throw StateError('no suppliers'));

  Future<SupplierModel> create(Map<String, dynamic> body) async =>
      (await w.suppliers.createSupplier(body))
          .getOrElse(() => throw StateError('not saved'));

  Future<SupplierModel> update(String id, Map<String, dynamic> body) async =>
      (await w.suppliers.updateSupplier(id, body))
          .getOrElse(() => throw StateError('not saved'));

  Failure failureOf(Object result) => (result as dynamic)
      .fold((Failure f) => f, (_) => throw StateError('it worked')) as Failure;

  /// A new supplier we already owe 800.
  Future<SupplierModel> createWithOpening({String name = 'Bilal & Sons'}) =>
      create({
        'name': name,
        'phone': '0311-7654321',
        'address_line1': '12 Anarkali',
        'city': 'Lahore',
        'payment_terms_days': 7,
        'opening_balance': {
          'amount': '800.00',
          'direction': 'we_owe_them',
          'as_of_date': '2026-10-01',
          'branch_id': kBranch,
        },
      });

  Future<void> syncTwice() async {
    w.world.goOnline();
    await w.rig.sync();
    await w.rig.sync();
  }

  SupplierFormCubit formCubit() => SupplierFormCubit(
        getSupplierUseCase: GetSupplierUseCase(w.suppliers),
        createSupplierUseCase: CreateSupplierUseCase(w.suppliers),
        updateSupplierUseCase: UpdateSupplierUseCase(w.suppliers),
      );

  group('pickers read the device', () {
    test('a pulled device answers without asking the server', () async {
      final server = FakeRest();
      w.world.goOnline();
      final online = w.onlineWith(server);

      final list = (await online.getSuppliers()).getOrElse(() => []);
      expect(list.single.name, 'Haji Traders');
      expect(list.single.phone, '03001234567');
      expect(list.single.paymentTermsDays, 14);
      final one = await online.getSupplier('s1');
      expect(one.isRight(), isTrue);
      expect(server.log, isEmpty);
    });

    test('before the first pull the server is asked', () async {
      final fresh = SupplierWorld();
      addTearDown(fresh.world.dispose);
      final server = FakeRest()
        ..collection(
          ApiConstants.suppliers,
          seed: [
            {'id': 'srv-1', 'business_id': 'biz', 'name': 'From Server'},
          ],
        );
      final list =
          (await fresh.onlineWith(server).getSuppliers()).getOrElse(() => []);
      expect(list.single.name, 'From Server');
      expect(server.log, ['GET ${ApiConstants.suppliers}']);
    });

    test('what changed at the office arrives with the next pull', () async {
      w.world.goOnline();
      w.rig.server.put('supplier', 's2', {
        'id': 's2',
        'name': 'Akbar Foods',
        'phone': '042111',
        'is_active': true,
      });
      w.rig.server.put('supplier', 's1', {
        'id': 's1',
        'name': 'Haji Traders & Co',
        'is_active': false,
      });
      await w.rig.sync();
      w.world.goOffline();
      final list = await all();
      expect(list.map((s) => s.name), ['Akbar Foods', 'Haji Traders & Co']);
      expect(list.last.isActive, isFalse);

      w.world.goOnline();
      w.rig.server.remove('supplier', 's2');
      await w.rig.sync();
      w.world.goOffline();
      expect((await all()).map((s) => s.id), ['s1']);
    });

    test('a new supplier is in every picker at once', () async {
      final added = await createWithOpening();

      expect((await all()).map((s) => s.name), [
        'Bilal & Sons',
        'Haji Traders',
      ]);
      // Pay supplier.
      final one = (await w.suppliers.getSupplier(added.id))
          .getOrElse(() => throw StateError('x'));
      expect(one.phone, '0311-7654321');
      expect(one.addressLine1, '12 Anarkali');
      expect(one.paymentTermsDays, 7);
      // Khata hub.
      expect((await w.hub('bilal')).items.single.id, added.id);
      expect((await w.hub('7654321')).items.single.balanceOwed, d('800'));
    });
  });

  group('adding a supplier offline', () {
    test('it is queued as the server expects it', () async {
      final added = await createWithOpening();

      final op = (await w.queued()).single;
      expect(op.type, OpTypes.supplierCreate);
      expect(op.payload['id'], added.id);
      expect(op.payload['address'], '12 Anarkali');
      expect(op.payload, isNot(contains('address_line1')));
      expect(op.payload, isNot(contains('email')), reason: 'blank is absent');
      expect(op.payload['opening_balance'], {
        'amount': '800.00',
        'direction': 'we_owe_them',
        'as_of_date': '2026-10-01',
        'branch_id': kBranch,
      });
      expect(await w.rig.store.unsyncedSupplierIds(), {added.id});
      expect(
        OpDescriber.describe(op).title,
        'New supplier Bilal & Sons',
      );
    });

    test('the open list shows it on top, with what we owe', () async {
      final list = w.listCubit();
      addTearDown(list.close);
      final id = await expectCreatedShowsInList<SuppliersListState>(
        list: list,
        open: list.load,
        create: () async =>
            (await list.createQuick(name: 'Zafar Mills', phone: '0300111'))?.id,
        rows: (state) => state is SuppliersListLoaded
            ? [for (final r in state.filteredItems) r.supplier.id]
            : null,
      );
      final row = (list.state as SuppliersListLoaded)
          .allItems
          .singleWhere((r) => r.supplier.id == id);
      expect(d(row.balance!), d('0'));
    });

    test('the full form saves it, and an open list hears of it', () async {
      final list = w.listCubit();
      final form = formCubit()
        ..initCreate()
        ..updateName('Zafar Mills')
        ..updateAddressLine1('Mall Road');
      addTearDown(list.close);
      addTearDown(form.close);
      await list.load();

      expect(await form.submit(), isNull);
      await settle(list);

      final names = (list.state as SuppliersListLoaded)
          .allItems
          .map((r) => r.supplier.name);
      expect(names, contains('Zafar Mills'));
      expect((await w.queued()).single.payload['address'], 'Mall Road');
    });

    test('an open Khata hub shows its opening balance', () async {
      final hub = KhataHubCubit(w.khata, initialTab: PartyType.supplier);
      addTearDown(hub.close);
      await hub.load();
      final added = await createWithOpening();
      await settle(hub);
      expect(
        [for (final r in hub.state.list!.rows) r.id],
        containsAll(['s1', added.id]),
      );
    });

    test('the opening balance section works offline', () async {
      final opening = OpeningBalanceCubit(
        w.khata,
        type: PartyType.supplier,
        resolveBranch: () async => kBranch,
        clock: () => DateTime(2026, 10, 29),
        saveOffline: w.suppliers.createSupplier,
      );
      addTearDown(opening.close);
      expect(opening.worksOffline, isTrue);
      opening.update(opening.state.draft.copyWith(amountText: '250'));

      expect(await opening.create({'name': 'Zafar Mills'}), isNull);

      final op = (await w.queued()).single;
      expect(
        (op.payload['opening_balance'] as Map)['amount'],
        '250.00',
      );
    });

    test('its account is the opening balance until the server has it',
        () async {
      final added = await createWithOpening();
      final id = added.id;

      final balance = (await w.suppliers.getSupplierBalance(id))
          .getOrElse(() => throw StateError('x'));
      expect(d(balance.balance), d('-800'));
      final page = (await w.suppliers.getLedger(id))
          .getOrElse(() => throw StateError('x'));
      expect(page.items.single.pending, isTrue);
      expect(page.items.single.amount, d('-800'));
      expect(page.olderNeedsInternet, isFalse);
      final bills = (await w.khata.openItems(PartyType.supplier, id))
          .getOrElse(() => throw StateError('x'))
          .value;
      expect(bills.balanceOwed, d('800'));
      expect(bills.items.single.remaining, d('800'));
      expect((await w.overview()).value.payable.total, d('1800'));
      expect((await w.overview()).value.payable.count, 2);
    });

    test('values the server would refuse are said now, nothing is queued',
        () async {
      for (final body in [
        {'name': 'A'},
        {'name': 'Good Name', 'email': 'not-an-email'},
        {'name': 'Good Name', 'payment_terms_days': 5000},
      ]) {
        final failure = failureOf(await w.suppliers.createSupplier(body));
        expect(failure, isA<ValidationFailure>());
        expectPlainLanguage(failure.message);
      }
      expect(await w.queued(), isEmpty);
      expect(await all(), hasLength(1));
    });

    test('syncing sends it once and counts nothing twice', () async {
      final added = await createWithOpening();
      await syncTwice();
      w.world.goOffline();

      expect(await w.queued(), isEmpty);
      expect(await w.rig.store.unsyncedSupplierIds(), isEmpty);
      expect(await w.rig.store.pendingSupplierCreates(), isEmpty);
      expect(
        w.rig.server.receivedOps.where((o) => o['type'] == 'supplier.create'),
        hasLength(1),
      );
      expect(await all(), hasLength(2));
      final balance = (await w.suppliers.getSupplierBalance(added.id))
          .getOrElse(() => throw StateError('x'));
      expect(d(balance.balance), d('-800'));
      final page = (await w.suppliers.getLedger(added.id))
          .getOrElse(() => throw StateError('x'));
      expect(page.items.single.pending, isFalse);
      expect((await w.overview()).value.payable.total, d('1800'));
    });

    test('accepted but not pulled yet, the account still reads right',
        () async {
      final added = await createWithOpening();
      w.world.goOnline();
      await w.rig.push.pushAll();
      w.world.goOffline();

      expect(await w.queued(), isEmpty);
      final balance = (await w.suppliers.getSupplierBalance(added.id))
          .getOrElse(() => throw StateError('x'));
      expect(d(balance.balance), d('-800'));
    });

    test('a payment follows it and both arrive in order', () async {
      final added = await createWithOpening();
      final paid = (await w.suppliers.paySupplier({
        'supplier_id': added.id,
        'amount': '300',
        'payment_source': 'bank',
        'branch_id': kBranch,
      }))
          .getOrElse(() => throw StateError('not saved'));
      expect(paid.queued, isTrue);
      expect(paid.balance, d('-500'));

      final ops = await w.queued();
      expect(ops.map((o) => o.type), [
        OpTypes.supplierCreate,
        OpTypes.supplierPayment,
      ]);
      expect(ops.last.dependsOn, [ops.first.opId]);

      await syncTwice();
      w.world.goOffline();
      expect(await w.queued(), isEmpty);
      final balance = (await w.suppliers.getSupplierBalance(added.id))
          .getOrElse(() => throw StateError('x'));
      expect(d(balance.balance), d('-500'));
      final page = (await w.suppliers.getLedger(added.id))
          .getOrElse(() => throw StateError('x'));
      expect(page.items, hasLength(2));
      expect(page.items.where((e) => e.pending), isEmpty);
    });

    testWidgets('the badge stays until the server has it', (tester) async {
      // The database is read in real time, outside the widget test's clock.
      var unsynced = <String>{};
      final changes = StreamController<void>.broadcast();
      addTearDown(changes.close);
      final added = (await tester.runAsync(() async {
        final added = await createWithOpening();
        unsynced = await w.rig.store.unsyncedSupplierIds();
        return added;
      }))!;
      await tester.pumpWidget(
        MaterialApp(
          home: SupplierSyncBadge(
            supplierId: added.id,
            compact: false,
            unsyncedIds: () async => unsynced,
            changes: changes.stream,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(NotSyncedBadge), findsOneWidget);

      await tester.runAsync(() async {
        await syncTwice();
        unsynced = await w.rig.store.unsyncedSupplierIds();
      });
      changes.add(null);
      await tester.pumpAndSettle();
      expect(find.byType(NotSyncedBadge), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('editing a supplier offline', () {
    test('only what changed is sent, and the list shows it at once',
        () async {
      final list = w.listCubit();
      final form = formCubit();
      addTearDown(list.close);
      addTearDown(form.close);
      await list.load();
      await form.loadForEdit('s1');
      form.updateCity('Multan');

      expect(await form.submit(), isNull);
      await settle(list);

      final op = (await w.queued()).single;
      expect(op.type, OpTypes.supplierUpdate);
      expect(op.payload, {
        'id': 's1',
        'fields': {'city': 'Multan'},
      });
      expect(
        (list.state as SuppliersListLoaded).allItems.single.supplier.city,
        'Multan',
      );
      expect(await w.rig.store.unsyncedSupplierIds(), {'s1'});

      await syncTwice();
      expect(await w.queued(), isEmpty);
      final held = w.rig.server.live['supplier|s1']!.data!;
      expect(held['city'], 'Multan');
      expect(held['phone'], '03001234567');
      expect((await all()).single.city, 'Multan');
    });

    test('a cleared field is sent as empty', () async {
      final form = formCubit();
      addTearDown(form.close);
      await form.loadForEdit('s1');
      form.updatePhone('');
      expect(form.changes(), {'phone': ''});
      expect(await form.submit(), isNull);
      expect((await w.queued()).single.payload['fields'], {'phone': ''});
      expect((await all()).single.phone, anyOf(isNull, isEmpty));
    });

    test('saving without a change queues nothing', () async {
      final form = formCubit();
      addTearDown(form.close);
      await form.loadForEdit('s1');
      expect(await form.submit(), isNull);
      expect(await w.queued(), isEmpty);
    });

    test('an edit of a new supplier follows its create', () async {
      final added = await createWithOpening();
      await update(added.id, {'city': 'Karachi'});

      final ops = await w.queued();
      expect(ops.last.type, OpTypes.supplierUpdate);
      expect(ops.last.dependsOn, [ops.first.opId]);

      await syncTwice();
      expect(await w.queued(), isEmpty);
      expect(
        w.rig.server.live['supplier|${added.id}']!.data!['city'],
        'Karachi',
      );
    });

    test('a discarded edit puts the supplier back', () async {
      await update('s1', {'name': 'Renamed Traders'});
      await update('s1', {'city': 'Multan'});
      final ops = await w.queued();

      await w.rig.store.transaction(
        () => w.rig.store.discardOp(ops.first.opId, reason: 'test'),
      );
      var one = (await all()).single;
      expect(one.name, 'Haji Traders');
      expect(one.city, 'Multan', reason: 'the other edit still waits');

      await w.rig.store.transaction(
        () => w.rig.store.discardOp(ops.last.opId, reason: 'test'),
      );
      one = (await all()).single;
      expect(one.city, anyOf(isNull, isEmpty));
      expect(await w.rig.store.unsyncedSupplierIds(), isEmpty);
    });
  });

  group('what needs the internet', () {
    test('activating and deleting say so and keep nothing', () async {
      final off = await w.suppliers.updateSupplier('s1', {'is_active': false});
      expect(failureOf(off).message, SupplierText.statusNeedsInternet);
      final gone = await w.suppliers.deleteSupplier('s1');
      expect(failureOf(gone).message, SupplierText.deleteNeedsInternet);
      expect(await w.queued(), isEmpty);
      expect((await all()).single.isActive, isTrue);
    });

    test('a new supplier cannot be deactivated or deleted before syncing',
        () async {
      final added = await createWithOpening();
      final off =
          await w.suppliers.updateSupplier(added.id, {'is_active': false});
      expect(failureOf(off).message, SupplierText.notSyncedYet);
      final gone = await w.suppliers.deleteSupplier(added.id);
      expect(failureOf(gone).message, SupplierText.notSyncedYet);
      expect(await w.queued(), hasLength(1));
    });

    test('the list says why and keeps its rows', () async {
      final list = w.listCubit();
      addTearDown(list.close);
      await list.load();
      final errors = <String>[];
      final watch = list.stream.listen((s) {
        if (s is SuppliersListError) errors.add(s.message);
      });
      addTearDown(watch.cancel);

      expect(await list.deleteSupplier('s1'), isFalse);
      expect(await list.toggleActive('s1', false), isFalse);
      await pumpEventQueue();

      expect(errors, [
        SupplierText.deleteNeedsInternet,
        SupplierText.statusNeedsInternet,
      ]);
      final row = (list.state as SuppliersListLoaded).allItems.single;
      expect(row.supplier.isActive, isTrue);
    });
  });

  group('a name or phone that is taken', () {
    test('known on this device: said at once', () async {
      final byName = failureOf(
        await w.suppliers.createSupplier({'name': '  haji   TRADERS '}),
      ) as ValidationFailure;
      expect(byName.code, SupplierText.duplicateCode);
      expect(
        byName.message,
        SupplierText.duplicate('name', 'Haji Traders'),
      );

      final byPhone = failureOf(
        await w.suppliers.createSupplier({
          'name': 'Someone Else',
          'phone': '0300-123 4567',
        }),
      );
      expect(byPhone.message, SupplierText.duplicate('phone', 'Haji Traders'));
      expect(await w.queued(), isEmpty);
    });

    test('Quick Add shows the sentence and the list stays', () async {
      final list = w.listCubit();
      addTearDown(list.close);
      await list.load();

      expect(await list.createQuick(name: 'Haji Traders'), isNull);

      expect(
        list.lastCreateError,
        SupplierText.duplicate('name', 'Haji Traders'),
      );
      expect(list.state, isA<SuppliersListLoaded>());
    });

    test('an edit cannot take it either', () async {
      final added = await createWithOpening();
      final result = await w.suppliers.updateSupplier(
        added.id,
        {'name': 'Haji Traders'},
      );
      expect(
        (failureOf(result) as ValidationFailure).code,
        SupplierText.duplicateCode,
      );
      expect(await w.queued(), hasLength(1));
    });

    test('online, the server\'s answer is shown as it is', () async {
      final server = FakeRest()
        ..on(
          'POST',
          ApiConstants.suppliers,
          (_) => jsonResponse(
            {
              'detail': {
                'code': 'duplicate_supplier',
                'message': 'Another supplier already has this name',
                'field': 'name',
                'existing_supplier_id': 's9',
              },
            },
            status: 409,
          ),
        );
      w.world.goOnline();
      final failure = failureOf(
        await w.onlineWith(server).createSupplier({'name': 'Taken'}),
      );
      expect(failure.code, SupplierText.duplicateCode);
      expect(failure.message, 'Another supplier already has this name');
      expect(await w.queued(), isEmpty);
    });

    /// Added here, while the office adds one of the same name; then synced.
    Future<
        ({
          String added,
          OutboxOp create,
          String expense,
        })> refusedByTheServer() async {
      final added = await createWithOpening(name: 'Zafar Mills');
      await w.suppliers.paySupplier({
        'supplier_id': added.id,
        'amount': '100',
        'payment_source': 'bank',
        'branch_id': kBranch,
      });
      final expense = await w.rig.writer.createExpense({
        'branch_id': kBranch,
        'expense_category_id': 'ec1',
        'expense_date': '2026-10-29',
        'amount': '250.00',
        'supplier_id': added.id,
        'payments': <dynamic>[],
      });
      await w.rig.writer.createFollowup({
        'party_type': 'supplier',
        'party_id': added.id,
        'kind': 'note',
        'note': 'Call on Monday',
      });
      w.rig.server.put('supplier', 's9', {
        'id': 's9',
        'name': 'Zafar Mills',
        'is_active': true,
      });
      w.rig.server.put('supplier_balance', 's9', {
        'id': 's9',
        'supplier_id': 's9',
        'balance_owed': '0.00',
        'advance_amount': '0.00',
      });
      await syncTwice();
      final create = (await w.rig.store.ops())
          .singleWhere((o) => o.type == OpTypes.supplierCreate);
      return (added: added.id, create: create, expense: expense);
    }

    test('refused by the server: kept, and the existing one is known',
        () async {
      final r = await refusedByTheServer();
      expect(r.create.needsAttention, isTrue);
      expect(r.create.errorCode, 'duplicate_supplier');
      final found = await w.rig.store.duplicateSupplier(r.create.opId);
      expect(found?.existingId, 's9');
      expect(found?.field, 'name');
      // Nothing was lost on the way.
      expect((await all()).map((s) => s.id), contains(r.added));
      expect(
        (await w.rig.store.ops(statuses: OutboxStatus.unfinished)).length,
        4,
      );
    });

    test('use the existing one: what was recorded goes to it', () async {
      final r = await refusedByTheServer();

      await w.rig.store.transaction(
        () => w.rig.store.useExistingSupplier(r.create.opId),
      );

      final waiting = await w.rig.store.ops(statuses: OutboxStatus.unfinished);
      expect(waiting.map((o) => o.type).toSet(), {
        OpTypes.supplierPayment,
        OpTypes.expenseCreate,
        OpTypes.followupCreate,
      });
      for (final o in waiting) {
        expect(o.status, OutboxStatus.pending);
        expect(o.dependsOn, isNot(contains(r.create.opId)));
        expect(
          o.payload['supplier_id'] ?? o.payload['party_id'],
          's9',
        );
      }
      expect((await all()).map((s) => s.id), isNot(contains(r.added)));

      await syncTwice();
      expect(await w.queued(), isEmpty);
      final balance = (await w.suppliers.getSupplierBalance('s9'))
          .getOrElse(() => throw StateError('x'));
      expect(d(balance.balance), d('100'), reason: 'the payment arrived');
    });

    test('discarded: the supplier goes, the expense stays without it',
        () async {
      final r = await refusedByTheServer();

      await w.rig.store.transaction(
        () => w.rig.store.discardOp(r.create.opId, reason: 'test'),
      );

      final waiting = await w.rig.store.ops(statuses: OutboxStatus.unfinished);
      expect(waiting.single.type, OpTypes.expenseCreate);
      expect(waiting.single.payload, isNot(contains('supplier_id')));
      expect(waiting.single.payload['amount'], '250.00');
      expect(waiting.single.dependsOn, isEmpty);
      expect((await all()).map((s) => s.id), isNot(contains(r.added)));
      expect((await w.hub()).items.map((i) => i.id), ['s1']);

      await syncTwice();
      expect(await w.queued(), isEmpty);
    });

    test('renamed: the same supplier is sent again', () async {
      final r = await refusedByTheServer();

      await update(r.added, {'name': 'Zafar Mills Lahore'});

      final create = (await w.rig.store.ops())
          .singleWhere((o) => o.type == OpTypes.supplierCreate);
      expect(create.status, OutboxStatus.pending);
      expect(create.payload['name'], 'Zafar Mills Lahore');
      expect(await w.rig.store.duplicateSupplier(create.opId), isNull);

      await syncTwice();
      expect(await w.queued(), isEmpty);
      expect(
        w.rig.server.live['supplier|${r.added}']!.data!['name'],
        'Zafar Mills Lahore',
      );
      final balance = (await w.suppliers.getSupplierBalance(r.added))
          .getOrElse(() => throw StateError('x'));
      expect(d(balance.balance), d('-700'));
    });

    testWidgets('the failed items page offers the existing supplier',
        (tester) async {
      late String createOp;
      await tester.runAsync(() async {
        createOp = (await refusedByTheServer()).create.opId;
        w.world.goOffline();
      });
      // Database work started by the page needs real time and a frame.
      Future<void> wait() async {
        for (var i = 0; i < 6; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 40)),
          );
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FailedItemsPage(
              store: w.rig.store,
              engine: w.rig.engine,
              canDiscard: true,
            ),
          ),
        ),
      );
      await wait();
      expect(
        find.text(SupplierText.existingIs('Zafar Mills')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('use-existing-supplier')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('use-existing-dialog')), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirm-use-existing')));
      await tester.pumpAndSettle();
      await wait();
      expect(find.byKey(const Key('use-existing-supplier')), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await wait();
      expect(await tester.runAsync(() => w.rig.store.op(createOp)), isNull);
    });

    test('a server refusal on an edit is explained and can be discarded',
        () async {
      w.rig.server.errors['supplier.update'] = const OpError(
        code: 'duplicate_supplier',
        message: 'Another supplier already has this name',
        details: {'field': 'name', 'existing_supplier_id': 's9'},
      );
      await update('s1', {'name': 'Taken Name'});
      await syncTwice();
      final op = (await w.rig.store.ops())
          .singleWhere((o) => o.type == OpTypes.supplierUpdate);
      expect(op.needsAttention, isTrue);
      expect(op.errorMessage, contains('already has this name'));

      await w.rig.store.transaction(
        () => w.rig.store.discardOp(op.opId, reason: 'test'),
      );
      w.world.goOffline();
      expect((await all()).single.name, 'Haji Traders');
    });
  });

  group('where the device\'s part of an account ends', () {
    /// The server holds older supplier entries than it sends.
    Future<void> olderExists() async {
      w.world.goOnline();
      w.rig.server.put('supplier_balance', 's1', {
        'id': 's1',
        'supplier_id': 's1',
        'balance_owed': '1500.00',
        'advance_amount': '0.00',
        'has_older_entries': true,
        'oldest_included_entry_at': '2026-10-01T09:00:00+00:00',
      });
      await w.rig.sync();
      w.world.goOffline();
    }

    test('the supplier ledger says older entries need internet', () async {
      await olderExists();
      final cubit = w.ledgerCubit();
      addTearDown(cubit.close);
      await cubit.load('s1');
      expect(cubit.state.olderNeedsInternet, isTrue);
      expect(cubit.state.openingNeedsInternet, isFalse, reason: 'no dates');

      // A period inside what is here: complete, with its start proven.
      await cubit.setDates(DateTime(2026, 10, 15), null);
      expect(cubit.state.olderNeedsInternet, isFalse);
      expect(cubit.state.openingBalance, d('-600'));
      expect(cubit.state.openingNeedsInternet, isFalse);

      // One reaching further back: no start is made up.
      await cubit.setDates(DateTime(2026, 9, 1), null);
      expect(cubit.state.olderNeedsInternet, isTrue);
      expect(cubit.state.openingBalance, isNull);
      expect(cubit.state.openingNeedsInternet, isTrue);
    });

    test('a complete account says nothing', () async {
      final cubit = w.ledgerCubit();
      addTearDown(cubit.close);
      await cubit.load('s1');
      expect(cubit.state.olderNeedsInternet, isFalse);
    });

    /// Ali owes 1000: one older line is not sent to the device.
    Future<void> customerWithHistory({required bool older}) async {
      w.world.goOnline();
      w.rig.server.put('customer_balance', 'c1', {
        'id': 'c1',
        'customer_id': 'c1',
        'balance_owed': '1000.00',
        'has_older_entries': older,
        'oldest_included_entry_at':
            older ? '2026-10-10T09:00:00+00:00' : null,
      });
      w.rig.server.put('customer_ledger', 'cl-1', {
        'id': 'cl-1',
        'customer_id': 'c1',
        'branch_id': kBranch,
        'entry_type': 'udhaar_given',
        'amount': older ? -400 : -1000,
        'entry_at': '2026-10-10T09:00:00+00:00',
        'created_at': '2026-10-10T09:00:00+00:00',
      });
      await w.rig.sync();
      w.world.goOffline();
    }

    test('the customer ledger says it too', () async {
      await customerWithHistory(older: true);
      final cubit = w.world.ledgerCubit();
      addTearDown(cubit.close);
      await cubit.load('c1');

      expect(cubit.fromDevice, isTrue);
      expect(cubit.olderNeedsInternet, isTrue);
      final state = cubit.state as CustomerLedgerLoaded;
      expect(state.entries.single.entry.id, 'cl-1');
      expect(state.balance, '-1000.00');
    });

    for (final older in [true, false]) {
      testWidgets(
          'the customer table ${older ? 'ends with' : 'has no'} the note',
          (tester) async {
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final cubit = (await tester.runAsync(() async {
          await customerWithHistory(older: older);
          final cubit = w.world.ledgerCubit();
          await cubit.load('c1');
          return cubit;
        }))!;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider.value(
                value: cubit,
                child: CustomerLedgerTable(
                  state: cubit.state as CustomerLedgerLoaded,
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(
          find.text(KhataText.olderNeedInternet),
          older ? findsOneWidget : findsNothing,
        );
        await tester.pumpWidget(const SizedBox());
        await tester.runAsync(cubit.close);
      });
    }
  });
}
