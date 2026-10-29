import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frantend/features/auth/data/models/token_model.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frantend/features/auth/domain/offline/credential_hasher.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';
import 'package:frantend/features/auth/domain/usecases/seed_pin_device_cache_usecase.dart';
import 'package:frantend/features/restaurant/domain/usecases/load_business_session_usecase.dart';

import '../helpers/fake_http.dart';

const _phone = '+923001234567';
const _user = UserModel(
  id: 'u1',
  name: 'Ali',
  role: 'owner',
  businessId: 't1',
  businessSlug: 'acme',
);

class _Remote implements AuthRemoteDataSource {
  bool offline = false;
  String correctPassword = 'Secret#1';
  String correctPin = '1234';
  int logins = 0;

  Never _drop() => throw DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.connectionError,
      );

  @override
  Future<TokenModel> login({
    required String phone,
    required String password,
    String? businessSlug,
  }) async {
    if (offline) _drop();
    logins++;
    if (password != correctPassword) {
      throw DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
          data: {'detail': 'Invalid credentials'},
        ),
      );
    }
    return const TokenModel(
      accessToken: 'a',
      refreshToken: 'r',
      tokenType: 'bearer',
      tenantId: 't1',
      user: _user,
    );
  }

  @override
  Future<TokenModel> pinLogin({
    required String businessSlug,
    required String userId,
    required String pinCode,
  }) async {
    if (offline) _drop();
    return const TokenModel(
      accessToken: 'a2',
      refreshToken: 'r2',
      tokenType: 'bearer',
      tenantId: 't1',
      user: _user,
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserModel> getCurrentUser() async => _user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Seed extends Fake implements SeedPinDeviceCacheUseCase {
  @override
  Future<void> call(user) async {}
}

class _Session extends Fake implements LoadBusinessSessionUseCase {
  int resets = 0;

  @override
  Future<void> call() async {}

  @override
  void reset() => resets++;
}

class _Local implements AuthLocalDataSource {
  _Local(this.storage, this.db);

  final FakeSecureStorage storage;
  final AppDatabase db;
  UserModel? cached;

  @override
  Future<void> cacheUser(UserModel user) async => cached = user;

  @override
  Future<UserModel?> getCachedUser() async => cached;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? tenantId,
    String? userId,
  }) async {
    await storage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    if (userId != null) await storage.saveUserId(userId);
  }

  @override
  Future<void> clearSession() => storage.clearAuthSession();

  @override
  Future<bool> hasSession() => storage.hasValidSession();
}

