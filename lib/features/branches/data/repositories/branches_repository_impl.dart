import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/branches/data/datasources/branches_remote_datasource.dart';
import 'package:frantend/features/branches/domain/repositories/branches_repository.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BranchesRepository)
class BranchesRepositoryImpl implements BranchesRepository {
  BranchesRepositoryImpl({
    required BranchesRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final BranchesRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  Future<Either<Failure, T>> _wrap<T>(Future<T> call) async {
    try {
      return Right(await call);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<BranchModel>>> getBranches() =>
      _wrap(_remote.getBranches());

  @override
  Future<Either<Failure, BranchModel>> getBranchById(String branchId) =>
      _wrap(_remote.getBranchById(branchId));
}
