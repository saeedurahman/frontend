import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/di/foundation_module.dart';
import 'package:frantend/core/di/injection.config.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/core/offline/repos/offline_decorators.dart';
import 'package:frantend/core/offline/repos/offline_pos_repository.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/core/sync/sync_status.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:frantend/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:frantend/features/customers/domain/repositories/customers_repository.dart';
import 'package:frantend/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:frantend/features/pos/domain/repositories/pos_repository.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/returns/domain/repositories/returns_repository.dart';
import 'package:frantend/features/sales/domain/repositories/sales_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_http.dart';

/// The generated config plus the hand-written foundation module must form a
/// complete dependency graph (a missing registration would only otherwise
/// show up at runtime, on the first POS screen).
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true; // one per test
  late GetIt sl;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    sl = GetIt.asNewInstance();
    await sl.init();
    registerFoundationServices(sl);
  });

  tearDown(() => sl.reset());

  test('the sync engine graph resolves', () {
    expect(sl<SyncStore>(), isNotNull);
    expect(sl<SyncEngine>(), isNotNull);
    expect(sl<SyncStatusSource>(), isA<EngineSyncStatusSource>());
    expect(sl<ConnectivityProbe>(), isNotNull);
  });

  test('POS and management repositories are the outbox-backed ones', () {
    expect(sl<PosRepository>(), isA<OfflinePosRepository>());
    expect(sl<CustomersRepository>(), isA<OfflineCustomersRepository>());
    expect(sl<CashRegisterRepository>(), isA<OfflineCashRegisterRepository>());
    expect(sl<ExpensesRepository>(), isA<OfflineExpensesRepository>());
    expect(sl<ReturnsRepository>(), isA<OfflineReturnsRepository>());
    expect(sl<SalesRepository>(), isA<OfflineSalesRepository>());
  });

  test('the POS cubit can be built (all use cases resolve)', () async {
    final cubit = sl<PosCubit>();
    expect(cubit, isNotNull);
    await cubit.close();
  });

  test('logout uses the real guard, not the stub', () {
    expect(sl<PendingWorkGuard>(), isNot(isA<NoPendingWorkGuard>()));
    expect(sl<LogoutUseCase>(), isNotNull);
    expect(sl<AuthRepository>(), isNotNull);
  });

  test('the lease block routes to /subscription-expired and clears on logout',
      () {
    final guard = AuthGuard(FakeSecureStorage())
      ..flagsProvider = () => BusinessFeatureFlags.disabled;
    guard.setAuthenticated(true);
    expect(guard.isSubscriptionBlocked, isFalse);

    guard.setLeaseBlocked(true);
    expect(guard.isSubscriptionBlocked, isTrue);
    expect(guard.redirect('/pos'), '/subscription-expired');

    guard.setLeaseBlocked(false);
    expect(guard.isSubscriptionBlocked, isFalse);

    guard.setLeaseBlocked(true);
    guard.setAuthenticated(false);
    expect(guard.isSubscriptionBlocked, isFalse);
  });
}
