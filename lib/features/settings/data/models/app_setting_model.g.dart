// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettingModel _$AppSettingModelFromJson(Map<String, dynamic> json) =>
    _AppSettingModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      branchId: json['branch_id'] as String?,
      settingKey: json['setting_key'] as String,
      settingValue: json['setting_value'] as Map<String, dynamic>,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$AppSettingModelToJson(_AppSettingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'branch_id': instance.branchId,
      'setting_key': instance.settingKey,
      'setting_value': instance.settingValue,
      'updated_at': instance.updatedAt,
    };
