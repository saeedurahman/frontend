import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/utils/sale_line_display.dart';

typedef ProductByIdLoader = Future<Either<Failure, ProductModel>> Function(
  String productId,
);

abstract final class SaleProductEnrichment {
  static Future<SaleResponseModel> enrichSale(
    SaleResponseModel sale,
    ProductByIdLoader loadProduct,
  ) async {
    final productCache = <String, ProductModel?>{};
    final enrichedLines = <SaleLineModel>[];

    for (final line in sale.lines) {
      final hasName =
          line.productName != null && line.productName!.trim().isNotEmpty;
      if (hasName) {
        enrichedLines.add(line);
        continue;
      }

      if (!productCache.containsKey(line.productId)) {
        final productResult = await loadProduct(line.productId);
        productCache[line.productId] =
            productResult.fold((_) => null, (product) => product);
      }

      final product = productCache[line.productId];
      enrichedLines.add(
        product == null ? line : SaleLineDisplay.enrichLine(line, product),
      );
    }

    return sale.copyWith(lines: enrichedLines);
  }

  static Future<List<String>> productNamesForSale(
    SaleResponseModel sale,
    ProductByIdLoader loadProduct,
  ) async {
    final enriched = await enrichSale(sale, loadProduct);
    return SaleLineDisplay.namesFromLines(enriched.lines);
  }
}
