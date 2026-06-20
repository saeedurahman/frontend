import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/features/returns/domain/repositories/returns_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateSaleReturnUseCase {
  const CreateSaleReturnUseCase(this._repository);

  final ReturnsRepository _repository;

  Future<Either<Failure, SaleReturnResponseModel>> call(
    Map<String, dynamic> body,
  ) =>
      _repository.createReturn(body);
}

@injectable
class GetReturnsUseCase {
  const GetReturnsUseCase(this._repository);

  final ReturnsRepository _repository;

  Future<Either<Failure, List<SaleReturnResponseModel>>> call({
    String? branchId,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.getReturns(branchId: branchId, skip: skip, limit: limit);
}

@injectable
class GetReturnByIdUseCase {
  const GetReturnByIdUseCase(this._repository);

  final ReturnsRepository _repository;

  Future<Either<Failure, SaleReturnResponseModel>> call(String id) =>
      _repository.getReturnById(id);
}
