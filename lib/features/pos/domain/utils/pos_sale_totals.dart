import 'package:decimal/decimal.dart';

/// Totals of the cart as the server will record them.
///
/// [totalAmount] is the grand total the customer pays (after the optional
/// rounding of the grand total); [exactTotal] is net + tax before it and
/// [roundingAmount] the signed difference (negative when rounded down).
class PosSaleTotals {
  const PosSaleTotals({
    required this.subtotal,
    required this.totalDiscount,
    required this.totalTax,
    required this.totalAmount,
    Decimal? netAmount,
    Decimal? exactTotal,
    Decimal? roundingAmount,
  })  : _netAmount = netAmount,
        _exactTotal = exactTotal,
        _roundingAmount = roundingAmount;

  final Decimal subtotal;
  final Decimal totalDiscount;
  final Decimal totalTax;
  final Decimal totalAmount;
  final Decimal? _netAmount;
  final Decimal? _exactTotal;
  final Decimal? _roundingAmount;

  /// Amount before tax (after discounts).
  Decimal get netAmount => _netAmount ?? subtotal - totalDiscount;
  Decimal get roundingAmount => _roundingAmount ?? Decimal.zero;
  Decimal get exactTotal => _exactTotal ?? totalAmount - roundingAmount;

  bool get hasRounding => roundingAmount != Decimal.zero;

  static PosSaleTotals get zero => PosSaleTotals(
        subtotal: Decimal.zero,
        totalDiscount: Decimal.zero,
        totalTax: Decimal.zero,
        totalAmount: Decimal.zero,
      );
}
