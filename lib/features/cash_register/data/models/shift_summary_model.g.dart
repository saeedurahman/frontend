// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftSummaryModelImpl _$$ShiftSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShiftSummaryModelImpl(
  shiftId: json['shift_id'] as String?,
  status: json['status'] as String?,
  openingFloat: json['opening_float'] as String? ?? '0',
  totalCashSales: json['total_cash_sales'] as String? ?? '0',
  totalCardSales: json['total_card_sales'] as String? ?? '0',
  totalWalletSales: json['total_wallet_sales'] as String? ?? '0',
  totalOtherSales: json['total_other_sales'] as String? ?? '0',
  totalReturns: json['total_returns'] as String? ?? '0',
  totalCashIn: json['total_cash_in'] as String? ?? '0',
  totalCashOut: json['total_cash_out'] as String? ?? '0',
  totalExpenses: json['total_expenses'] as String? ?? '0',
  expectedCash: json['expected_cash'] as String? ?? '0',
  actualCash: json['actual_cash'] as String?,
  cashDifference: json['cash_difference'] as String?,
);

Map<String, dynamic> _$$ShiftSummaryModelImplToJson(
  _$ShiftSummaryModelImpl instance,
) => <String, dynamic>{
  'shift_id': instance.shiftId,
  'status': instance.status,
  'opening_float': instance.openingFloat,
  'total_cash_sales': instance.totalCashSales,
  'total_card_sales': instance.totalCardSales,
  'total_wallet_sales': instance.totalWalletSales,
  'total_other_sales': instance.totalOtherSales,
  'total_returns': instance.totalReturns,
  'total_cash_in': instance.totalCashIn,
  'total_cash_out': instance.totalCashOut,
  'total_expenses': instance.totalExpenses,
  'expected_cash': instance.expectedCash,
  'actual_cash': instance.actualCash,
  'cash_difference': instance.cashDifference,
};
