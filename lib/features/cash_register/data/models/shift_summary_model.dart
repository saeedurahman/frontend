import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/cash_register/data/models/shift_cash_movement.dart';

part 'shift_summary_model.freezed.dart';
part 'shift_summary_model.g.dart';

@freezed
abstract class ShiftSummaryModel with _$ShiftSummaryModel {
  const ShiftSummaryModel._();

  const factory ShiftSummaryModel({
    @JsonKey(name: 'shift_id') String? shiftId,
    String? status,
    @JsonKey(name: 'opening_float') @Default('0') String openingFloat,
    @JsonKey(name: 'total_cash_sales') @Default('0') String totalCashSales,
    @JsonKey(name: 'total_card_sales') @Default('0') String totalCardSales,
    @JsonKey(name: 'total_wallet_sales') @Default('0') String totalWalletSales,

    /// Put on the customer's account (udhaar): no money came in.
    @JsonKey(name: 'credit_sales') @Default('0') String creditSales,

    /// Bank transfer, cheque and "other" only.
    @JsonKey(name: 'total_other_sales') @Default('0') String totalOtherSales,
    @JsonKey(name: 'total_returns') @Default('0') String totalReturns,
    @JsonKey(name: 'total_cash_in') @Default('0') String totalCashIn,
    @JsonKey(name: 'total_cash_out') @Default('0') String totalCashOut,
    @JsonKey(name: 'total_expenses') @Default('0') String totalExpenses,
    @JsonKey(name: 'expected_cash') @Default('0') String expectedCash,
    @JsonKey(name: 'actual_cash') String? actualCash,
    @JsonKey(name: 'cash_difference') String? cashDifference,
    /// Server only: a summary worked out on this device has none.
    @JsonKey(name: 'cash_movements')
    @Default([])
    List<ShiftCashMovement> cashMovements,
  }) = _ShiftSummaryModel;

  factory ShiftSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftSummaryModelFromJson(json);

  Decimal get openingFloatDecimal => DecimalUtils.parse(openingFloat);
  Decimal get expectedCashDecimal => DecimalUtils.parse(expectedCash);
  Decimal get actualCashDecimal =>
      actualCash == null ? Decimal.zero : DecimalUtils.parse(actualCash!);
  Decimal get cashDifferenceDecimal => cashDifference == null
      ? Decimal.zero
      : DecimalUtils.parse(cashDifference!);

  Decimal get totalSalesAmount => DecimalUtils.parse(totalCashSales) +
      DecimalUtils.parse(totalCardSales) +
      DecimalUtils.parse(totalWalletSales) +
      DecimalUtils.parse(creditSales) +
      DecimalUtils.parse(totalOtherSales);
}
