import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/sales/data/models/sale_list_item_model.dart';

part 'sales_list_state.freezed.dart';

@freezed
sealed class SalesListState with _$SalesListState {
  const factory SalesListState.initial() = SalesListInitial;

  const factory SalesListState.loading() = SalesListLoading;

  const factory SalesListState.loaded({
    required List<SaleListItemModel> items,
    required int total,
    required int skip,
    required int limit,
    String? statusFilter,
    String? branchIdFilter,
    String? searchQuery,
    DateTime? dateFrom,
    DateTime? dateTo,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasActiveFilters,
  }) = SalesListLoaded;

  const factory SalesListState.error(String message) = SalesListError;
}
