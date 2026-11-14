// Price Lists screen / sync pull -> local data -> POS card, grid and cart.
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/pos/presentation/widgets/product_grid_area.dart';
import 'package:frantend/shared/widgets/quantity/quantity_calculator_sheet.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/offline/repos/local_repositories.dart';
import 'package:frantend/core/offline/repos/offline_pos_repository.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/pos/data/models/discount_scheme_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/domain/repositories/barcode_cache_repository.dart';
import 'package:frantend/features/pos/domain/repositories/held_orders_repository.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/models/add_to_cart_result.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';

import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_store.dart' show PriceChange;
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/products/data/models/price_list_detail_models.dart';
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/products/presentation/cubit/price_lists_cubit.dart';

import '../sync/sync_rig.dart';

// ── fakes for what the price flow does not touch ───────────────────────────

class _NoRemote extends Fake implements PosRemoteDataSource {}

class _CreateSale extends Fake implements CreateSaleUseCase {}

class _MyShift extends Fake implements GetMyActiveShiftUseCase {
  @override
  Future<Either<Failure, RegisterShiftModel?>> call() async => const Right(null);
}

class _OpenShift extends Fake implements OpenShiftUseCase {}

class _Summary extends Fake implements GetShiftSummaryUseCase {}

class _Registers extends Fake implements GetRegistersUseCase {
  @override
  Future<Either<Failure, List<CashRegisterModel>>> call({
    String? branchId,
  }) async =>
      const Right([]);
}

class _CreateRegister extends Fake implements CreateRegisterUseCase {}

class _Tax extends Fake implements GetTaxRatesUseCase {
  @override
  Future<Either<Failure, List<TaxRateModel>>> call() async => const Right([]);
}

class _Settings extends Fake implements GetSettingsUseCase {
  @override
  Future<Either<Failure, List<AppSettingModel>>> call({
    String? branchId,
  }) async =>
      const Right([]);
}

class _Schemes extends Fake implements GetDiscountSchemesUseCase {
  @override
  Future<Either<Failure, List<DiscountSchemeModel>>> call() async =>
      const Right([]);
}

class _Preview extends Fake implements PreviewSalePriceUseCase {}

class _OpenTab extends Fake implements OpenTabUseCase {}

class _AddLines extends Fake implements AddTabLinesUseCase {}

class _Fire extends Fake implements FireTabUseCase {}

class _Bill extends Fake implements RequestTabBillUseCase {}

class _Complete extends Fake implements CompleteTabUseCase {}

class _GetTab extends Fake implements GetTabSaleUseCase {}

class _Kot extends Fake implements GetKotOrdersByTableUseCase {}

class _Barcode extends Fake implements LookupBarcodeUseCase {}

class _GetCustomer extends Fake implements customers_uc.GetCustomerUseCase {
  @override
  Future<Either<Failure, CustomerModel>> call(String id) async =>
      const Left(ServerFailure('local only'));
}

class _GetBalance extends Fake
    implements customers_uc.GetCustomerBalanceUseCase {
  @override
  Future<Either<Failure, CustomerBalanceModel>> call(String customerId) async =>
      const Left(ServerFailure('local only'));
}

class _Auth extends Fake implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async => const UserModel(
        id: kUser,
        name: 'Cashier',
        role: 'cashier',
        businessId: kBusiness,
        branchId: kBranch,
        permissionKeys: ['sales.create', 'shifts.open'],
      );
}

class _HeldRepo implements HeldOrdersRepository {
  @override
  Future<void> save(HeldOrderModel order, HeldOrderScope scope) async {}

  @override
  Future<List<HeldOrderModel>> list(HeldOrderScope scope) async => const [];

  @override
  Future<HeldOrderModel?> find(String id, HeldOrderScope scope) async => null;

  @override
  Future<void> delete(String id) async {}
}

class _BarcodeCache implements BarcodeCacheRepository {
  @override
  Future<ProductModel?> find(String tenantKey, String barcode) async => null;

  @override
  Future<void> remember(String t, String b, ProductModel p) async {}
}

