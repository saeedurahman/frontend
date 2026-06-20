import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_return_line_model.freezed.dart';
part 'sale_return_line_model.g.dart';

@freezed
class SaleReturnLineModel with _$SaleReturnLineModel {
  const factory SaleReturnLineModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'sale_return_id') required String saleReturnId,
    @JsonKey(name: 'sale_line_id') String? saleLineId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    required String qty,
    @JsonKey(name: 'unit_price') required String unitPrice,
    @JsonKey(name: 'tax_amount') @Default('0') String taxAmount,
  }) = _SaleReturnLineModel;

  factory SaleReturnLineModel.fromJson(Map<String, dynamic> json) =>
      _$SaleReturnLineModelFromJson(json);
}
