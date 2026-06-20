import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductByBarcodeUseCase {
  const GetProductByBarcodeUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Either<Failure, ProductModel>> call(String barcode) =>
      _repository.getProductByBarcode(barcode);
}
