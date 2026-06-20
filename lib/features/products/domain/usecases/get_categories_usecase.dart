import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Either<Failure, List<CategoryModel>>> call({String? parentId}) =>
      _repository.getCategories(parentId: parentId);
}
