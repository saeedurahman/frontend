// Product edit > Set Price -> local data -> POS card and cart, on the real
// local database (in memory), sync feed and POS repository.
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/offline/repos/local_repositories.dart';
import 'package:frantend/core/offline/repos/offline_pos_repository.dart';
import 'package:frantend/core/services/image_upload_service.dart';
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
import 'package:frantend/features/products/data/datasources/products_local_datasource.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/repositories/products_repository_impl.dart';
import 'package:frantend/features/products/domain/usecases/add_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/add_variation_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/products/domain/usecases/product_pricing_usecases.dart'
    as pricing;
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';

import '../helpers/fake_http.dart';
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

class _GetCustomer extends Fake implements customers_uc.GetCustomerUseCase {}

class _GetBalance extends Fake
    implements customers_uc.GetCustomerBalanceUseCase {}

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

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _ProductsLocal extends Fake implements ProductsLocalDataSource {}

class _Probe extends Fake implements ConnectivityProbe {}

class _Images extends Fake implements ImageUploadService {}

class _GetById extends Fake implements GetProductByIdUseCase {}

class _Create extends Fake implements CreateProductUseCase {}

class _Update extends Fake implements UpdateProductUseCase {}

class _AddVar extends Fake implements AddVariationUseCase {}

class _AddBar extends Fake implements AddBarcodeUseCase {}

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

/// The product form's price section: the server answers [response] to
/// `POST /prices/lists/{id}/items`; a saved price goes into the local data.
ProductFormCubit _form(
  SyncRig rig, {
  required String productId,
  required String variationId,
  required Map<String, dynamic> Function(Map<String, dynamic> body) response,
  List<RequestOptions>? requests,
}) {
  final adapter = FakeAdapter((o) {
    requests?.add(o);
    return jsonResponse(
      response(Map<String, dynamic>.from(o.data as Map)),
      status: 201,
    );
  });
  final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
  final repo = ProductsRepositoryImpl(
    remoteDataSource: ProductsRemoteDataSourceImpl(_Dio(dio)),
    localDataSource: _ProductsLocal(),
    connectivityProbe: _Probe(),
    errorHandler: const ErrorHandler(),
  );
  final cubit = ProductFormCubit(
    getProductByIdUseCase: _GetById(),
    createProductUseCase: _Create(),
    updateProductUseCase: _Update(),
    addVariationUseCase: _AddVar(),
    addBarcodeUseCase: _AddBar(),
    getPriceListsUseCase: pricing.GetPriceListsUseCase(repo),
    getProductPriceUseCase: pricing.GetProductPriceUseCase(repo),
    setProductPriceUseCase: pricing.SetProductPriceUseCase(repo),
    imageUploadService: _Images(),
    authLocalDataSource: _Auth(),
    localDefaultPriceListId: rig.catalog.defaultPriceListId,
    onPriceSaved: rig.catalog.rememberPriceItem,
  );
  // ignore: invalid_use_of_visible_for_testing_member
  cubit.emit(ProductFormState(
    mode: 'edit',
    productId: productId,
    variations: [VariationFormItem(id: variationId, name: 'Default', isDefault: true)],
  ));
  return cubit;
}

/// A product as the backend creates it: one default variation, no price yet.
void _unpricedProduct(SyncRig rig, String id, String name) {
  rig.server.put('product', id, {
    'id': id,
    'name': name,
    'sku': id.toUpperCase(),
    'category_id': 'cat-1',
    'is_active': true,
    'is_sellable': true,
    'product_type': 'standard',
    'tracking_type': 'none',
  });
  rig.server.put('product_variation', 'v-$id', {
    'id': 'v-$id',
    'product_id': id,
    'name': 'Default',
    'is_default': true,
    'is_active': true,
  });
  rig.server.setStock(id, kBranch, 10);
}

/// A `price_list_items` row exactly as `sync_feed.py` sends it (raw table
/// row, numerics as strings).
Map<String, dynamic> _feedItem(
  String id,
  String productId,
  String price, {
  String? variationId,
  String minQty = '1.0000',
}) =>
    {
      'id': id,
      'price_list_id': 'pl-1',
      'product_id': productId,
      'variation_id': variationId,
      'unit_price': price,
      'min_qty': minQty,
      'created_at': '2026-10-29T08:00:00+00:00',
      'updated_at': '2026-10-29T08:00:00+00:00',
      'deleted_at': null,
    };

