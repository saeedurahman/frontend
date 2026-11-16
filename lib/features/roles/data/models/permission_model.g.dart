// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PermissionModel _$PermissionModelFromJson(Map<String, dynamic> json) =>
    _PermissionModel(
      permissionKey: json['permission_key'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PermissionModelToJson(_PermissionModel instance) =>
    <String, dynamic>{
      'permission_key': instance.permissionKey,
      'description': instance.description,
    };

_PermissionModuleModel _$PermissionModuleModelFromJson(
  Map<String, dynamic> json,
) => _PermissionModuleModel(
  module: json['module'] as String,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PermissionModuleModelToJson(
  _PermissionModuleModel instance,
) => <String, dynamic>{
  'module': instance.module,
  'permissions': instance.permissions,
};

_PermissionsCatalogModel _$PermissionsCatalogModelFromJson(
  Map<String, dynamic> json,
) => _PermissionsCatalogModel(
  modules:
      (json['modules'] as List<dynamic>?)
          ?.map(
            (e) => PermissionModuleModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$PermissionsCatalogModelToJson(
  _PermissionsCatalogModel instance,
) => <String, dynamic>{'modules': instance.modules};
