import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/price_list_detail_models.dart';
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:injectable/injectable.dart';

abstract class ProductsRemoteDataSource {
  Future<PaginatedProductsModel> getProducts({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 50,
  });

  Future<ProductModel> getProductById(String id);
  Future<ProductModel> getProductByBarcode(String barcode);
  Future<ProductModel> createProduct(Map<String, dynamic> body);
  Future<ProductModel> updateProduct(String id, Map<String, dynamic> body);
  Future<void> deleteProduct(String id);
  Future<VariationModel> addVariation(
    String productId,
    Map<String, dynamic> body,
  );
  Future<VariationModel> updateVariation(
    String productId,
    String variationId,
    Map<String, dynamic> body,
  );
  Future<BarcodeModel> addBarcode(
    String productId,
    Map<String, dynamic> body,
  );

  Future<List<CategoryModel>> getCategories({String? parentId});
  Future<CategoryModel> createCategory(Map<String, dynamic> body);
  Future<CategoryModel> updateCategory(String id, Map<String, dynamic> body);
  Future<void> deleteCategory(String id);

  Future<List<BrandModel>> getBrands();
  Future<BrandModel> createBrand(Map<String, dynamic> body);
  Future<void> deleteBrand(String id);

  Future<List<UnitModel>> getUnits();
  Future<UnitModel> createUnit(Map<String, dynamic> body);

  Future<List<PriceListModel>> getPriceLists();
  Future<PriceListModel> getPriceList(String id);
  Future<PriceListModel> createPriceList(Map<String, dynamic> body);
  Future<PriceListModel> updatePriceList(String id, Map<String, dynamic> body);
  Future<Map<String, dynamic>> deletePriceList(String id);
  Future<PriceListModel> copyPriceList(String id, Map<String, dynamic> body);
  Future<PaginatedPriceListItemsModel> getPriceListItems(
    String id, {
    String? search,
    int skip = 0,
    int limit = 50,
  });
  Future<BulkPriceResponseModel> bulkUpsertPriceItems(
    String id,
    List<Map<String, dynamic>> items,
  );
  Future<void> deletePriceItem(String id, String itemId);
  Future<AdjustPricesResponseModel> adjustPriceList(
    String id,
    Map<String, dynamic> body,
  );
  Future<Map<String, dynamic>> importPriceListCsv(
    String id,
    Map<String, dynamic> body,
  );
  Future<ProductPriceModel?> getProductPrice(
    String productId, {
    String? variationId,
  });
  Future<ProductPriceModel> setProductPrice(
    String productId,
    String priceListId,
    Map<String, dynamic> body,
  );
}

