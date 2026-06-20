import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';

abstract class ReturnsRepository {
  Future<Either<Failure, SaleReturnResponseModel>> createReturn(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, List<SaleReturnResponseModel>>> getReturns({
    String? branchId,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, SaleReturnResponseModel>> getReturnById(String id);
}
