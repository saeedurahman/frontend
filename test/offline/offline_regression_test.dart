// Regression tests for the offline-mode bugs:
//   1. quantity popup "Add" waited ~3 s on a network modifier lookup;
//   2. stock on the product card did not follow a sale / a pull;
//   3. customer quick-create showed a raw connection error;
// plus the audit of the other counter flows. Everything runs against the
// in-memory fake sync server (SyncRig) and a "connection refused" HTTP fake.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/offline/receipt_branding_source.dart';
import 'package:frantend/core/offline/repos/offline_decorators.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/utils/pos_perf.dart';
import 'package:frantend/features/pos/presentation/cubit/customer_picker_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/models/add_to_cart_result.dart';
import 'package:frantend/features/pos/presentation/widgets/customer_picker_dialog.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/shared/widgets/sync/not_synced_badge.dart';

import '../helpers/offline_world.dart';
import '../sync/sync_rig.dart';

Decimal d(String v) => Decimal.parse(v);

/// Waits (real time, short polls) until [condition] holds.
Future<void> waitFor(
  bool Function() condition, {
  String reason = 'condition',
  Duration timeout = const Duration(seconds: 3),
}) async {
  final watch = Stopwatch()..start();
  while (!condition()) {
    if (watch.elapsed > timeout) fail('Timed out waiting for $reason');
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}

ProductListItemModel card(PosCubit pos, String id) =>
    pos.state.products.firstWhere((p) => p.id == id);

Decimal? shownStock(PosCubit pos, [String id = 'p1']) =>
    Decimal.tryParse(pos.getDisplayStock(id) ?? '');

/// Opens a shift and completes a cash sale of [qty] x p1 through the cubit.
Future<void> sellThroughPos(PosCubit pos, {String qty = '2'}) async {
  if (pos.state.activeShift == null) {
    expect(await pos.openShift(Decimal.zero, null), isTrue,
        reason: pos.state.openShiftError);
  }
  final added = await pos.addToCart(card(pos, 'p1'), qty: d(qty));
  expect(added.result, AddToCartResult.added, reason: added.message);
  await pos.submitSale([
    PaymentLineModel(
      paymentMethod: 'cash',
      amount: pos.state.displayGrandTotal,
    ),
  ]);
}

class _SlowFailingSearch extends Fake
    implements customers_uc.GetCustomersUseCase {
  final pending = <Completer<Either<Failure, List<CustomerModel>>>>[];

  @override
  Future<Either<Failure, List<CustomerModel>>> call({String? search}) {
    final c = Completer<Either<Failure, List<CustomerModel>>>();
    pending.add(c);
    return c.future;
  }
}

class _MemoryCustomers extends Fake
    implements customers_uc.GetCustomersUseCase {
  _MemoryCustomers(this.items);
  final List<CustomerModel> items;

  @override
  Future<Either<Failure, List<CustomerModel>>> call({String? search}) async {
    final q = search?.toLowerCase() ?? '';
    return Right([
      for (final c in items)
        if (c.name.toLowerCase().contains(q)) c,
    ]);
  }
}

class _MemoryCreate extends Fake implements customers_uc.CreateCustomerUseCase {
  _MemoryCreate(this.items);
  final List<CustomerModel> items;

  @override
  Future<Either<Failure, CustomerModel>> call(Map<String, dynamic> body) async {
    final customer = CustomerModel(
      id: 'c-new-${items.length}',
      businessId: kBusiness,
      name: '${body['name']}',
    );
    items.add(customer);
    return Right(customer);
  }
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true; // one per test

  // ════════════════════════════════════════════════════════════════════
  // BUG 1: add-to-cart must not wait for the network
  // ════════════════════════════════════════════════════════════════════
  group('add-to-cart is instant', () {
    test('fails if add-to-cart awaits any network call '
        '(the server never answers)', () async {
      // Every HTTP request hangs forever: anything that awaits one of them
      // can only run into the timeouts below.
      final world = OfflineWorld(adapter: UnreachableAdapter(hang: true));
      addTearDown(world.dispose);
      await world.seed();
      final pos = world.posCubit();
      addTearDown(pos.close);
      await pos.init().timeout(const Duration(seconds: 5));

      // What the "Add" button of the quantity popup does: the modifier
      // lookup, then the cart.
      final groups = await world.modifiers
          .groupsFor('p1')
          .timeout(const Duration(seconds: 1));
      final outcome = await pos
          .addToCart(card(pos, 'p1'), qty: d('3'))
          .timeout(const Duration(seconds: 1));

      expect(groups, isEmpty);
      expect(outcome.result, AddToCartResult.added);
      expect(pos.state.cartItems.single.qty, d('3'));
      expect(pos.state.cartItems.single.unitPrice, d('100.00'));
      // The server is asked in the background and never answers: the cart
      // cannot have depended on it.
      await waitFor(() => world.adapter.requests.isNotEmpty,
          reason: 'the background modifier refresh');
      expect(world.adapter.answered, 0);
    });

    test('connection refused (probe has not noticed yet): the cart still '
        'updates from local data, also for a scanned barcode', () async {
      // As in production: refused after a moment, retried once a second later.
      final world = OfflineWorld(
        adapter: UnreachableAdapter(delay: const Duration(seconds: 1)),
        retries: true,
      );
      addTearDown(world.dispose);
      await world.seed();
      final pos = world.posCubit();
      addTearDown(pos.close);
      await pos.init();

      final watch = Stopwatch()..start();
      await world.modifiers.groupsFor('p1');
      final added = await pos.addToCart(card(pos, 'p1'), qty: d('2'));
      final scanned = await pos.lookupBarcode('8964000111111');
      watch.stop();

      expect(added.result, AddToCartResult.added);
      expect(scanned, isTrue);
      expect(pos.state.cartItems.single.qty, d('3'));
      expect(world.adapter.answered, 0,
          reason: 'nothing waited for the refusal (1 s away)');
      expect(watch.elapsed, lessThan(const Duration(milliseconds: 500)));
    });

    test('known offline: no request is even attempted', () async {
      final world = OfflineWorld();
      addTearDown(world.dispose);
      await world.seed();
      world.goOffline();
      final pos = world.posCubit();
      addTearDown(pos.close);
      await pos.init();

      await world.modifiers.groupsFor('p1');
      await pos.addToCart(card(pos, 'p1'));
      await pos.lookupBarcode('8964000111111');

      expect(pos.state.cartItems.single.qty, d('2'));
      expect(world.adapter.requests, isEmpty);
    });

    test('modifier groups are served from the device once they were fetched',
        () async {
      final world = OfflineWorld();
      addTearDown(world.dispose);
      await world.seed();
      // The copy a warm-up stored while the server was reachable.
      await world.rig.store.setMeta(
        'modifier_groups:p1',
        jsonEncode({
          'at': world.rig.now.millisecondsSinceEpoch,
          'groups': [
            {
              'id': 'g1',
              'business_id': kBusiness,
              'name': 'Extras',
              'selection_type': 'multiple',
              'modifiers': [
                {
                  'id': 'm1',
                  'business_id': kBusiness,
                  'modifier_group_id': 'g1',
                  'name': 'Cheese',
                  'price_delta': '50',
                },
              ],
            },
            {
              'id': 'g2',
              'business_id': kBusiness,
              'name': 'Retired',
              'selection_type': 'single',
              'is_active': false,
              'modifiers': <dynamic>[],
            },
          ],
        }),
      );
      world.goOffline();

      final groups = await world.modifiers.groupsFor('p1');

      expect(groups.single.name, 'Extras');
      expect(groups.single.modifiers.single.name, 'Cheese');
      expect(world.adapter.requests, isEmpty);
    });

    test('performance: add-to-cart < 100 ms, sale save < 300 ms', () async {
      final world = OfflineWorld();
      addTearDown(world.dispose);
      await world.seed(stock: 100);
      world.goOffline();
      final pos = world.posCubit();
      addTearDown(pos.close);
      await pos.init();
      expect(await pos.openShift(Decimal.zero, null), isTrue);

      // First call pays for JIT / statement preparation; measure the next.
      await pos.addToCart(card(pos, 'p1'));
      await pos.addToCart(card(pos, 'p1'), qty: d('2'));
      expect(PosPerf.last(PosPerf.addToCart), isNotNull);
      expect(PosPerf.last(PosPerf.addToCart)!, lessThan(PosPerf.addToCartBudget));

      await pos.submitSale([
        PaymentLineModel(
          paymentMethod: 'cash',
          amount: pos.state.displayGrandTotal,
        ),
      ]);
      expect(PosPerf.last(PosPerf.saleSave)!, lessThan(PosPerf.saleSaveBudget));
    });
  });

  // ════════════════════════════════════════════════════════════════════
  // BUG 2: stock shown = pulled stock - sales the pull does not include
  // ════════════════════════════════════════════════════════════════════
  group('stock on the card is reactive', () {
    late OfflineWorld world;
    late PosCubit pos;

    setUp(() async {
      world = OfflineWorld();
      await world.seed(); // p1: 10 in stock
      pos = world.posCubit();
      await pos.init();
      expect(shownStock(pos), d('10'));
    });

    tearDown(() async {
      await pos.close();
      await world.dispose();
    });

    test('drops right after a sale is saved on this device (offline)',
        () async {
      world.goOffline();

      await sellThroughPos(pos, qty: '2');

      await waitFor(() => shownStock(pos) == d('8'), reason: 'stock 8');
      expect(await world.rig.stockOf('p1'), d('8'));
    });

    test('follows a sale saved outside the cubit (store event, no navigation)',
        () async {
      await world.rig.sell(qty: '3');
      await waitFor(() => shownStock(pos) == d('7'), reason: 'stock 7');
    });

    test('follows a pull (stock changed on the server)', () async {
      world.rig.server.setStock('p1', kBranch, 25);
      await world.rig.sync();
      await waitFor(() => shownStock(pos) == d('25'), reason: 'stock 25');
    });

    test('sync of the sale: never double subtracted, never jumps back up',
        () async {
      world.goOffline();
      await sellThroughPos(pos, qty: '2');
      await waitFor(() => shownStock(pos) == d('8'));

      // Every value the card shows from here on.
      final seen = <Decimal?>[];
      final sub = pos.stream
          .map((s) => Decimal.tryParse(s.stockCache['p1'] ?? ''))
          .listen(seen.add);
      addTearDown(sub.cancel);

      world.goOnline();
      await world.rig.sync(); // push (applied) then pull (server stock = 8)
      await world.rig.sync(); // and again: nothing changes
      await pumpEventQueue();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(world.rig.server.stock['p1|$kBranch'], 8);
      expect((await world.rig.store.counts()).unfinished, 0);
      expect(await world.rig.stockOf('p1'), d('8'),
          reason: 'pulled 8, and the synced sale is no longer subtracted');
      expect(shownStock(pos), d('8'));
      expect(seen.where((v) => v != d('8')), isEmpty,
          reason: 'no 6 (double subtraction) and no 10 (dropped too early)');
      expect(await world.rig.store.stockUnconfirmedSales(), isEmpty);
    });

    test('accepted by the server but not pulled yet: still subtracted once',
        () async {
      await world.rig.sell(qty: '2');

      // Push only: the server has the sale, the device still has the old
      // pulled balance (10).
      final pushed = await world.rig.push.pushAll();
      expect(pushed.applied, 1);
      expect(await world.rig.store.stockUnconfirmedSales(), hasLength(1));
      expect(await world.rig.stockOf('p1'), d('8'));

      // The pull delivers the balance that contains the sale (8).
      await world.rig.pull.pullAll();
      expect(await world.rig.store.stockUnconfirmedSales(), isEmpty);
      expect(await world.rig.stockOf('p1'), d('8'));
      await waitFor(() => shownStock(pos) == d('8'));
    });

    test('a sale made while another is waiting for its pull', () async {
      await world.rig.sell(qty: '2');
      await world.rig.push.pushAll(); // first sale accepted, not pulled
      await world.rig.sell(qty: '1'); // second sale still pending
      expect(await world.rig.stockOf('p1'), d('7'));

      await world.rig.sync(); // pushes the second, pulls 7
      expect(await world.rig.stockOf('p1'), d('7'));
      await waitFor(() => shownStock(pos) == d('7'));
    });

    test('returns and voids announce a stock change', () async {
      final sale = await world.rig.sell(qty: '2');
      await world.rig.sync();

      final events = <void>[];
      final sub = world.rig.store.stockChanges.listen(events.add);
      addTearDown(sub.cancel);

      await world.rig.writer.createReturn({
        'branch_id': kBranch,
        'sale_id': sale['id'],
        'lines': <dynamic>[],
      });
      await pumpEventQueue();
      expect(events, hasLength(1), reason: 'return queued');

      await world.rig.writer.voidSale(sale['id']! as String);
      await pumpEventQueue();
      expect(events, hasLength(2), reason: 'void queued');

      // The server restocks; the next pull brings it to the open POS.
      world.rig.server.setStock('p1', kBranch, 10);
      await world.rig.sync();
      await waitFor(() => shownStock(pos) == d('10'), reason: 'restocked');
    });

    test('the quantity popup and add-to-cart read the same number', () async {
      world.goOffline();
      await sellThroughPos(pos, qty: '4');
      await waitFor(() => shownStock(pos) == d('6'));

      // The popup's "In stock" comes from getDisplayStock (the card's
      // source); add-to-cart checks the same cache.
      final outcome = await pos.addToCart(card(pos, 'p1'), qty: d('6'));
      expect(outcome.result, AddToCartResult.added);
      expect(pos.state.cartItems.single.maxAvailableStock, d('6'));
    });
  });

  // ════════════════════════════════════════════════════════════════════
  // BUG 3: customer quick-create is local-first
  // ════════════════════════════════════════════════════════════════════
  group('customer quick-create offline', () {
    late OfflineWorld world;

    setUp(() async {
      world = OfflineWorld();
      await world.seed();
    });

    tearDown(() => world.dispose());

    test('no error, pending badge, selected in the cart, syncs later',
        () async {
      // Connection refused, and the probe has not noticed: the worst case.
      world.rig.server.offline = true;
      final picker = world.pickerCubit();
      addTearDown(picker.close);
      final pos = world.posCubit();
      addTearDown(pos.close);
      await pos.init();

      await picker.loadInitial();
      expect(picker.state.error, isNull);
      expect(picker.state.results.map((c) => c.name), contains('Ali Traders'));

      picker.search('Bilal');
      picker.showCreateForm();
      final customer = await picker.createCustomer(
        name: 'Bilal Store',
        phone: '0301',
        creditLimit: '500',
      );
      await Future<void>.delayed(const Duration(milliseconds: 400)); // debounce

      expect(customer, isNotNull);
      expect(picker.state.error, isNull);
      expect(picker.state.isCreating, isFalse);
      expect(picker.state.isUnsynced(customer!.id), isTrue);
      expect(picker.state.isUnsynced('c1'), isFalse);
      expect(
        world.adapter.requests.where((r) => r.path.contains('customers')),
        isEmpty,
        reason: 'the picker never touches the network',
      );

      // Shown again from the device, still marked.
      await picker.loadInitial();
      expect(picker.state.results.map((c) => c.name), contains('Bilal Store'));
      expect(picker.state.isUnsynced(customer.id), isTrue);

      // Selected in the cart with data from the device.
      await pos.selectCustomer(customer);
      expect(pos.state.selectedCustomer?.id, customer.id);
      expect(pos.state.selectedCustomer?.name, 'Bilal Store');
      expect(pos.state.selectedCustomer?.creditLimit, '500');

      // One local write + one outbox op.
      final ops = await world.rig.store.ops();
      expect(ops.single.type, OpTypes.customerCreate);
      expect(ops.single.entityId, customer.id);

      // Back online: it syncs and the badge goes away.
      world.rig.server.offline = false;
      await world.rig.sync();
      expect(world.rig.server.live.containsKey('customer|${customer.id}'), isTrue);
      expect(await world.rig.catalog.unsyncedCustomerIds(), isEmpty);
      await picker.loadInitial();
      expect(picker.state.isUnsynced(customer.id), isFalse);
    });

    test('a search that fails late cannot put an error on the create form',
        () async {
      final search = _SlowFailingSearch();
      final items = <CustomerModel>[];
      final picker = CustomerPickerCubit(
        getCustomersUseCase: search,
        createCustomerUseCase: _MemoryCreate(items),
        unsyncedCustomerIds: () async => {for (final c in items) c.id},
      );
      addTearDown(picker.close);

      unawaited(picker.loadInitial()); // still on its way
      picker.showCreateForm();
      final customer = await picker.createCustomer(name: 'Late Larry');

      // The old request now fails with the text the bug report quoted.
      search.pending.single.complete(const Left(NetworkFailure(
        'The connection errored: The remote computer refused the network '
        'connection. This indicates an error which most likely cannot be '
        'solved by the library.',
      )));
      await pumpEventQueue();

      expect(customer, isNotNull);
      expect(picker.state.error, isNull);
      expect(picker.state.results.single.name, 'Late Larry');
      expect(picker.state.isUnsynced(customer!.id), isTrue);
    });

    test('a failure that does get through is plain language', () async {
      final search = _SlowFailingSearch();
      final picker = CustomerPickerCubit(
        getCustomersUseCase: search,
        createCustomerUseCase: _MemoryCreate([]),
      );
      addTearDown(picker.close);

      final load = picker.loadInitial();
      search.pending.single.complete(const Left(NetworkFailure(
        'DioException [connection error]: The connection errored: '
        'refused the network connection',
      )));
      await load;

      expect(picker.state.error, UserErrorMessage.offline);
      expectPlainLanguage(picker.state.error);
    });

    testWidgets('picker dialog: the new customer is selected, carries the '
        '"Not synced yet" badge, and no error is shown', (tester) async {
      final items = <CustomerModel>[
        const CustomerModel(id: 'c1', businessId: kBusiness, name: 'Ali Traders'),
      ];
      sl.registerFactory<CustomerPickerCubit>(
        () => CustomerPickerCubit(
          getCustomersUseCase: _MemoryCustomers(items),
          createCustomerUseCase: _MemoryCreate(items),
          unsyncedCustomerIds: () async =>
              {for (final c in items) if (c.id != 'c1') c.id},
        ),
      );
      addTearDown(sl.reset);
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      CustomerModel? picked;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async =>
                  picked = await CustomerPickerDialog.show(context),
              child: const Text('pick'),
            ),
          ),
        ),
      ));

      // Quick-create.
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create new customer'));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'Name *'), 'Bilal Store');
      await tester.tap(find.text('Save Customer'));
      await tester.pumpAndSettle();

      expect(find.byType(CustomerPickerDialog), findsNothing,
          reason: 'saved and closed at once');
      expect(picked?.name, 'Bilal Store');

      // Open again: listed from the device with the badge.
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();
      expect(find.text('Bilal Store'), findsOneWidget);
      expect(find.text(UserErrorMessage.notSyncedYet), findsOneWidget);
      expect(find.byIcon(NotSyncedBadge.icon), findsOneWidget);
      for (final fragment in UnreachableAdapter.rawFragments) {
        expect(find.textContaining(fragment), findsNothing);
      }
    });

    testWidgets('cart header badge disappears once the customer synced',
        (tester) async {
      var unsynced = <String>{'c-new'};
      final changes = StreamController<void>.broadcast();
      addTearDown(changes.close);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomerSyncBadge(
            customerId: 'c-new',
            unsyncedIds: () async => unsynced,
            changes: changes.stream,
          ),
        ),
      ));
      await tester.pump();
      expect(find.byIcon(NotSyncedBadge.icon), findsOneWidget);
      expect(find.byTooltip(UserErrorMessage.notSyncedYet), findsOneWidget);

      unsynced = {};
      changes.add(null);
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(NotSyncedBadge.icon), findsNothing);
    });
  });

  // ════════════════════════════════════════════════════════════════════
  // AUDIT: the other counter flows while the server refuses connections
  // ════════════════════════════════════════════════════════════════════
  group('audited flows: connection refused', () {
    late OfflineWorld world;

    setUp(() async {
      world = OfflineWorld();
      await world.seed();
      // The sync server is gone too; the probe still says "online", so every
      // remote read really is attempted and refused.
      world.rig.server.offline = true;
    });

    tearDown(() => world.dispose());

    /// Asserts a failure (if any) is words for a person.
    void plain(Either<Failure, Object?> result) =>
        result.fold((f) => expectPlainLanguage(f.message), (_) {});

    test('customer list / detail / balance fall back to the device', () async {
      final list = await world.customers.getCustomers(search: 'ali');
      final one = await world.customers.getCustomer('c1');
      final balance = await world.customers.getCustomerBalance('c1');

      expect(list.getOrElse(() => []).single.name, 'Ali Traders');
      expect(one.isRight(), isTrue);
      expect(balance.getOrElse(() => throw 'x').balance, '-1000.00');
      // Unknown on the device: a plain sentence, not the library's text.
      final missing = await world.customers.getCustomer('nope');
      expect(missing.isLeft(), isTrue);
      plain(missing);
    });

    test('customer payment: saved, no error, "will sync when online"',
        () async {
      final ledger = world.ledgerCubit();
      addTearDown(ledger.close);

      await ledger.load('c1');
      final loaded = ledger.state;
      expect(loaded, isA<CustomerLedgerLoaded>(),
          reason: 'customer and balance come from the device');
      expect(ledger.ledgerNeedsConnection, isTrue);
      expect((loaded as CustomerLedgerLoaded).balance, '-1000.00');

      final response = await ledger.recordPayment(
        amount: d('400'),
        paymentMethod: 'cash',
      );

      expect(response, isNotNull);
      expect(response!.newBalance, '-600.00');
      final after = ledger.state as CustomerLedgerLoaded;
      expect(after.paymentError, isNull);
      expect(after.isRecordingPayment, isFalse);
      expect(after.balance, '-600.00');
      expect(ledger.lastPaymentSavedOffline, isTrue);
      expect((await world.rig.store.ops()).single.type, OpTypes.customerPayment);
    });

    test('expense create: saved locally; categories from the stored copy',
        () async {
      // Never fetched: a plain message.
      final none = await world.expenses.getCategories();
      expect(none.isLeft(), isTrue);
      plain(none);

      await world.rig.store.setMeta(
        OfflineExpensesRepository.categoriesKey,
        jsonEncode([
          {'id': 'ec1', 'name': 'Utilities'},
        ]),
      );
      final cached = await world.expenses.getCategories();
      expect(cached.getOrElse(() => []).single.name, 'Utilities');

      final created = await world.expenses.createExpense({
        'branch_id': kBranch,
        'expense_category_id': 'ec1',
        'expense_date': '2026-10-29',
        'amount': '250.00',
        'description': 'Electricity',
        'payments': <dynamic>[],
      });
      expect(created.isRight(), isTrue);
      expect(created.getOrElse(() => throw 'x').expenseNumber, 'Pending sync');
      expect((await world.rig.store.ops()).single.type, OpTypes.expenseCreate);
    });

    test('shift open / close, hold / resume: local only', () async {
      final before = world.adapter.requests.length;
      final opened = await world.cashRegister.openShift({
        'cash_register_id': 'reg-1',
        'opening_float': '100',
      });
      final shift = opened.getOrElse(() => throw 'x');
      final active = await world.cashRegister.getMyActiveShift();
      expect(active.getOrElse(() => null)?.id, shift.id);

      final pos = world.posCubit();
      addTearDown(pos.close);
      await pos.init();
      final requestsAfterInit = world.adapter.requests.length;
      await pos.addToCart(card(pos, 'p1'), qty: d('2'));
      expect(await pos.holdCurrentSale(), isTrue);
      expect(pos.state.cartItems, isEmpty);
      final resumed = await pos.resumeHeldOrder(pos.state.heldOrders.single.id);
      expect(resumed.resumed, isTrue);
      expect(pos.state.cartItems.single.qty, d('2'));
      expect(pos.state.registersError, isNull);
      expect(pos.state.shiftSummaryError, isNull);

      final closed = await world.cashRegister.closeShift(
        shift.id,
        actualCash: '100',
      );
      expect(closed.isRight(), isTrue);
      // Only the background modifier warm-up of pos.init() may have tried.
      expect(
        world.adapter.requests
            .skip(before)
            .where((r) => !r.path.contains('modifier-groups')),
        isEmpty,
      );
      expect(world.adapter.requests.length, requestsAfterInit);
    });

    test('creating a register needs the server: plain message', () async {
      final pos = world.posCubit();
      addTearDown(pos.close);
      await pos.init();

      expect(await pos.createDefaultRegister(), isFalse);
      expect(pos.state.registersError, UserErrorMessage.offline);
    });

    test('return create: queued locally', () async {
      final sale = await world.rig.sell();
      final result = await world.returns.createReturn({
        'branch_id': kBranch,
        'sale_id': sale['id'],
        'reason': 'damaged',
        'lines': <dynamic>[],
      });
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => throw 'x').returnNumber, 'Pending sync');
    });

    test('receipt reprint: the sale opens from the device', () async {
      world.rig.server.offline = false;
      final sale = await world.rig.sell();
      await world.rig.sync(); // now "synced": the server copy is preferred
      world.rig.server.offline = true;

      final viaRefusal = await world.sales.getSaleById(sale['id']! as String);
      expect(viaRefusal.isRight(), isTrue);

      // Known offline: the server is not even asked.
      world.goOffline();
      final before = world.adapter.requests.length;
      final direct = await world.sales.getSaleById(sale['id']! as String);
      expect(direct.getOrElse(() => throw 'x').saleNumber, isNotNull);
      expect(world.adapter.requests.length, before);

      // A sale this device never saw: plain message.
      final unknown = await world.sales.getSaleById('other-device-sale');
      expect(unknown.isLeft(), isTrue);
      plain(unknown);
    });

    test('receipt branding: stored copy, else defaults; never an error',
        () async {
      // Nothing stored: no header, default footer, no exception.
      expect(await world.branding.businessProfile(), isNull);
      final defaults = await world.branding.displaySettings(branchId: kBranch);
      expect(defaults.footerText, ReceiptBrandingSource.defaults.footerText);
      expect(defaults.paperSize, '80mm');

      // What a sync stored earlier.
      await world.rig.store.setMeta(
        ReceiptBrandingSource.profileKey,
        jsonEncode(
          const BusinessProfileModel(id: kBusiness, name: 'Demo Mart').toJson(),
        ),
      );
      world.goOffline();
      final before = world.adapter.requests.length;
      final profile = await world.branding.businessProfile();
      expect(profile?.name, 'Demo Mart');
      expect(world.adapter.requests.length, before,
          reason: 'printing offline does not touch the network');
    });

    test('sale save cannot fail for connectivity reasons', () async {
      final pos = world.posCubit();
      addTearDown(pos.close);
      await pos.init();

      await sellThroughPos(pos);

      expect(pos.state.cartItems, isEmpty);
      expect((await world.rig.store.sales()).single['sync_state'], 'pending');
    });
  });

  // ════════════════════════════════════════════════════════════════════
  // Central mapper
  // ════════════════════════════════════════════════════════════════════
  group('central error mapper', () {
    const handler = ErrorHandler();
    final options = RequestOptions(path: '/customers');

    test('connection refused never reaches the UI as library text', () {
      final refused = DioException.connectionError(
        requestOptions: options,
        reason: UnreachableAdapter.reason,
        error: const SocketException(UnreachableAdapter.reason),
      );
      expect(refused.message, contains('The connection errored'),
          reason: 'this is the text from the bug report');

      final failure = handler.mapExceptionToFailure(refused);
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, UserErrorMessage.offline);
      expectPlainLanguage(failure.message);
    });

    test('timeouts, sockets and unknown transport errors map the same way', () {
      final errors = <Object>[
        DioException.connectionTimeout(
          timeout: const Duration(seconds: 5),
          requestOptions: options,
        ),
        DioException.receiveTimeout(
          timeout: const Duration(seconds: 5),
          requestOptions: options,
        ),
        DioException(
          requestOptions: options,
          error: const SocketException('Connection refused', osError: OSError('', 111)),
        ),
        const SocketException('Failed host lookup: api.example.com'),
        const HttpException('Connection closed before full header was received'),
        TimeoutException('gone'),
      ];
      for (final error in errors) {
        final failure = handler.mapExceptionToFailure(error);
        expect(failure, isA<NetworkFailure>(), reason: '$error');
        expect(failure.message, UserErrorMessage.offline);
        expect(UserErrorMessage.from(error), UserErrorMessage.offline);
      }
    });

    test('raw text inside another message is replaced, real messages are kept',
        () {
      expect(
        UserErrorMessage.from(Exception(
          'DioException [connection error]: The connection errored: '
          'The remote computer refused the network connection.',
        )),
        UserErrorMessage.offline,
      );
      expect(
        UserErrorMessage.from(const NetworkFailure('SocketException: errno = 1225')),
        UserErrorMessage.offline,
      );
      expect(
        UserErrorMessage.from(const ValidationFailure('Phone: field required')),
        'Phone: field required',
      );
      expect(UserErrorMessage.from(Exception('Cart is empty')), 'Cart is empty');
      expect(
        handler.mapExceptionToFailure(StateError('SocketException: x')).message,
        UserErrorMessage.offline,
      );
    });

    test('server answers keep their own message', () {
      final bad = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 409,
          data: {'detail': 'Phone already used'},
        ),
      );
      expect(handler.mapExceptionToFailure(bad).message, 'Phone already used');
    });
  });
}
