import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_model.freezed.dart';
part 'permission_model.g.dart';

@freezed
abstract class PermissionModel with _$PermissionModel {
  const factory PermissionModel({
    @JsonKey(name: 'permission_key') required String permissionKey,
    required String description,
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);
}

@freezed
abstract class PermissionModuleModel with _$PermissionModuleModel {
  const factory PermissionModuleModel({
    required String module,
    @Default([]) List<PermissionModel> permissions,
  }) = _PermissionModuleModel;

  factory PermissionModuleModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModuleModelFromJson(json);
}

@freezed
abstract class PermissionsCatalogModel with _$PermissionsCatalogModel {
  const factory PermissionsCatalogModel({
    @Default([]) List<PermissionModuleModel> modules,
  }) = _PermissionsCatalogModel;

  factory PermissionsCatalogModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionsCatalogModelFromJson(json);
}
