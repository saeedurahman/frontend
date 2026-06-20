import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/sales/data/models/paginated_sales_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/domain/repositories/sales_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSalesUseCase {
  const GetSalesUseCase(this._repository);

  final SalesRepository _repository;

  Future<Either<Failure, PaginatedSalesModel>> call({
    String? branchId,
    String? customerId,
    String? status,
    String? saleType,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? search,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.getSales(
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
}

@injectable
class GetSaleByIdUseCase {
  const GetSaleByIdUseCase(this._repository);

  final SalesRepository _repository;

  Future<Either<Failure, SaleResponseModel>> call(String id) =>
      _repository.getSaleById(id);
}

@injectable
class CancelSaleUseCase {
  const CancelSaleUseCase(this._repository);

  final SalesRepository _repository;

  Future<Either<Failure, SaleResponseModel>> call(String id) =>
      _repository.cancelSale(id);
}
