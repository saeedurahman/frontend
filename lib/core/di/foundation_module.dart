import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:frantend/core/identity/device_identity.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/core/platform/app_window_service.dart';
import 'package:frantend/core/platform/barcode_scanner_service.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/core/sync/sync_status.dart';
import 'package:frantend/features/auth/domain/offline/credential_hasher.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/pos/data/repositories/barcode_cache_repository_impl.dart';
import 'package:frantend/features/pos/data/repositories/held_orders_repository_impl.dart';
import 'package:frantend/features/pos/domain/repositories/barcode_cache_repository.dart';
import 'package:frantend/features/pos/domain/repositories/held_orders_repository.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:get_it/get_it.dart';

/// Hand-registered Phase 4a services: platform adapters, identity,
/// reachability, offline credentials and local-data lifecycle.
///
/// Kept out of the generated `injection.config.dart` so the adapters can be
/// swapped per platform (Windows now, mobile later) in exactly one place.
void registerFoundationServices(GetIt sl) {
  void once<T extends Object>(T Function() create) {
    if (!sl.isRegistered<T>()) sl.registerLazySingleton<T>(create);
  }

  // ── Platform adapters (Windows implementations) ──────────────────────
  once<SecureKeyStore>(() => const FlutterSecureKeyStore());
  once<PrinterService>(() => const WindowsPrinterService());
  once<FileSaverService>(() => const WindowsFileSaverService());
  once<AppWindowService>(() => WindowsAppWindowService());
  once<BarcodeScannerService>(() => KeyboardWedgeBarcodeScanner());

  // ── Identity ─────────────────────────────────────────────────────────
  once<IdGenerator>(() => UuidIdGenerator());
  once<DeviceIdentity>(
    () => DeviceIdentity(
      store: sl<SecureKeyStore>(),
      ids: sl<IdGenerator>(),
    ),
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
  once<SyncStatusSource>(
    () => ProbeBackedSyncStatusSource(sl<ConnectivityProbe>()),
  );

  // ── Offline credentials + local data lifecycle ───────────────────────
  once<CredentialHasher>(() => Pbkdf2CredentialHasher());
  once<OfflineCredentialVerifier>(
    () => OfflineCredentialVerifier(
      store: sl<SecureKeyStore>(),
      hasher: sl<CredentialHasher>(),
    ),
  );
  once<PendingWorkGuard>(() => const NoPendingWorkGuard());
  once<LocalDataLifecycle>(
    () => LocalDataLifecycle(
      database: sl<AppDatabase>(),
      offlineCredentials: sl<OfflineCredentialVerifier>(),
      secureStore: sl<SecureKeyStore>(),
      clearPinRoster: () => sl<SecureStorage>().clearPinDeviceCache(),
    ),
  );

  // ── POS ports ────────────────────────────────────────────────────────
  once<HeldOrdersRepository>(
    () => HeldOrdersRepositoryImpl(sl<HeldOrdersDao>()),
  );
  once<BarcodeCacheRepository>(
    () => BarcodeCacheRepositoryImpl(sl<MasterDataCacheDao>()),
  );
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
      sl<GetProductByIdUseCase>(),
    ),
  );
  // Per-cubit state (the retry id), so a factory, not a singleton.
  if (!sl.isRegistered<SaleAttemptTracker>()) {
    sl.registerFactory<SaleAttemptTracker>(
      () => SaleAttemptTracker(sl<IdGenerator>()),
    );
  }
}
