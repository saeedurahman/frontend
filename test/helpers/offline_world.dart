import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/network/interceptors/retry_interceptor.dart';
import 'package:frantend/core/offline/product_modifier_cache.dart';
import 'package:frantend/core/offline/receipt_branding_source.dart';
import 'package:frantend/core/offline/repos/local_repositories.dart';
import 'package:frantend/core/offline/repos/offline_decorators.dart';
import 'package:frantend/core/offline/repos/offline_pos_repository.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/expenses/data/datasources/expenses_remote_datasource.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/pos/data/repositories/barcode_cache_repository_impl.dart';
import 'package:frantend/features/pos/data/repositories/held_orders_repository_impl.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/presentation/cubit/customer_picker_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/restaurant/data/datasources/restaurant_remote_datasource.dart';
import 'package:frantend/features/restaurant/data/repositories/restaurant_repository_impl.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/returns/data/datasources/returns_remote_datasource.dart';
import 'package:frantend/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:frantend/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';

import '../sync/sync_rig.dart';

/// The backend is completely unreachable: every HTTP request ends like a
/// refused TCP connection, with the exact text Dio produces on Windows.
///
/// * [delay]: how long the OS takes to report the refusal.
/// * [hang]: the request never gets an answer at all (a test that awaits it
///   can only time out).
class UnreachableAdapter implements HttpClientAdapter {
  UnreachableAdapter({this.delay = Duration.zero, this.hang = false});

  final Duration delay;
  final bool hang;

  /// Every request that was attempted.
  final List<RequestOptions> requests = [];

  /// How many of them have been answered (with the refusal) so far.
  int answered = 0;

  static const reason =
      'The remote computer refused the network connection.\r\n';

  /// What used to reach the screen.
  static const rawFragments = <String>[
    'connection errored',
    'refused the network connection',
    'cannot be solved by the library',
    'DioException',
    'SocketException',
  ];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (hang) return Completer<ResponseBody>().future;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    answered++;
    throw DioException.connectionError(
      requestOptions: options,
      reason: reason,
      error: const SocketException(
        reason,
        osError: OSError(reason, 1225),
      ),
    );
  }

  @override
  void close({bool force = false}) {}
}

