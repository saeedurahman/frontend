import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';

part 'suppliers_list_state.freezed.dart';

@freezed
class SupplierListRow with _$SupplierListRow {
  const factory SupplierListRow({
    required SupplierModel supplier,
    String? balance,
    @Default(false) bool balanceLoading,
  }) = _SupplierListRow;
}

@Freezed()
sealed class SuppliersListState with _$SuppliersListState {
  const factory SuppliersListState.initial() = SuppliersListInitial;

  const factory SuppliersListState.loading() = SuppliersListLoading;

  const factory SuppliersListState.loaded({
    required List<SupplierListRow> allItems,
    required List<SupplierListRow> filteredItems,
    String? searchQuery,
  }) = SuppliersListLoaded;

  const factory SuppliersListState.error(String message) = SuppliersListError;
}
