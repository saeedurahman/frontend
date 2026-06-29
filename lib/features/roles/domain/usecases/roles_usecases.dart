import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/roles/data/models/permission_model.dart';
import 'package:frantend/features/roles/data/models/role_model.dart';
import 'package:frantend/features/roles/domain/repositories/roles_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPermissionsCatalogUseCase {
  const GetPermissionsCatalogUseCase(this._repository);

  final RolesRepository _repository;

  Future<Either<Failure, PermissionsCatalogModel>> call() =>
      _repository.getPermissionsCatalog();
}

@injectable
class GetRolesUseCase {
  const GetRolesUseCase(this._repository);

  final RolesRepository _repository;

  Future<Either<Failure, List<RoleModel>>> call() => _repository.getRoles();
}

@injectable
class GetRoleUseCase {
  const GetRoleUseCase(this._repository);

  final RolesRepository _repository;

  Future<Either<Failure, RoleModel>> call(String id) =>
      _repository.getRole(id);
}

@injectable
class CreateRoleUseCase {
  const CreateRoleUseCase(this._repository);

  final RolesRepository _repository;

  Future<Either<Failure, RoleModel>> call({
    required String name,
    String? description,
    required List<String> permissionKeys,
  }) =>
      _repository.createRole(
        name: name,
        description: description,
        permissionKeys: permissionKeys,
      );
}

@injectable
class UpdateRoleUseCase {
  const UpdateRoleUseCase(this._repository);

  final RolesRepository _repository;

  Future<Either<Failure, RoleModel>> call({
    required String id,
    String? name,
    String? description,
  }) =>
      _repository.updateRole(id: id, name: name, description: description);
}

@injectable
class DeleteRoleUseCase {
  const DeleteRoleUseCase(this._repository);

  final RolesRepository _repository;

  Future<Either<Failure, void>> call(String id) => _repository.deleteRole(id);
}

@injectable
class AssignRolePermissionsUseCase {
  const AssignRolePermissionsUseCase(this._repository);

  final RolesRepository _repository;

  Future<Either<Failure, RoleModel>> call({
    required String id,
    required List<String> permissionKeys,
  }) =>
      _repository.assignPermissions(id: id, permissionKeys: permissionKeys);
}
