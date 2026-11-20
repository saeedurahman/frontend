// POS + pharmacy batches: the real PosCubit with a real BatchStockSource.

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/offline/product_modifier_cache.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
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
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/inventory/data/batch_stock_source.dart';
import 'package:frantend/features/pos/domain/utils/pos_calculations.dart';
import 'package:frantend/features/pos/presentation/models/add_to_cart_outcome.dart';
import '../sync/sync_rig.dart';


Decimal d(String v) => Decimal.parse(v);

// ── catalog used by the tests ──────────────────────────────────────────────

const _pcs = UnitModel(id: 'u-pcs', businessId: 't1', name: 'Piece', symbol: 'pcs');
const _kg = UnitModel(id: 'u-kg', businessId: 't1', name: 'Kilogram', symbol: 'kg');

ProductModel _product(
  String id,
  String name, {
  UnitModel unit = _pcs,
  String? barcode,
}) =>
    ProductModel(
      id: id,
      businessId: 't1',
      name: name,
      productType: 'standard',
      trackingType: 'none',
      baseUnit: unit,
      variations: [
        VariationModel(
          id: 'v-$id',
          businessId: 't1',
          productId: id,
          name: 'Default',
          isDefault: true,
        ),
      ],
      barcodes: [
        if (barcode != null)
          BarcodeModel(
            id: 'bc-$id',
            productId: id,
            barcode: barcode,
            barcodeType: 'EAN13',
          ),
      ],
    );

final _catalog = <String, ProductModel>{
  'p1': _product('p1', 'Rice 5kg', barcode: '8964000111111'),
  'p2': _product('p2', 'Sugar loose', unit: _kg),
  'p3': _product('p3', 'Unpriced tea'),
  'p4': _product('p4', 'Burger'),
};

const _prices = {'p1': '100', 'p2': '150', 'p4': '500'};

ProductListItemModel _listItem(String id) => ProductListItemModel(
      id: id,
      businessId: 't1',
      name: _catalog[id]!.name,
      productType: 'standard',
      trackingType: 'none',
    );

// ── fakes ──────────────────────────────────────────────────────────────────

class _Products extends Fake implements GetProductsUseCase {
  @override
  Future<Either<Failure, PaginatedProductsModel>> call({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    bool? needsAttention,
    int skip = 0,
    int limit = 50,
  }) async =>
      Right(PaginatedProductsModel(
        total: _catalog.length,
        skip: 0,
        limit: 60,
        items: [for (final id in _catalog.keys) _listItem(id)],
      ));
}

class _Categories extends Fake implements GetCategoriesUseCase {
  @override
  Future<Either<Failure, List<CategoryModel>>> call({String? parentId}) async =>
      const Right([]);
}

class _ProductById extends Fake implements GetProductByIdUseCase {
  @override
  Future<Either<Failure, ProductModel>> call(String id) async {
    final p = _catalog[id];
    return p == null ? const Left(NotFoundFailure('x')) : Right(p);
  }
}

class _Barcode extends Fake implements LookupBarcodeUseCase {
  @override
  Future<Either<Failure, ProductModel>> call(String barcode) async {
    for (final p in _catalog.values) {
      if (p.barcodes.any((b) => b.barcode == barcode)) return Right(p);
    }
    return const Left(NotFoundFailure('Barcode not found'));
  }
}

class _Price extends Fake implements GetProductPriceUseCase {
  @override
  Future<Either<Failure, Decimal?>> call(
    String p,
    String? v, {
    Decimal? qty,
    String? priceListId,
    String? customerId,
  }) async =>
      Right(_prices[p] == null ? null : Decimal.parse(_prices[p]!));
}

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

class _Stock extends Fake implements GetStockBalanceUseCase {
  @override
  Future<Either<Failure, StockBalanceModel>> call({
    required String branchId,
    required String productId,
    String? variationId,
  }) async =>
      Right(StockBalanceModel(
        productId: productId,
        branchId: branchId,
        currentQty: '20',
      ));
}

class _Stocks extends Fake implements GetStockBalancesUseCase {
  @override
  Future<Either<Failure, List<StockBalanceModel>>> call({
    required String branchId,
    List<String>? productIds,
  }) async =>
      Right([
        for (final id in _catalog.keys)
          StockBalanceModel(productId: id, branchId: branchId, currentQty: '20'),
      ]);
}

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

