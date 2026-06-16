import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';

abstract class RegisterRepository {
  Future<Either<Failure, User>> register(RegisterEntity entity);
}
