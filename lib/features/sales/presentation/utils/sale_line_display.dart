import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

abstract final class SaleLineDisplay {
  static String label(SaleLineModel line) {
    final name = line.productName?.trim();
    if (name != null && name.isNotEmpty) {
      final variation = line.variationName?.trim();
      if (variation != null && variation.isNotEmpty) {
        return '$name ($variation)';
      }
      return name;
    }
    final id = line.productId;
    final shortId = id.length > 8 ? id.substring(0, 8) : id;
    return 'Product $shortId';
  }

  static List<String> namesFromLines(List<SaleLineModel> lines) {
    final names = <String>[];
    for (final line in lines) {
      final label = SaleLineDisplay.label(line);
      if (!names.contains(label)) {
        names.add(label);
      }
    }
    return names;
  }

  static List<String> namesFromSale(SaleResponseModel sale) =>
      namesFromLines(sale.lines);

  static String summaryFromNames(List<String> names) {
    if (names.isEmpty) return '—';
    if (names.length == 1) return names.first;
    if (names.length == 2) return names.join(', ');
    return '${names[0]}, ${names[1]} +${names.length - 2}';
  }

  static SaleLineModel enrichLine(SaleLineModel line, ProductModel product) {
    var variationName = line.variationName?.trim();
    final variationId = line.variationId;
    if ((variationName == null || variationName.isEmpty) &&
        variationId != null) {
      for (final variation in product.variations) {
        if (variation.id == variationId) {
          variationName = variation.name;
          break;
        }
      }
    }

    return line.copyWith(
      productName: product.name,
      variationName: variationName ?? line.variationName,
    );
  }
}
