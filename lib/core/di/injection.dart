import 'package:frantend/core/di/foundation_module.dart';
import 'package:frantend/core/di/injection.config.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/security/idle_lock_service.dart';
import 'package:frantend/core/security/pin_security_service.dart';
import 'package:frantend/core/session/session_services.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await sl.init();
  registerFoundationServices(sl);
  _registerSecurityServices();
  SessionServices.register();
  SessionServices.wire();
}

/// Hand-registered (not generated) services.
void _registerSecurityServices() {
  if (!sl.isRegistered<PinSecurityService>()) {
    sl.registerLazySingleton<PinSecurityService>(
      () => PinSecurityServiceImpl(
        offlineVerifier: sl<OfflineCredentialVerifier>(),
        secureStorage: sl<SecureStorage>(),
      ),
    );
  }
  if (sl.isRegistered<IdleLockService>()) return;
  sl.registerLazySingleton<IdleLockService>(() {
    final guard = sl<AuthGuard>();
    return IdleLockService(
      preferences: sl<PreferencesStorage>(),
      authChanges: guard,
      isAuthenticated: () => guard.isAuthenticated,
      canLock: () async {
        // Kitchen displays sit idle by design; users without a PIN must never be locked out.
        if (guard.isKitchenOnlyUser) return false;
        final userId = await sl<SecureStorage>().getUserId();
        if (userId == null) return false;
        final cache = await sl<PinDeviceCache>().read();
        final slug = cache?.businessSlug.trim() ?? '';
        return sl<PinSecurityService>().hasPin(userId: userId, slug: slug);
      },
    );
  });
}
