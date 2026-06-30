import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

abstract final class SaleCalculations {
  static Decimal lineTotal(SaleLineModel line) {
    if (line.lineTotal != null && line.lineTotal!.isNotEmpty) {
      return DecimalUtils.parse(line.lineTotal!);
    }
    final qty = DecimalUtils.parse(line.qty);
    final price = DecimalUtils.parse(line.unitPrice);
    final discount = DecimalUtils.parse(line.discountAmount);
    final tax = DecimalUtils.parse(line.taxAmount ?? '0');
    return (qty * price) - discount + tax;
  }

  static Decimal sumLines(List<SaleLineModel> lines) =>
      lines.fold(Decimal.zero, (sum, line) => sum + lineTotal(line));

  static Decimal totalPaid(SaleResponseModel sale) {
    if (sale.totalPaid != null && sale.totalPaid!.isNotEmpty) {
      return DecimalUtils.parse(sale.totalPaid!);
    }
    return sale.payments.fold(
      Decimal.zero,
      (sum, p) => sum + DecimalUtils.parse(p.amount),
    );
  }

  static Decimal balanceDue(SaleResponseModel sale) {
    final total = DecimalUtils.parse(sale.totalAmount);
    final paid = totalPaid(sale);
    final due = total - paid;
    return due > Decimal.zero ? due : Decimal.zero;
  }
}

abstract final class SaleStatus {
  static const draft = 'draft';
  static const held = 'held';
  static const completed = 'completed';
  static const partiallyPaid = 'partially_paid';
  static const cancelled = 'cancelled';
  static const voided = 'voided';

  static bool canCancel(String status) =>
      status != completed && status != voided && status != cancelled;

  static bool canReturn(String status) =>
      status == completed || status == partiallyPaid;

  static bool hasReturnLines(SaleResponseModel sale) => sale.lines.any(
        (line) => (Decimal.tryParse(line.returnedQty) ?? Decimal.zero) > Decimal.zero,
      );

  static bool isVoidCandidate(SaleResponseModel sale) =>
      sale.saleStatus == completed &&
      sale.registerShiftId != null &&
      sale.registerShiftId!.trim().isNotEmpty &&
      !hasReturnLines(sale);
}
