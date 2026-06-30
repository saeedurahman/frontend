import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';
import 'package:frantend/features/settings/data/models/business_config_model.dart';

part 'business_profile_model.freezed.dart';
part 'business_profile_model.g.dart';

@freezed
class BusinessTypeModel with _$BusinessTypeModel {
  const factory BusinessTypeModel({
    required String id,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _BusinessTypeModel;

  factory BusinessTypeModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessTypeModelFromJson(json);
}

@freezed
class BusinessProfileModel with _$BusinessProfileModel {
  const factory BusinessProfileModel({
    required String id,
    required String name,
    @JsonKey(name: 'legal_name') String? legalName,
    String? email,
    String? phone,
    @JsonKey(name: 'tax_id') String? taxId,
    @JsonKey(name: 'address_line1') String? addressLine1,
    @JsonKey(name: 'logo_url') String? logoUrl,
    String? city,
    @JsonKey(name: 'country_code') @Default('PK') String countryCode,
    @JsonKey(name: 'currency_code') @Default('PKR') String currencyCode,
    @JsonKey(name: 'subscription_plan') String? subscriptionPlan,
    @JsonKey(name: 'subscription_status') String? subscriptionStatus,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'business_type') BusinessTypeModel? businessType,
    BusinessConfigModel? config,
    @Default([]) List<BranchModel> branches,
  }) = _BusinessProfileModel;

  factory BusinessProfileModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileModelFromJson(json);
}
