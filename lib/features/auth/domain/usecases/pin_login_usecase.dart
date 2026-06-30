import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class PinLoginUseCase {
  PinLoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call({
    required String businessSlug,
    required String userId,
    required String pinCode,
  }) =>
      _repository.pinLogin(
        businessSlug: businessSlug,
        userId: userId,
        pinCode: pinCode,
      );
}
