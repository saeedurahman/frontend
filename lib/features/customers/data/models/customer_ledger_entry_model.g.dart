// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_ledger_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerLedgerEntryModel _$CustomerLedgerEntryModelFromJson(
  Map<String, dynamic> json,
) => _CustomerLedgerEntryModel(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  customerId: json['customer_id'] as String,
  entryType: $enumDecode(
    _$LedgerEntryTypeEnumMap,
    json['entry_type'],
    unknownValue: LedgerEntryType.adjustment,
  ),
  amount: json['amount'] as String,
  referenceType: json['reference_type'] as String?,
  referenceId: json['reference_id'] as String?,
  entryAt: json['entry_at'] as String?,
  notes: json['notes'] as String?,
  createdAt: json['created_at'] as String?,
  branchId: json['branch_id'] as String?,
  paymentSource: json['payment_source'] as String?,
  referenceNo: json['reference_no'] as String?,
  registerShiftId: json['register_shift_id'] as String?,
  reversalOfId: json['reversal_of_id'] as String?,
  reversedById: json['reversed_by_id'] as String?,
  reversedAt: json['reversed_at'] as String?,
  isReversed: json['is_reversed'] as bool? ?? false,
  isReversal: json['is_reversal'] as bool? ?? false,
  runningBalance: json['running_balance'] as String?,
);

Map<String, dynamic> _$CustomerLedgerEntryModelToJson(
  _CustomerLedgerEntryModel instance,
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
  'branch_id': instance.branchId,
  'payment_source': instance.paymentSource,
  'reference_no': instance.referenceNo,
  'register_shift_id': instance.registerShiftId,
  'reversal_of_id': instance.reversalOfId,
  'reversed_by_id': instance.reversedById,
  'reversed_at': instance.reversedAt,
  'is_reversed': instance.isReversed,
  'is_reversal': instance.isReversal,
  'running_balance': instance.runningBalance,
};

const _$LedgerEntryTypeEnumMap = {
  LedgerEntryType.sale: 'sale',
  LedgerEntryType.payment: 'payment',
  LedgerEntryType.return_: 'return_',
  LedgerEntryType.openingBalance: 'opening_balance',
  LedgerEntryType.adjustment: 'adjustment',
  LedgerEntryType.refund: 'refund',
  LedgerEntryType.reversal: 'reversal',
  LedgerEntryType.correction: 'correction',
};
