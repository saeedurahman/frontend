import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';

part 'purchase_orders_list_state.freezed.dart';

@Freezed()
sealed class PurchaseOrdersListState with _$PurchaseOrdersListState {
  const factory PurchaseOrdersListState.initial() = PurchaseOrdersListInitial;

  const factory PurchaseOrdersListState.loading() = PurchaseOrdersListLoading;

  const factory PurchaseOrdersListState.loaded({
    required List<PurchaseOrderModel> allOrders,
    required List<PurchaseOrderModel> filteredOrders,
    required List<SupplierModel> suppliers,
    String? statusFilter,
    String? supplierFilter,
  }) = PurchaseOrdersListLoaded;

  const factory PurchaseOrdersListState.error(String message) =
      PurchaseOrdersListError;
}
