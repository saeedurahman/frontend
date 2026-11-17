// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_price_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalePricePreviewLineModel _$SalePricePreviewLineModelFromJson(
  Map<String, dynamic> json,
) => _SalePricePreviewLineModel(
  productId: json['product_id'] as String,
  variationId: json['variation_id'] as String?,
  qty: json['qty'] as String,
  unitPrice: json['unit_price'] as String,
  lineOrder: json['line_order'] == null ? 0 : JsonNum.intOr(json['line_order']),
  lineSubtotal: json['line_subtotal'] as String,
  discountPct: json['discount_pct'] as String? ?? '0',
  discountAmount: json['discount_amount'] as String? ?? '0',
  taxRate: json['tax_rate'] as String? ?? '0',
  taxAmount: json['tax_amount'] as String? ?? '0',
  netAmount: json['net_amount'] as String?,
  lineTotal: json['line_total'] as String,
);

Map<String, dynamic> _$SalePricePreviewLineModelToJson(
  _SalePricePreviewLineModel instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'variation_id': instance.variationId,
  'qty': instance.qty,
  'unit_price': instance.unitPrice,
  'line_order': instance.lineOrder,
  'line_subtotal': instance.lineSubtotal,
  'discount_pct': instance.discountPct,
  'discount_amount': instance.discountAmount,
  'tax_rate': instance.taxRate,
  'tax_amount': instance.taxAmount,
  'net_amount': instance.netAmount,
  'line_total': instance.lineTotal,
};

_SalePricePreviewModel _$SalePricePreviewModelFromJson(
  Map<String, dynamic> json,
) => _SalePricePreviewModel(
  discountSchemeId: json['discount_scheme_id'] as String?,
  subtotal: json['subtotal'] as String,
  totalDiscount: json['total_discount'] as String? ?? '0',
  totalTax: json['total_tax'] as String? ?? '0',
  netAmount: json['net_amount'] as String?,
  exactTotal: json['exact_total'] as String?,
  roundingAmount: json['rounding_amount'] as String? ?? '0',
  taxInclusive: json['tax_inclusive'] as bool? ?? false,
  taxRoundingMode: json['tax_rounding_mode'] as String? ?? 'none',
  taxLabel: json['tax_label'] as String? ?? 'GST',
  totalAmount: json['total_amount'] as String,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map(
            (e) =>
                SalePricePreviewLineModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$SalePricePreviewModelToJson(
  _SalePricePreviewModel instance,
) => <String, dynamic>{
  'discount_scheme_id': instance.discountSchemeId,
  'subtotal': instance.subtotal,
  'total_discount': instance.totalDiscount,
  'total_tax': instance.totalTax,
  'net_amount': instance.netAmount,
  'exact_total': instance.exactTotal,
  'rounding_amount': instance.roundingAmount,
  'tax_inclusive': instance.taxInclusive,
  'tax_rounding_mode': instance.taxRoundingMode,
  'tax_label': instance.taxLabel,
  'total_amount': instance.totalAmount,
  'lines': instance.lines,
};
