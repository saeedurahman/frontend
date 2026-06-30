import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';
import 'package:frantend/features/users/domain/repositories/users_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUsersUseCase {
  const GetUsersUseCase(this._repository);
  final UsersRepository _repository;

  Future<Either<Failure, List<StaffUserModel>>> call({String? role}) =>
      _repository.getUsers(role: role);
}

@injectable
class GetUserUseCase {
  const GetUserUseCase(this._repository);
  final UsersRepository _repository;

  Future<Either<Failure, StaffUserModel>> call(String id) =>
      _repository.getUser(id);
}

@injectable
class CreateUserUseCase {
  const CreateUserUseCase(this._repository);
  final UsersRepository _repository;

  Future<Either<Failure, StaffUserModel>> call({
    required String fullName,
    required String phone,
    required String password,
    String? branchId,
    required List<String> roleIds,
  }) =>
      _repository.createUser(
        fullName: fullName,
        phone: phone,
        password: password,
        branchId: branchId,
        roleIds: roleIds,
      );
}

@injectable
class UpdateUserUseCase {
  const UpdateUserUseCase(this._repository);
  final UsersRepository _repository;

  Future<Either<Failure, StaffUserModel>> call({
    required String id,
    String? fullName,
    String? branchId,
    bool? isActive,
  }) =>
      _repository.updateUser(
        id: id,
        fullName: fullName,
        branchId: branchId,
        isActive: isActive,
      );
}

@injectable
class ReplaceUserRolesUseCase {
  const ReplaceUserRolesUseCase(this._repository);
  final UsersRepository _repository;

  Future<Either<Failure, StaffUserModel>> call({
    required String id,
    required List<String> roleIds,
  }) =>
      _repository.replaceUserRoles(id: id, roleIds: roleIds);
}

@injectable
class DeleteUserUseCase {
  const DeleteUserUseCase(this._repository);
  final UsersRepository _repository;

  Future<Either<Failure, void>> call(String id) => _repository.deleteUser(id);
}

@injectable
class ResetUserPinUseCase {
  const ResetUserPinUseCase(this._repository);
  final UsersRepository _repository;

  Future<Either<Failure, void>> call({
    required String id,
    required String pinCode,
  }) =>
      _repository.resetUserPin(id: id, pinCode: pinCode);
}
