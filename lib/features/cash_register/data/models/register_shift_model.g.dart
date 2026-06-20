// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterShiftModelImpl _$$RegisterShiftModelImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterShiftModelImpl(
  id: json['id'] as String,
  cashRegisterId: json['cash_register_id'] as String,
  branchId: json['branch_id'] as String?,
  openedBy: json['opened_by'] as String?,
  closedBy: json['closed_by'] as String?,
  openedByName: json['opened_by_name'] as String?,
  closedByName: json['closed_by_name'] as String?,
  openingFloat: json['opening_float'] as String? ?? '0',
  expectedCash: json['expected_cash'] as String?,
  actualCash: json['actual_cash'] as String?,
  cashDifference: json['cash_difference'] as String?,
  openedAt: json['opened_at'] as String?,
  closedAt: json['closed_at'] as String?,
  status: json['status'] as String? ?? 'open',
  notes: json['notes'] as String?,
  register: json['register'] == null
      ? null
      : CashRegisterModel.fromJson(json['register'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$RegisterShiftModelImplToJson(
  _$RegisterShiftModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'cash_register_id': instance.cashRegisterId,
  'branch_id': instance.branchId,
  'opened_by': instance.openedBy,
  'closed_by': instance.closedBy,
  'opened_by_name': instance.openedByName,
  'closed_by_name': instance.closedByName,
  'opening_float': instance.openingFloat,
  'expected_cash': instance.expectedCash,
  'actual_cash': instance.actualCash,
  'cash_difference': instance.cashDifference,
  'opened_at': instance.openedAt,
  'closed_at': instance.closedAt,
  'status': instance.status,
  'notes': instance.notes,
  'register': instance.register,
};
