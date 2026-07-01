// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalEntryListModelImpl _$$JournalEntryListModelImplFromJson(
  Map<String, dynamic> json,
) => _$JournalEntryListModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String?,
  entryNumber: json['entry_number'] as String,
  status: json['status'] as String,
  entryDate: json['entry_date'] as String,
  description: json['description'] as String?,
  referenceType: json['reference_type'] as String?,
  postedAt: json['posted_at'] as String?,
  totalDebit: json['total_debit'] as String,
  totalCredit: json['total_credit'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$$JournalEntryListModelImplToJson(
  _$JournalEntryListModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'branch_id': instance.branchId,
  'entry_number': instance.entryNumber,
  'status': instance.status,
  'entry_date': instance.entryDate,
  'description': instance.description,
  'reference_type': instance.referenceType,
  'posted_at': instance.postedAt,
  'total_debit': instance.totalDebit,
  'total_credit': instance.totalCredit,
  'created_at': instance.createdAt,
};
