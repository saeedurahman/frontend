import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';

part 'goods_receipt_state.freezed.dart';

@freezed
class GoodsReceiptLineItem with _$GoodsReceiptLineItem {
  const GoodsReceiptLineItem._();

  const factory GoodsReceiptLineItem({
    required PurchaseLineModel line,
    @Default('') String qtyReceived,
    @Default('') String costPerUnit,
    @Default('') String batchNumber,
    DateTime? expiryDate,
  }) = _GoodsReceiptLineItem;

  double get maxQty => double.tryParse(line.qtyToReceive) ?? 0;
}

@freezed
class GoodsReceiptState with _$GoodsReceiptState {
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
