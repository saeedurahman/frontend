import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/returns/data/datasources/returns_remote_datasource.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/features/returns/domain/repositories/returns_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReturnsRepository)
class ReturnsRepositoryImpl implements ReturnsRepository {
  ReturnsRepositoryImpl({
    required ReturnsRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final ReturnsRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, SaleReturnResponseModel>> createReturn(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createReturn(body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SaleReturnResponseModel>>> getReturns({
    String? branchId,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final result = await _remote.getReturns(
        branchId: branchId,
        skip: skip,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SaleReturnResponseModel>> getReturnById(
    String id,
  ) async {
    try {
      final result = await _remote.getReturnById(id);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
