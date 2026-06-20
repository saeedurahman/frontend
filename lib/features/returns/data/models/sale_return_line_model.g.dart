// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_return_line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleReturnLineModelImpl _$$SaleReturnLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$SaleReturnLineModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  saleReturnId: json['sale_return_id'] as String,
  saleLineId: json['sale_line_id'] as String?,
  productId: json['product_id'] as String,
  variationId: json['variation_id'] as String?,
  qty: json['qty'] as String,
  unitPrice: json['unit_price'] as String,
  taxAmount: json['tax_amount'] as String? ?? '0',
);

Map<String, dynamic> _$$SaleReturnLineModelImplToJson(
  _$SaleReturnLineModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'sale_return_id': instance.saleReturnId,
  'sale_line_id': instance.saleLineId,
  'product_id': instance.productId,
  'variation_id': instance.variationId,
  'qty': instance.qty,
  'unit_price': instance.unitPrice,
  'tax_amount': instance.taxAmount,
};
