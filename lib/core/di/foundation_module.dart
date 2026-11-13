import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/identity/device_identity.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/offline_policy.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/offline/product_modifier_cache.dart';
import 'package:frantend/core/offline/receipt_branding_source.dart';
import 'package:frantend/core/offline/repos/local_repositories.dart';
import 'package:frantend/core/offline/repos/offline_decorators.dart';
import 'package:frantend/core/offline/repos/offline_pos_repository.dart';
import 'package:frantend/core/platform/app_window_service.dart';
import 'package:frantend/core/platform/barcode_scanner_service.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/session/business_session_cubit.dart';
import 'package:frantend/core/session/session_notices.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/core/sync/http_sync_api.dart';
import 'package:frantend/core/sync/lease_service.dart';
import 'package:frantend/core/sync/online_extras.dart';
import 'package:frantend/core/sync/outbox_pending_work_guard.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/push_service.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/sync/sync_status.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/offline/credential_hasher.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/domain/repositories/customers_repository.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/expenses/data/datasources/expenses_remote_datasource.dart';
import 'package:frantend/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/pos/data/repositories/barcode_cache_repository_impl.dart';
import 'package:frantend/features/pos/data/repositories/held_orders_repository_impl.dart';
import 'package:frantend/features/pos/domain/repositories/barcode_cache_repository.dart';
import 'package:frantend/features/pos/domain/repositories/held_orders_repository.dart';
import 'package:frantend/features/pos/domain/repositories/pos_repository.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/presentation/cubit/customer_picker_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/features/products/domain/usecases/add_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/add_variation_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/product_pricing_usecases.dart'
    as pricing;
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/returns/data/datasources/returns_remote_datasource.dart';
import 'package:frantend/features/returns/domain/repositories/returns_repository.dart';
import 'package:frantend/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:frantend/features/sales/domain/repositories/sales_repository.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:get_it/get_it.dart';

