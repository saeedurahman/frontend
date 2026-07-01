// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_of_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChartOfAccountModelImpl _$$ChartOfAccountModelImplFromJson(
  Map<String, dynamic> json,
) => _$ChartOfAccountModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  parentId: json['parent_id'] as String?,
  accountCode: json['account_code'] as String,
  accountName: json['account_name'] as String,
  accountType: json['account_type'] as String,
  accountSubtype: json['account_subtype'] as String?,
  isSystem: json['is_system'] as bool? ?? false,
  isActive: json['is_active'] as bool? ?? true,
  description: json['description'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  deletedAt: json['deleted_at'] as String?,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => ChartOfAccountModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ChartOfAccountModelImplToJson(
  _$ChartOfAccountModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'parent_id': instance.parentId,
  'account_code': instance.accountCode,
  'account_name': instance.accountName,
  'account_type': instance.accountType,
  'account_subtype': instance.accountSubtype,
  'is_system': instance.isSystem,
  'is_active': instance.isActive,
  'description': instance.description,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'deleted_at': instance.deletedAt,
  'children': instance.children,
};