class FakeDioClient implements DioClient {
  FakeDioClient(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

/// Fails the test when [text] is transport-library output.
void expectPlainLanguage(String? text) {
  if (text == null) return;
  for (final fragment in UnreachableAdapter.rawFragments) {
    expect(
      text.toLowerCase(),
      isNot(contains(fragment.toLowerCase())),
      reason: 'raw network error reached the UI: "$text"',
    );
  }
}

class _Auth extends Fake implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async => const UserModel(
        id: kUser,
        name: 'Cashier',
        role: 'cashier',
        businessId: kBusiness,
        branchId: kBranch,
        permissionKeys: ['sales.create', 'shifts.open', 'shifts.close'],
      );
}

/// The app's data layer wired like `foundation_module.dart`: the in-memory
/// fake sync server and local database of [SyncRig], plus real remote data
/// sources over an HTTP client whose server is unreachable.
class OfflineWorld {
  OfflineWorld({
    UnreachableAdapter? adapter,
    bool retries = false,
    SyncRig? rig,
  })  : rig = rig ?? SyncRig(),
        adapter = adapter ?? UnreachableAdapter() {
    dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:9'))
      ..httpClientAdapter = this.adapter;
    // The production client retries non-POS paths once, one second later.
    if (retries) dio.interceptors.add(RetryInterceptor(dio: dio, retries: 1));
    final client = FakeDioClient(dio);
    const errors = ErrorHandler();
    bool reachable() => this.rig.probe.isReachable;

    products = LocalProductsRepository(this.rig.catalog);
    inventory = LocalInventoryRepository(this.rig.catalog);
    localSettings = LocalSettingsRepository(this.rig.catalog, this.rig.store);
    localCustomers = LocalCustomersRepository(this.rig.catalog);
    pos = OfflinePosRepository(
      catalog: this.rig.catalog,
      writer: this.rig.writer,
      store: this.rig.store,
      remote: PosRemoteDataSourceImpl(client),
      errorHandler: errors,
      userId: () async => kUser,
    );
    customers = OfflineCustomersRepository(
      remoteDataSource: CustomersRemoteDataSourceImpl(client),
      errorHandler: errors,
      writer: this.rig.writer,
      catalog: this.rig.catalog,
      isReachable: reachable,
    );
    cashRegister = OfflineCashRegisterRepository(
      remoteDataSource: CashRegisterRemoteDataSourceImpl(client),
      errorHandler: errors,
      writer: this.rig.writer,
      catalog: this.rig.catalog,
      store: this.rig.store,
      userId: () async => kUser,
    );
    expenses = OfflineExpensesRepository(
      remoteDataSource: ExpensesRemoteDataSourceImpl(client),
      errorHandler: errors,
      writer: this.rig.writer,
      store: this.rig.store,
    );
    returns = OfflineReturnsRepository(
      remoteDataSource: ReturnsRemoteDataSourceImpl(client),
      errorHandler: errors,
      writer: this.rig.writer,
    );
    sales = OfflineSalesRepository(
      remoteDataSource: SalesRemoteDataSourceImpl(client),
      errorHandler: errors,
      writer: this.rig.writer,
      store: this.rig.store,
      isReachable: reachable,
    );
    restaurant = RestaurantRepositoryImpl(
      remoteDataSource: RestaurantRemoteDataSourceImpl(client),
      errorHandler: errors,
    );
    settings = SettingsRepositoryImpl(
      remoteDataSource: SettingsRemoteDataSourceImpl(client),
      errorHandler: errors,
    );
    modifiers = ProductModifierCache.onStore(
      store: this.rig.store,
      fetch: GetProductModifierGroupsUseCase(restaurant).call,
      isReachable: reachable,
    );
    branding = ReceiptBrandingSource(
      store: this.rig.store,
      localSettings: localSettings,
      fetchProfile: GetBusinessProfileUseCase(settings).call,
      fetchSettings: ({String? branchId}) =>
          GetSettingsUseCase(settings)(branchId: branchId),
      isReachable: reachable,
    );
  }

  final SyncRig rig;
  final UnreachableAdapter adapter;
  late final Dio dio;

  late final LocalProductsRepository products;
  late final LocalInventoryRepository inventory;
  late final LocalSettingsRepository localSettings;
  late final LocalCustomersRepository localCustomers;
  late final OfflinePosRepository pos;
  late final OfflineCustomersRepository customers;
  late final OfflineCashRegisterRepository cashRegister;
  late final OfflineExpensesRepository expenses;
  late final OfflineReturnsRepository returns;
  late final OfflineSalesRepository sales;
  late final RestaurantRepositoryImpl restaurant;
  late final SettingsRepositoryImpl settings;
  late final ProductModifierCache modifiers;
  late final ReceiptBrandingSource branding;

  /// Pulls the seeded catalog while the sync server is still reachable.
  Future<void> seed({int stock = 10}) async {
    rig.seedServer(stock: stock);
    await rig.sync();
  }

  /// Cuts the connection: the sync API and the probe both say "offline".
  /// (The HTTP adapter refuses connections from the start.)
  void goOffline() {
    rig.server.offline = true;
    rig.probe.set(ReachabilityStatus.offline);
  }

  void goOnline() {
    rig.server.offline = false;
    rig.probe.set(ReachabilityStatus.online);
  }

