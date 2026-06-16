import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/exceptions.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required ErrorHandler errorHandler,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo,
        _errorHandler = errorHandler;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        final cached = await _localDataSource.getCachedUser();
        if (cached != null && await _localDataSource.hasSession()) {
          return Right(cached.toEntity());
        }
        return const Left(NetworkFailure());
      }

      final token = await _remoteDataSource.login(
        phone: phone,
        password: password,
      );

      await _localDataSource.saveTokens(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
        tenantId: token.tenantId,
        userId: token.user?.id,
      );

      User user;
      if (token.user != null) {
        await _localDataSource.cacheUser(token.user!);
        user = token.user!.toEntity();
      } else {
        final remoteUser = await _remoteDataSource.getCurrentUser();
        await _localDataSource.cacheUser(remoteUser);
        user = remoteUser.toEntity();
      }

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, User>> pinLogin({
    required String pin,
    required String userId,
  }) async {
    try {
      final token = await _remoteDataSource.pinLogin(pin: pin, userId: userId);

      await _localDataSource.saveTokens(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
        tenantId: token.tenantId,
        userId: token.user?.id ?? userId,
      );

      if (token.user != null) {
        await _localDataSource.cacheUser(token.user!);
        return Right(token.user!.toEntity());
      }

      final remoteUser = await _remoteDataSource.getCurrentUser();
      await _localDataSource.cacheUser(remoteUser);
      return Right(remoteUser.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, User>> registerBusiness(
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await _remoteDataSource.registerBusiness(data);

      await _localDataSource.saveTokens(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
        tenantId: token.tenantId,
        userId: token.user?.id,
      );

      User user;
      if (token.user != null) {
        await _localDataSource.cacheUser(token.user!);
        user = token.user!.toEntity();
      } else {
        final remoteUser = await _remoteDataSource.getCurrentUser();
        await _localDataSource.cacheUser(remoteUser);
        user = remoteUser.toEntity();
      }

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.logout();
      }
      await _localDataSource.clearSession();
      return const Right(null);
    } catch (e) {
      await _localDataSource.clearSession();
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      if (await _networkInfo.isConnected) {
        final remoteUser = await _remoteDataSource.getCurrentUser();
        await _localDataSource.cacheUser(remoteUser);
        return Right(remoteUser.toEntity());
      }

      final cached = await _localDataSource.getCachedUser();
      if (cached != null) return Right(cached.toEntity());
      return const Left(CacheFailure('No cached user found'));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<bool> isAuthenticated() => _localDataSource.hasSession();
}
