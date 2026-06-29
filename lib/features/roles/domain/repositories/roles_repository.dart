import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/roles/data/models/permission_model.dart';
import 'package:frantend/features/roles/data/models/role_model.dart';

abstract class RolesRepository {
  Future<Either<Failure, PermissionsCatalogModel>> getPermissionsCatalog();

  Future<Either<Failure, List<RoleModel>>> getRoles();

  Future<Either<Failure, RoleModel>> getRole(String id);

  Future<Either<Failure, RoleModel>> createRole({
    required String name,
    String? description,
    required List<String> permissionKeys,
  });

  Future<Either<Failure, RoleModel>> updateRole({
    required String id,
    String? name,
    String? description,
  });

  Future<Either<Failure, void>> deleteRole(String id);

  Future<Either<Failure, RoleModel>> assignPermissions({
    required String id,
    required List<String> permissionKeys,
  });
}
