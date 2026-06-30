import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/users/data/datasources/users_remote_datasource.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';
import 'package:frantend/features/users/domain/repositories/users_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UsersRepository)
class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl({
    required UsersRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final UsersRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, List<StaffUserModel>>> getUsers({String? role}) async {
    try {
      return Right(await _remote.getUsers(role: role));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StaffUserModel>> getUser(String id) async {
    try {
      return Right(await _remote.getUser(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StaffUserModel>> createUser({
    required String fullName,
    required String phone,
    required String password,
    String? branchId,
    required List<String> roleIds,
  }) async {
    try {
      return Right(
        await _remote.createUser(
          fullName: fullName,
          phone: phone,
          password: password,
          branchId: branchId,
          roleIds: roleIds,
        ),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StaffUserModel>> updateUser({
    required String id,
    String? fullName,
    String? branchId,
    bool? isActive,
  }) async {
    try {
      return Right(
        await _remote.updateUser(
          id: id,
          fullName: fullName,
          branchId: branchId,
          isActive: isActive,
        ),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StaffUserModel>> replaceUserRoles({
    required String id,
    required List<String> roleIds,
  }) async {
    try {
      return Right(
        await _remote.replaceUserRoles(id: id, roleIds: roleIds),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await _remote.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> resetUserPin({
    required String id,
    required String pinCode,
  }) async {
    try {
      await _remote.resetUserPin(id: id, pinCode: pinCode);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
