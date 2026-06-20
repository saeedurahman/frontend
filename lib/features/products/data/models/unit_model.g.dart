// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnitModelImpl _$$UnitModelImplFromJson(Map<String, dynamic> json) =>
    _$UnitModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      isBaseUnit: json['is_base_unit'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$UnitModelImplToJson(_$UnitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'name': instance.name,
      'symbol': instance.symbol,
      'is_base_unit': instance.isBaseUnit,
      'is_active': instance.isActive,
    };

_$UnitConversionModelImpl _$$UnitConversionModelImplFromJson(
  Map<String, dynamic> json,
) => _$UnitConversionModelImpl(
  id: json['id'] as String,
  fromUnitId: json['from_unit_id'] as String,
  toUnitId: json['to_unit_id'] as String,
  conversionFactor: json['conversion_factor'] as String,
);

Map<String, dynamic> _$$UnitConversionModelImplToJson(
  _$UnitConversionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'from_unit_id': instance.fromUnitId,
  'to_unit_id': instance.toUnitId,
  'conversion_factor': instance.conversionFactor,
};