/// Hand-registered services: platform adapters, identity, reachability,
/// offline credentials, the offline data layer and the sync engine.
///
/// Kept out of the generated `injection.config.dart` (which cannot be
/// regenerated here) so it survives a regeneration; where a generated
/// registration must change behavior (repositories that now write through
/// the outbox, `PosCubit`), it is *replaced* here after `init()`.
void registerFoundationServices(GetIt sl) {
  void once<T extends Object>(T Function() create) {
    if (!sl.isRegistered<T>()) sl.registerLazySingleton<T>(create);
  }

  void replace<T extends Object>(T Function() create) {
    if (sl.isRegistered<T>()) sl.unregister<T>();
    sl.registerLazySingleton<T>(create);
  }

  Future<UserCtx?> cachedUser() async {
    final user = await sl<AuthLocalDataSource>().getCachedUser();
    return user == null ? null : UserCtx(user.id, user.name, user.businessId, user.branchId);
  }

  Future<String?> userId() async => (await cachedUser())?.id;
  Future<String?> businessId() async => (await cachedUser())?.businessId;

  // ── Platform adapters (Windows implementations) ──────────────────────
  once<SecureKeyStore>(() => const FlutterSecureKeyStore());
  once<PrinterService>(() => const WindowsPrinterService());
  once<FileSaverService>(() => const WindowsFileSaverService());
  once<AppWindowService>(() => WindowsAppWindowService());
  once<BarcodeScannerService>(() => KeyboardWedgeBarcodeScanner());

  // ── Identity ─────────────────────────────────────────────────────────
  once<IdGenerator>(() => UuidIdGenerator());
  once<DeviceIdentity>(
    () => DeviceIdentity(store: sl<SecureKeyStore>(), ids: sl<IdGenerator>()),
  );

  // ── Reachability ─────────────────────────────────────────────────────
  once<ConnectivityProbe>(
    () => HttpConnectivityProbe.forApi(
      // Bare client on purpose: no auth, no retries, no interceptors, so a
      // probe never triggers token refresh or session handling.
      dio: Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          sendTimeout: const Duration(seconds: 3),
        ),
      ),
      connectivity: Connectivity(),
    ),
  );

  // ── Offline credentials ──────────────────────────────────────────────
  once<CredentialHasher>(() => Pbkdf2CredentialHasher());
  once<OfflineCredentialVerifier>(
    () => OfflineCredentialVerifier(
      store: sl<SecureKeyStore>(),
      hasher: sl<CredentialHasher>(),
    ),
  );

  // ── Offline data layer ───────────────────────────────────────────────
  once<SyncConfig>(() => const SyncConfig());
  once<SyncStore>(() => SyncStore(sl<AppDatabase>()));
  once<LocalCatalog>(() => LocalCatalog(sl<SyncStore>(), businessId: businessId));
  once<OfflinePolicy>(
    () => OfflinePolicy(sl<PreferencesStorage>(), sl<LocalCatalog>()),
  );
  once<OfflineWriter>(
    () => OfflineWriter(
      store: sl<SyncStore>(),
      ids: sl<IdGenerator>(),
      deviceId: () => sl<DeviceIdentity>().deviceId(),
      actingUser: () async {
        final u = await cachedUser();
        return u == null
            ? null
            : ActingUser(id: u.id, name: u.name, businessId: u.businessId, branchId: u.branchId);
      },
    ),
  );
  once<LeaseService>(
    () => LeaseService(
      store: sl<SyncStore>(),
      publicKey: LeaseService.configuredPublicKey,
      businessId: businessId,
    ),
  );
  once<SyncApi>(
    () => HttpSyncApi(
      dio: sl<Dio>(),
      deviceId: () => sl<DeviceIdentity>().deviceId(),
      deviceName: () => sl<DeviceIdentity>().deviceName(),
      appVersion: sl<SyncConfig>().appVersion,
    ),
  );
  once<OnlineExtras>(
    () => OnlineExtras(
      dio: sl<Dio>(),
      store: sl<SyncStore>(),
      lease: sl<LeaseService>(),
      userId: userId,
    ),
  );
  once<PendingWorkGuard>(
    () => OutboxPendingWorkGuard(
      sl<SyncStore>(),
      heldOrders: () => sl<HeldOrdersDao>().countAll(),
    ),
  );
  once<LocalDataLifecycle>(
    () => LocalDataLifecycle(
      database: sl<AppDatabase>(),
      offlineCredentials: sl<OfflineCredentialVerifier>(),
      secureStore: sl<SecureKeyStore>(),
      clearPinRoster: () => sl<SecureStorage>().clearPinDeviceCache(),
      pendingWork: sl<PendingWorkGuard>(),
    ),
  );
  once<SyncEngine>(
    () => SyncEngine(
      store: sl<SyncStore>(),
      push: PushService(
        store: sl<SyncStore>(),
        api: sl<SyncApi>(),
        ids: sl<IdGenerator>(),
        config: sl<SyncConfig>(),
      ),
      pull: PullService(
        store: sl<SyncStore>(),
        api: sl<SyncApi>(),
        config: sl<SyncConfig>(),
        currentUserId: userId,
        onAccess: (a) => sl<AccessCubit>().applyPulledAccess(
          permissionKeys: a.permissionKeys,
          branchIds: a.branchIds,
          permissionsVersion: a.permissionsVersion,
        ),
        onProgress: (p) => sl<SyncEngine>().reportProgress(p),
      ),
      probe: sl<ConnectivityProbe>(),
      config: sl<SyncConfig>(),
      hooks: SyncHooks(
        onFlaggedSales: (ids) => SessionNotices.post(
          ids.length == 1
              ? 'Sync finished: 1 sale was flagged for review.'
              : 'Sync finished: ${ids.length} sales were flagged for review.',
        ),
        afterSync: () => sl<OnlineExtras>().run(),
        // onDeviceRevoked is attached by SessionServices (needs the router).
      ),
    ),
  );
  once<SyncStatusSource>(
    () => EngineSyncStatusSource(sl<SyncEngine>(), sl<ConnectivityProbe>()),
  );

  // ── POS ports ────────────────────────────────────────────────────────
  once<HeldOrdersRepository>(
    () => HeldOrdersRepositoryImpl(sl<HeldOrdersDao>()),
  );
  once<BarcodeCacheRepository>(
    () => BarcodeCacheRepositoryImpl(sl<MasterDataCacheDao>()),
  );

  // Local-only readers (the POS reads from the device, never the network).
  once<LocalProductsRepository>(() => LocalProductsRepository(sl<LocalCatalog>()));
  once<LocalInventoryRepository>(() => LocalInventoryRepository(sl<LocalCatalog>()));
  once<LocalSettingsRepository>(
    () => LocalSettingsRepository(sl<LocalCatalog>(), sl<SyncStore>()),
  );
  once<LocalCustomersRepository>(() => LocalCustomersRepository(sl<LocalCatalog>()));

  bool reachable() => sl<ConnectivityProbe>().isReachable;

  // Modifier groups for add-to-cart: read from the device, refreshed in the
  // background. Skipped entirely for a business without restaurant features.
  once<ProductModifierCache>(
    () => ProductModifierCache.onStore(
      store: sl<SyncStore>(),
      fetch: (productId) => sl<GetProductModifierGroupsUseCase>()(productId),
      enabled: () {
        if (!sl.isRegistered<BusinessSessionCubit>()) return true;
        final session = sl<BusinessSessionCubit>().state;
        return !session.isLoaded || session.flags.enableRestaurant;
      },
      isReachable: reachable,
    ),
  );

  // Receipt header / footer from the copies on the device.
  once<ReceiptBrandingSource>(
    () => ReceiptBrandingSource(
      store: sl<SyncStore>(),
      localSettings: sl<LocalSettingsRepository>(),
      fetchProfile: () => sl<GetBusinessProfileUseCase>()(),
      fetchSettings: ({String? branchId}) =>
          sl<GetSettingsUseCase>()(branchId: branchId),
      isReachable: reachable,
    ),
  );

  // ── Repositories that now write through the outbox ───────────────────
  replace<PosRepository>(
    () => OfflinePosRepository(
      catalog: sl<LocalCatalog>(),
      writer: sl<OfflineWriter>(),
      store: sl<SyncStore>(),
      remote: sl<PosRemoteDataSource>(),
      errorHandler: sl<ErrorHandler>(),
      userId: userId,
    ),
  );
  replace<CustomersRepository>(
    () => OfflineCustomersRepository(
      remoteDataSource: sl<CustomersRemoteDataSource>(),
      errorHandler: sl<ErrorHandler>(),
      writer: sl<OfflineWriter>(),
      catalog: sl<LocalCatalog>(),
      isReachable: reachable,
    ),
  );
  replace<CashRegisterRepository>(
    () => OfflineCashRegisterRepository(
      remoteDataSource: sl<CashRegisterRemoteDataSource>(),
      errorHandler: sl<ErrorHandler>(),
      writer: sl<OfflineWriter>(),
      catalog: sl<LocalCatalog>(),
      store: sl<SyncStore>(),
      userId: userId,
    ),
  );
  replace<ExpensesRepository>(
    () => OfflineExpensesRepository(
      remoteDataSource: sl<ExpensesRemoteDataSource>(),
      errorHandler: sl<ErrorHandler>(),
      writer: sl<OfflineWriter>(),
      store: sl<SyncStore>(),
    ),
  );
  replace<ReturnsRepository>(
    () => OfflineReturnsRepository(
      remoteDataSource: sl<ReturnsRemoteDataSource>(),
      errorHandler: sl<ErrorHandler>(),
      writer: sl<OfflineWriter>(),
    ),
  );
  replace<SalesRepository>(
    () => OfflineSalesRepository(
      remoteDataSource: sl<SalesRemoteDataSource>(),
      errorHandler: sl<ErrorHandler>(),
      writer: sl<OfflineWriter>(),
      store: sl<SyncStore>(),
      isReachable: reachable,
    ),
  );

  // ── POS use cases bound to the local readers ─────────────────────────
  once<ResolvePosSessionUseCase>(
    () => ResolvePosSessionUseCase(
      sl<AuthLocalDataSource>(),
      sl<ConnectivityProbe>(),
    ),
  );
  once<HeldOrdersUseCases>(
    () => HeldOrdersUseCases(
      sl<HeldOrdersRepository>(),
      sl<GetProductPriceUseCase>(),
      sl<IdGenerator>(),
    ),
  );
  once<ResolveBarcodeUseCase>(
    () => ResolveBarcodeUseCase(
      sl<BarcodeCacheRepository>(),
      sl<LookupBarcodeUseCase>(),
      GetProductByIdUseCase(sl<LocalProductsRepository>()),
    ),
  );
  // Per-cubit state (the retry id), so a factory, not a singleton.
  if (!sl.isRegistered<SaleAttemptTracker>()) {
    sl.registerFactory<SaleAttemptTracker>(
      () => SaleAttemptTracker(sl<IdGenerator>()),
    );
  }

  // Product form: price lookups read the pulled data first, and a saved price
  // is pulled back so POS / product lists show it straight away.
  if (sl.isRegistered<ProductFormCubit>()) sl.unregister<ProductFormCubit>();
  sl.registerFactory<ProductFormCubit>(
    () => ProductFormCubit(
      getProductByIdUseCase: sl<GetProductByIdUseCase>(),
      createProductUseCase: sl<CreateProductUseCase>(),
      updateProductUseCase: sl<UpdateProductUseCase>(),
      addVariationUseCase: sl<AddVariationUseCase>(),
      addBarcodeUseCase: sl<AddBarcodeUseCase>(),
      getPriceListsUseCase: sl<pricing.GetPriceListsUseCase>(),
      getProductPriceUseCase: sl<pricing.GetProductPriceUseCase>(),
      setProductPriceUseCase: sl<pricing.SetProductPriceUseCase>(),
      imageUploadService: sl<ImageUploadService>(),
      authLocalDataSource: sl<AuthLocalDataSource>(),
      localDefaultPriceListId: sl<LocalCatalog>().defaultPriceListId,
      // Local copy first (POS shows it at once), then a pull to confirm it.
      onPriceSaved: (item) async {
        await sl<LocalCatalog>().rememberPrice(item);
        await sl<SyncEngine>().syncNow(manual: true);
      },
    ),
  );

  // POS customer picker: the list and the search read this device only, and
  // quick-create is a local write + outbox op. No call here can fail (or
  // wait) because of the network.
  if (sl.isRegistered<CustomerPickerCubit>()) {
    sl.unregister<CustomerPickerCubit>();
  }
  sl.registerFactory<CustomerPickerCubit>(
    () => CustomerPickerCubit(
      getCustomersUseCase:
          customers_uc.GetCustomersUseCase(sl<LocalCustomersRepository>()),
      createCustomerUseCase:
          customers_uc.CreateCustomerUseCase(sl<CustomersRepository>()),
      unsyncedCustomerIds: sl<LocalCatalog>().unsyncedCustomerIds,
    ),
  );

  if (sl.isRegistered<PosCubit>()) sl.unregister<PosCubit>();
  sl.registerFactory<PosCubit>(
    () => PosCubit(
      getProductsUseCase: GetProductsUseCase(sl<LocalProductsRepository>()),
      getCategoriesUseCase: GetCategoriesUseCase(sl<LocalProductsRepository>()),
      getProductByIdUseCase: GetProductByIdUseCase(sl<LocalProductsRepository>()),
      getProductPriceUseCase: sl<GetProductPriceUseCase>(),
      createSaleUseCase: sl<CreateSaleUseCase>(),
      getMyActiveShiftUseCase: sl<GetMyActiveShiftUseCase>(),
      openShiftUseCase: sl<OpenShiftUseCase>(),
      getShiftSummaryUseCase: sl<GetShiftSummaryUseCase>(),
      getRegistersUseCase: sl<GetRegistersUseCase>(),
      createRegisterUseCase: sl<CreateRegisterUseCase>(),
      getStockBalanceUseCase: GetStockBalanceUseCase(sl<LocalInventoryRepository>()),
      getStockBalancesUseCase: GetStockBalancesUseCase(sl<LocalInventoryRepository>()),
      getTaxRatesUseCase: GetTaxRatesUseCase(sl<LocalSettingsRepository>()),
      getSettingsUseCase: GetSettingsUseCase(sl<LocalSettingsRepository>()),
      getDiscountSchemesUseCase: sl<GetDiscountSchemesUseCase>(),
      previewSalePriceUseCase: sl<PreviewSalePriceUseCase>(),
      openTabUseCase: sl<OpenTabUseCase>(),
      addTabLinesUseCase: sl<AddTabLinesUseCase>(),
      fireTabUseCase: sl<FireTabUseCase>(),
      requestTabBillUseCase: sl<RequestTabBillUseCase>(),
      completeTabUseCase: sl<CompleteTabUseCase>(),
      getTabSaleUseCase: sl<GetTabSaleUseCase>(),
      getKotOrdersByTableUseCase: sl<GetKotOrdersByTableUseCase>(),
      resolvePosSession: sl<ResolvePosSessionUseCase>(),
      heldOrdersUseCases: sl<HeldOrdersUseCases>(),
      resolveBarcodeUseCase: sl<ResolveBarcodeUseCase>(),
      saleAttempts: sl<SaleAttemptTracker>(),
      getCustomerUseCase: customers_uc.GetCustomerUseCase(sl<LocalCustomersRepository>()),
      getCustomerBalanceUseCase:
          customers_uc.GetCustomerBalanceUseCase(sl<LocalCustomersRepository>()),
      offlinePolicy: sl<OfflinePolicy>(),
      priceChanges: sl<LocalCatalog>().priceChanges,
      stockChanges: sl<LocalCatalog>().stockChanges,
      warmModifiers: (ids) => unawaited(sl<ProductModifierCache>().warm(ids)),
      askQuantityOnTap: sl<PreferencesStorage>().getAskQuantityOnTap,
    ),
  );
}

/// Minimal user view for the wiring closures.
class UserCtx {
  const UserCtx(this.id, this.name, this.businessId, this.branchId);
  final String id;
  final String name;
  final String? businessId;
  final String? branchId;
}
