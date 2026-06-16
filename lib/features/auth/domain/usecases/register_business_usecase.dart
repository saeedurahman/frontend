import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterBusinessUseCase {
  RegisterBusinessUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call(Map<String, dynamic> data) =>
      _repository.registerBusiness(data);
}
