import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddVariationUseCase {
  const AddVariationUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Either<Failure, VariationModel>> call(
    String productId,
    Map<String, dynamic> body,
  ) =>
      _repository.addVariation(productId, body);
}
