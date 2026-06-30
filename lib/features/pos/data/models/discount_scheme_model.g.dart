// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_scheme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscountSchemeModelImpl _$$DiscountSchemeModelImplFromJson(
  Map<String, dynamic> json,
) => _$DiscountSchemeModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  name: json['name'] as String,
  discountType: json['discount_type'] as String,
  discountValue: json['discount_value'] as String,
  minPurchaseAmount: json['min_purchase_amount'] as String?,
  validFrom: json['valid_from'] as String?,
  validTo: json['valid_to'] as String?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$$DiscountSchemeModelImplToJson(
  _$DiscountSchemeModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'name': instance.name,
  'discount_type': instance.discountType,
  'discount_value': instance.discountValue,
  'min_purchase_amount': instance.minPurchaseAmount,
  'valid_from': instance.validFrom,
  'valid_to': instance.validTo,
  'is_active': instance.isActive,
};
