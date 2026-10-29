import 'package:frantend/features/products/data/models/product_model.dart';

/// Read-through cache of barcode -> product, per business.
abstract class BarcodeCacheRepository {
  /// The cached product, or null (also when the cache entry is unreadable).
  Future<ProductModel?> find(String tenantKey, String barcode);

  /// Best effort: a failing cache must never break scanning.
  Future<void> remember(String tenantKey, String barcode, ProductModel product);
}
