// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessTypeModelImpl _$$BusinessTypeModelImplFromJson(
  Map<String, dynamic> json,
) => _$BusinessTypeModelImpl(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$$BusinessTypeModelImplToJson(
  _$BusinessTypeModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'description': instance.description,
  'is_active': instance.isActive,
};

_$BusinessProfileModelImpl _$$BusinessProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$BusinessProfileModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  legalName: json['legal_name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  taxId: json['tax_id'] as String?,
  addressLine1: json['address_line1'] as String?,
  logoUrl: json['logo_url'] as String?,
  city: json['city'] as String?,
  countryCode: json['country_code'] as String? ?? 'PK',
  currencyCode: json['currency_code'] as String? ?? 'PKR',
  subscriptionPlan: json['subscription_plan'] as String?,
  subscriptionStatus: json['subscription_status'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  businessType: json['business_type'] == null
      ? null
      : BusinessTypeModel.fromJson(
          json['business_type'] as Map<String, dynamic>,
        ),
  config: json['config'] == null
      ? null
      : BusinessConfigModel.fromJson(json['config'] as Map<String, dynamic>),
  branches:
      (json['branches'] as List<dynamic>?)
          ?.map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$BusinessProfileModelImplToJson(
  _$BusinessProfileModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'legal_name': instance.legalName,
  'email': instance.email,
  'phone': instance.phone,
  'tax_id': instance.taxId,
  'address_line1': instance.addressLine1,
  'logo_url': instance.logoUrl,
  'city': instance.city,
  'country_code': instance.countryCode,
  'currency_code': instance.currencyCode,
  'subscription_plan': instance.subscriptionPlan,
  'subscription_status': instance.subscriptionStatus,
  'is_active': instance.isActive,
  'business_type': instance.businessType,
  'config': instance.config,
  'branches': instance.branches,
};
