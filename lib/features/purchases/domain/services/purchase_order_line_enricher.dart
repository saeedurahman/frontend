import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:injectable/injectable.dart';

/// Fills missing [PurchaseLineModel.productName] / [variationName] when the
/// purchases API returns only product/variation IDs (no joined labels).
@injectable
class PurchaseOrderLineEnricher {
  const PurchaseOrderLineEnricher(this._getProductById);

  final GetProductByIdUseCase _getProductById;

  Future<PurchaseOrderModel> enrich(PurchaseOrderModel order) async {
    if (!_needsEnrichment(order)) return order;

    final productIds = order.lines.map((line) => line.productId).toSet();
    final productsById = await _loadProducts(productIds);

    final lines = order.lines.map((line) {
      final product = productsById[line.productId];
      final productName = _nonEmpty(line.productName) ?? product?.name;
      final variationName =
          _nonEmpty(line.variationName) ?? _variationName(product, line.variationId);

      if (productName == line.productName && variationName == line.variationName) {
        return line;
      }
      return line.copyWith(
        productName: productName,
        variationName: variationName,
      );
    }).toList();

    return order.copyWith(lines: lines);
  }

  bool _needsEnrichment(PurchaseOrderModel order) {
    return order.lines.any((line) {
      final missingProductName = _nonEmpty(line.productName) == null;
      final missingVariationName =
          line.variationId != null && _nonEmpty(line.variationName) == null;
      return missingProductName || missingVariationName;
    });
  }

  Future<Map<String, ProductModel>> _loadProducts(Set<String> productIds) async {
    final products = <String, ProductModel>{};
    await Future.wait(
      productIds.map((id) async {
        final result = await _getProductById(id);
        result.fold((_) {}, (product) => products[id] = product);
      }),
    );
    return products;
  }

  String? _variationName(ProductModel? product, String? variationId) {
    if (product == null || variationId == null) return null;
    for (final variation in product.variations) {
      if (variation.id == variationId) return variation.name;
    }
    return null;
  }

  String? _nonEmpty(String? value) {
    if (value == null || value.isEmpty) return null;
    return value;
  }
}
