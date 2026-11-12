import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/core/utils/json_num.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.role = '',
    this.businessId,
    this.branchId,
    this.businessName,
    this.businessSlug,
    this.businessTypeCode,
    this.roles = const [],
    this.permissionKeys = const [],
    this.permissionsVersion,
    this.branchIds = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String id;
  @JsonKey(name: 'full_name')
  final String name;
  final String? email;
  final String? phone;
  @JsonKey(defaultValue: '')
  final String role;
  @JsonKey(name: 'business_id')
  final String? businessId;
  @JsonKey(name: 'branch_id')
  final String? branchId;
  @JsonKey(name: 'business_name')
  final String? businessName;
  @JsonKey(name: 'business_slug')
  final String? businessSlug;
  @JsonKey(name: 'business_type_code')
  final String? businessTypeCode;
  @JsonKey(name: 'roles')
  final List<String> roles;
  @JsonKey(name: 'permission_keys')
  final List<String> permissionKeys;

  /// Fingerprint (string) of roles + permissions + branch scope; changes
  /// whenever the user's access changes. Never compare numerically.
  @JsonKey(name: 'permissions_version', fromJson: JsonNum.stringOrNull)
  final String? permissionsVersion;

  /// Branches the user is limited to. Empty = no branch restriction sent.
  @JsonKey(name: 'branch_ids', defaultValue: <String>[])
  final List<String> branchIds;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() => User(
        id: id,
        email: email ?? phone ?? '',
        name: name,
        role: role,
        businessId: businessId,
        branchId: branchId,
        businessSlug: businessSlug,
        roles: roles,
        permissionKeys: permissionKeys,
        permissionsVersion: permissionsVersion,
        branchIds: branchIds,
      );

  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        phone: user.email.isNotEmpty ? user.email : null,
        name: user.name,
        role: user.role,
        businessId: user.businessId,
        branchId: user.branchId,
        businessSlug: user.businessSlug,
        roles: user.roles,
        permissionKeys: user.permissionKeys,
        permissionsVersion: user.permissionsVersion,
        branchIds: user.branchIds,
      );
}
