// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnitModel _$UnitModelFromJson(Map<String, dynamic> json) => _UnitModel(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  name: json['name'] as String,
  symbol: json['symbol'] as String,
  isBaseUnit: json['is_base_unit'] as bool? ?? false,
  isActive: json['is_active'] as bool? ?? true,
  allowsDecimal: json['allows_decimal'] as bool? ?? false,
);

Map<String, dynamic> _$UnitModelToJson(_UnitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'name': instance.name,
      'symbol': instance.symbol,
      'is_base_unit': instance.isBaseUnit,
      'is_active': instance.isActive,
      'allows_decimal': instance.allowsDecimal,
    };

_UnitConversionModel _$UnitConversionModelFromJson(Map<String, dynamic> json) =>
    _UnitConversionModel(
      id: json['id'] as String,
      fromUnitId: json['from_unit_id'] as String,
      toUnitId: json['to_unit_id'] as String,
      conversionFactor: json['conversion_factor'] as String,
    );

Map<String, dynamic> _$UnitConversionModelToJson(
  _UnitConversionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'from_unit_id': instance.fromUnitId,
  'to_unit_id': instance.toUnitId,
  'conversion_factor': instance.conversionFactor,
};
