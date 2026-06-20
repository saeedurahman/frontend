import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';

part 'paginated_products_model.freezed.dart';
part 'paginated_products_model.g.dart';

@freezed
class PaginatedProductsModel with _$PaginatedProductsModel {
  const factory PaginatedProductsModel({
    required int total,
    required int skip,
    required int limit,
    @Default([]) List<ProductListItemModel> items,
  }) = _PaginatedProductsModel;

  factory PaginatedProductsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedProductsModelFromJson(json);
}
