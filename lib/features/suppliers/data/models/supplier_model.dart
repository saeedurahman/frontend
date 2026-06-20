import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_model.freezed.dart';
part 'supplier_model.g.dart';

@freezed
class SupplierModel with _$SupplierModel {
  const factory SupplierModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    @JsonKey(name: 'contact_person') String? contactPerson,
    String? email,
    String? phone,
    @JsonKey(name: 'tax_id') String? taxId,
    @JsonKey(name: 'address_line1') String? addressLine1,
    String? city,
    @JsonKey(name: 'payment_terms_days') @Default(30) int paymentTermsDays,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _SupplierModel;

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);
}

@freezed
class SupplierBalanceModel with _$SupplierBalanceModel {
  const factory SupplierBalanceModel({
    @JsonKey(name: 'supplier_id') required String supplierId,
    required String balance,
  }) = _SupplierBalanceModel;

  factory SupplierBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierBalanceModelFromJson(json);
}
