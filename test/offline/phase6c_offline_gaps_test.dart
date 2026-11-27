import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/local_history.dart';
import 'package:frantend/core/offline/repos/local_sale_mapper.dart';
import 'package:frantend/core/offline/sale_line_modifiers.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/restaurant/presentation/cubit/tables_floor_cubit.dart';
import 'package:frantend/features/restaurant/presentation/cubit/tables_floor_state.dart';
import 'package:frantend/features/restaurant/presentation/pages/tables_floor_page.dart';
import 'package:frantend/features/restaurant/presentation/utils/table_service_errors.dart';
import 'package:frantend/features/sales/presentation/utils/sale_line_display.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';
import 'package:go_router/go_router.dart';

import '../helpers/offline_world.dart';
import '../sync/sync_rig.dart';

class _FakeBranchCubit extends Cubit<BranchSelectorState> implements BranchSelectorCubit {
  _FakeBranchCubit() : super(const BranchSelectorState());

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeTablesCubit extends Cubit<TablesFloorState> implements TablesFloorCubit {
  _FakeTablesCubit() : super(const TablesFloorState());
  int inits = 0;

  @override
  Future<void> init() async => inits++;

  @override
  Future<void> onBranchChanged(String? branchId) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

final _wide = (from: DateTime(2000), to: DateTime(2100));

void main() {
  late OfflineWorld world;

  setUp(() async {
    world = OfflineWorld();
    await world.seed();
    SaleSyncBadges.clear();
  });

  tearDown(() => world.dispose());

  void seedModifiers() {
    final s = world.rig.server;
    s.put('modifier_group', 'g1', {
      'id': 'g1',
      'name': 'Extras',
      'selection_type': 'multiple',
      'is_active': true,
      'sort_order': 0,
    });
    s.put('modifier', 'm1', {
      'id': 'm1',
      'modifier_group_id': 'g1',
      'name': 'Extra cheese',
      'price_delta': '50.00',
      'is_active': true,
      'sort_order': 0,
    });
    s.put('product_modifier_group', 'pmg1', {
      'id': 'pmg1',
      'product_id': 'p1',
      'modifier_group_id': 'g1',
      'sort_order': 0,
    });
  }

  group('1. modifiers offline', () {
    test('groups come from the pulled data; the network is never asked', () async {
      seedModifiers();
      await world.rig.sync();
      world.goOffline();
      final before = world.adapter.requests.length;

      final groups = await world.modifiers.groupsFor('p1');
      expect(groups.single.name, 'Extras');
      expect(groups.single.modifiers.single.name, 'Extra cheese');
      expect(groups.single.modifiers.single.priceDelta, '50.00');
      expect(await world.modifiers.groupsFor('p-without'), isEmpty);
      expect(world.adapter.requests.length, before);
    });

    test('a sale with modifiers: local line, totals, receipt, and sale.create',
        () async {
      seedModifiers();
      await world.rig.sync();
      world.goOffline();

      // The cart sends the final per-unit price (100 + 50) and the list.
      final body = world.rig.cartBody(
        price: '150.00',
        payments: [
          {'payment_method': 'cash', 'amount': '315.00', 'tendered_amount': '315.00', 'change_given': '0.00'},
        ],
      );
      body['lines'] = [
        {
          ...(body['lines'] as List).first as Map<String, dynamic>,
          'modifiers': [
            {'modifier_id': 'm1', 'name': 'Extra cheese', 'price': '50.00', 'qty': '1'},
          ],
        },
      ];
      final row = await world.rig.writer.saveSale(body);

      // Totals include the modifier: 2 x 150 = 300, +5% tax = 315.
      expect(row['total_amount'], '315.00');

      // The receipt (from the local record) lists the modifier.
      final sale = LocalSaleMapper.toResponse(row);
      final line = sale.lines.single;
      expect(SaleLineDisplay.modifiers(line).single.name, 'Extra cheese');
      expect(SaleLineDisplay.modifierLabels(line).single, contains('Extra cheese'));
      expect(line.notes, startsWith(SaleLineModifier.notesPrefix));

      // Sent to the server in the contract shape.
      world.goOnline();
      await world.rig.sync();
      final op = world.rig.server.receivedOps.firstWhere((o) => o['type'] == 'sale.create');
      final sent = ((op['payload'] as Map)['lines'] as List).single as Map;
      expect(sent['unit_price'], '150.00');
      final mod = (sent['modifiers'] as List).single as Map;
      expect(mod['modifier_id'], 'm1');
      expect(mod['price'], '50.00');
      expect(mod['qty'], '1');
    });

    test('notes encoding round-trips like the server', () {
      final mods = [
        SaleLineModifier(modifierId: 'm1', name: 'Cheese', price: Decimal.zero),
      ];
      final encoded = SaleLineModifier.encodeNotes('no onion', mods)!;
      final decoded = SaleLineModifier.decodeNotes(encoded);
      expect(decoded.note, 'no onion');
      expect(decoded.modifiers.single.name, 'Cheese');
      expect(SaleLineModifier.decodeNotes('plain').note, 'plain');
    });
  });

  group('2. table service offline', () {
    setUp(() {
      if (sl.isRegistered<TablesFloorCubit>()) sl.unregister<TablesFloorCubit>();
      sl.registerFactory<TablesFloorCubit>(_FakeTablesCubit.new);
      if (sl.isRegistered<BranchSelectorCubit>()) sl.unregister<BranchSelectorCubit>();
      sl.registerSingleton<BranchSelectorCubit>(_FakeBranchCubit());
    });
    tearDown(() {
      if (sl.isRegistered<TablesFloorCubit>()) sl.unregister<TablesFloorCubit>();
      if (sl.isRegistered<BranchSelectorCubit>()) sl.unregister<BranchSelectorCubit>();
    });

    Widget host(ConnectivityProbe probe) => MaterialApp.router(
          routerConfig: GoRouter(routes: [
            GoRoute(path: '/', builder: (_, __) => Scaffold(body: TablesFloorPage(probe: probe))),
            GoRoute(path: RouteNames.pos, builder: (_, __) => const Scaffold(body: Text('POS SCREEN'))),
          ]),
        );

    testWidgets('offline: the plain banner and a way to Counter sale', (tester) async {
      await tester.pumpWidget(host(FixedConnectivityProbe(ReachabilityStatus.offline)));
      await tester.pump();

      expect(find.text(OfflineMessages.tableService), findsOneWidget);
      expect(OfflineMessages.tableService,
          'Table service needs internet. You can still make a Counter sale.');
      expectPlainLanguage(OfflineMessages.tableService);

      await tester.tap(find.byKey(const Key('online-only-action')));
      await tester.pumpAndSettle();
      expect(find.text('POS SCREEN'), findsOneWidget);
    });

    testWidgets('online: no banner', (tester) async {
      await tester.pumpWidget(host(FixedConnectivityProbe()));
      await tester.pump();
      expect(find.byKey(const Key('online-only-banner')), findsNothing);
    });

    test('table errors never carry transport text', () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:9'))
        ..httpClientAdapter = UnreachableAdapter();
      Object? thrown;
      try {
        await dio.get('/restaurant/tables');
      } catch (e) {
        thrown = e;
      }
      expect(thrown, isNotNull);
      expect(TableServiceErrors.from(thrown!), OfflineMessages.tableService);
      expect(
        TableServiceErrors.message(const NetworkFailure('SocketException: connection errored')),
        OfflineMessages.tableService,
      );
      expect(
        TableServiceErrors.message(const ValidationFailure('Table is occupied')),
        'Table is occupied',
      );
    });
  });

  group('3. local history', () {
    void seedSummary() {
      world.rig.server.put('sale_summary', 'srv-1', {
        'id': 'srv-1',
        'sale_number': 'INV-20261110-0007',
        'branch_id': kBranch,
        'customer_id': 'c1',
        'customer_name': 'Ali Traders',
        'status': 'completed',
        'sold_at': '2026-11-10T10:00:00+00:00',
        'total_amount': '500.00',
        'payments': [
          {'payment_method': 'cash', 'amount': '500.00'},
        ],
      });
    }

    Future<List<String>> numbers({String? search}) async {
      final page = (await world.sales.getSales(
        branchId: kBranch,
        dateFrom: _wide.from,
        dateTo: _wide.to,
        search: search,
      ))
          .getOrElse(() => throw 'list failed');
      return [for (final i in page.items) i.saleNumber];
    }

    test('pulled recent sales and this device\'s pending sales, merged', () async {
      seedSummary();
      await world.rig.sync();
      final pending = await world.rig.sell(customerId: 'c1');
      world.goOffline();

      final page = (await world.sales.getSales(
        branchId: kBranch,
        dateFrom: _wide.from,
        dateTo: _wide.to,
      ))
          .getOrElse(() => throw 'list failed');
      expect(page.total, 2);
      expect(page.items.map((i) => i.id), containsAll(['srv-1', pending['id']]));

      expect(SaleSyncBadges.of('srv-1'), SaleSyncBadge.none);
      expect(SaleSyncBadges.of(pending['id']! as String), SaleSyncBadge.notSynced);
      expect(SaleSyncBadge.notSynced.label, 'Not synced yet');
      expect(SaleSyncBadge.needsAttention.label, 'Needs attention');

      // A sale the server refused needs attention.
      await world.rig.store.setSaleState(pending['id']! as String, 'failed');
      await numbers();
      expect(SaleSyncBadges.of(pending['id']! as String), SaleSyncBadge.needsAttention);
    });

    test('searchable by number, customer and date', () async {
      seedSummary();
      await world.rig.sync();
      final pending = await world.rig.sell();
      world.goOffline();

      expect(await numbers(search: '0007'), ['INV-20261110-0007']);
      expect(await numbers(search: 'ali traders'), ['INV-20261110-0007']);
      expect(await numbers(search: '2026-11-10'), ['INV-20261110-0007']);
      expect(await numbers(search: '${pending['receipt_no']}'), ['${pending['receipt_no']}']);
      expect(await numbers(search: 'nothing-like-this'), isEmpty);
    });

    test('a connection that is refused falls back to local, plainly', () async {
      seedSummary();
      await world.rig.sync();
      // Probe still says online; the HTTP call is refused.
      final result = await world.sales.getSales(
        branchId: kBranch,
        dateFrom: _wide.from,
        dateTo: _wide.to,
      );
      expect(result.isRight(), isTrue);
    });

    test('pending sale opens locally with its receipt; synced shows summary only',
        () async {
      seedSummary();
      await world.rig.sync();
      final pending = await world.rig.sell();
      world.goOffline();

      final local = (await world.sales.getSaleById(pending['id']! as String))
          .getOrElse(() => throw 'no detail');
      expect(local.lines, isNotEmpty);
      expect(SaleLineDisplay.isSummaryOnly(local), isFalse);
      expect(local.offline, isTrue);

      final summary = (await world.sales.getSaleById('srv-1')).getOrElse(() => throw 'no summary');
      expect(summary.lines, isEmpty);
      expect(summary.totalAmount, '500.00');
      expect(SaleLineDisplay.isSummaryOnly(summary), isTrue);
      expect(OfflineMessages.fullDetailsNeedInternet, 'Full details need internet');

      final unknown = await world.sales.getSaleById('never-seen');
      expect(unknown.isLeft(), isTrue);
      unknown.fold((f) => expectPlainLanguage(f.message), (_) {});
    });
  });

  group('3b. shift history local', () {
    test('pulled and local shifts with totals and difference', () async {
      world.rig.server.put('register_shift', 'sh-old', {
        'id': 'sh-old',
        'cash_register_id': 'reg-1',
        'branch_id': kBranch,
        'status': 'closed',
        'opening_float': '500.00',
        'expected_cash': '1500.00',
        'actual_cash': '1450.00',
        'cash_difference': '-50.00',
        'opened_at': '2026-11-01T08:00:00+00:00',
        'closed_at': '2026-11-01T20:00:00+00:00',
      });
      await world.rig.sync();
      world.goOffline();

      final shift = await world.rig.writer.openShift(
        registerId: 'reg-1',
        registerName: 'Front',
        branchId: kBranch,
        openingFloat: Decimal.parse('200'),
      );
      final shiftId = shift['id']! as String;
      await world.rig.sell(shiftId: shiftId);
      await world.rig.writer.closeShift(shiftId: shiftId, actualCash: Decimal.parse('400'));

      final list = (await world.cashRegister.getShifts()).getOrElse(() => throw 'no shifts');
      expect(list.map((s) => s.id), containsAll(['sh-old', shiftId]));

      final pulled = list.firstWhere((s) => s.id == 'sh-old');
      expect(pulled.cashDifference, '-50.00');
      expect(pulled.expectedCash, '1500.00');

      // Local: opening 200 + 210 cash taken = 410 expected; 400 counted.
      final mine = list.firstWhere((s) => s.id == shiftId);
      expect(mine.expectedCash, '410.00');
      expect(mine.cashDifference, '-10.00');

      final detail = (await world.cashRegister.getShiftById('sh-old')).getOrElse(() => throw 'x');
      expect(detail.status, 'closed');
      final summary = (await world.cashRegister.getShiftSummary('sh-old')).getOrElse(() => throw 'x');
      expect(summary.cashDifference, '-50.00');
      expect(summary.expectedCash, '1500.00');

      final unknown = await world.cashRegister.getShiftById('not-here');
      unknown.fold((f) => expectPlainLanguage(f.message), (_) => fail('expected a failure'));
    });
  });

  group('4. customers', () {
    test('balance sign: negative = owes, matching balance_owed', () async {
      final catalog = world.rig.catalog;
      expect(await catalog.customerBalance('c1'), Decimal.parse('-1000'));
      expect(await catalog.balanceOwed('c1'), Decimal.parse('1000'));
      // balance_owed alone is enough, and means "owes".
      expect(LocalCatalog.balanceOf({'balance_owed': '300.00'}), Decimal.parse('-300'));
      expect(LocalCatalog.balanceOf({'balance': '-300.00'}), Decimal.parse('-300'));
      expect(LocalCatalog.balanceOf({'balance': '125.00'}), Decimal.parse('125'));

      // Credit sold offline: they owe more.
      await world.rig.sell(customerId: 'c1', payments: [
        {'payment_method': 'credit', 'amount': '210.00'},
      ]);
      expect(await catalog.balanceOwed('c1'), Decimal.parse('1210'));
    });

    test('offline payment updates the balance at once, reconciles after sync',
        () async {
      world.goOffline();
      final paid = await world.customers.recordPayment(
        'c1',
        amount: Decimal.parse('400'),
        paymentSource: 'cash',
      );
      expect(paid.isRight(), isTrue);

      final shown = (await world.customers.getCustomerBalance('c1')).getOrElse(() => throw 'x');
      expect(shown.balance, '-600.00');
      expect((await world.customers.getCustomer('c1')).getOrElse(() => throw 'x').balance, '-600.00');

      world.goOnline();
      await world.rig.sync();
      // The server applied it: the pulled balance includes the 400, and the
      // pending adjustment is gone (no double count).
      expect(await world.rig.catalog.customerBalance('c1'), Decimal.parse('-600'));
      expect(await world.rig.catalog.balanceOwed('c1'), Decimal.parse('600'));
    });

    test('list, search, detail come from the device offline', () async {
      world.goOffline();
      final before = world.adapter.requests.length;
      final list = (await world.customers.getCustomers(search: 'ali')).getOrElse(() => throw 'x');
      expect(list.single.name, 'Ali Traders');
      expect(world.adapter.requests.length, before);
    });
  });

  group('5. receipt branding', () {
    test('from pulled settings, and old sales reprint offline', () async {
      world.rig.server.put('settings', 'biz', {
        'business_name': 'Demo Mart',
        'address_line1': '12 Mall Road',
        'phone': '0300',
        'ntn': '1234567-8',
        'receipt_footer': 'Thanks!',
      });
      await world.rig.sync();
      final sale = await world.rig.sell();
      await world.rig.sync();
      world.goOffline();
      final before = world.adapter.requests.length;

      final profile = await world.branding.businessProfile();
      expect(profile?.name, 'Demo Mart');
      expect(profile?.taxId, '1234567-8');
      expect((await world.branding.displaySettings()).footerText, 'Thanks!');

      final reprint = await world.sales.getSaleById(sale['id']! as String);
      expect(reprint.isRight(), isTrue);
      expect(world.adapter.requests.length, before);
    });
  });

  group('6. products and inventory read offline', () {
    test('list, detail, categories and stock from the pulled copy', () async {
      world.goOffline();
      final before = world.adapter.requests.length;

      final list = (await world.productsRepo.getProducts()).getOrElse(() => throw 'x');
      expect(list.items.map((p) => p.name), contains('Rice 5kg'));
      final one = (await world.productsRepo.getProductById('p1')).getOrElse(() => throw 'x');
      expect(one.name, 'Rice 5kg');
      final cats = (await world.productsRepo.getCategories()).getOrElse(() => throw 'x');
      expect(cats.map((c) => c.name), contains('Grocery'));
      final stock = (await world.inventoryRepo.getStockBalance(branchId: kBranch, productId: 'p1'))
          .getOrElse(() => throw 'x');
      expect(Decimal.parse(stock.currentQty), Decimal.parse('10'));
      expect(world.adapter.requests.length, before);
    });

    test('editing says it needs internet; nothing is queued', () async {
      world.goOffline();
      final result = await world.productsRepo.createProduct({'name': 'New'});
      result.fold(
        (f) {
          expect(f.message, OfflineMessages.editingNeedsInternet);
          expectPlainLanguage(f.message);
        },
        (_) => fail('must not succeed offline'),
      );
      expect(await world.rig.store.ops(), isEmpty);
    });

    test('a refused connection while the probe says online still reads locally',
        () async {
      final list = await world.productsRepo.getProducts();
      expect(list.isRight(), isTrue);
    });
  });

  group('7. no raw error text on offline paths', () {
    test('every failure produced offline is plain language', () async {
      world.goOffline();
      final failures = <Failure>[];
      void add<T>(dynamic either) =>
          (either as dynamic).fold((Failure f) => failures.add(f), (_) {});

      add(await world.sales.getSaleById('x'));
      add(await world.cashRegister.getShiftById('x'));
      add(await world.cashRegister.getShiftSummary('x'));
      add(await world.customers.getCustomer('nobody'));
      add(await world.productsRepo.getProductById('nobody'));
      add(await world.productsRepo.createProduct({}));
      add(await world.inventoryRepo.getStockBalance(branchId: kBranch, productId: 'nobody'));

      expect(failures, isNotEmpty);
      for (final f in failures) {
        expectPlainLanguage(f.message);
        expect(UserErrorMessage.looksRaw(f.message), isFalse, reason: f.message);
      }
    });
  });
}
