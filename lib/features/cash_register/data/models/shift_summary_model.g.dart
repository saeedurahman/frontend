// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShiftSummaryModel _$ShiftSummaryModelFromJson(Map<String, dynamic> json) =>
    _ShiftSummaryModel(
      shiftId: json['shift_id'] as String?,
      status: json['status'] as String?,
      openingFloat: json['opening_float'] as String? ?? '0',
      totalCashSales: json['total_cash_sales'] as String? ?? '0',
      totalCardSales: json['total_card_sales'] as String? ?? '0',
      totalWalletSales: json['total_wallet_sales'] as String? ?? '0',
      creditSales: json['credit_sales'] as String? ?? '0',
      totalOtherSales: json['total_other_sales'] as String? ?? '0',
      totalReturns: json['total_returns'] as String? ?? '0',
      totalCashIn: json['total_cash_in'] as String? ?? '0',
      totalCashOut: json['total_cash_out'] as String? ?? '0',
      totalExpenses: json['total_expenses'] as String? ?? '0',
      expectedCash: json['expected_cash'] as String? ?? '0',
      actualCash: json['actual_cash'] as String?,
      cashDifference: json['cash_difference'] as String?,
      cashMovements:
          (json['cash_movements'] as List<dynamic>?)
              ?.map(
                (e) => ShiftCashMovement.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ShiftSummaryModelToJson(_ShiftSummaryModel instance) =>
    <String, dynamic>{
      'shift_id': instance.shiftId,
      'status': instance.status,
      'opening_float': instance.openingFloat,
      'total_cash_sales': instance.totalCashSales,
      'total_card_sales': instance.totalCardSales,
      'total_wallet_sales': instance.totalWalletSales,
      'credit_sales': instance.creditSales,
      'total_other_sales': instance.totalOtherSales,
      'total_returns': instance.totalReturns,
      'total_cash_in': instance.totalCashIn,
      'total_cash_out': instance.totalCashOut,
      'total_expenses': instance.totalExpenses,
      'expected_cash': instance.expectedCash,
      'actual_cash': instance.actualCash,
      'cash_difference': instance.cashDifference,
      'cash_movements': instance.cashMovements,
    };