Future<void> _until(bool Function() done) async {
  for (var i = 0; i < 200 && !done(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
  expect(done(), isTrue, reason: 'timed out waiting for the POS to refresh');
}

ProductListItemModel _card(PosCubit pos, String id) =>
    pos.state.products.firstWhere((p) => p.id == id);

void main() {
  late SyncRig rig;
  late PosCubit pos;

  setUp(() async {
    rig = SyncRig();
    rig.seedServer();
    _unpricedProduct(rig, 'p2', 'Tea 250g');
    await rig.sync();
    pos = _pos(rig);
    await pos.init();
    await _until(() => pos.getDisplayPrice('p1') != null);
  });

  tearDown(() async {
    await pos.close();
    await rig.dispose();
  });

  test('a product with no price in the default list asks for a price', () async {
    expect(pos.getDisplayPrice('p2'), isNull, reason: 'card shows "Tap to set price"');

    final outcome = await pos.addToCart(_card(pos, 'p2'));

    expect(outcome.result, AddToCartResult.needsPrice);
    expect(outcome.pendingPrice?.variationId, 'v-p2');
    expect(pos.state.cartItems, isEmpty);
  });

  test('a priced product goes straight to the cart, no price popup', () async {
    final outcome = await pos.addToCart(_card(pos, 'p1'));

    expect(outcome.result, AddToCartResult.added);
    expect(pos.state.cartItems.single.unitPrice, Decimal.parse('100.00'));
    expect(pos.state.cartItems.single.priceManual, isFalse);
  });

  test('Set Price -> the open POS shows the price and adds to cart at once',
      () async {
    final requests = <RequestOptions>[];
    final form = _form(
      rig,
      productId: 'p2',
      variationId: 'v-p2',
      requests: requests,
      response: (body) => {
        'id': 'pli-new',
        'price_list_id': 'pl-1',
        'product_id': body['product_id'],
        'variation_id': body['variation_id'],
        'unit_price': '250.00',
        'min_qty': '1.0000',
      },
    );
    addTearDown(form.close);
    final pullsBefore = rig.server.pullCalls;

    expect(await form.saveProductPrice(unitPrice: '250'), isTrue);

    expect(requests.single.path, '/prices/lists/pl-1/items');
    expect(requests.single.data['variation_id'], 'v-p2',
        reason: 'the form prices the default variation');
    expect(rig.server.pullCalls, pullsBefore, reason: 'no pull was needed');

    // Local data: correct product, list and price.
    final stored = await rig.store.entity('price_list_item', 'pli-new');
    expect(stored, containsPair('product_id', 'p2'));
    expect(stored, containsPair('price_list_id', 'pl-1'));
    expect(stored, containsPair('unit_price', '250.00'));

    // The card (product-level lookup) shows it without reopening the POS.
    await _until(() => pos.getDisplayPrice('p2') != null);
    expect(pos.getDisplayPrice('p2'), Decimal.parse('250.00'));

    final outcome = await pos.addToCart(_card(pos, 'p2'));
    expect(outcome.result, AddToCartResult.added);
    expect(outcome.pendingPrice, isNull);
    final line = pos.state.cartItems.single;
    expect(line.unitPrice, Decimal.parse('250.00'));
    expect(line.variationId, 'v-p2');
    expect(line.priceManual, isFalse);
  });

  test('a POS opened after Set Price shows the price on the card', () async {
    final form = _form(
      rig,
      productId: 'p2',
      variationId: 'v-p2',
      response: (body) => {
        'id': 'pli-new',
        'price_list_id': 'pl-1',
        'product_id': 'p2',
        'variation_id': 'v-p2',
        'unit_price': '250.00',
        'min_qty': '1.0000',
      },
    );
    addTearDown(form.close);
    await form.saveProductPrice(unitPrice: '250');

    final fresh = _pos(rig);
    addTearDown(fresh.close);
    await fresh.init();
    await _until(() => fresh.getDisplayPrice('p2') != null);

    expect(fresh.getDisplayPrice('p2'), Decimal.parse('250.00'));
    expect((await fresh.addToCart(_card(fresh, 'p2'))).result, AddToCartResult.added);
  });

  test('a pulled price_list_item (backend feed shape) is used by the POS',
      () async {
    rig.server.put(
      'price_list_item',
      'pli-srv',
      _feedItem('pli-srv', 'p2', '180.0000', variationId: 'v-p2'),
    );
    await rig.sync();

    final stored = await rig.store.entity('price_list_item', 'pli-srv');
    expect(stored, containsPair('product_id', 'p2'));
    expect(stored, containsPair('unit_price', '180.0000'));

    await _until(() => pos.getDisplayPrice('p2') != null);
    expect(pos.getDisplayPrice('p2'), Decimal.parse('180'));
    final outcome = await pos.addToCart(_card(pos, 'p2'));
    expect(outcome.result, AddToCartResult.added);
    expect(pos.state.cartItems.single.unitPrice, Decimal.parse('180'));
  });

  test('a new price on an existing item replaces the old one (save, then pull)',
      () async {
    var price = '250.00';
    final form = _form(
      rig,
      productId: 'p2',
      variationId: 'v-p2',
      response: (body) => {
        'id': 'pli-new', // the backend upserts: same row id
        'price_list_id': 'pl-1',
        'product_id': 'p2',
        'variation_id': 'v-p2',
        'unit_price': price,
        'min_qty': '1.0000',
      },
    );
    addTearDown(form.close);

    await form.saveProductPrice(unitPrice: '250');
    await _until(() => pos.getDisplayPrice('p2') == Decimal.parse('250'));
    await pos.addToCart(_card(pos, 'p2'));

    price = '300.00';
    await form.saveProductPrice(unitPrice: '300');
    await _until(() => pos.getDisplayPrice('p2') == Decimal.parse('300'));
    expect(
      await rig.store.entities('price_list_item', where: 'parent_id = ?', args: ['p2']),
      hasLength(1),
      reason: 'replaced, not duplicated',
    );
    expect(await rig.catalog.price('p2', variationId: 'v-p2'), Decimal.parse('300'));

    // The server changes it again; the pull replaces the same row.
    rig.server.put(
      'price_list_item',
      'pli-new',
      _feedItem('pli-new', 'p2', '320.0000', variationId: 'v-p2'),
    );
    await rig.sync();
    await _until(() => pos.getDisplayPrice('p2') == Decimal.parse('320'));

    pos.clearCart();
    await pos.addToCart(_card(pos, 'p2'));
    expect(pos.state.cartItems.single.unitPrice, Decimal.parse('320'));
  });

  test('a price list that was never pulled is created locally with the price',
      () async {
    await rig.catalog.rememberPriceItem({
      'id': 'pli-x',
      'price_list_id': 'pl-new',
      'product_id': 'p2',
      'variation_id': null,
      'unit_price': '40.00',
      'min_qty': '1',
    });
    final list = await rig.store.entity('price_list', 'pl-new');
    expect(list, isNotNull);
    expect(list!['is_default'], isFalse,
        reason: 'the pulled default list stays the default');
    expect(await rig.catalog.defaultPriceListId(), 'pl-1');
  });

  group('lookup rules', () {
    test('variation prices and min_qty tiers; base price when no tier matches',
        () async {
      rig.server.put('product_variation', 'v-large', {
        'id': 'v-large',
        'product_id': 'p2',
        'name': 'Large',
        'is_default': false,
        'is_active': true,
      });
      rig.server.put('price_list_item', 'a',
          _feedItem('a', 'p2', '50.00', variationId: 'v-p2', minQty: '2.0000'));
      rig.server.put('price_list_item', 'b',
          _feedItem('b', 'p2', '45.00', variationId: 'v-p2', minQty: '10.0000'));
      rig.server.put('price_list_item', 'c',
          _feedItem('c', 'p2', '80.00', variationId: 'v-large'));
      await rig.sync();

      Future<Decimal?> price({String? v, int qty = 1}) =>
          rig.catalog.price('p2', variationId: v, qty: Decimal.fromInt(qty));

      // Lowest tier starts at 2: one unit still sells at the base price.
      expect(await price(v: 'v-p2'), Decimal.parse('50'));
      expect(await price(v: 'v-p2', qty: 5), Decimal.parse('50'));
      expect(await price(v: 'v-p2', qty: 12), Decimal.parse('45'));
      expect(await price(v: 'v-large'), Decimal.parse('80'));
      // The card asks without a variation: the default variation's price.
      expect(await price(), Decimal.parse('50'));
    });

    test('a product-level price serves every variation without its own price',
        () async {
      rig.server.put('price_list_item', 'd', _feedItem('d', 'p2', '70.00'));
      await rig.sync();
      expect(await rig.catalog.price('p2'), Decimal.parse('70'));
      expect(await rig.catalog.price('p2', variationId: 'v-p2'), Decimal.parse('70'));
    });

    test('items of another price list and deleted items are ignored', () async {
      rig.server.put('price_list', 'pl-2', {
        'id': 'pl-2', 'name': 'Wholesale', 'is_default': false, 'is_active': true,
      });
      rig.server.put('price_list_item', 'e', {
        ..._feedItem('e', 'p2', '10.00', variationId: 'v-p2'),
        'price_list_id': 'pl-2',
      });
      rig.server.put('price_list_item', 'f',
          _feedItem('f', 'p2', '60.00', variationId: 'v-p2'));
      await rig.sync();
      expect(await rig.catalog.price('p2'), Decimal.parse('60'));

      rig.server.remove('price_list_item', 'f');
      await rig.sync();
      expect(await rig.catalog.price('p2'), isNull);
    });
  });
}
