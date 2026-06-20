import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateBrandUseCase {
  const CreateBrandUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Either<Failure, BrandModel>> call(Map<String, dynamic> body) =>
      _repository.createBrand(body);
}
