import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/returns/data/models/refund_line_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

part 'process_return_state.freezed.dart';

@freezed
abstract class ReturnLineFormItem with _$ReturnLineFormItem {
  const ReturnLineFormItem._();

  const factory ReturnLineFormItem({
    required String originalSaleLineId,
    required String productId,
    String? variationId,
    required String productName,
    String? variationName,
    required String originalQty,
    @Default('0') String alreadyReturnedQty,
    @Default('0') String returnQty,
    required String unitPrice,
    @Default('0') String originalTaxAmount,
    @Default('0') String originalDiscountAmount,
    // The sale's own tax mode (snapshot): prices already include tax.
    @Default(false) bool taxInclusive,
  }) = _ReturnLineFormItem;

  Decimal get originalQtyDecimal => DecimalUtils.parse(originalQty);

  Decimal get alreadyReturnedQtyDecimal =>
      DecimalUtils.parse(alreadyReturnedQty);

  Decimal get returnQtyDecimal => DecimalUtils.parse(returnQty);

  Decimal get unitPriceDecimal => DecimalUtils.parse(unitPrice);

  Decimal get originalTaxAmountDecimal =>
      DecimalUtils.parse(originalTaxAmount);

  Decimal get originalDiscountAmountDecimal =>
      DecimalUtils.parse(originalDiscountAmount);

  Decimal get maxReturnableQty =>
      originalQtyDecimal - alreadyReturnedQtyDecimal;

  /// What this line refunds, un-rounded: the sale's net, tax and discount
  /// prorated by the returned share of the line (the server's rule). Prices
  /// that include tax already hold the tax, so it is not added again.
  Decimal get exactRefund {
    final qty = returnQtyDecimal;
    final origQty = originalQtyDecimal;
    if (qty <= Decimal.zero || origQty <= Decimal.zero) {
      return Decimal.zero;
    }
    final afterDiscount =
        (origQty * unitPriceDecimal) - originalDiscountAmountDecimal;
    final lineTotal =
        taxInclusive ? afterDiscount : afterDiscount + originalTaxAmountDecimal;
    return DecimalUtils.fromRational(
      (lineTotal * qty / origQty),
      fractionDigits: 8,
    );
  }

  /// Shown per line only; the refund total is rounded once, not per line.
  Decimal get lineRefundAmount => PricingEngine.round2(exactRefund);
}

@freezed
abstract class ProcessReturnState with _$ProcessReturnState {
  const ProcessReturnState._();

  const factory ProcessReturnState({
    SaleResponseModel? originalSale,
    CustomerModel? customer,
    @Default([]) List<ReturnLineFormItem> returnLines,
    @Default([]) List<RefundLineModel> refundLines,
    String? reason,
    String? notes,
    String? activeShiftId,
    @Default(false) bool isLoading,
    @Default(false) bool isCheckingShift,
    @Default(false) bool isSubmitting,
    @Default(false) bool accessDenied,
    String? error,
    String? submitError,
  }) = _ProcessReturnState;

  bool get hasReturnableLines =>
      returnLines.any((line) => line.returnQtyDecimal > Decimal.zero);

  /// Refund total: the prorated lines added up exactly, then rounded once with
  /// the sale's own rounding mode (a full return equals the sale total).
  Decimal get totalReturnAmount {
    final exact = returnLines.fold(
      Decimal.zero,
      (sum, line) => sum + line.exactRefund,
    );
    return PricingEngine.roundTotal(exact, originalSale?.taxRoundingMode).$1;
  }

  Decimal get totalRefundEntered => refundLines.fold(
        Decimal.zero,
        (sum, line) => sum + line.amount,
      );

  Decimal get remainingToRefund => totalReturnAmount - totalRefundEntered;

  bool get hasCashRefund =>
      refundLines.any((line) => line.paymentMethod == 'cash');

  bool get canSubmit =>
      !isLoading &&
      !isSubmitting &&
      originalSale != null &&
      hasReturnableLines &&
      reason != null &&
      reason!.isNotEmpty &&
      (reason != 'Other' || (notes != null && notes!.trim().isNotEmpty)) &&
      totalRefundEntered == totalReturnAmount &&
      totalReturnAmount > Decimal.zero;
}