// ── wiring (as in foundation_module.dart) ──────────────────────────────────

/// The POS cubit over the local database, wired like production.
PosCubit _pos(SyncRig rig) {
  final products = LocalProductsRepository(rig.catalog);
  final inventory = LocalInventoryRepository(rig.catalog);
  final price = GetProductPriceUseCase(OfflinePosRepository(
    catalog: rig.catalog,
    writer: rig.writer,
    store: rig.store,
    remote: _NoRemote(),
    errorHandler: const ErrorHandler(),
    userId: () async => kUser,
  ));
  final byId = GetProductByIdUseCase(products);
  return PosCubit(
    getProductsUseCase: GetProductsUseCase(products),
    getCategoriesUseCase: GetCategoriesUseCase(products),
    getProductByIdUseCase: byId,
    getProductPriceUseCase: price,
    createSaleUseCase: _CreateSale(),
    getMyActiveShiftUseCase: _MyShift(),
    openShiftUseCase: _OpenShift(),
    getShiftSummaryUseCase: _Summary(),
    getRegistersUseCase: _Registers(),
    createRegisterUseCase: _CreateRegister(),
    getStockBalanceUseCase: GetStockBalanceUseCase(inventory),
    getStockBalancesUseCase: GetStockBalancesUseCase(inventory),
    getTaxRatesUseCase: _Tax(),
    getSettingsUseCase: _Settings(),
    getDiscountSchemesUseCase: _Schemes(),
    previewSalePriceUseCase: _Preview(),
    openTabUseCase: _OpenTab(),
    addTabLinesUseCase: _AddLines(),
    fireTabUseCase: _Fire(),
    requestTabBillUseCase: _Bill(),
    completeTabUseCase: _Complete(),
    getTabSaleUseCase: _GetTab(),
    getKotOrdersByTableUseCase: _Kot(),
    resolvePosSession: ResolvePosSessionUseCase(_Auth(), FixedConnectivityProbe()),
    heldOrdersUseCases: HeldOrdersUseCases(_HeldRepo(), price, UuidIdGenerator()),
    resolveBarcodeUseCase: ResolveBarcodeUseCase(_BarcodeCache(), _Barcode(), byId),
    saleAttempts: SaleAttemptTracker(UuidIdGenerator()),
    getCustomerUseCase: _GetCustomer(),
    getCustomerBalanceUseCase: _GetBalance(),
    priceChanges: rig.catalog.priceChanges,
    resolvePriceList: (id) => rig.catalog.effectivePriceList(customerId: id),
  );
}


// ── PriceListsCubit over a fake server ─────────────────────────────────────

class _ListsRepo extends Fake implements ProductsRepository {
  final saved = <Map<String, dynamic>>[];
  final deleted = <String>[];

  @override
  Future<Either<Failure, BulkPriceResponseModel>> bulkUpsertPriceItems(
    String id,
    List<Map<String, dynamic>> items,
  ) async {
    saved.addAll(items);
    return const Right(
      BulkPriceResponseModel(created: 0, updated: 1, unchanged: 0, total: 1),
    );
  }