void main() {
  late _Remote remote;
  late _Local local;
  late FakeSecureStorage storage;
  late InMemorySecureKeyStore keys;
  late OfflineCredentialVerifier verifier;
  late LocalDataLifecycle lifecycle;
  late AppDatabase db;
  late FixedConnectivityProbe probe;
  late _Session session;
  late AuthRepositoryImpl repo;

  setUp(() {
    remote = _Remote();
    storage = FakeSecureStorage();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    local = _Local(storage, db);
    keys = InMemorySecureKeyStore();
    verifier = OfflineCredentialVerifier(
      store: keys,
      hasher: Pbkdf2CredentialHasher(iterations: 100),
    );
    lifecycle = LocalDataLifecycle(
      database: db,
      offlineCredentials: verifier,
      secureStore: keys,
    );
    probe = FixedConnectivityProbe();
    session = _Session();
    repo = AuthRepositoryImpl(
      remoteDataSource: remote,
      localDataSource: local,
      connectivityProbe: probe,
      errorHandler: const ErrorHandler(),
      seedPinDeviceCache: _Seed(),
      loadBusinessSession: session,
      offlineCredentials: verifier,
      localDataLifecycle: lifecycle,
    );
  });

  tearDown(() => db.close());

  Future<void> onlineLogin() async {
    final r = await repo.login(
      phone: _phone,
      password: 'Secret#1',
      businessSlug: 'acme',
    );
    expect(r.isRight(), isTrue);
  }

  group('offline password login', () {
    test('works for a user who logged in online on this device', () async {
      await onlineLogin();
      remote.offline = true;

      final r = await repo.login(phone: _phone, password: 'Secret#1');

      expect(r.isRight(), isTrue);
      expect(r.getOrElse(() => throw 'x').id, 'u1');
    });

    test('a wrong password offline is refused with attempts left', () async {
      await onlineLogin();
      remote.offline = true;

      final r = await repo.login(phone: _phone, password: 'wrong');

      final failure = r.fold((f) => f, (_) => null);
      expect(failure, isA<AuthFailure>());
      expect(failure!.message, contains('4 attempt'));
    });

    test('locks after 5 wrong tries and needs an online login', () async {
      await onlineLogin();
      remote.offline = true;
      for (var i = 0; i < 5; i++) {
        await repo.login(phone: _phone, password: 'bad$i');
      }
      final locked = await repo.login(phone: _phone, password: 'Secret#1');
      expect(locked.fold((f) => f.message, (_) => ''), contains('online'));

      // Back online: a real login unlocks offline sign-in again.
      remote.offline = false;
      await onlineLogin();
      remote.offline = true;
      expect(
        (await repo.login(phone: _phone, password: 'Secret#1')).isRight(),
        isTrue,
      );
    });

    test('a user never seen online cannot sign in offline', () async {
      remote.offline = true;
      // Even with a leftover session on the device.
      await storage.saveTokens(accessToken: 'a', refreshToken: 'r');
      local.cached = _user;

      final r = await repo.login(phone: _phone, password: 'Secret#1');

      expect(r.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });

    test('the old bypass is gone: cached user + session is not enough',
        () async {
      await onlineLogin();
      remote.offline = true;
      // Right user cached, session present, but a stranger types any password.
      final r = await repo.login(phone: _phone, password: 'whatever');
      expect(r.isLeft(), isTrue);
    });

    test('a server answer (401) never falls back to offline', () async {
      await onlineLogin();
      final r = await repo.login(phone: _phone, password: 'wrong');
      expect(r.fold((f) => f, (_) => null), isA<AuthFailure>());
      // Still online-only error text, no "attempts left" offline wording.
      expect(r.fold((f) => f.message, (_) => ''), isNot(contains('attempt')));
    });

    test('offline login needs the session to still be on the device', () async {
      await onlineLogin();
      await storage.clearAuthSession();
      remote.offline = true;

      final r = await repo.login(phone: _phone, password: 'Secret#1');

      expect(r.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });
  });

  group('offline PIN login (idle-lock unlock)', () {
    test('verifies against the PIN used at the last online PIN login',
        () async {
      await repo.pinLogin(businessSlug: 'acme', userId: 'u1', pinCode: '1234');
      remote.offline = true;

      final ok = await repo.pinLogin(
        businessSlug: 'acme',
        userId: 'u1',
        pinCode: '1234',
      );
      final bad = await repo.pinLogin(
        businessSlug: 'acme',
        userId: 'u1',
        pinCode: '9999',
      );

      expect(ok.isRight(), isTrue);
      expect(bad.isLeft(), isTrue);
    });

    test('PIN lockout after 5 failures', () async {
      await repo.pinLogin(businessSlug: 'acme', userId: 'u1', pinCode: '1234');
      remote.offline = true;
      for (var i = 0; i < 5; i++) {
        await repo.pinLogin(businessSlug: 'acme', userId: 'u1', pinCode: '000$i');
      }
      final r = await repo.pinLogin(
        businessSlug: 'acme',
        userId: 'u1',
        pinCode: '1234',
      );
      expect(r.isLeft(), isTrue);
    });
  });

  group('logout / tenant switch', () {
    test('logout wipes the verifier and tenant data', () async {
      await onlineLogin();
      await db.into(db.masterDataCacheTable).insert(
            MasterDataCacheTableCompanion.insert(
              cacheKey: 'k',
              jsonData: '{}',
              cachedAt: DateTime.now(),
            ),
          );

      final r = await repo.logout();

      expect(r.isRight(), isTrue);
      expect(await db.select(db.masterDataCacheTable).get(), isEmpty);
      expect(keys.values.containsKey(OfflineCredentialVerifier.storageKey),
          isFalse);
      expect(session.resets, 1);
      expect(await storage.hasValidSession(), isFalse);
    });

    test('after logout nobody can sign in offline', () async {
      await onlineLogin();
      await repo.logout();
      remote.offline = true;
      await storage.saveTokens(accessToken: 'a', refreshToken: 'r');
      final r = await repo.login(phone: _phone, password: 'Secret#1');
      expect(r.fold((f) => f, (_) => null), isA<NetworkFailure>());
    });

    test('signing into a different business wipes the previous one', () async {
      await onlineLogin(); // tenant t1
      await db.into(db.masterDataCacheTable).insert(
            MasterDataCacheTableCompanion.insert(
              cacheKey: 'k',
              jsonData: '{}',
              cachedAt: DateTime.now(),
            ),
          );
      expect(await lifecycle.onTenantSignedIn('t1'), isFalse);
      expect(await lifecycle.onTenantSignedIn('t2'), isTrue);
      expect(await db.select(db.masterDataCacheTable).get(), isEmpty);
    });
  });
}
