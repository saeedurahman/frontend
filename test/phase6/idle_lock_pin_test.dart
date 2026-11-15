import 'dart:convert';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/security/idle_lock_host.dart';
import 'package:frantend/core/security/idle_lock_service.dart';
import 'package:frantend/core/security/pin_security_service.dart';
import 'package:frantend/core/storage/preferences_storage.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/datasources/pin_device_cache.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/offline/credential_hasher.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/settings/presentation/widgets/security_settings_section.dart';
import 'package:frantend/features/users/domain/repositories/users_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository implements AuthRepository {
  bool isOnline = true;
  String expectedPassword = 'Password123!';
  String expectedPin = '123456';

  @override
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
    String? businessSlug,
  }) async {
    if (!isOnline) {
      return const Left(NetworkFailure('Server unreachable'));
    }
    if (password == expectedPassword) {
      return const Right(User(
        id: 'u1',
        name: 'Test Owner',
        email: 'owner@test.com',
        role: 'owner',
      ));
    }
    return const Left(AuthFailure('Invalid credentials'));
  }

  @override
  Future<Either<Failure, User>> pinLogin({
    required String businessSlug,
    required String userId,
    required String pinCode,
  }) async {
    if (!isOnline) {
      return const Left(NetworkFailure('Server unreachable'));
    }
    if (pinCode == expectedPin) {
      return const Right(User(
        id: 'u1',
        name: 'Test Owner',
        email: 'owner@test.com',
        role: 'owner',
      ));
    }
    return const Left(AuthFailure('Invalid PIN'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUsersRepository implements UsersRepository {
  String? lastResetPin;
  String? lastCurrentPassword;

  @override
  Future<Either<Failure, void>> resetUserPin({
    required String id,
    required String pinCode,
    required String currentPassword,
    String? currentPin,
  }) async {
    if (currentPassword != 'Password123!') {
      return const Left(AuthFailure('Current password is incorrect'));
    }
    lastResetPin = pinCode;
    lastCurrentPassword = currentPassword;
    if (sl.isRegistered<PinSecurityService>()) {
      await sl<PinSecurityService>().recordPinEnrolled(
        userId: id,
        slug: 'test-hop',
        pin: pinCode,
      );
    }
    return const Right(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class DirectCredentialHasher implements CredentialHasher {
  DirectCredentialHasher({this.iterations = 10});
  @override
  final int iterations;
  @override
  Uint8List newSalt() => Uint8List(16);
  @override
  Future<String> hash(String secret, Uint8List salt, {int? iterations}) async {
    return base64Encode(pbkdf2(secret, salt, iterations ?? this.iterations, 32));
  }
}

class _FakeAuthLocalDataSource implements AuthLocalDataSource {
  UserModel? user;

  @override
  Future<UserModel?> getCachedUser() async => user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late InMemorySecureKeyStore keyStore;
  late SecureStorage secureStorage;
  late OfflineCredentialVerifier offlineVerifier;
  late PinSecurityService pinSecurityService;
  late PreferencesStorage preferences;
  late _FakeAuthRepository fakeAuthRepository;
  late _FakeUsersRepository fakeUsersRepository;
  late _FakeAuthLocalDataSource fakeAuthLocalDataSource;
  late AuthGuard authGuard;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();
    preferences = PreferencesStorage(sharedPrefs);
    keyStore = InMemorySecureKeyStore();
    secureStorage = SecureStorage(keyStore);
    offlineVerifier = OfflineCredentialVerifier(
      store: keyStore,
      hasher: DirectCredentialHasher(iterations: 10),
    );
    pinSecurityService = PinSecurityServiceImpl(
      offlineVerifier: offlineVerifier,
      secureStorage: secureStorage,
    );
    fakeAuthRepository = _FakeAuthRepository();
    fakeUsersRepository = _FakeUsersRepository();
    fakeAuthLocalDataSource = _FakeAuthLocalDataSource();
    authGuard = AuthGuard(secureStorage);

    await secureStorage.saveUserId('u1');
    await secureStorage.saveTokens(accessToken: 'tok', refreshToken: 'ref');

    fakeAuthLocalDataSource.user = const UserModel(
      id: 'u1',
      name: 'Test Hop 3',
      email: 'owner@test.com',
      role: 'owner',
      businessSlug: 'test-hop',
    );

    // Register test dependencies in sl
    if (sl.isRegistered<SecureStorage>()) sl.unregister<SecureStorage>();
    sl.registerSingleton<SecureStorage>(secureStorage);

    if (sl.isRegistered<OfflineCredentialVerifier>()) sl.unregister<OfflineCredentialVerifier>();
    sl.registerSingleton<OfflineCredentialVerifier>(offlineVerifier);

    if (sl.isRegistered<PinSecurityService>()) sl.unregister<PinSecurityService>();
    sl.registerSingleton<PinSecurityService>(pinSecurityService);

    if (sl.isRegistered<PreferencesStorage>()) sl.unregister<PreferencesStorage>();
    sl.registerSingleton<PreferencesStorage>(preferences);

    if (sl.isRegistered<AuthRepository>()) sl.unregister<AuthRepository>();
    sl.registerSingleton<AuthRepository>(fakeAuthRepository);

    if (sl.isRegistered<UsersRepository>()) sl.unregister<UsersRepository>();
    sl.registerSingleton<UsersRepository>(fakeUsersRepository);

    if (sl.isRegistered<AuthLocalDataSource>()) sl.unregister<AuthLocalDataSource>();
    sl.registerSingleton<AuthLocalDataSource>(fakeAuthLocalDataSource);

    if (sl.isRegistered<PinDeviceCache>()) sl.unregister<PinDeviceCache>();
    sl.registerSingleton<PinDeviceCache>(PinDeviceCacheImpl(secureStorage));
    await sl<PinDeviceCache>().write(const PinDeviceCacheData(
      businessSlug: 'test-hop',
      staff: [PinStaffEntry(id: 'u1', fullName: 'Test Hop 3')],
    ));
  });

  tearDown(() {
    if (sl.isRegistered<IdleLockService>()) {
      sl<IdleLockService>().dispose();
      sl.unregister<IdleLockService>();
    }
  });

  group('Phase 6a BUG 2: Idle Lock & PIN Requirements', () {
    test('(a) users with no PIN are NEVER locked out after idle timeout', () async {
      var clock = DateTime(2026, 1, 1);
      final lockService = IdleLockService(
        preferences: preferences,
        authChanges: authGuard,
        isAuthenticated: () => true,
        canLock: () async {
          final userId = await secureStorage.getUserId();
          if (userId == null) return false;
          return pinSecurityService.hasPin(userId: userId, slug: 'test-hop');
        },
        now: () => clock,
      );
      if (sl.isRegistered<IdleLockService>()) sl.unregister<IdleLockService>();
      sl.registerSingleton<IdleLockService>(lockService);

      // Verify user has no PIN
      expect(await pinSecurityService.hasPin(userId: 'u1', slug: 'test-hop'), isFalse);

      fakeAsync((async) {
        lockService.start();
        // Elapse past default 10 minutes timeout
        async.elapse(const Duration(minutes: 10, seconds: 5));
        clock = clock.add(const Duration(minutes: 10, seconds: 5));
        async.flushMicrotasks();

        // User must NOT be locked because canLock returns false
        expect(lockService.locked.value, isFalse);

        // Even after an hour of inactivity, still not locked
        async.elapse(const Duration(hours: 1));
        clock = clock.add(const Duration(hours: 1));
        async.flushMicrotasks();
        expect(lockService.locked.value, isFalse);
      });

      // Now enroll a PIN for the user
      await pinSecurityService.recordPinEnrolled(userId: 'u1', slug: 'test-hop', pin: '123456');
      expect(await pinSecurityService.hasPin(userId: 'u1', slug: 'test-hop'), isTrue);

      fakeAsync((async) {
        clock = clock.add(const Duration(seconds: 5));
        lockService.recordActivity();
        async.elapse(const Duration(minutes: 10, seconds: 5));
        clock = clock.add(const Duration(minutes: 10, seconds: 5));
        async.flushMicrotasks();

        // Now user HAS a PIN, so terminal locks as expected
        expect(lockService.locked.value, isTrue);
      });
    });

    testWidgets('(b) if a user is locked and has no PIN, offers unlock with account password', (tester) async {
      final lockService = IdleLockService(
        preferences: preferences,
        authChanges: authGuard,
        isAuthenticated: () => true,
        canLock: () async => false,
      );
      if (sl.isRegistered<IdleLockService>()) sl.unregister<IdleLockService>();
      sl.registerSingleton<IdleLockService>(lockService);

      // Force lock screen (e.g. manual lock)
      lockService.lock();
      expect(lockService.locked.value, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          home: IdleLockHost(
            service: lockService,
            child: const Scaffold(body: Text('Protected App Content')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Since user has no PIN, lock screen must offer password unlock directly
      expect(find.textContaining('No PIN set'), findsOneWidget);
      expect(find.text('Account Password'), findsOneWidget);
      expect(find.text('Unlock'), findsOneWidget);

      // Enter correct account password
      await tester.enterText(find.byType(TextField), 'Password123!');
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      // Screen must unlock!
      expect(lockService.locked.value, isFalse);
      expect(find.text('Protected App Content'), findsOneWidget);
    });

    testWidgets('(d) unlocking offline works through the stored offline verifier', (tester) async {
      final lockService = IdleLockService(
        preferences: preferences,
        authChanges: authGuard,
        isAuthenticated: () => true,
      );
      if (sl.isRegistered<IdleLockService>()) sl.unregister<IdleLockService>();
      sl.registerSingleton<IdleLockService>(lockService);

      // Enroll password in offline verifier
      await offlineVerifier.enroll(
        kind: OfflineCredentialKind.password,
        tenantKey: 'test-hop',
        identity: 'u1',
        userId: 'u1',
        secret: 'OfflineSecret!99',
      );

      // Make remote auth repository offline
      fakeAuthRepository.isOnline = false;

      // Lock screen
      lockService.lock();

      await tester.pumpWidget(
        MaterialApp(
          home: IdleLockHost(
            service: lockService,
            child: const Scaffold(body: Text('Offline Content')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Wrong password attempt
      await tester.enterText(find.byType(TextField), 'WrongPassword!');
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      // Remains locked and shows offline failure with attempts remaining
      expect(lockService.locked.value, isTrue);
      expect(find.textContaining('Incorrect password'), findsOneWidget);

      // Correct password attempt
      await tester.enterText(find.byType(TextField), 'OfflineSecret!99');
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      // Successfully unlocked offline!
      expect(lockService.locked.value, isFalse);
      expect(find.text('Offline Content'), findsOneWidget);
    });

    testWidgets('(c) Settings > Security shows whether PIN is set, lets user set one with current password, and explains idle lock', (tester) async {
      final lockService = IdleLockService(
        preferences: preferences,
        authChanges: authGuard,
        isAuthenticated: () => true,
      );
      if (sl.isRegistered<IdleLockService>()) sl.unregister<IdleLockService>();
      sl.registerSingleton<IdleLockService>(lockService);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SecuritySettingsSection(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Shows "Not set" initially
      expect(find.text('Terminal PIN'), findsOneWidget);
      expect(find.text('Not set'), findsOneWidget);
      expect(find.text('Set PIN'), findsOneWidget);

      // 2. Explains idle auto-lock in plain language
      expect(find.textContaining('Protects your terminal when you step away'), findsOneWidget);
      expect(find.textContaining('Auto-lock is disabled until you set a PIN'), findsOneWidget);

      // 3. Tap "Set PIN" to open dialog
      await tester.tap(find.text('Set PIN'));
      await tester.pumpAndSettle();

      expect(find.text('Set Terminal PIN'), findsOneWidget);
      expect(find.text('Current Password *'), findsOneWidget);
      expect(find.text('New 6-digit PIN *'), findsOneWidget);
      expect(find.text('Confirm New PIN *'), findsOneWidget);

      // Try saving without current password
      await tester.tap(find.text('Save PIN'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your current account password'), findsOneWidget);

      // Fill in current password and mismatching PINs
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Password123!');
      await tester.enterText(textFields.at(1), '123456');
      await tester.enterText(textFields.at(2), '654321');
      await tester.tap(find.text('Save PIN'));
      await tester.pumpAndSettle();
      expect(find.text('PINs do not match'), findsOneWidget);

      // Fill in matching 6-digit PIN
      await tester.enterText(textFields.at(2), '123456');
      await tester.tap(find.text('Save PIN'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Dialog closed, PIN successfully set
      expect(fakeUsersRepository.lastResetPin, equals('123456'));
      expect(fakeUsersRepository.lastCurrentPassword, equals('Password123!'));

      // Badge updated to "Set" and button updated to "Change PIN"
      expect(find.text('Set'), findsOneWidget);
      expect(find.text('Change PIN'), findsOneWidget);
      expect(await pinSecurityService.hasPin(userId: 'u1', slug: 'test-hop'), isTrue);
    });
  });
}