  @override
  Future<Either<Failure, void>> deletePriceItem(String id, String itemId) async {
    deleted.add(itemId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, PaginatedPriceListItemsModel>> getPriceListItems(
    String id, {
    String? search,
    int skip = 0,
    int limit = 50,
  }) async =>
      const Left(ServerFailure('not needed'));

  @override
  Future<Either<Failure, List<PriceListModel>>> getPriceLists() async =>
      const Left(ServerFailure('not needed'));
}

// ── data ───────────────────────────────────────────────────────────────────

const _ws = 'pl-ws';

CustomerModel _customer(String id, {String? listId}) => CustomerModel(
      id: id,
      businessId: kBusiness,
      name: id,
      priceListId: listId,
    );

void _list(SyncRig rig, String id, String name,
    {String? validTo, bool active = true}) {
  rig.server.put('price_list', id, {
    'id': id,
    'name': name,
    'is_default': false,
    'is_active': active,
    if (validTo != null) 'valid_to': validTo,
  });
}

void _item(SyncRig rig, String id, String listId, String productId, String price) {
  rig.server.put('price_list_item', id, {
    'id': id,
    'price_list_id': listId,
    'product_id': productId,
    'variation_id': null,
    'unit_price': price,
    'min_qty': '1',
  });
}

Future<void> _until(bool Function() done) async {
  for (var i = 0; i < 300 && !done(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  expect(done(), isTrue, reason: 'timed out waiting for the POS to refresh');
}

Decimal _d(String v) => Decimal.parse(v);

ProductListItemModel _card(PosCubit pos, String id) =>
    pos.state.products.firstWhere((p) => p.id == id);

void main() {
  late SyncRig rig;
  late PosCubit pos;
  late _ListsRepo repo;
  late PriceListsCubit lists;

  setUp(() async {
    rig = SyncRig();
    rig.seedServer(); // default list pl-1 "Retail", p1 = 100
    // p2 exists in the default list only (150).
    rig.product('p2', 'Tea 250g', 'T250', price: '150.00');
    _list(rig, _ws, 'Wholesale');
    _item(rig, 'pli-ws-p1', _ws, 'p1', '250.00');
    _list(rig, 'pl-old', 'Old deal', validTo: '2020-01-01');
    _item(rig, 'pli-old-p1', 'pl-old', 'p1', '70.00');
    for (final c in [
      ('c-ws', _ws),
      ('c-ws2', _ws),
      ('c-old', 'pl-old'),
      ('c-none', null),
      ('c-other', null),
    ]) {
      rig.server.put('customer', c.$1, {
        'id': c.$1,
        'name': c.$1,
        'is_active': true,
        'price_list_id': c.$2,
      });
    }
    await rig.sync();

    if (sl.isRegistered<LocalCatalog>()) sl.unregister<LocalCatalog>();
    sl.registerSingleton<LocalCatalog>(rig.catalog);
    if (sl.isRegistered<SyncEngine>()) sl.unregister<SyncEngine>();
    sl.registerSingleton<SyncEngine>(rig.engine);

    repo = _ListsRepo();
    lists = PriceListsCubit(productsRepository: repo);
    // ignore: invalid_use_of_visible_for_testing_member
    lists.emit(lists.state.copyWith(selectedListId: _ws));

    pos = _pos(rig);
    await pos.init();
    await _until(() => pos.getDisplayPrice('p1') != null);
  });

  tearDown(() async {
    await lists.close();
    await pos.close();
    await rig.dispose();
    if (sl.isRegistered<LocalCatalog>()) sl.unregister<LocalCatalog>();
    if (sl.isRegistered<SyncEngine>()) sl.unregister<SyncEngine>();
  });

  test('(b) walk-in and customers without a list see 100, never wholesale 250',
      () async {
    expect(pos.getDisplayPrice('p1'), _d('100'));
    await pos.selectCustomer(_customer('c-none'));
    expect(pos.getDisplayPrice('p1'), _d('100'));
    await pos.selectCustomer(_customer('c-other'));
    expect(pos.getDisplayPrice('p1'), _d('100'));
    expect(pos.specialPriceListName, isNull);
    expect((await pos.addToCart(_card(pos, 'p1'))).result, AddToCartResult.added);
    expect(pos.state.cartItems.single.unitPrice, _d('100'));
  });

  test('(a) wholesale 250 -> 200 in Price Lists shows in the open POS', () async {
    await pos.selectCustomer(_customer('c-ws', listId: _ws));
    expect(pos.getDisplayPrice('p1'), _d('250'));
    expect(pos.specialPriceListName, 'Wholesale');

    expect(await lists.savePriceItem(productId: 'p1', price: '200'), isTrue);
    await _until(() => pos.getDisplayPrice('p1') == _d('200'));

    // One row for the slot: the pulled row was updated, not duplicated.
    final rows = (await rig.store.entities('price_list_item'))
        .where((r) => r['price_list_id'] == _ws && r['product_id'] == 'p1');
    expect(rows.length, 1);
    // The default list is untouched.
    await pos.selectCustomer(null);
    expect(pos.getDisplayPrice('p1'), _d('100'));
  });

  test('(a) a POS opened after the change shows 200 for the wholesale customer',
      () async {
    await lists.savePriceItem(productId: 'p1', price: '200');
    final fresh = _pos(rig);
    addTearDown(fresh.close);
    await fresh.init();
    await _until(() => fresh.getDisplayPrice('p1') != null);
    expect(fresh.getDisplayPrice('p1'), _d('100'));
    await fresh.selectCustomer(_customer('c-ws', listId: _ws));
    expect(fresh.getDisplayPrice('p1'), _d('200'));
    // And after the next pull (the server holds 200 too).
    _item(rig, 'pli-ws-p1', _ws, 'p1', '200.00');
    await rig.sync();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(fresh.getDisplayPrice('p1'), _d('200'));
  });

  test('(c) switching customers re-prices the grid and the cart', () async {
    await pos.selectCustomer(_customer('c-ws', listId: _ws));
    await pos.addToCart(_card(pos, 'p1'));
    expect(pos.state.cartItems.single.unitPrice, _d('250'));

    await pos.selectCustomer(_customer('c-none'));
    expect(pos.getDisplayPrice('p1'), _d('100'));
    expect(pos.state.cartItems.single.unitPrice, _d('100'));

    await pos.selectCustomer(_customer('c-ws2', listId: _ws));
    expect(pos.getDisplayPrice('p1'), _d('250'));
    expect(pos.state.cartItems.single.unitPrice, _d('250'));

    await pos.selectCustomer(_customer('c-other'));
    expect(pos.getDisplayPrice('p1'), _d('100'));
    expect(pos.state.cartItems.single.unitPrice, _d('100'));
  });

  test('(d) a default-list price change updates the non-wholesale views',
      () async {
    await pos.selectCustomer(_customer('c-none'));
    expect(pos.getDisplayPrice('p2'), _d('150'));
    _item(rig, 'pli-p2', 'pl-1', 'p2', '175.00');
    await rig.sync();
    await _until(() => pos.getDisplayPrice('p2') == _d('175'));
    expect(pos.getDisplayPrice('p1'), _d('100'));
  });

  test('(e) a pulled change of a list nobody shows leaves the POS alone',
      () async {
    final before = pos.state.priceContext.version;
    _list(rig, 'pl-vip', 'VIP');
    _item(rig, 'pli-vip-p1', 'pl-vip', 'p1', '90.00');
    await rig.sync();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(pos.getDisplayPrice('p1'), _d('100'));
    expect(pos.state.priceContext.version, before,
        reason: 'no re-resolve for a list that is not in force');
  });

  test('(f) an assigned list without the item falls back to the default price',
      () async {
    await pos.selectCustomer(_customer('c-ws', listId: _ws));
    expect(pos.getDisplayPrice('p1'), _d('250'));
    expect(pos.getDisplayPrice('p2'), _d('150'),
        reason: 'wholesale has no p2: the default list price');
    expect((await pos.addToCart(_card(pos, 'p2'))).result, AddToCartResult.added);
    expect(pos.state.cartItems.single.unitPrice, _d('150'));
  });

  test('(g) an expired assigned list falls back to the default list', () async {
    await pos.selectCustomer(_customer('c-old', listId: 'pl-old'));
    expect(pos.getDisplayPrice('p1'), _d('100'));
    expect(pos.specialPriceListName, isNull);
  });

  test('a price removed on the server disappears from the wholesale view',
      () async {
    await pos.selectCustomer(_customer('c-ws', listId: _ws));
    expect(pos.getDisplayPrice('p1'), _d('250'));
    rig.server.remove('price_list_item', 'pli-ws-p1');
    await rig.sync();
    await _until(() => pos.getDisplayPrice('p1') == _d('100'));
  });

  test('removing a price in Price Lists falls back to the default price',
      () async {
    await pos.selectCustomer(_customer('c-ws', listId: _ws));
    expect(await lists.deletePriceItem('pli-ws-p1'), isTrue);
    await _until(() => pos.getDisplayPrice('p1') == _d('100'));
    expect(repo.deleted, ['pli-ws-p1']);
  });

  test('saving a non-default list price never writes into the default slot',
      () async {
    await lists.savePriceItem(productId: 'p2', price: '99');
    final rows = (await rig.store.entities('price_list_item'))
        .where((r) => r['product_id'] == 'p2')
        .toList();
    expect(rows.where((r) => r['price_list_id'] == 'pl-1').single['unit_price'],
        '150.00');
    expect(rows.where((r) => r['price_list_id'] == _ws).single['unit_price'],
        '99');
    expect(pos.getDisplayPrice('p2'), _d('150'));
  });

  test('a price list saved before it was pulled never becomes the default',
      () async {
    await rig.catalog.rememberPrice(
      listId: 'pl-new',
      productId: 'p1',
      price: '55',
    );
    expect(await rig.catalog.defaultPriceListId(), 'pl-1');
    await pos.refreshPrices();
    expect(pos.getDisplayPrice('p1'), _d('100'));
  });

  test('SyncStore announces price changes with the list and product', () async {
    final events = <PriceChange>[];
    final sub = rig.catalog.priceChanges.listen(events.add);
    addTearDown(sub.cancel);
    _item(rig, 'pli-ws-p1', _ws, 'p1', '240.00');
    await rig.sync();
    await Future<void>.delayed(Duration.zero);
    expect(
      events.any((e) => e.priceListId == _ws && e.productId == 'p1'),
      isTrue,
    );
  });

  testWidgets('(h) the card shows the new price without leaving the screen',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final prev = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.exceptionAsString().contains('overflowed')) return;
      prev?.call(d);
    };
    addTearDown(() => FlutterError.onError = prev);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BlocProvider<PosCubit>.value(
          value: pos,
          child: const ProductGridArea(),
        ),
      ),
    ));
    await tester.pump();

