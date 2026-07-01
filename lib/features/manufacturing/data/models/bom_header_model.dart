import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/manufacturing/data/models/bom_line_model.dart';

part 'bom_header_model.freezed.dart';
part 'bom_header_model.g.dart';

@freezed
class BomHeaderModel with _$BomHeaderModel {
  const factory BomHeaderModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    required String name,
    @JsonKey(name: 'output_qty') required String outputQty,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default(1) int version,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    @Default([]) List<BomLineModel> lines,
  }) = _BomHeaderModel;

  factory BomHeaderModel.fromJson(Map<String, dynamic> json) =>
      _$BomHeaderModelFromJson(json);
}