  /// The POS cubit exactly as `foundation_module.dart` builds it.
  PosCubit posCubit() {
    final byId = GetProductByIdUseCase(products);
    final price = GetProductPriceUseCase(pos);
    return PosCubit(
      getProductsUseCase: GetProductsUseCase(products),
      getCategoriesUseCase: GetCategoriesUseCase(products),
      getProductByIdUseCase: byId,
      getProductPriceUseCase: price,
      createSaleUseCase: CreateSaleUseCase(pos),
      getMyActiveShiftUseCase: GetMyActiveShiftUseCase(cashRegister),
      openShiftUseCase: OpenShiftUseCase(pos),
      getShiftSummaryUseCase: GetShiftSummaryUseCase(pos),
      getRegistersUseCase: GetRegistersUseCase(pos),
      createRegisterUseCase: CreateRegisterUseCase(pos),
      getStockBalanceUseCase: GetStockBalanceUseCase(inventory),
      getStockBalancesUseCase: GetStockBalancesUseCase(inventory),
      getTaxRatesUseCase: GetTaxRatesUseCase(localSettings),
      getSettingsUseCase: GetSettingsUseCase(localSettings),
      getDiscountSchemesUseCase: GetDiscountSchemesUseCase(pos),
      previewSalePriceUseCase: PreviewSalePriceUseCase(pos),
      openTabUseCase: OpenTabUseCase(restaurant),
      addTabLinesUseCase: AddTabLinesUseCase(restaurant),
      fireTabUseCase: FireTabUseCase(restaurant),
      requestTabBillUseCase: RequestTabBillUseCase(restaurant),
      completeTabUseCase: CompleteTabUseCase(restaurant),
      getTabSaleUseCase: GetTabSaleUseCase(restaurant),
      getKotOrdersByTableUseCase: GetKotOrdersByTableUseCase(restaurant),
      resolvePosSession: ResolvePosSessionUseCase(_Auth(), rig.probe),
      heldOrdersUseCases: HeldOrdersUseCases(
        HeldOrdersRepositoryImpl(HeldOrdersDao(rig.db)),
        price,
        rig.ids,
      ),
      resolveBarcodeUseCase: ResolveBarcodeUseCase(
        BarcodeCacheRepositoryImpl(MasterDataCacheDao(rig.db)),
        LookupBarcodeUseCase(pos),
        byId,
      ),
      saleAttempts: SaleAttemptTracker(rig.ids),
      getCustomerUseCase: customers_uc.GetCustomerUseCase(localCustomers),
      getCustomerBalanceUseCase:
          customers_uc.GetCustomerBalanceUseCase(localCustomers),
      priceChanges: rig.catalog.priceChanges,
      resolvePriceList: (id) => rig.catalog.effectivePriceList(customerId: id),
      stockChanges: rig.catalog.stockChanges,
      warmModifiers: (ids) => unawaited(modifiers.warm(ids)),
    );
  }

  /// The POS customer picker exactly as `foundation_module.dart` builds it.
  CustomerPickerCubit pickerCubit() => CustomerPickerCubit(
        getCustomersUseCase: customers_uc.GetCustomersUseCase(localCustomers),
        createCustomerUseCase: customers_uc.CreateCustomerUseCase(customers),
        unsyncedCustomerIds: rig.catalog.unsyncedCustomerIds,
      );

  CustomerLedgerCubit ledgerCubit() => CustomerLedgerCubit(
        getCustomerUseCase: customers_uc.GetCustomerUseCase(customers),
        getCustomerBalanceUseCase:
            customers_uc.GetCustomerBalanceUseCase(customers),
        getCustomerLedgerUseCase:
            customers_uc.GetCustomerLedgerUseCase(customers),
        recordCustomerPaymentUseCase: RecordCustomerPaymentUseCase(customers),
        getMyActiveShiftUseCase: GetMyActiveShiftUseCase(cashRegister),
      );

  /// Lets best-effort background reads finish before the database closes.
  Future<void> dispose() async {
    await Future<void>.delayed(const Duration(milliseconds: 30));
    await rig.dispose();
  }
}
