// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessConfigModelImpl _$$BusinessConfigModelImplFromJson(
  Map<String, dynamic> json,
) => _$BusinessConfigModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  enableRestaurant: json['enable_restaurant'] as bool? ?? false,
  enableManufacturing: json['enable_manufacturing'] as bool? ?? false,
  enableWeightBilling: json['enable_weight_billing'] as bool? ?? false,
  enableKot: json['enable_kot'] as bool? ?? false,
  fifoCostingEnabled: json['fifo_costing_enabled'] as bool? ?? true,
  allowNegativeStock: json['allow_negative_stock'] as bool? ?? false,
  configJson: json['config_json'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$BusinessConfigModelImplToJson(
  _$BusinessConfigModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'enable_restaurant': instance.enableRestaurant,
  'enable_manufacturing': instance.enableManufacturing,
  'enable_weight_billing': instance.enableWeightBilling,
  'enable_kot': instance.enableKot,
  'fifo_costing_enabled': instance.fifoCostingEnabled,
  'allow_negative_stock': instance.allowNegativeStock,
  'config_json': instance.configJson,
};
