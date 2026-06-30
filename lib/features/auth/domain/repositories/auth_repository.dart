import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String phone,
    required String password,
  });

  Future<Either<Failure, User>> pinLogin({
    required String businessSlug,
    required String userId,
    required String pinCode,
  });

  Future<Either<Failure, User>> registerBusiness(
    Map<String, dynamic> data,
  );

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<bool> isAuthenticated();
}
