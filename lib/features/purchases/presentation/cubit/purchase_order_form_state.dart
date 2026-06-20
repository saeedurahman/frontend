import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';

part 'purchase_order_form_state.freezed.dart';

@freezed
class PurchaseLineFormItem with _$PurchaseLineFormItem {
  const PurchaseLineFormItem._();

  const factory PurchaseLineFormItem({
    String? productId,
    String? productName,
    String? variationId,
    String? variationName,
    @Default('') String orderedQty,
    @Default('') String costPerUnit,
    @Default('0') String taxRate,
    @Default([]) List<VariationModel> variations,
  }) = _PurchaseLineFormItem;

  double get lineSubtotal {
    final qty = double.tryParse(orderedQty) ?? 0;
    final cost = double.tryParse(costPerUnit) ?? 0;
    final tax = double.tryParse(taxRate) ?? 0;
    return qty * cost * (1 + tax / 100);
  }
}

@freezed
class PurchaseOrderFormState with _$PurchaseOrderFormState {
  const PurchaseOrderFormState._();

  const factory PurchaseOrderFormState({
    String? branchId,
    String? supplierId,
    DateTime? expectedAt,
    @Default('') String notes,
    @Default([]) List<PurchaseLineFormItem> lines,
    @Default([]) List<SupplierModel> suppliers,
    @Default([]) List<ProductListItemModel> products,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default({}) Map<String, String> errors,
  }) = _PurchaseOrderFormState;

  double get subtotal =>
      lines.fold(0, (sum, line) => sum + (line.orderedQty.isEmpty || line.costPerUnit.isEmpty
          ? 0
          : (double.tryParse(line.orderedQty) ?? 0) * (double.tryParse(line.costPerUnit) ?? 0)));

  double get taxTotal => lines.fold(0, (sum, line) {
        final qty = double.tryParse(line.orderedQty) ?? 0;
        final cost = double.tryParse(line.costPerUnit) ?? 0;
        final tax = double.tryParse(line.taxRate) ?? 0;
        return sum + qty * cost * tax / 100;
      });

  double get grandTotal => subtotal + taxTotal;
}
