import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class CustomersListCubit extends Cubit<CustomersListState> {
  CustomersListCubit({
    required GetCustomersUseCase getCustomersUseCase,
    required GetCustomerBalanceUseCase getCustomerBalanceUseCase,
    required UpdateCustomerUseCase updateCustomerUseCase,
  })  : _getCustomers = getCustomersUseCase,
        _getBalance = getCustomerBalanceUseCase,
        _updateCustomer = updateCustomerUseCase,
        super(const CustomersListState.initial());

  final GetCustomersUseCase _getCustomers;
  final GetCustomerBalanceUseCase _getBalance;
  final UpdateCustomerUseCase _updateCustomer;

  Timer? _searchDebounce;
  String? _search;
  CustomerActiveFilter _activeFilter = CustomerActiveFilter.all;
  bool _hasOutstandingOnly = false;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> load() async {
    emit(const CustomersListState.loading());

    final result = await _getCustomers(search: _search);
    await result.fold(
      (failure) async => emit(CustomersListState.error(failure.message)),
      (customers) async {
        final rows = customers
            .map((c) => CustomerListRow(customer: c, balanceLoading: true))
            .toList();
        emit(
          CustomersListState.loaded(
            allItems: rows,
            filteredItems: _filter(rows),
            searchQuery: _search,
            activeFilter: _activeFilter,
            hasOutstandingOnly: _hasOutstandingOnly,
          ),
        );
        await _loadBalances(rows);
      },
    );
  }

  Future<void> _loadBalances(List<CustomerListRow> rows) async {
    final futures = rows.map((row) async {
      final result = await _getBalance(row.customer.id);
      return result.fold(
        (_) => row.copyWith(balanceLoading: false, balance: '—'),
        (balance) => row.copyWith(
          balanceLoading: false,
          balance: balance.balance,
        ),
      );
    });
    final updated = await Future.wait(futures);
    final current = state;
    if (current is CustomersListLoaded) {
      emit(
        current.copyWith(
          allItems: updated,
          filteredItems: _filter(updated),
        ),
      );
    }
  }

  void search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _search = query.isEmpty ? null : query;
      load();
    });
  }

  void setActiveFilter(CustomerActiveFilter filter) {
    _activeFilter = filter;
    final current = state;
    if (current is CustomersListLoaded) {
      emit(
        current.copyWith(
          activeFilter: filter,
          filteredItems: _filter(current.allItems),
        ),
      );
    }
  }

  void setHasOutstandingFilter(bool value) {
    _hasOutstandingOnly = value;
    final current = state;
    if (current is CustomersListLoaded) {
      emit(
        current.copyWith(
          hasOutstandingOnly: value,
          filteredItems: _filter(current.allItems),
        ),
      );
    }
  }

  List<CustomerListRow> _filter(List<CustomerListRow> items) {
    return items.where((row) {
      switch (_activeFilter) {
        case CustomerActiveFilter.active:
          if (!row.customer.isActive) return false;
        case CustomerActiveFilter.inactive:
          if (row.customer.isActive) return false;
        case CustomerActiveFilter.all:
          break;
      }
      if (_hasOutstandingOnly &&
          !CustomerBalanceUtils.hasOutstanding(row.balance)) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> refresh() => load();

  Future<bool> toggleActive(String id, bool isActive) async {
    final current = state;
    if (current is! CustomersListLoaded) return false;

    final index = current.allItems.indexWhere((r) => r.customer.id == id);
    if (index < 0) return false;

    final row = current.allItems[index];
    final updatedCustomer = row.customer.copyWith(isActive: isActive);
    final updatedRow = row.copyWith(customer: updatedCustomer);
    final allItems = [...current.allItems];
    allItems[index] = updatedRow;
    emit(
      current.copyWith(
        allItems: allItems,
        filteredItems: _filter(allItems),
      ),
    );

    final result = await _updateCustomer(id, {'is_active': isActive});
    return result.fold(
      (failure) {
        allItems[index] = row;
        emit(
          current.copyWith(
            allItems: allItems,
            filteredItems: _filter(allItems),
          ),
        );
        emit(CustomersListState.error(failure.message));
        return false;
      },
      (_) => true,
    );
  }

  Future<bool> deactivateCustomer(String id) =>
      toggleActive(id, false);
}
