import 'dart:convert';

import 'package:frantend/core/database/daos/master_data_cache_dao.dart';
import 'package:frantend/features/pos/domain/repositories/barcode_cache_repository.dart';
import 'package:frantend/features/products/data/models/product_model.dart';

class BarcodeCacheRepositoryImpl implements BarcodeCacheRepository {
  const BarcodeCacheRepositoryImpl(this._cache);

  final MasterDataCacheDao _cache;

  static String keyFor(String tenantKey, String barcode) =>
      'pos_barcode:$tenantKey:$barcode';

  @override
  Future<ProductModel?> find(String tenantKey, String barcode) async {
    try {
      final json = await _cache.getCache(keyFor(tenantKey, barcode));
      if (json == null) return null;
      return ProductModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(json) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> remember(
    String tenantKey,
    String barcode,
    ProductModel product,
  ) async {
    try {
      await _cache.upsertCache(
        keyFor(tenantKey, barcode),
        jsonEncode(product.toJson()),
      );
    } catch (_) {
      // Cache is best-effort; scanning must never fail because of it.
    }
  }
}
