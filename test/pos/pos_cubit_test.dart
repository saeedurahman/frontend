import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/discount_scheme_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/pos/domain/errors/pos_errors.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';

class _Products extends Fake implements GetProductsUseCase {
  @override
  Future<Either<Failure, PaginatedProductsModel>> call({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async =>
      const Right(PaginatedProductsModel(total: 0, skip: 0, limit: 60));
}

class _Categories extends Fake implements GetCategoriesUseCase {
  @override
  Future<Either<Failure, List<CategoryModel>>> call({String? parentId}) async =>
      const Right([]);
}

class _ProductById extends Fake implements GetProductByIdUseCase {}

class _Barcode extends Fake implements LookupBarcodeUseCase {}

class _Price extends Fake implements GetProductPriceUseCase {
  Decimal? price;
  bool fail = false;

  @override
  Future<Either<Failure, Decimal?>> call(String p, String? v) async =>
      fail ? const Left(ServerFailure('x')) : Right(price);
}

class _CreateSale extends Fake implements CreateSaleUseCase {
  final bodies = <Map<String, dynamic>>[];
  bool fail = false;

  @override
  Future<Either<Failure, SaleResponseModel>> call(
    Map<String, dynamic> body,
  ) async {
    bodies.add(body);
    if (fail) return const Left(ServerFailure('boom'));
    return Right(SaleResponseModel(
      id: body['id'] as String,
      branchId: 'b1',
      saleType: 'pos',
      saleStatus: 'completed',
    ));
  }
}

class _MyShift extends Fake implements GetMyActiveShiftUseCase {
  RegisterShiftModel? shift;

  @override
  Future<Either<Failure, RegisterShiftModel?>> call() async => Right(shift);
}

class _OpenShift extends Fake implements OpenShiftUseCase {
  Either<Failure, RegisterShiftModel> result =
      const Left(ServerFailure('Register is already in use'));

  @override
  Future<Either<Failure, RegisterShiftModel>> call(
    Map<String, dynamic> body,
  ) async =>
      result;
}

class _Summary extends Fake implements GetShiftSummaryUseCase {
  @override
  Future<Either<Failure, ShiftSummaryModel>> call(String shiftId) async =>
      const Left(ServerFailure('no summary'));
}

class _Registers extends Fake implements GetRegistersUseCase {
  @override
  Future<Either<Failure, List<CashRegisterModel>>> call({
    String? branchId,
  }) async =>
      const Right([
        CashRegisterModel(id: 'r1', branchId: 'b1', name: 'Main'),
      ]);
}

class _CreateRegister extends Fake implements CreateRegisterUseCase {}

class _Stock extends Fake implements GetStockBalanceUseCase {}

class _Stocks extends Fake implements GetStockBalancesUseCase {
  @override
  Future<Either<Failure, List<StockBalanceModel>>> call({
    required String branchId,
    List<String>? productIds,
  }) async =>
      const Right([]);
}

class _Tax extends Fake implements GetTaxRatesUseCase {
  List<TaxRateModel> rates = [];

  @override
  Future<Either<Failure, List<TaxRateModel>>> call() async => Right(rates);
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

class _Auth extends Fake implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async => const UserModel(
        id: 'u1',
        name: 'Cashier',
        role: 'cashier',
        businessId: 't1',
        branchId: 'b1',
        permissionKeys: ['sales.create', 'shifts.open'],
      );
}

class _Net extends Fake implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

class _MemoryHeldDao extends Fake implements HeldOrdersDao {
  final rows = <String, (HeldOrderModel, HeldOrderScope?)>{};

  @override
  Future<void> saveHeldOrder(HeldOrderModel order,
      {HeldOrderScope? scope}) async {
    rows[order.id] = (order, scope);
  }

  @override
  Future<List<HeldOrderModel>> getHeldOrdersFor(HeldOrderScope scope) async => [
        for (final r in rows.values)
          if (r.$2 == scope) r.$1,
      ];

  @override
  Future<HeldOrderModel?> getHeldOrderForScope(
    String id,
    HeldOrderScope scope,
  ) async {
    final r = rows[id];
    return r != null && r.$2 == scope ? r.$1 : null;
  }

  @override
  Future<void> deleteHeldOrder(String id) async => rows.remove(id);
}

class _MemoryCache extends Fake implements MasterDataCacheDao {}

class _GetCustomer extends Fake implements customers_uc.GetCustomerUseCase {}

class _GetBalance extends Fake
    implements customers_uc.GetCustomerBalanceUseCase {}

class _Rig {
  _Rig() {
    cubit = PosCubit(
      getProductsUseCase: _Products(),
      getCategoriesUseCase: _Categories(),
      getProductByIdUseCase: _ProductById(),
      lookupBarcodeUseCase: _Barcode(),
      getProductPriceUseCase: price,
      createSaleUseCase: createSale,
      getMyActiveShiftUseCase: myShift,
      openShiftUseCase: openShift,
      getShiftSummaryUseCase: _Summary(),
      getRegistersUseCase: _Registers(),
      createRegisterUseCase: _CreateRegister(),
      getStockBalanceUseCase: _Stock(),
      getStockBalancesUseCase: _Stocks(),
      getTaxRatesUseCase: tax,
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
      authLocalDataSource: _Auth(),
      networkInfo: _Net(),
      heldOrdersDao: held,
      getCustomerUseCase: _GetCustomer(),
      getCustomerBalanceUseCase: _GetBalance(),
      masterDataCacheDao: _MemoryCache(),
    );
  }

  final price = _Price();
  final createSale = _CreateSale();
  final myShift = _MyShift();
  final openShift = _OpenShift();
  final tax = _Tax();
  final held = _MemoryHeldDao();
  late final PosCubit cubit;
}

const _shift = RegisterShiftModel(id: 's1', cashRegisterId: 'r1');

CartItemModel _item({String id = 'p1', String price = '100'}) => CartItemModel(
      productId: id,
      productName: 'Item $id',
      unitPrice: Decimal.parse(price),
      qty: Decimal.one,
    );

PaymentLineModel _cash(String v) => PaymentLineModel(
      paymentMethod: PaymentMethods.cash,
      amount: Decimal.parse(v),
    );

void main() {
  late _Rig rig;

  setUp(() => rig = _Rig());
  tearDown(() => rig.cubit.close());

  Future<void> start({bool withShift = true}) async {
    rig.myShift.shift = withShift ? _shift : null;
    await rig.cubit.init();
    rig.cubit.addItemsForTest([_item()]);
  }

  group('shift gate', () {
    test('submitSale hard-fails with no active shift', () async {
      await start(withShift: false);
      await expectLater(
        rig.cubit.submitSale([_cash('100')]),
        throwsA(isA<ShiftRequiredException>()),
      );
      expect(rig.createSale.bodies, isEmpty);
    });

    test('submitSale works once a shift is open', () async {
      await start();
      final sale = await rig.cubit.submitSale([_cash('100')]);
      expect(sale.saleStatus, 'completed');
      expect(rig.createSale.bodies.single['register_shift_id'], 's1');
    });

    test('openShift surfaces the real server failure', () async {
      await start(withShift: false);
      final ok = await rig.cubit.openShift(Decimal.zero, null);
      expect(ok, isFalse);
      expect(rig.cubit.state.openShiftError, 'Register is already in use');
    });

    test('a successful openShift clears the error', () async {
      await start(withShift: false);
      await rig.cubit.openShift(Decimal.zero, null);
      rig.openShift.result = const Right(_shift);
      final ok = await rig.cubit.openShift(Decimal.zero, null);
      expect(ok, isTrue);
      expect(rig.cubit.state.openShiftError, isNull);
      expect(rig.cubit.state.activeShift?.id, 's1');
    });
  });

  group('payments and retries', () {
    test('payments that do not match the total are refused client-side',
        () async {
      await start();
      await expectLater(
        rig.cubit.submitSale([_cash('99')]),
        throwsA(isA<PaymentMismatchException>()),
      );
      expect(rig.createSale.bodies, isEmpty);
    });

    test('re-tapping after a failure re-sends the SAME sale id', () async {
      await start();
      rig.createSale.fail = true;
      await expectLater(
        rig.cubit.submitSale([_cash('100')]),
        throwsException,
      );
      await expectLater(
        rig.cubit.submitSale([_cash('100')]),
        throwsException,
      );
      expect(rig.createSale.bodies, hasLength(2));
      expect(rig.createSale.bodies[0]['id'], rig.createSale.bodies[1]['id']);
    });

    test('a different cart after a failure gets a NEW sale id', () async {
      await start();
      rig.createSale.fail = true;
      await expectLater(
        rig.cubit.submitSale([_cash('100')]),
        throwsException,
      );
      rig.cubit.addItemsForTest([_item(id: 'p2', price: '50')]);
      await expectLater(
        rig.cubit.submitSale([_cash('150')]),
        throwsException,
      );
      expect(rig.createSale.bodies[0]['id'], isNot(rig.createSale.bodies[1]['id']));
    });

    test('after success the next sale gets a new id', () async {
      await start();
      await rig.cubit.submitSale([_cash('100')]);
      rig.cubit.addItemsForTest([_item()]);
      await rig.cubit.submitSale([_cash('100')]);
      expect(rig.createSale.bodies[0]['id'], isNot(rig.createSale.bodies[1]['id']));
    });
  });

  group('tax editing', () {
    test('a cashier without override/tax permission cannot change line tax',
        () async {
      await start();
      rig.cubit.updateLineTaxRate(
        0,
        const TaxRateModel(id: 't', businessId: 'b', name: 'GST', rate: '17'),
      );
      expect(rig.cubit.state.cartItems.first.taxRateId, isNull);
    });
  });

  group('held orders', () {
    test('labels are unique', () {
      final now = DateTime(2026, 1, 1, 14, 5, 9);
      expect(PosCubitCartMixin.uniqueHeldLabel(null, now, const []), 'Order 14:05:09');
      expect(
        PosCubitCartMixin.uniqueHeldLabel(null, now, const ['Order 14:05:09']),
        'Order 14:05:09 (2)',
      );
      expect(
        PosCubitCartMixin.uniqueHeldLabel(
            'Table', now, const ['table', 'Table (2)']),
        'Table (3)',
      );
    });

    test('held orders are scoped to tenant + branch + user', () async {
      await start();
      expect(await rig.cubit.holdCurrentSale(), isTrue);
      expect(rig.cubit.state.heldOrders, hasLength(1));

      // An order parked by another cashier/branch/tenant is invisible.
      final other = rig.cubit.state.heldOrders.single;
      rig.held.rows['x'] = (
        other.copyWith(id: 'x'),
        const HeldOrderScope(tenantId: 't1', branchId: 'b1', userId: 'u2'),
      );
      rig.held.rows['y'] = (
        other.copyWith(id: 'y'),
        const HeldOrderScope(tenantId: 't2', branchId: 'b1', userId: 'u1'),
      );
      await rig.cubit.loadHeldOrders();
      expect(rig.cubit.state.heldOrders.map((o) => o.id),
          isNot(containsAll(['x', 'y'])));
      final result = await rig.cubit.resumeHeldOrder('x');
      expect(result.resumed, isFalse);
    });

    test('resume refreshes prices and reports the change', () async {
      await start();
      await rig.cubit.holdCurrentSale();
      rig.price.price = Decimal.parse('120');
      final id = rig.cubit.state.heldOrders.single.id;

      final result = await rig.cubit.resumeHeldOrder(id);

      expect(result.resumed, isTrue);
      expect(result.hasChanges, isTrue);
      expect(result.changes.single, contains('100.00 -> 120.00'));
      expect(rig.cubit.state.cartItems.single.unitPrice, Decimal.parse('120'));
    });

    test('resume keeps manual prices and warns when refresh fails', () async {
      await start();
      rig.cubit.addItemsForTest([
        _item(id: 'm', price: '10').copyWith(priceManual: true),
      ]);
      await rig.cubit.holdCurrentSale();
      rig.price.fail = true;
      final result =
          await rig.cubit.resumeHeldOrder(rig.cubit.state.heldOrders.single.id);
      expect(rig.cubit.state.cartItems.last.unitPrice, Decimal.parse('10'));
      expect(result.changes.join(), contains('could not be refreshed'));
    });
  });
}
