import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

@freezed
class RoleModel with _$RoleModel {
  const factory RoleModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    String? description,
    @JsonKey(name: 'is_system') @Default(false) bool isSystem,
    @JsonKey(name: 'permission_keys') @Default([]) List<String> permissionKeys,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);
}
