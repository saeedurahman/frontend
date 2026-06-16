import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';
import 'package:frantend/features/register/domain/repositories/register_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RegisterRepository)
class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRepositoryImpl(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, User>> register(RegisterEntity entity) {
    return _authRepository.registerBusiness(entity.toJson());
  }
}
