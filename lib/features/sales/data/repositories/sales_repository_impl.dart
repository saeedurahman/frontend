import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:frantend/features/sales/data/models/paginated_sales_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/domain/repositories/sales_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SalesRepository)
class SalesRepositoryImpl implements SalesRepository {
  SalesRepositoryImpl({
    required SalesRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final SalesRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, PaginatedSalesModel>> getSales({
    String? branchId,
    String? customerId,
    String? status,
    String? saleType,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final result = await _remote.getSales(
        branchId: branchId,
        customerId: customerId,
        status: status,
        saleType: saleType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        search: search,
        skip: skip,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SaleResponseModel>> getSaleById(String id) async {
    try {
      final result = await _remote.getSaleById(id);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SaleResponseModel>> cancelSale(String id) async {
    try {
      final result = await _remote.cancelSale(id);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
