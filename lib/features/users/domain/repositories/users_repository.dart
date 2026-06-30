import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<StaffUserModel>>> getUsers({String? role});

  Future<Either<Failure, StaffUserModel>> getUser(String id);

  Future<Either<Failure, StaffUserModel>> createUser({
    required String fullName,
    required String phone,
    required String password,
    String? branchId,
    required List<String> roleIds,
  });

  Future<Either<Failure, StaffUserModel>> updateUser({
    required String id,
    String? fullName,
    String? branchId,
    bool? isActive,
  });

  Future<Either<Failure, StaffUserModel>> replaceUserRoles({
    required String id,
    required List<String> roleIds,
  });

  Future<Either<Failure, void>> deleteUser(String id);

  Future<Either<Failure, void>> resetUserPin({
    required String id,
    required String pinCode,
  });
}
