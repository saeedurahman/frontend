import 'package:frantend/core/di/injection.config.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/security/idle_lock_service.dart';
import 'package:frantend/core/session/session_services.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
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
  _registerSecurityServices();
  SessionServices.register();
  SessionServices.wire();
}

/// Hand-registered (not generated) services.
void _registerSecurityServices() {
  if (sl.isRegistered<IdleLockService>()) return;
  sl.registerLazySingleton<IdleLockService>(() {
    final guard = sl<AuthGuard>();
    return IdleLockService(
      preferences: sl<PreferencesStorage>(),
      authChanges: guard,
      isAuthenticated: () => guard.isAuthenticated,
      canLock: () async {
        // Kitchen displays sit idle by design; users without a PIN could not
        // get back in.
        if (guard.isKitchenOnlyUser) return false;
        final userId = await sl<SecureStorage>().getUserId();
        final cache = await sl<PinDeviceCache>().read();
        if (userId == null || cache == null) return false;
        return cache.businessSlug.trim().isNotEmpty &&
            cache.staff.any((s) => s.id == userId);
      },
    );
  });
}
