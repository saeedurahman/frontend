// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffUserModel _$StaffUserModelFromJson(Map<String, dynamic> json) =>
    _StaffUserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      branchId: json['branch_id'] as String?,
      branchName: json['branch_name'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)
              ?.map((e) => StaffRoleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isActive: json['is_active'] as bool? ?? true,
      lastLoginAt: json['last_login_at'] as String?,
    );

Map<String, dynamic> _$StaffUserModelToJson(_StaffUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'branch_id': instance.branchId,
      'branch_name': instance.branchName,
      'roles': instance.roles,
      'is_active': instance.isActive,
      'last_login_at': instance.lastLoginAt,
    };
