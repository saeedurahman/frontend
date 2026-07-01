// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_line_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalLineModelImpl _$$JournalLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$JournalLineModelImpl(
  id: json['id'] as String,
  accountId: json['account_id'] as String,
  accountCode: json['account_code'] as String,
  accountName: json['account_name'] as String,
  debitAmount: json['debit_amount'] as String,
  creditAmount: json['credit_amount'] as String,
  description: json['description'] as String?,
  lineOrder: (json['line_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$JournalLineModelImplToJson(
  _$JournalLineModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'account_id': instance.accountId,
  'account_code': instance.accountCode,
  'account_name': instance.accountName,
  'debit_amount': instance.debitAmount,
  'credit_amount': instance.creditAmount,
  'description': instance.description,
  'line_order': instance.lineOrder,
};
