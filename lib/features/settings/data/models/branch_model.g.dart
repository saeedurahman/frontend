// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BranchModel _$BranchModelFromJson(Map<String, dynamic> json) => _BranchModel(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  name: json['name'] as String,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  isDefault: json['is_default'] as bool? ?? false,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$BranchModelToJson(_BranchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'is_default': instance.isDefault,
      'is_active': instance.isActive,
    };
