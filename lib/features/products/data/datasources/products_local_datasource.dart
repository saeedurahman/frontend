import 'dart:convert';

import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:injectable/injectable.dart';

abstract class ProductsLocalDataSource {
  Future<void> cacheProducts(List<ProductListItemModel> products);
  Future<List<ProductListItemModel>> getCachedProducts();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<CategoryModel>> getCachedCategories();
  Future<void> cacheBrands(List<BrandModel> brands);
  Future<List<BrandModel>> getCachedBrands();
  Future<void> cacheUnits(List<UnitModel> units);
  Future<List<UnitModel>> getCachedUnits();
}

@LazySingleton(as: ProductsLocalDataSource)
class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  ProductsLocalDataSourceImpl(this._cacheDao);

  final MasterDataCacheDao _cacheDao;

  static const _productsKey = 'products_list';
  static const _categoriesKey = 'categories';
  static const _brandsKey = 'brands';
  static const _unitsKey = 'units';

  @override
  Future<void> cacheProducts(List<ProductListItemModel> products) async {
    final json = jsonEncode(products.map((p) => p.toJson()).toList());
    await _cacheDao.upsertCache(_productsKey, json);
  }

  @override
  Future<List<ProductListItemModel>> getCachedProducts() async {
    final json = await _cacheDao.getCache(_productsKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => ProductListItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final json = jsonEncode(categories.map((c) => c.toJson()).toList());
    await _cacheDao.upsertCache(_categoriesKey, json);
  }

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    final json = await _cacheDao.getCache(_categoriesKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheBrands(List<BrandModel> brands) async {
    final json = jsonEncode(brands.map((b) => b.toJson()).toList());
    await _cacheDao.upsertCache(_brandsKey, json);
  }

  @override
  Future<List<BrandModel>> getCachedBrands() async {
    final json = await _cacheDao.getCache(_brandsKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheUnits(List<UnitModel> units) async {
    final json = jsonEncode(units.map((u) => u.toJson()).toList());
    await _cacheDao.upsertCache(_unitsKey, json);
  }

  @override
  Future<List<UnitModel>> getCachedUnits() async {
    final json = await _cacheDao.getCache(_unitsKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => UnitModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
