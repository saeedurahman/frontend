import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/roles/data/datasources/roles_remote_datasource.dart';
import 'package:frantend/features/roles/data/models/permission_model.dart';
import 'package:frantend/features/roles/data/models/role_model.dart';
import 'package:frantend/features/roles/domain/repositories/roles_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RolesRepository)
class RolesRepositoryImpl implements RolesRepository {
  RolesRepositoryImpl({
    required RolesRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final RolesRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, PermissionsCatalogModel>> getPermissionsCatalog() async {
    try {
      return Right(await _remote.getPermissionsCatalog());
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<RoleModel>>> getRoles() async {
    try {
      return Right(await _remote.getRoles());
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RoleModel>> getRole(String id) async {
    try {
      return Right(await _remote.getRole(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RoleModel>> createRole({
    required String name,
    String? description,
    required List<String> permissionKeys,
  }) async {
    try {
      return Right(
        await _remote.createRole(
          name: name,
          description: description,
          permissionKeys: permissionKeys,
        ),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RoleModel>> updateRole({
    required String id,
    String? name,
    String? description,
  }) async {
    try {
      return Right(
        await _remote.updateRole(id: id, name: name, description: description),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRole(String id) async {
    try {
      await _remote.deleteRole(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RoleModel>> assignPermissions({
    required String id,
    required List<String> permissionKeys,
  }) async {
    try {
      return Right(
        await _remote.assignPermissions(id: id, permissionKeys: permissionKeys),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
