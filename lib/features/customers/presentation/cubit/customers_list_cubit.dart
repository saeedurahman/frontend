import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/khata/domain/balance_filter.dart';
import 'package:injectable/injectable.dart';

@injectable
class CustomersListCubit extends Cubit<CustomersListState>
    with AutoRefresh<CustomersListState> {
  CustomersListCubit({
    required GetCustomersUseCase getCustomersUseCase,
    required GetCustomerBalanceUseCase getCustomerBalanceUseCase,
    required UpdateCustomerUseCase updateCustomerUseCase,
  })  : _getCustomers = getCustomersUseCase,
        _getBalance = getCustomerBalanceUseCase,
        _updateCustomer = updateCustomerUseCase,
        super(const CustomersListState.initial()) {
    watchData(const {DataTopic.customers, DataTopic.customerLedger}, _reload);
  }

  final GetCustomersUseCase _getCustomers;
  final GetCustomerBalanceUseCase _getBalance;
  final UpdateCustomerUseCase _updateCustomer;

  Timer? _searchDebounce;
  String? _search;
  CustomerActiveFilter _activeFilter = CustomerActiveFilter.all;
  BalanceFilter _balanceFilter = BalanceFilter.all;
  BalanceSort _balanceSort = BalanceSort.none;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> load() async {
    final read = beginRead();
    emit(const CustomersListState.loading());

    final result = await _fetch();
    if (isStale(read)) return;
    await result.fold(
      (failure) async => emit(CustomersListState.error(failure.message)),
      (customers) => _show(customers, read),
    );
  }

  /// Reads the list again without a spinner. Search, filters and the balances
  /// on screen stay; so do the rows when the read fails.
  Future<void> refresh() =>
      state is CustomersListLoaded ? _reload() : load();

  Future<void> _reload() async {
    final before = state;
    if (before is CustomersListInitial) return;
    if (before is! CustomersListLoaded) return load();

    final read = beginRead();
    final result = await _fetch();
    if (isStale(read)) return;
    await result.fold(
      (_) async {
        // This read replaced the one that was fetching balances.
        final current = state;
        if (current is CustomersListLoaded) {
          await _loadBalances(current.allItems, read);
        }
      },
      (customers) => _show(customers, read),
    );
  }

  /// The customers that match the search, plus the ones just created (a search
  /// typed earlier must not hide them).
  Future<Either<Failure, List<CustomerModel>>> _fetch() async {
    final result = await _getCustomers(search: _search);
    if (_search == null) return result;
    return result.fold(
      (failure) async => Left(failure),
      (found) async {
        final missing = createdIds.toSet()
          ..removeAll(found.map((c) => c.id));
        if (missing.isEmpty) return Right(found);
        final everyone = await _getCustomers();
        return Right([
          ...everyone.fold(
            (_) => const <CustomerModel>[],
            (all) => all.where((c) => missing.contains(c.id)),
          ),
          ...found,
        ]);
      },
    );
  }

  Future<void> _show(List<CustomerModel> customers, int read) async {
    final current = state;
    final shown = <String, String?>{
      if (current is CustomersListLoaded)
        for (final r in current.allItems) r.customer.id: r.balance,
    };
    final rows = [
      for (final c in newestFirst(customers, (c) => c.id))
        CustomerListRow(
          customer: c,
          balance: shown[c.id],
          balanceLoading: shown[c.id] == null,
        ),
    ];
    emit(
      CustomersListState.loaded(
        allItems: rows,
        filteredItems: _filter(rows),
        searchQuery: _search,
        activeFilter: _activeFilter,
        balanceFilter: _balanceFilter,
        balanceSort: _balanceSort,
      ),
    );
    await _loadBalances(rows, read);
  }

  /// The id of the new customer on top of the list, if any.
  String? get newestCreatedId {
    final current = state;
    if (current is! CustomersListLoaded) return null;
    return createdOnTop(current.filteredItems, (r) => r.customer.id);
  }

  Future<void> _loadBalances(List<CustomerListRow> rows, int read) async {
    final balances = <String, String?>{};
    await Future.wait(
      rows.map((row) async {
        final result = await _getBalance(row.customer.id);
        balances[row.customer.id] = result.fold((_) => null, (b) => b.balance);
      }),
    );
    if (isStale(read)) return;
    final current = state;
    if (current is! CustomersListLoaded) return;
    final updated = [
      for (final row in current.allItems)
        balances.containsKey(row.customer.id)
            ? row.copyWith(
                balanceLoading: false,
                balance: balances[row.customer.id] ?? row.balance ?? '—',
              )
            : row,
    ];
    emit(
      current.copyWith(
        allItems: updated,
        filteredItems: _filter(updated),
      ),
    );
  }

  void search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _search = query.isEmpty ? null : query;
      forgetCreated();
      load();
    });
  }

  void setActiveFilter(CustomerActiveFilter filter) {
    _activeFilter = filter;
    forgetCreated();
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

  void setBalanceFilter(BalanceFilter filter) {
    _balanceFilter = filter;
    _applyBalanceChoice();
  }

  void setBalanceSort(BalanceSort sort) {
    _balanceSort = sort;
    _applyBalanceChoice();
  }

  void _applyBalanceChoice() {
    forgetCreated();
    final current = state;
    if (current is CustomersListLoaded) {
      emit(
        current.copyWith(
          balanceFilter: _balanceFilter,
          balanceSort: _balanceSort,
          filteredItems: _filter(current.allItems),
        ),
      );
    }
  }

  /// A customer just created is shown whatever the filters say, until the user
  /// changes them.
  List<CustomerListRow> _filter(List<CustomerListRow> items) {
    final matching = items.where((row) {
      if (isNewlyCreated(row.customer.id)) return true;
      switch (_activeFilter) {
        case CustomerActiveFilter.active:
          if (!row.customer.isActive) return false;
        case CustomerActiveFilter.inactive:
          if (row.customer.isActive) return false;
        case CustomerActiveFilter.all:
          break;
      }
      return _balanceFilter.matches(listBalance(row.balance));
    }).toList();
    return _balanceSort.apply(
      matching,
      (row) => listBalance(row.balance),
      _balanceFilter,
    );
  }

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
        final restored = [...allItems];
        restored[index] = row;
        emit(
          current.copyWith(
            allItems: restored,
            filteredItems: _filter(restored),
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
