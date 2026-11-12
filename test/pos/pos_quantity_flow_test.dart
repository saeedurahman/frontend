// Product tap / cart-line tap / scanner -> quantity calculator -> cart,
// with the real PosCubit and the real POS action helpers.
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
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
import 'package:frantend/features/pos/presentation/utils/pos_product_actions.dart';
import 'package:frantend/features/pos/presentation/widgets/manual_price_dialog.dart';
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
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/restaurant/presentation/widgets/modifier_picker_sheet.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/widgets/pos_settings_section.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/shared/widgets/quantity/quantity_calculator_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<Either<Failure, Decimal?>> call(String p, String? v) async =>
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

/// Modifier groups per product; counts how often they were asked for.
class _Modifiers extends Fake implements GetProductModifierGroupsUseCase {
  final asked = <String>[];

  @override
  Future<Either<Failure, List<ModifierGroupModel>>> call(String productId) async {
    asked.add(productId);
    if (productId != 'p4') return const Right([]);
    return const Right([
      ModifierGroupModel(
        id: 'g1',
        businessId: 't1',
        name: 'Extras',
        selectionType: 'multiple',
        modifiers: [
          ModifierModel(
            id: 'm1',
            businessId: 't1',
            modifierGroupId: 'g1',
            name: 'Cheese',
            priceDelta: '50',
          ),
        ],
      ),
    ]);
  }
}

class _Rig {
  _Rig({
    this.askQuantity = true,
    List<String> permissions = const ['sales.create', 'shifts.open'],
  }) {
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
          ResolvePosSessionUseCase(_Auth(permissions), FixedConnectivityProbe()),
      heldOrdersUseCases: HeldOrdersUseCases(_HeldRepo(), price, UuidIdGenerator()),
      resolveBarcodeUseCase: ResolveBarcodeUseCase(_BarcodeCache(), _Barcode(), byId),
      saleAttempts: SaleAttemptTracker(UuidIdGenerator()),
      getCustomerUseCase: _GetCustomer(),
      getCustomerBalanceUseCase: _GetBalance(),
      askQuantityOnTap: () => askQuantity,
    );
  }

  bool askQuantity;
  late final PosCubit cubit;
}

