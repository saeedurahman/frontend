import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/returns/data/models/refund_line_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

part 'process_return_state.freezed.dart';

@freezed
class ReturnLineFormItem with _$ReturnLineFormItem {
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

  Decimal get lineRefundAmount {
    final qty = returnQtyDecimal;
    final origQty = originalQtyDecimal;
    if (qty <= Decimal.zero || origQty <= Decimal.zero) {
      return Decimal.zero;
    }
    final netBeforeTax =
        (origQty * unitPriceDecimal) - originalDiscountAmountDecimal;
    final proratedNet = DecimalUtils.fromRational(
      netBeforeTax * qty / origQty,
      fractionDigits: 2,
    );
    final proratedTax = DecimalUtils.fromRational(
      originalTaxAmountDecimal * qty / origQty,
      fractionDigits: 2,
    );
    return proratedNet + proratedTax;
  }
}

@freezed
class ProcessReturnState with _$ProcessReturnState {
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

  Decimal get totalReturnAmount => returnLines.fold(
        Decimal.zero,
        (sum, line) => sum + line.lineRefundAmount,
      );

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
      totalRefundEntered >= totalReturnAmount &&
      totalReturnAmount > Decimal.zero;
}
