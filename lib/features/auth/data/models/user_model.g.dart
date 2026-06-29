// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  name: json['full_name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  role: json['role'] as String? ?? 'owner',
  businessId: json['business_id'] as String?,
  branchId: json['branch_id'] as String?,
  businessName: json['business_name'] as String?,
  businessTypeCode: json['business_type_code'] as String?,
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  permissionKeys:
      (json['permission_keys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
  'business_id': instance.businessId,
  'branch_id': instance.branchId,
  'business_name': instance.businessName,
  'business_type_code': instance.businessTypeCode,
  'roles': instance.roles,
  'permission_keys': instance.permissionKeys,
};
