import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';

part 'goods_receipt_state.freezed.dart';

@freezed
abstract class GoodsReceiptLineItem with _$GoodsReceiptLineItem {
  const GoodsReceiptLineItem._();

  const factory GoodsReceiptLineItem({
    required PurchaseLineModel line,
    @Default('') String qtyReceived,
    @Default('') String costPerUnit,
    @Default('') String batchNumber,
    DateTime? expiryDate,

    /// The product tracks expiry: batch number and expiry date are required.
    @Default(false) bool trackExpiry,
  }) = _GoodsReceiptLineItem;

  double get maxQty => double.tryParse(line.qtyToReceive) ?? 0;
}

/// The bill total of what is being received now: quantity x cost per line.
extension GoodsReceiptTotal on GoodsReceiptState {
  Decimal get total {
    var sum = Decimal.zero;
    for (final item in lines) {
      final qty = Decimal.tryParse(item.qtyReceived.trim()) ?? Decimal.zero;
      final cost = Decimal.tryParse(item.costPerUnit.trim()) ?? Decimal.zero;
      if (qty > Decimal.zero && cost > Decimal.zero) sum += qty * cost;
    }
    return sum.round(scale: 2);
  }
}

@freezed
abstract class GoodsReceiptState with _$GoodsReceiptState {
  const factory GoodsReceiptState({
    String? branchId,
    PurchaseOrderModel? order,
    @Default([]) List<GoodsReceiptLineItem> lines,
    DateTime? receivedAt,
    @Default('') String supplierInvoiceNo,
    @Default('') String notes,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default({}) Map<String, String> errors,
  }) = _GoodsReceiptState;
}
