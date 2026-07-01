import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';

abstract class ProductsRepository {
  Future<Either<Failure, PaginatedProductsModel>> getProducts({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, ProductModel>> getProductById(String id);
  Future<Either<Failure, ProductModel>> getProductByBarcode(String barcode);
  Future<Either<Failure, ProductModel>> createProduct(Map<String, dynamic> body);
  Future<Either<Failure, ProductModel>> updateProduct(
    String id,
    Map<String, dynamic> body,
  );
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, VariationModel>> addVariation(
    String productId,
    Map<String, dynamic> body,
  );
  Future<Either<Failure, VariationModel>> updateVariation(
    String productId,
    String variationId,
    Map<String, dynamic> body,
  );
  Future<Either<Failure, BarcodeModel>> addBarcode(
    String productId,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, List<CategoryModel>>> getCategories({String? parentId});
  Future<Either<Failure, CategoryModel>> createCategory(
    Map<String, dynamic> body,
  );
  Future<Either<Failure, void>> deleteCategory(String id);

  Future<Either<Failure, List<BrandModel>>> getBrands();
  Future<Either<Failure, BrandModel>> createBrand(Map<String, dynamic> body);
  Future<Either<Failure, void>> deleteBrand(String id);

  Future<Either<Failure, List<UnitModel>>> getUnits();
  Future<Either<Failure, UnitModel>> createUnit(Map<String, dynamic> body);

  Future<Either<Failure, List<PriceListModel>>> getPriceLists();
  Future<Either<Failure, ProductPriceModel?>> getProductPrice(
    String productId, {
    String? variationId,
  });
  Future<Either<Failure, ProductPriceModel>> setProductPrice(
    String productId,
    String priceListId,
    Map<String, dynamic> body,
  );
}
