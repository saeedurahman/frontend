import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUnitsUseCase {
  const GetUnitsUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Either<Failure, List<UnitModel>>> call() => _repository.getUnits();
}
