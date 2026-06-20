import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/features/products/data/datasources/products_local_datasource.dart';
import 'package:frantend/features/products/data/datasources/products_remote_datasource.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProductsRepository)
class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl({
    required ProductsRemoteDataSource remoteDataSource,
    required ProductsLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _networkInfo = networkInfo,
        _errorHandler = errorHandler;

  final ProductsRemoteDataSource _remote;
  final ProductsLocalDataSource _local;
  final NetworkInfo _networkInfo;
  final ErrorHandler _errorHandler;

  bool _isOfflineError(Object e) {
    if (e is DioException) {
      return e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          (e.response == null && e.type != DioExceptionType.badResponse);
    }
    return false;
  }

  @override
  Future<Either<Failure, PaginatedProductsModel>> getProducts({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final result = await _remote.getProducts(
        categoryId: categoryId,
        brandId: brandId,
        isActive: isActive,
        search: search,
        skip: skip,
        limit: limit,
      );
      if (skip == 0) {
        await _local.cacheProducts(result.items);
      }
      return Right(result);
    } catch (e) {
      if (_isOfflineError(e)) {
        final cached = await _local.getCachedProducts();
        if (cached.isNotEmpty) {
          final filtered = _filterCachedProducts(
            cached,
            categoryId: categoryId,
            brandId: brandId,
            isActive: isActive,
            search: search,
          );
          final paged = filtered.skip(skip).take(limit).toList();
          return Right(
            PaginatedProductsModel(
              total: filtered.length,
              skip: skip,
              limit: limit,
              items: paged,
            ),
          );
        }
      }
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  List<ProductListItemModel> _filterCachedProducts(
    List<ProductListItemModel> items, {
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
  }) {
    return items.where((p) {
      if (categoryId != null && p.categoryId != categoryId) return false;
      if (brandId != null && p.brandId != brandId) return false;
      if (isActive != null && p.isActive != isActive) return false;
      if (search != null && search.isNotEmpty) {
        final q = search.toLowerCase();
        final nameMatch = p.name.toLowerCase().contains(q);
        final skuMatch = p.sku?.toLowerCase().contains(q) ?? false;
        if (!nameMatch && !skuMatch) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) async {
    try {
      final result = await _remote.getProductById(id);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductByBarcode(
    String barcode,
  ) async {
    try {
      final result = await _remote.getProductByBarcode(barcode);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> createProduct(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createProduct(body);
      return Right(result);
    } catch (e) {
      if (_isOfflineError(e) || !await _networkInfo.isConnected) {
        return Left(const NetworkFailure('Product queued for sync when online'));
      }
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> updateProduct(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.updateProduct(id, body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _remote.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, VariationModel>> addVariation(
    String productId,
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.addVariation(productId, body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, VariationModel>> updateVariation(
    String productId,
    String variationId,
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.updateVariation(productId, variationId, body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BarcodeModel>> addBarcode(
    String productId,
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.addBarcode(productId, body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories({
    String? parentId,
  }) async {
    try {
      final result = await _remote.getCategories(parentId: parentId);
      await _local.cacheCategories(result);
      return Right(result);
    } catch (e) {
      if (_isOfflineError(e)) {
        final cached = await _local.getCachedCategories();
        if (cached.isNotEmpty) return Right(cached);
      }
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CategoryModel>> createCategory(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createCategory(body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _remote.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<BrandModel>>> getBrands() async {
    try {
      final result = await _remote.getBrands();
      await _local.cacheBrands(result);
      return Right(result);
    } catch (e) {
      if (_isOfflineError(e)) {
        final cached = await _local.getCachedBrands();
        if (cached.isNotEmpty) return Right(cached);
      }
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BrandModel>> createBrand(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createBrand(body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBrand(String id) async {
    try {
      await _remote.deleteBrand(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<UnitModel>>> getUnits() async {
    try {
      final result = await _remote.getUnits();
      await _local.cacheUnits(result);
      return Right(result);
    } catch (e) {
      if (_isOfflineError(e)) {
        final cached = await _local.getCachedUnits();
        if (cached.isNotEmpty) return Right(cached);
      }
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UnitModel>> createUnit(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createUnit(body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
