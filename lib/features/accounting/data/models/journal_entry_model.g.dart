// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalEntryModelImpl _$$JournalEntryModelImplFromJson(
  Map<String, dynamic> json,
) => _$JournalEntryModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String?,
  entryNumber: json['entry_number'] as String,
  status: json['status'] as String,
  entryDate: json['entry_date'] as String,
  description: json['description'] as String?,
  referenceType: json['reference_type'] as String?,
  referenceId: json['reference_id'] as String?,
  postedAt: json['posted_at'] as String?,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => JournalLineModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalDebit: json['total_debit'] as String,
  totalCredit: json['total_credit'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  deletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$$JournalEntryModelImplToJson(
  _$JournalEntryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'branch_id': instance.branchId,
  'entry_number': instance.entryNumber,
  'status': instance.status,
  'entry_date': instance.entryDate,
  'description': instance.description,
  'reference_type': instance.referenceType,
  'reference_id': instance.referenceId,
  'posted_at': instance.postedAt,
  'lines': instance.lines,
  'total_debit': instance.totalDebit,
  'total_credit': instance.totalCredit,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'deleted_at': instance.deletedAt,
};
