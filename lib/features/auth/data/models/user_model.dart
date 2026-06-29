import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.role = 'owner',
    this.businessId,
    this.branchId,
    this.businessName,
    this.businessTypeCode,
    this.roles = const [],
    this.permissionKeys = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String id;
  @JsonKey(name: 'full_name')
  final String name;
  final String? email;
  final String? phone;
  @JsonKey(defaultValue: 'owner')
  final String role;
  @JsonKey(name: 'business_id')
  final String? businessId;
  @JsonKey(name: 'branch_id')
  final String? branchId;
  @JsonKey(name: 'business_name')
  final String? businessName;
  @JsonKey(name: 'business_type_code')
  final String? businessTypeCode;
  @JsonKey(name: 'roles')
  final List<String> roles;
  @JsonKey(name: 'permission_keys')
  final List<String> permissionKeys;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() => User(
        id: id,
        email: email ?? phone ?? '',
        name: name,
        role: role,
        businessId: businessId,
        branchId: branchId,
        roles: roles,
        permissionKeys: permissionKeys,
      );

  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        phone: user.email.isNotEmpty ? user.email : null,
        name: user.name,
        role: user.role,
        businessId: user.businessId,
        branchId: user.branchId,
        roles: user.roles,
        permissionKeys: user.permissionKeys,
      );
}
