import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';

part 'customers_list_state.freezed.dart';

enum CustomerActiveFilter { all, active, inactive }

@freezed
class CustomerListRow with _$CustomerListRow {
  const factory CustomerListRow({
    required CustomerModel customer,
    String? balance,
    @Default(false) bool balanceLoading,
  }) = _CustomerListRow;
}

@Freezed()
sealed class CustomersListState with _$CustomersListState {
  const factory CustomersListState.initial() = CustomersListInitial;

  const factory CustomersListState.loading() = CustomersListLoading;

  const factory CustomersListState.loaded({
    required List<CustomerListRow> allItems,
    required List<CustomerListRow> filteredItems,
    String? searchQuery,
    @Default(CustomerActiveFilter.all) CustomerActiveFilter activeFilter,
    @Default(false) bool hasOutstandingOnly,
  }) = CustomersListLoaded;

  const factory CustomersListState.error(String message) = CustomersListError;
}