/// A stand-in for the POS screen: the search box, one button per product
/// (the card tap), a scan button and the cart quantities.
class _Screen extends StatelessWidget {
  const _Screen({required this.searchFocus});
  final FocusNode searchFocus;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    return PosSearchFocus(
      node: searchFocus,
      child: Scaffold(
        body: Builder(
          builder: (context) => Column(
            children: [
              TextField(key: const Key('search'), focusNode: searchFocus),
              for (final id in _catalog.keys)
                TextButton(
                  key: Key('card-$id'),
                  onPressed: () => openProductFromGrid(context, cubit, _listItem(id)),
                  child: Text('card $id'),
                ),
              TextButton(
                key: const Key('scan'),
                onPressed: () =>
                    addBarcodeWithPricePrompt(context, cubit, '8964000111111'),
                child: const Text('scan'),
              ),
              BlocBuilder<PosCubit, dynamic>(
                builder: (context, _) => Column(
                  children: [
                    for (var i = 0; i < cubit.state.cartItems.length; i++)
                      TextButton(
                        key: Key('line-$i'),
                        onPressed: () => editCartLineQuantity(context, cubit, i),
                        child: Text('line $i'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  late _Modifiers modifiers;
  late FocusNode searchFocus;

  setUp(() {
    modifiers = _Modifiers();
    sl.registerSingleton<GetProductModifierGroupsUseCase>(modifiers);
    searchFocus = FocusNode();
  });

  tearDown(() async {
    await sl.reset();
    searchFocus.dispose();
  });

  Future<_Rig> pumpPos(
    WidgetTester tester, {
    bool askQuantity = true,
    List<String> permissions = const ['sales.create', 'shifts.open'],
  }) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final rig = _Rig(askQuantity: askQuantity, permissions: permissions);
    addTearDown(rig.cubit.close);
    await rig.cubit.init();
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<PosCubit>.value(
        value: rig.cubit,
        child: _Screen(searchFocus: searchFocus),
      ),
    ));
    await tester.pumpAndSettle();
    return rig;
  }

  Future<void> tapCard(WidgetTester tester, String id) async {
    await tester.tap(find.byKey(Key('card-$id')));
    await tester.pumpAndSettle();
  }

  Future<void> press(WidgetTester tester, List<LogicalKeyboardKey> keys) async {
    for (final k in keys) {
      await tester.sendKeyEvent(k);
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  String text(WidgetTester tester, String key) =>
      tester.widget<Text>(find.byKey(Key(key))).data!;

  final popup = find.byType(QuantityCalculatorSheet);

  group('product tap', () {
    testWidgets('opens the calculator; nothing is added until Add',
        (tester) async {
      final rig = await pumpPos(tester);
      await tapCard(tester, 'p1');

      expect(popup, findsOneWidget);
      expect(find.text('Rice 5kg'), findsOneWidget);
      expect(text(tester, 'qty-price'), 'Rs. 100');
      expect(text(tester, 'qty-stock'), 'In stock: 20 pcs');
      expect(rig.cubit.state.cartItems, isEmpty);
    });

    testWidgets('3 x 3 + Enter adds one line of 9 and closes the popup',
        (tester) async {
      final rig = await pumpPos(tester);
      searchFocus.requestFocus();
      await tester.pump();
      await tapCard(tester, 'p1');
      await press(tester, [
        LogicalKeyboardKey.digit3,
        LogicalKeyboardKey.keyX,
        LogicalKeyboardKey.digit3,
        LogicalKeyboardKey.enter,
      ]);

      expect(popup, findsNothing);
      final line = rig.cubit.state.cartItems.single;
      expect(line.productId, 'p1');
      expect(line.qty, d('9'));
      expect(line.unitPrice, d('100'));
      expect(line.priceManual, isFalse);
      expect(line.lineTotal, d('900'));
      expect(searchFocus.hasFocus, isTrue,
          reason: 'focus goes back to the search box');
    });

    testWidgets('empty input + Add = 1; Esc adds nothing', (tester) async {
      final rig = await pumpPos(tester);
      await tapCard(tester, 'p1');
      await press(tester, [LogicalKeyboardKey.escape]);
      expect(popup, findsNothing);
      expect(rig.cubit.state.cartItems, isEmpty);

      await tapCard(tester, 'p1');
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.pumpAndSettle();
      expect(rig.cubit.state.cartItems.single.qty, Decimal.one);
    });

    testWidgets('a fast double tap opens one popup and adds once',
        (tester) async {
      final rig = await pumpPos(tester);
      await tester.tap(find.byKey(const Key('card-p1')));
      await tester.tap(find.byKey(const Key('card-p1')), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(popup, findsOneWidget);

      await tester.tap(find.byKey(const Key('qty-key-5')));
      await tester.tap(find.byKey(const Key('qty-confirm')));
      await tester.tap(find.byKey(const Key('qty-confirm')), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(rig.cubit.state.cartItems.single.qty, d('5'));
    });

    testWidgets('a kg item takes decimals; a piece item does not',
        (tester) async {
      final rig = await pumpPos(tester);
      await tapCard(tester, 'p2');
      await press(tester, [
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.digit0,
        LogicalKeyboardKey.slash,
        LogicalKeyboardKey.digit4,
      ]);
      expect(text(tester, 'qty-result'), '= 2.5 kg');
      expect(text(tester, 'qty-total'), 'Rs. 375');
      await press(tester, [LogicalKeyboardKey.enter]);
      expect(rig.cubit.state.cartItems.single.qty, d('2.5'));

      await tapCard(tester, 'p1');
      await press(tester, [
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.period,
        LogicalKeyboardKey.digit5,
        LogicalKeyboardKey.enter,
      ]);
      expect(popup, findsOneWidget, reason: 'refused: whole numbers only');
      expect(find.text('Whole numbers only for this item'), findsOneWidget);
      expect(rig.cubit.state.cartItems, hasLength(1));
    });

    testWidgets('more than the stock is blocked when the owner setting forbids it',
        (tester) async {
      final rig = await pumpPos(tester);
      // No OfflinePolicy wired = strict, so the calculator blocks. (The
      // warning-only case is covered in quantity_calculator_sheet_test.)
      expect(rig.cubit.allowBelowStock, isFalse);
      await tapCard(tester, 'p1');
      await press(tester, [
        LogicalKeyboardKey.digit5,
        LogicalKeyboardKey.digit0,
        LogicalKeyboardKey.enter,
      ]);
      expect(find.text('Only 20 pcs in stock'), findsOneWidget);
      expect(rig.cubit.state.cartItems, isEmpty);
    });
  });

  group('setting "Ask quantity on product tap"', () {
    testWidgets('OFF: a tap adds 1 directly, no popup', (tester) async {
      final rig = await pumpPos(tester, askQuantity: false);
      await tapCard(tester, 'p1');
      expect(popup, findsNothing);
      expect(rig.cubit.state.cartItems.single.qty, Decimal.one);

      await tapCard(tester, 'p1');
      expect(popup, findsNothing);
      expect(rig.cubit.state.cartItems.single.qty, d('2'));
    });

    testWidgets('the switch is read on every tap', (tester) async {
      final rig = await pumpPos(tester, askQuantity: false);
      await tapCard(tester, 'p1');
      expect(popup, findsNothing);

      rig.askQuantity = true;
      await tapCard(tester, 'p2');
      expect(popup, findsOneWidget);
    });

    testWidgets('Settings > POS stores the preference (default ON)',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = PreferencesStorage(await SharedPreferences.getInstance());
      expect(prefs.getAskQuantityOnTap(), isTrue);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: PosSettingsSection(preferences: prefs)),
      ));
      expect(find.text('Ask quantity on product tap'), findsOneWidget);
      await tester.tap(find.byKey(const Key('pos-ask-quantity')));
      await tester.pumpAndSettle();
      expect(prefs.getAskQuantityOnTap(), isFalse);
    });
  });

  group('scanner', () {
    testWidgets('a barcode scan adds 1 without the popup, every time',
        (tester) async {
      final rig = await pumpPos(tester);
      await tester.tap(find.byKey(const Key('scan')));
      await tester.pumpAndSettle();
      expect(popup, findsNothing);
      expect(rig.cubit.state.cartItems.single.qty, Decimal.one);

      await tester.tap(find.byKey(const Key('scan')));
      await tester.pumpAndSettle();
      expect(popup, findsNothing);
      expect(rig.cubit.state.cartItems.single.qty, d('2'));
    });
  });

  group('product already in the cart', () {
    testWidgets('the popup opens with the current quantity; Update replaces it',
        (tester) async {
      final rig = await pumpPos(tester);
      await tapCard(tester, 'p1');
      await press(tester, [LogicalKeyboardKey.digit4, LogicalKeyboardKey.enter]);

      await tapCard(tester, 'p1');
      expect(text(tester, 'qty-display'), '4');
      expect(find.text('Update'), findsOneWidget);
      expect(find.byKey(const Key('qty-remove')), findsOneWidget);

      await press(tester, [
        LogicalKeyboardKey.digit1,
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.enter,
      ]);
      expect(rig.cubit.state.cartItems.single.qty, d('12'),
          reason: 'replaced, not 4 + 12');
    });

    testWidgets('Remove deletes the line', (tester) async {
      final rig = await pumpPos(tester);
      await tapCard(tester, 'p1');
      await press(tester, [LogicalKeyboardKey.enter]);
      await tapCard(tester, 'p2');
      await press(tester, [LogicalKeyboardKey.enter]);
      expect(rig.cubit.state.cartItems, hasLength(2));

      await tapCard(tester, 'p1');
      await tester.tap(find.byKey(const Key('qty-remove')));
      await tester.pumpAndSettle();

      expect(popup, findsNothing);
      expect(rig.cubit.state.cartItems.single.productId, 'p2');
    });

    testWidgets('tapping a cart line quantity opens the same popup in edit mode',
        (tester) async {
      final rig = await pumpPos(tester);
      rig.cubit.addItemsForTest([
        CartItemModel(
          productId: 'p2',
          variationId: 'v-p2',
          productName: 'Sugar loose',
          unitPrice: d('150'),
          qty: d('2'),
          itemDiscountPct: d('10'),
        ),
      ]);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('line-0')));
      await tester.pumpAndSettle();
      expect(text(tester, 'qty-display'), '2');
      expect(find.text('Update'), findsOneWidget);
      // 2 x 150 = 300, minus the line's 10% discount.
      expect(text(tester, 'qty-total'), 'Rs. 270');

      await press(tester, [
        LogicalKeyboardKey.digit0,
        LogicalKeyboardKey.period,
        LogicalKeyboardKey.digit5,
        LogicalKeyboardKey.enter,
      ]);
      final line = rig.cubit.state.cartItems.single;
      expect(line.qty, d('0.5'));
      expect(line.itemDiscountPct, d('10'), reason: 'the rest of the line is kept');
    });

    test('repeated adds of the same product still merge into one line',
        () async {
      final rig = _Rig();
      addTearDown(rig.cubit.close);
      await rig.cubit.init();

      await rig.cubit.addToCart(_listItem('p1'), qty: d('6'));
      await rig.cubit.addToCart(_listItem('p1'));
      final outcome = await rig.cubit.addToCart(_listItem('p1'), qty: d('3'));

      expect(outcome.result, AddToCartResult.added);
      expect(rig.cubit.state.cartItems.single.qty, d('10'));
    });
  });

  group('price', () {
    testWidgets('no price: the existing "set price" popup comes first',
        (tester) async {
      final rig = await pumpPos(tester);
      await tapCard(tester, 'p3');
      expect(find.byType(ManualPriceDialog), findsOneWidget);
      expect(popup, findsNothing);

      await tester.enterText(find.byType(TextField).last, '40');
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      expect(popup, findsOneWidget);
      expect(text(tester, 'qty-price'), 'Rs. 40');
      await press(tester, [LogicalKeyboardKey.digit3, LogicalKeyboardKey.enter]);

      final line = rig.cubit.state.cartItems.single;
      expect(line.qty, d('3'));
      expect(line.unitPrice, d('40'));
      expect(line.priceManual, isTrue);
    });

    testWidgets('a cashier without price override cannot edit the price',
        (tester) async {
      await pumpPos(tester);
      await tapCard(tester, 'p1');
      expect(find.byKey(const Key('qty-price-edit')), findsNothing);
    });

    testWidgets('with sales.override_price the line uses the typed price',
        (tester) async {
      final rig = await pumpPos(
        tester,
        permissions: ['sales.create', 'shifts.open', 'sales.override_price'],
      );
      expect(rig.cubit.canOverridePrice, isTrue);
      await tapCard(tester, 'p1');
      await tester.tap(find.byKey(const Key('qty-price-edit')));
      await tester.pump();
      await press(tester, [
        LogicalKeyboardKey.digit9,
        LogicalKeyboardKey.digit0,
        LogicalKeyboardKey.enter, // price
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.enter, // quantity
      ]);

      final line = rig.cubit.state.cartItems.single;
      expect(line.qty, d('2'));
      expect(line.unitPrice, d('90'));
      expect(line.priceManual, isTrue);
      expect(rig.cubit.getDisplayPrice('p1'), d('100'),
          reason: 'the list price on the card is untouched');
    });
  });

  group('modifiers', () {
    testWidgets('are chosen after the quantity; the line gets that quantity',
        (tester) async {
      final rig = await pumpPos(tester);
      await tapCard(tester, 'p4');
      expect(popup, findsOneWidget);
      expect(find.byType(ModifierPickerSheet), findsNothing);
      expect(modifiers.asked, isEmpty, reason: 'the popup does not wait for them');

      await press(tester, [LogicalKeyboardKey.digit3, LogicalKeyboardKey.enter]);
      expect(popup, findsNothing);
      expect(find.byType(ModifierPickerSheet), findsOneWidget);

      await tester.tap(find.text('Cheese'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to order'));
      await tester.pumpAndSettle();

      final line = rig.cubit.state.cartItems.single;
      expect(line.qty, d('3'));
      expect(line.modifiers.single.modifierId, 'm1');
      expect(line.unitPrice, d('550'));
    });
  });
}
