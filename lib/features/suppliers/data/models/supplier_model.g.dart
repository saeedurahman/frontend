// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupplierModelImpl _$$SupplierModelImplFromJson(Map<String, dynamic> json) =>
    _$SupplierModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      contactPerson: json['contact_person'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      taxId: json['tax_id'] as String?,
      addressLine1: json['address_line1'] as String?,
      city: json['city'] as String?,
      paymentTermsDays: (json['payment_terms_days'] as num?)?.toInt() ?? 30,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$SupplierModelImplToJson(_$SupplierModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'name': instance.name,
      'contact_person': instance.contactPerson,
      'email': instance.email,
      'phone': instance.phone,
      'tax_id': instance.taxId,
      'address_line1': instance.addressLine1,
      'city': instance.city,
      'payment_terms_days': instance.paymentTermsDays,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$SupplierBalanceModelImpl _$$SupplierBalanceModelImplFromJson(
  Map<String, dynamic> json,
) => _$SupplierBalanceModelImpl(
  supplierId: json['supplier_id'] as String,
  balance: json['balance'] as String,
);

Map<String, dynamic> _$$SupplierBalanceModelImplToJson(
  _$SupplierBalanceModelImpl instance,
) => <String, dynamic>{
  'supplier_id': instance.supplierId,
  'balance': instance.balance,
};
