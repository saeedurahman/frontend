import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';

part 'production_orders_list_state.freezed.dart';

@Freezed()
sealed class ProductionOrdersListState with _$ProductionOrdersListState {
  const factory ProductionOrdersListState.initial() =
      ProductionOrdersListInitial;

  const factory ProductionOrdersListState.loading() =
      ProductionOrdersListLoading;

  const factory ProductionOrdersListState.loaded({
    required List<ProductionOrderModel> allOrders,
    required List<ProductionOrderModel> filteredOrders,
    String? statusFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
    @Default(false) bool canCreate,
    @Default({}) Map<String, String> branchNames,
  }) = ProductionOrdersListLoaded;

  const factory ProductionOrdersListState.error(String message) =
      ProductionOrdersListError;

  const factory ProductionOrdersListState.accessDenied() =
      ProductionOrdersListAccessDenied;
}
