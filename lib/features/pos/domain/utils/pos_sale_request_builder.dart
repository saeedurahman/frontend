import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/utils/pos_calculations.dart';

/// Builds sale API payloads shared by preview and create.
abstract final class PosSaleRequestBuilder {
  /// Set once the backend contract for cash change is final. While false only
  /// the amount applied to the sale is sent (never the tendered amount), so a
  /// strict schema cannot reject the request.
  static const sendChangeInfo = false;

  static List<Map<String, dynamic>> paymentsJson(
    List<PaymentLineModel> payments,
  ) =>
      payments
          .map((p) => <String, dynamic>{
                'payment_method': p.paymentMethod,
                'amount': DecimalUtils.format(p.amount),
                if (p.referenceNo != null && p.referenceNo!.isNotEmpty)
                  'reference_no': p.referenceNo,
                if (sendChangeInfo && p.tendered != null) ...{
                  'tendered_amount': DecimalUtils.format(p.tendered!),
                  'change_amount': DecimalUtils.format(p.change),
                },
              })
          .toList();

  static Map<String, dynamic> buildBody({
    required String branchId,
    required List<CartItemModel> items,
    String? cartDiscountType,
    Decimal? cartDiscountValue,
    String? discountSchemeId,
    String? registerShiftId,
    String? customerId,
    String? notes,
    String? saleId,
    List<Map<String, dynamic>>? payments,
  }) {
    final lines = PosCalculations.buildSaleLines(
      items: items,
      cartDiscountType: cartDiscountType,
      cartDiscountValue: cartDiscountValue ?? Decimal.zero,
    );

    return {
      if (saleId != null) 'id': saleId,
      'branch_id': branchId,
      'sale_type': 'pos',
      if (registerShiftId != null) 'register_shift_id': registerShiftId,
      if (customerId != null) 'customer_id': customerId,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (discountSchemeId != null) 'discount_scheme_id': discountSchemeId,
      'lines': lines,
      if (payments != null) 'payments': payments,
    };
  }
}
