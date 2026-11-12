import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPriceListsUseCase {
  const GetPriceListsUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Either<Failure, List<PriceListModel>>> call() =>
      _repository.getPriceLists();

  /// Creates the business's default retail list (used only when the server has none).
  Future<Either<Failure, PriceListModel>> createDefault() =>
      _repository.createPriceList(const {
        'name': 'Retail',
        'list_type': 'retail',
        'is_default': true,
      });
}

@injectable
class GetProductPriceUseCase {
  const GetProductPriceUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Either<Failure, ProductPriceModel?>> call(
    String productId, {
    String? variationId,
  }) =>
      _repository.getProductPrice(productId, variationId: variationId);
}

@injectable
class SetProductPriceUseCase {
  const SetProductPriceUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Either<Failure, ProductPriceModel>> call(
    String productId,
    String priceListId,
    Map<String, dynamic> body,
  ) =>
      _repository.setProductPrice(productId, priceListId, body);
}
