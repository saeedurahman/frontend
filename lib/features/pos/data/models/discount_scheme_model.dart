import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount_scheme_model.freezed.dart';
part 'discount_scheme_model.g.dart';

@freezed
class DiscountSchemeModel with _$DiscountSchemeModel {
  const factory DiscountSchemeModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    @JsonKey(name: 'discount_type') required String discountType,
    @JsonKey(name: 'discount_value') required String discountValue,
    @JsonKey(name: 'min_purchase_amount') String? minPurchaseAmount,
    @JsonKey(name: 'valid_from') String? validFrom,
    @JsonKey(name: 'valid_to') String? validTo,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _DiscountSchemeModel;

  factory DiscountSchemeModel.fromJson(Map<String, dynamic> json) =>
      _$DiscountSchemeModelFromJson(json);
}

extension DiscountSchemeModelX on DiscountSchemeModel {
  String get summaryLabel {
    final value = Decimal.tryParse(discountValue) ?? Decimal.zero;
    if (discountType == 'percentage') {
      return '$name (${value.toStringAsFixed(0)}% off)';
    }
    return '$name (${value.toStringAsFixed(2)} off)';
  }
}
