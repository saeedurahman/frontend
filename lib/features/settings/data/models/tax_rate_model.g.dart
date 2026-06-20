// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaxRateModelImpl _$$TaxRateModelImplFromJson(Map<String, dynamic> json) =>
    _$TaxRateModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      rate: json['rate'] as String,
      isCompound: json['is_compound'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$TaxRateModelImplToJson(_$TaxRateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'name': instance.name,
      'rate': instance.rate,
      'is_compound': instance.isCompound,
      'is_active': instance.isActive,
    };