    Future<void> settle(bool Function() done) => tester.runAsync(() async {
          await _until(done);
        });

    // Walk-in: the default price.
    expect(find.text(formatPKR(100)), findsWidgets);

    // The wholesale customer: 250, labelled "Wholesale".
    await tester.runAsync(
      () => pos.selectCustomer(_customer('c-ws', listId: _ws)),
    );
    await tester.pump();
    expect(find.text(formatPKR(250)), findsWidgets);
    expect(find.text('Wholesale'), findsWidgets);
    expect(find.text(formatPKR(100)), findsNothing);

    // Price Lists saves 200: the same card text changes in place.
    await tester.runAsync(
      () => lists.savePriceItem(productId: 'p1', price: '200'),
    );
    await settle(() => pos.getDisplayPrice('p1') == _d('200'));
    await tester.pump();
    expect(find.text(formatPKR(200)), findsWidgets);
    expect(find.text(formatPKR(250)), findsNothing);

    // Back to a customer without a list: default price, no label.
    await tester.runAsync(() => pos.selectCustomer(_customer('c-none')));
    await tester.pump();
    expect(find.text(formatPKR(100)), findsWidgets);
    expect(find.text('Wholesale'), findsNothing);
  });

  testWidgets('an open quantity popup re-reads the price when it changes',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final prev = FlutterError.onError;
    FlutterError.onError = (d) {
      if (d.exceptionAsString().contains('overflowed')) return;
      prev?.call(d);
    };
    addTearDown(() => FlutterError.onError = prev);

    final updates = StreamController<Decimal?>.broadcast();
    addTearDown(updates.close);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: QuantityCalculatorSheet(
          config: QuantityCalculatorConfig(
            title: 'Rice',
            unitPrice: _d('250'),
            priceUpdates: updates.stream,
          ),
        ),
      ),
    ));
    expect(find.textContaining(formatPKR(250)), findsWidgets);

    updates.add(_d('200'));
    await tester.pump();
    expect(find.textContaining(formatPKR(200)), findsWidgets);
    expect(find.textContaining(formatPKR(250)), findsNothing);
  });
}
