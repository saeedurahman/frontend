import 'package:frantend/core/utils/json_num.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_price_preview_model.freezed.dart';
part 'sale_price_preview_model.g.dart';

@freezed
abstract class SalePricePreviewLineModel with _$SalePricePreviewLineModel {
  const factory SalePricePreviewLineModel({
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    required String qty,
    @JsonKey(name: 'unit_price') required String unitPrice,
    @JsonKey(name: 'line_order', fromJson: JsonNum.intOr) @Default(0) int lineOrder,
    @JsonKey(name: 'line_subtotal') required String lineSubtotal,
    @JsonKey(name: 'discount_pct') @Default('0') String discountPct,
    @JsonKey(name: 'discount_amount') @Default('0') String discountAmount,
    @JsonKey(name: 'tax_rate') @Default('0') String taxRate,
    @JsonKey(name: 'tax_amount') @Default('0') String taxAmount,
    @JsonKey(name: 'net_amount') String? netAmount,
    @JsonKey(name: 'line_total') required String lineTotal,
  }) = _SalePricePreviewLineModel;

  factory SalePricePreviewLineModel.fromJson(Map<String, dynamic> json) =>
      _$SalePricePreviewLineModelFromJson(json);
}

@freezed
abstract class SalePricePreviewModel with _$SalePricePreviewModel {
  const SalePricePreviewModel._();

  const factory SalePricePreviewModel({
    @JsonKey(name: 'discount_scheme_id') String? discountSchemeId,
    required String subtotal,
    @JsonKey(name: 'total_discount') @Default('0') String totalDiscount,
    @JsonKey(name: 'total_tax') @Default('0') String totalTax,
    @JsonKey(name: 'net_amount') String? netAmount,
    @JsonKey(name: 'exact_total') String? exactTotal,
    @JsonKey(name: 'rounding_amount') @Default('0') String roundingAmount,
    @JsonKey(name: 'tax_inclusive') @Default(false) bool taxInclusive,
    @JsonKey(name: 'tax_rounding_mode') @Default('none') String taxRoundingMode,
    @JsonKey(name: 'tax_label') @Default('GST') String taxLabel,
    @JsonKey(name: 'total_amount') required String totalAmount,
    @Default([]) List<SalePricePreviewLineModel> lines,
  }) = _SalePricePreviewModel;

  factory SalePricePreviewModel.fromJson(Map<String, dynamic> json) =>
      _$SalePricePreviewModelFromJson(json);

  Decimal get subtotalDecimal =>
      Decimal.tryParse(subtotal) ?? Decimal.zero;

  Decimal get totalDiscountDecimal =>
      Decimal.tryParse(totalDiscount) ?? Decimal.zero;

  Decimal get totalTaxDecimal => Decimal.tryParse(totalTax) ?? Decimal.zero;

  Decimal get roundingAmountDecimal =>
      Decimal.tryParse(roundingAmount) ?? Decimal.zero;

  Decimal get totalAmountDecimal =>
      Decimal.tryParse(totalAmount) ?? Decimal.zero;
}
