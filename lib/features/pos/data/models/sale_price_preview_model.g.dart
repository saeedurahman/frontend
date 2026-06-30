// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_price_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalePricePreviewLineModelImpl _$$SalePricePreviewLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$SalePricePreviewLineModelImpl(
  productId: json['product_id'] as String,
  variationId: json['variation_id'] as String?,
  qty: json['qty'] as String,
  unitPrice: json['unit_price'] as String,
  lineOrder: (json['line_order'] as num?)?.toInt() ?? 0,
  lineSubtotal: json['line_subtotal'] as String,
  discountPct: json['discount_pct'] as String? ?? '0',
  discountAmount: json['discount_amount'] as String? ?? '0',
  taxRate: json['tax_rate'] as String? ?? '0',
  taxAmount: json['tax_amount'] as String? ?? '0',
  lineTotal: json['line_total'] as String,
);

Map<String, dynamic> _$$SalePricePreviewLineModelImplToJson(
  _$SalePricePreviewLineModelImpl instance,
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
  'line_total': instance.lineTotal,
};

_$SalePricePreviewModelImpl _$$SalePricePreviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$SalePricePreviewModelImpl(
  discountSchemeId: json['discount_scheme_id'] as String?,
  subtotal: json['subtotal'] as String,
  totalDiscount: json['total_discount'] as String? ?? '0',
  totalTax: json['total_tax'] as String? ?? '0',
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

Map<String, dynamic> _$$SalePricePreviewModelImplToJson(
  _$SalePricePreviewModelImpl instance,
) => <String, dynamic>{
  'discount_scheme_id': instance.discountSchemeId,
  'subtotal': instance.subtotal,
  'total_discount': instance.totalDiscount,
  'total_tax': instance.totalTax,
  'total_amount': instance.totalAmount,
  'lines': instance.lines,
};
