import 'package:dartz/dartz.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/exceptions.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/lifecycle/local_data_lifecycle.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frantend/features/auth/data/models/token_model.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/auth/domain/usecases/seed_pin_device_cache_usecase.dart';
import 'package:frantend/features/restaurant/domain/usecases/load_business_session_usecase.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required ConnectivityProbe connectivityProbe,
    required ErrorHandler errorHandler,
    required SeedPinDeviceCacheUseCase seedPinDeviceCache,
    required LoadBusinessSessionUseCase loadBusinessSession,
    required OfflineCredentialVerifier offlineCredentials,
    required LocalDataLifecycle localDataLifecycle,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _probe = connectivityProbe,
        _errorHandler = errorHandler,
        _seedPinDeviceCache = seedPinDeviceCache,
        _loadBusinessSession = loadBusinessSession,
        _offlineCredentials = offlineCredentials,
        _lifecycle = localDataLifecycle;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final ConnectivityProbe _probe;
  final ErrorHandler _errorHandler;
  final SeedPinDeviceCacheUseCase _seedPinDeviceCache;
  final LoadBusinessSessionUseCase _loadBusinessSession;
  final OfflineCredentialVerifier _offlineCredentials;
  final LocalDataLifecycle _lifecycle;

  Future<void> _refreshBusinessSession() async {
    if (_probe.isReachable) {
      await _loadBusinessSession();
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
    String? businessSlug,
  }) async {
    final TokenModel token;
    try {
      token = await _remoteDataSource.login(
        phone: phone,
        password: password,
        businessSlug: businessSlug,
      );
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      final failure = _errorHandler.mapExceptionToFailure(e);
      // The server could not be reached at all: fall back to the local
      // verifier. A server *answer* (wrong password, 4xx/5xx) never does.
      if (failure is NetworkFailure) {
        return _offlineLogin(
          kind: OfflineCredentialKind.password,
          identity: phone,
          tenantKey: businessSlug,
          secret: password,
        );
      }
      return Left(failure);
    }

    try {
      await _lifecycle.onTenantSignedIn(token.tenantId);
      final user = await _completeOnlineLogin(token);
      await _offlineCredentials.enroll(
        kind: OfflineCredentialKind.password,
        tenantKey: user.businessSlug ?? businessSlug ?? '',
        identity: phone,
        userId: user.id,
        secret: password,
      );
      await _seedPinDeviceCache(user);
      await _refreshBusinessSession();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, User>> pinLogin({
    required String businessSlug,
    required String userId,
    required String pinCode,
  }) async {
    final TokenModel token;
    try {
      token = await _remoteDataSource.pinLogin(
        businessSlug: businessSlug,
        userId: userId,
        pinCode: pinCode,
      );
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      final failure = _errorHandler.mapExceptionToFailure(e);
      if (failure is NetworkFailure) {
        return _offlineLogin(
          kind: OfflineCredentialKind.pin,
          identity: userId,
          tenantKey: businessSlug,
          secret: pinCode,
        );
      }
      return Left(failure);
    }

    try {
      await _lifecycle.onTenantSignedIn(token.tenantId);
      final user = await _completeOnlineLogin(token, fallbackUserId: userId);
      await _offlineCredentials.enroll(
        kind: OfflineCredentialKind.pin,
        tenantKey: businessSlug,
        identity: userId,
        userId: user.id,
        secret: pinCode,
      );
      await _seedPinDeviceCache(user);
      await _refreshBusinessSession();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  /// Persists tokens + profile of a successful online login.
  Future<User> _completeOnlineLogin(
    TokenModel token, {
    String? fallbackUserId,
  }) async {
    await _localDataSource.saveTokens(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      tenantId: token.tenantId,
      userId: token.user?.id ?? fallbackUserId,
    );
    final model = token.user ?? await _remoteDataSource.getCurrentUser();
    await _localDataSource.cacheUser(model);
    return model.toEntity();
  }

  /// Sign-in without the server. Only possible for a user who already signed
  /// in online on this device (a verifier exists), whose session is still on
  /// the device, and who has not hit the failure lockout.
  Future<Either<Failure, User>> _offlineLogin({
    required OfflineCredentialKind kind,
    required String identity,
    required String secret,
    String? tenantKey,
  }) async {
    const needsOnline = NetworkFailure(
      'No connection. Sign in once while online on this device to enable '
      'offline sign-in.',
    );
    if (!await _localDataSource.hasSession()) return const Left(needsOnline);

    final result = await _offlineCredentials.verify(
      kind: kind,
      identity: identity,
      tenantKey: tenantKey,
      secret: secret,
    );
    switch (result) {
      case OfflineVerified(:final userId):
        final cached = await _localDataSource.getCachedUser();
        if (cached == null || cached.id != userId) {
          return const Left(needsOnline);
        }
        return Right(cached.toEntity());
      case OfflineWrongSecret(:final attemptsLeft):
        final what = kind == OfflineCredentialKind.pin ? 'PIN' : 'password';
        return Left(AuthFailure(
          'Incorrect $what. $attemptsLeft attempt(s) left before offline '
          'sign-in is locked.',
        ));
      case OfflineLockedOut():
        return const Left(AuthFailure(
          'Too many wrong attempts. Connect to the internet and sign in '
          'online to unlock.',
        ));
      case OfflineNotEnrolled():
        return const Left(needsOnline);
    }
  }

  @override
  Future<Either<Failure, User>> registerBusiness(
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await _remoteDataSource.registerBusiness(data);
      await _lifecycle.onTenantSignedIn(token.tenantId);
      final user = await _completeOnlineLogin(token);
      await _seedPinDeviceCache(user);
      await _refreshBusinessSession();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      // The old offline verifier no longer matches the server password;
      // drop it so the next online login creates a fresh one.
      await _offlineCredentials.wipe();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (_probe.isReachable) {
        try {
          await _remoteDataSource.logout();
        } catch (_) {
          // Best effort: the local sign-out below must happen regardless.
        }
      }
      await _signOutLocally();
      return const Right(null);
    } catch (e) {
      await _signOutLocally();
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  Future<void> _signOutLocally() async {
    await _localDataSource.clearSession();
    _loadBusinessSession.reset();
    try {
      await _lifecycle.wipeOnLogout();
    } catch (_) {
      // The session is already gone; a failed wipe must not block sign-out.
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      if (_probe.isReachable) {
        final remoteUser = await _remoteDataSource.getCurrentUser();
        await _localDataSource.cacheUser(remoteUser);
        await _refreshBusinessSession();
        return Right(remoteUser.toEntity());
      }

      return await _cachedUser();
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      final failure = _errorHandler.mapExceptionToFailure(e);
      // Cold start with no network: the probe has not run yet, so the
      // request itself is the first to find out. Use the cached profile.
      if (failure is NetworkFailure) return _cachedUser();
      return Left(failure);
    }
  }

  Future<Either<Failure, User>> _cachedUser() async {
    final cached = await _localDataSource.getCachedUser();
    if (cached != null) return Right(cached.toEntity());
    return const Left(CacheFailure('No cached user found'));
  }

  @override
  Future<bool> isAuthenticated() => _localDataSource.hasSession();
}
