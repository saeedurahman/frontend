// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_ledger_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerLedgerEntryModelImpl _$$CustomerLedgerEntryModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerLedgerEntryModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  customerId: json['customer_id'] as String,
  entryType: $enumDecode(_$LedgerEntryTypeEnumMap, json['entry_type']),
  amount: json['amount'] as String,
  referenceType: json['reference_type'] as String?,
  referenceId: json['reference_id'] as String?,
  entryAt: json['entry_at'] as String?,
  notes: json['notes'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$$CustomerLedgerEntryModelImplToJson(
  _$CustomerLedgerEntryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'customer_id': instance.customerId,
  'entry_type': _$LedgerEntryTypeEnumMap[instance.entryType]!,
  'amount': instance.amount,
  'reference_type': instance.referenceType,
  'reference_id': instance.referenceId,
  'entry_at': instance.entryAt,
  'notes': instance.notes,
  'created_at': instance.createdAt,
};

const _$LedgerEntryTypeEnumMap = {
  LedgerEntryType.sale: 'sale',
  LedgerEntryType.payment: 'payment',
  LedgerEntryType.return_: 'return_',
  LedgerEntryType.openingBalance: 'opening_balance',
  LedgerEntryType.adjustment: 'adjustment',
  LedgerEntryType.refund: 'refund',
};
