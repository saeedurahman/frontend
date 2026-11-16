// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => _RoleModel(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  isSystem: json['is_system'] as bool? ?? false,
  permissionKeys:
      (json['permission_keys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$RoleModelToJson(_RoleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'name': instance.name,
      'description': instance.description,
      'is_system': instance.isSystem,
      'permission_keys': instance.permissionKeys,
    };
