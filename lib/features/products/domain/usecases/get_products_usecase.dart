import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Either<Failure, PaginatedProductsModel>> call({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.getProducts(
        categoryId: categoryId,
        brandId: brandId,
        isActive: isActive,
        search: search,
        skip: skip,
        limit: limit,
      );
}
