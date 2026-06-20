import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/sales/data/models/paginated_sales_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

abstract class SalesRepository {
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
  });

  Future<Either<Failure, SaleResponseModel>> getSaleById(String id);

  Future<Either<Failure, SaleResponseModel>> cancelSale(String id);
}
