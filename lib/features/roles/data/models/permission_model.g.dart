// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionModelImpl _$$PermissionModelImplFromJson(
  Map<String, dynamic> json,
) => _$PermissionModelImpl(
  permissionKey: json['permission_key'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$$PermissionModelImplToJson(
  _$PermissionModelImpl instance,
) => <String, dynamic>{
  'permission_key': instance.permissionKey,
  'description': instance.description,
};

_$PermissionModuleModelImpl _$$PermissionModuleModelImplFromJson(
  Map<String, dynamic> json,
) => _$PermissionModuleModelImpl(
  module: json['module'] as String,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PermissionModuleModelImplToJson(
  _$PermissionModuleModelImpl instance,
) => <String, dynamic>{
  'module': instance.module,
  'permissions': instance.permissions,
};

_$PermissionsCatalogModelImpl _$$PermissionsCatalogModelImplFromJson(
  Map<String, dynamic> json,
) => _$PermissionsCatalogModelImpl(
  modules:
      (json['modules'] as List<dynamic>?)
          ?.map(
            (e) => PermissionModuleModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PermissionsCatalogModelImplToJson(
  _$PermissionsCatalogModelImpl instance,
) => <String, dynamic>{'modules': instance.modules};
