import 'package:frantend/core/utils/json_num.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/sales/data/models/sale_list_item_model.dart';

part 'paginated_sales_model.freezed.dart';
part 'paginated_sales_model.g.dart';

@freezed
abstract class PaginatedSalesModel with _$PaginatedSalesModel {
  const factory PaginatedSalesModel({
    @JsonKey(fromJson: JsonNum.intOr) required int total,
    @JsonKey(fromJson: JsonNum.intOr) required int skip,
    @JsonKey(fromJson: JsonNum.intOr) required int limit,
    @Default([]) List<SaleListItemModel> items,
  }) = _PaginatedSalesModel;

  factory PaginatedSalesModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedSalesModelFromJson(json);
}