@LazySingleton(as: ProductsRemoteDataSource)
class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<PaginatedProductsModel> getProducts({
    String? categoryId,
    String? brandId,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.products,
      queryParameters: {
        if (categoryId != null) 'category_id': categoryId,
        if (brandId != null) 'brand_id': brandId,
        if (isActive != null) 'is_active': isActive,
        if (search != null && search.isNotEmpty) 'search': search,
        'skip': skip,
        'limit': limit,
      },
    );
    return PaginatedProductsModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.products}/$id',
    );
    return ProductModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ProductModel> getProductByBarcode(String barcode) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.products}/barcode/$barcode',
    );
    return ProductModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ProductModel> createProduct(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.products,
      data: body,
    );
    return ProductModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '${ApiConstants.products}/$id',
      data: body,
    );
    return ProductModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _dio.delete<void>('${ApiConstants.products}/$id');
  }

  @override
  Future<VariationModel> addVariation(
    String productId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiConstants.products}/$productId/variations',
      data: body,
    );
    return VariationModel.fromJson(response.data ?? const {});
  }

  @override
  Future<VariationModel> updateVariation(
    String productId,
    String variationId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '${ApiConstants.products}/$productId/variations/$variationId',
      data: body,
    );
    return VariationModel.fromJson(response.data ?? const {});
  }

  @override
  Future<BarcodeModel> addBarcode(
    String productId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiConstants.products}/$productId/barcodes',
      data: body,
    );
    return BarcodeModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<CategoryModel>> getCategories({String? parentId}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.categories,
      queryParameters: parentId == null ? null : {'parent_id': parentId},
    );
    return _toModelList(response.data, CategoryModel.fromJson);
  }

  @override
  Future<CategoryModel> createCategory(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.categories,
      data: body,
    );
    return CategoryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<CategoryModel> updateCategory(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '${ApiConstants.categories}/$id',
      data: body,
    );
    return CategoryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _dio.delete<void>('${ApiConstants.categories}/$id');
  }

  @override
  Future<List<BrandModel>> getBrands() async {
    final response = await _dio.get<dynamic>(ApiConstants.brands);
    return _toModelList(response.data, BrandModel.fromJson);
  }

  @override
  Future<BrandModel> createBrand(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.brands,
      data: body,
    );
    return BrandModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteBrand(String id) async {
    await _dio.delete<void>('${ApiConstants.brands}/$id');
  }

  @override
  Future<List<UnitModel>> getUnits() async {
    final response = await _dio.get<dynamic>(ApiConstants.units);
    return _toModelList(response.data, UnitModel.fromJson);
  }

  @override
  Future<UnitModel> createUnit(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.units,
      data: body,
    );
    return UnitModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<PriceListModel>> getPriceLists() async {
    final response = await _dio.get<dynamic>(ApiConstants.priceLists);
    return _toModelList(response.data, PriceListModel.fromJson);
  }

  @override
  Future<ProductPriceModel?> getProductPrice(
    String productId, {
    String? variationId,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.productPrice(productId),
        queryParameters:
            variationId == null ? null : {'variation_id': variationId},
      );
      final data = response.data;
      if (data == null || data.isEmpty) return null;
      final model = ProductPriceModel.fromJson(data);
      if (model.unitPrice == null || model.unitPrice!.isEmpty) return null;
      return model;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<ProductPriceModel> setProductPrice(
    String productId,
    String priceListId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.priceListItems(priceListId),
      data: {...body, 'product_id': productId},
    );
    return ProductPriceModel.fromJson(response.data ?? const {});
  }

  @override
  Future<PriceListModel> createPriceList(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.priceLists,
      data: body,
    );
    return PriceListModel.fromJson(response.data ?? const {});
  }

  @override
  Future<PriceListModel> getPriceList(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.priceListById(id),
    );
    return PriceListModel.fromJson(response.data ?? const {});
  }

  @override
  Future<PriceListModel> updatePriceList(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.priceListById(id),
      data: body,
    );
    return PriceListModel.fromJson(response.data ?? const {});
  }

  @override
  Future<Map<String, dynamic>> deletePriceList(String id) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      ApiConstants.priceListById(id),
    );
    return response.data ?? const {'deleted': true};
  }

  @override
  Future<PriceListModel> copyPriceList(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.priceListCopy(id),
      data: body,
    );
    return PriceListModel.fromJson(response.data ?? const {});
  }

  @override
  Future<PaginatedPriceListItemsModel> getPriceListItems(
    String id, {
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.priceListItems(id),
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'skip': skip,
        'limit': limit,
      },
    );
    return PaginatedPriceListItemsModel.fromJson(response.data ?? const {});
  }

  @override
  Future<BulkPriceResponseModel> bulkUpsertPriceItems(
    String id,
    List<Map<String, dynamic>> items,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.priceListItemsBulk(id),
      data: {'items': items},
    );
    return BulkPriceResponseModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deletePriceItem(String id, String itemId) async {
    await _dio.delete<void>(ApiConstants.priceListItemDelete(id, itemId));
  }

  @override
  Future<AdjustPricesResponseModel> adjustPriceList(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.priceListAdjust(id),
      data: body,
    );
    return AdjustPricesResponseModel.fromJson(response.data ?? const {});
  }

  @override
  Future<Map<String, dynamic>> importPriceListCsv(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.priceListImport(id),
      data: body,
    );
    return response.data ?? const {};
  }

  List<T> _toModelList<T>(
    dynamic payload,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (payload is List) {
      return payload
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return const [];
  }
}