class _GetCustomer extends Fake implements customers_uc.GetCustomerUseCase {}

class _GetBalance extends Fake
    implements customers_uc.GetCustomerBalanceUseCase {}

class _Auth extends Fake implements AuthLocalDataSource {
  _Auth(this.permissions);
  final List<String> permissions;

  @override
  Future<UserModel?> getCachedUser() async => UserModel(
        id: 'u1',
        name: 'Cashier',
        role: 'cashier',
        businessId: 't1',
        branchId: 'b1',
        permissionKeys: permissions,
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

class _Rig {
  _Rig({required this.batchStock}) {
    final price = _Price();
    final byId = _ProductById();
    cubit = PosCubit(
      getProductsUseCase: _Products(),
      getCategoriesUseCase: _Categories(),
      getProductByIdUseCase: byId,
      getProductPriceUseCase: price,
      createSaleUseCase: _CreateSale(),
      getMyActiveShiftUseCase: _MyShift(),
      openShiftUseCase: _OpenShift(),
      getShiftSummaryUseCase: _Summary(),
      getRegistersUseCase: _Registers(),
      createRegisterUseCase: _CreateRegister(),
      getStockBalanceUseCase: _Stock(),
      getStockBalancesUseCase: _Stocks(),
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
      resolvePosSession:
          ResolvePosSessionUseCase(
          _Auth(const ['sales.create', 'shifts.open']), FixedConnectivityProbe()),
      heldOrdersUseCases: HeldOrdersUseCases(_HeldRepo(), price, UuidIdGenerator()),
      resolveBarcodeUseCase: ResolveBarcodeUseCase(_BarcodeCache(), _Barcode(), byId),
      saleAttempts: SaleAttemptTracker(UuidIdGenerator()),
      getCustomerUseCase: _GetCustomer(),
      getCustomerBalanceUseCase: _GetBalance(),
      askQuantityOnTap: () => false,
      batchStock: batchStock,
    );
  }

  final BatchStockSource batchStock;
  final List<String> permissions = const ['sales.create', 'shifts.open'];
  late final PosCubit cubit;
}

void main() {
  late SyncRig sync;

  setUp(() {
    sync = SyncRig();
    final stored = <String, String>{};
    sl.registerSingleton<ProductModifierCache>(ProductModifierCache(
      read: (key) async => stored[key],
      write: (key, value) async => stored[key] = value,
      fetch: (_) async => const Right([]),
    ));
  });

  tearDown(() async {
    await sl.reset();
    await sync.dispose();
  });

  Future<void> putBatch(String id, String no, String? expiry, String qty, String received) =>
      sync.store.putEntity('stock_batch', id, {
        'id': id,
        'product_id': 'p1',
        'branch_id': 'b1',
        'batch_no': no,
        'expiry_date': expiry,
        'qty_remaining': qty,
        'received_at': received,
      });

  Future<void> policy({String pick = 'fifo', String expired = 'warn'}) =>
      sync.store.putEntity('settings', 'biz', {
        'app_settings': {
          'inventory.pick_policy': pick,
          'inventory.expired_sale': expired,
        },
      });

  Future<PosCubit> open() async {
    final rig = _Rig(
      batchStock: BatchStockSource(sync.store, clock: () => DateTime(2026, 11, 17)),
    );
    addTearDown(rig.cubit.close);
    await rig.cubit.init();
    return rig.cubit;
  }

  Future<AddToCartOutcome> add(PosCubit c, String qty, {bool confirm = false}) =>
      c.addToCart(_listItem('p1'), qty: d(qty), confirmExpired: confirm);

  // Received order: OLD (expired, arrived first) -> A -> B.
  // Expiry order: OLD (expired) -> B -> A.
  Future<void> stockWithExpired() async {
    await putBatch('b-old', 'OLD', '2026-10-01', '4', '2026-01-01T00:00:00Z');
    await putBatch('b-a', 'A', '2027-12-31', '6', '2026-02-01T00:00:00Z');
    await putBatch('b-b', 'B', '2027-03-31', '6', '2026-03-01T00:00:00Z');
  }

  List<String> slices(PosCubit c) =>
      [for (final s in c.state.cartItems.single.batches) '${s.batchNo}:${s.qty}'];

  group('which batch the till picks', () {
    test('FIFO takes the oldest arrival', () async {
      await policy(pick: 'fifo', expired: 'allow');
      await stockWithExpired();
      final c = await open();
      expect((await add(c, '3')).result, AddToCartResult.added);
      expect(slices(c), ['OLD:3']);
    });

    test('FEFO takes the soonest expiry that is not expired', () async {
      await policy(pick: 'fefo', expired: 'block');
      await stockWithExpired();
      final c = await open();
      expect((await add(c, '3')).result, AddToCartResult.added);
      expect(slices(c), ['B:3']);
    });

    test('a bigger quantity splits across batches on one line', () async {
      await policy(pick: 'fefo', expired: 'block');
      await stockWithExpired();
      final c = await open();
      await add(c, '8');
      expect(c.state.cartItems, hasLength(1));
      expect(slices(c), ['B:6', 'A:2']);
    });

    test('changing the quantity re-picks the batches', () async {
      await policy(pick: 'fefo', expired: 'block');
      await stockWithExpired();
      final c = await open();
      await add(c, '3');
      c.updateCartItemQty(0, d('8'));
      await pumpEventQueue();
      expect(slices(c), ['B:6', 'A:2']);
    });

    test('a product with no batch rows gets no batches (server picks)', () async {
      await policy();
      final c = await open();
      expect((await add(c, '2')).result, AddToCartResult.added);
      expect(c.state.cartItems.single.batches, isEmpty);
    });
  });

  group('expired stock rule', () {
    test('block: expired stock is skipped, and refused when nothing else is left', () async {
      await policy(pick: 'fifo', expired: 'block');
      // The fake shelf holds 20 in total: 4 expired + 16 in date, nothing outside batches.
      await putBatch('b-old', 'OLD', '2026-10-01', '4', '2026-01-01T00:00:00Z');
      await putBatch('b-a', 'A', '2027-12-31', '16', '2026-02-01T00:00:00Z');
      final c = await open();

      expect((await add(c, '3')).result, AddToCartResult.added);
      expect(slices(c), ['A:3']);
      c.clearCart();

      final blocked = await add(c, '18');
      expect(blocked.result, AddToCartResult.expiredBlocked);
      expect(blocked.message, contains('expired'));
      expect(c.state.cartItems, isEmpty);
    });

    test('warn: asks before using expired stock, then adds it when confirmed', () async {
      await policy(pick: 'fifo', expired: 'warn');
      await stockWithExpired();
      final c = await open();

      final first = await add(c, '3');
      expect(first.result, AddToCartResult.needsExpiryConfirm);
      expect(first.message, isNotNull);
      expect(c.state.cartItems, isEmpty);

      final second = await add(c, '3', confirm: true);
      expect(second.result, AddToCartResult.added);
      expect(slices(c), ['OLD:3']);
      expect(c.state.cartItems.single.batches.single.expired, isTrue);
    });

    test('warn: FEFO still reaches the expired batch first, so it asks', () async {
      await policy(pick: 'fefo', expired: 'warn');
      await stockWithExpired();
      final c = await open();
      // FEFO still orders by expiry, and the expired batch comes first.
      expect((await add(c, '3')).result, AddToCartResult.needsExpiryConfirm);
    });

    test('allow: expired stock is sold without a question', () async {
      await policy(pick: 'fifo', expired: 'allow');
      await stockWithExpired();
      final c = await open();
      expect((await add(c, '3')).result, AddToCartResult.added);
      expect(slices(c), ['OLD:3']);
    });
  });

  group('sale lines carry the batches', () {
    test('buildSaleLines sends batch_no, expiry_date and qty', () async {
      await policy(pick: 'fefo', expired: 'block');
      await stockWithExpired();
      final c = await open();
      await add(c, '8');
      final lines = PosCalculations.buildSaleLines(
        items: c.state.cartItems,
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );
      expect(lines.single['batches'], [
        {'batch_no': 'B', 'expiry_date': '2027-03-31', 'qty': '6'},
        {'batch_no': 'A', 'expiry_date': '2027-12-31', 'qty': '2'},
      ]);
    });

    test('a line without batches has no batches key', () async {
      await policy();
      final c = await open();
      await add(c, '2');
      final lines = PosCalculations.buildSaleLines(
        items: c.state.cartItems,
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );
      expect(lines.single.containsKey('batches'), isFalse);
    });
  });
}
