import 'package:decimal/decimal.dart';

class PosSaleTotals {
  const PosSaleTotals({
    required this.subtotal,
    required this.totalDiscount,
    required this.totalTax,
    required this.totalAmount,
  });

  final Decimal subtotal;
  final Decimal totalDiscount;
  final Decimal totalTax;
  final Decimal totalAmount;

  static PosSaleTotals get zero => PosSaleTotals(
        subtotal: Decimal.zero,
        totalDiscount: Decimal.zero,
        totalTax: Decimal.zero,
        totalAmount: Decimal.zero,
      );
}
