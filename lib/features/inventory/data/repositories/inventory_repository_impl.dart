import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl({
    required InventoryRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final InventoryRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, StockBalanceModel>> getStockBalance({
    required String branchId,
    required String productId,
    String? variationId,
  }) async {
    try {
      final result = await _remote.getStockBalance(
        branchId: branchId,
        productId: productId,
        variationId: variationId,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<StockBalanceModel>>> getStockBalances({
    required String branchId,
    List<String>? productIds,
  }) async {
    try {
      final result = await _remote.getStockBalances(
        branchId: branchId,
        productIds: productIds,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedStockMovementsModel>> getStockMovements({
    required String branchId,
    String? productId,
    String? movementType,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final result = await _remote.getStockMovements(
        branchId: branchId,
        productId: productId,
        movementType: movementType,
        skip: skip,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, StockAdjustmentModel>> createAdjustment(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createAdjustment(body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
