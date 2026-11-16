import 'package:frantend/core/utils/json_num.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';

part 'paginated_products_model.freezed.dart';
part 'paginated_products_model.g.dart';

@freezed
abstract class PaginatedProductsModel with _$PaginatedProductsModel {
  const factory PaginatedProductsModel({
    @JsonKey(fromJson: JsonNum.intOr) required int total,
    @JsonKey(fromJson: JsonNum.intOr) required int skip,
    @JsonKey(fromJson: JsonNum.intOr) required int limit,
    @Default([]) List<ProductListItemModel> items,
  }) = _PaginatedProductsModel;

  factory PaginatedProductsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedProductsModelFromJson(json);
}
