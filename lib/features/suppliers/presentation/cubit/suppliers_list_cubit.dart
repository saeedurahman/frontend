import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/khata/domain/balance_filter.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SuppliersListCubit extends Cubit<SuppliersListState>
    with AutoRefresh<SuppliersListState> {
  SuppliersListCubit({
    required GetSuppliersUseCase getSuppliersUseCase,
    required GetSupplierBalanceUseCase getSupplierBalanceUseCase,
    required UpdateSupplierUseCase updateSupplierUseCase,
    required DeleteSupplierUseCase deleteSupplierUseCase,
    required CreateSupplierUseCase createSupplierUseCase,
  })  : _getSuppliers = getSuppliersUseCase,
        _getBalance = getSupplierBalanceUseCase,
        _updateSupplier = updateSupplierUseCase,
        _deleteSupplier = deleteSupplierUseCase,
        _createSupplier = createSupplierUseCase,
        super(const SuppliersListState.initial()) {
    // A new supplier, or a payment or reversal that changes what is owed.
    watchData(const {DataTopic.suppliers, DataTopic.supplierLedger}, _reload);
  }

  final GetSuppliersUseCase _getSuppliers;
  final GetSupplierBalanceUseCase _getBalance;
  final UpdateSupplierUseCase _updateSupplier;
  final DeleteSupplierUseCase _deleteSupplier;
  final CreateSupplierUseCase _createSupplier;

  Timer? _searchDebounce;
  String? _search;
  BalanceFilter _balanceFilter = BalanceFilter.all;
  BalanceSort _balanceSort = BalanceSort.none;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> load() async {
    final read = beginRead();
    emit(const SuppliersListState.loading());

    final result = await _getSuppliers();
    if (isStale(read)) return;
    await result.fold(
      (failure) async => emit(SuppliersListState.error(failure.message)),
      (suppliers) => _show(suppliers, read),
    );
  }

  /// Reads the list again without a spinner. The search and the balances on
  /// screen stay; so do the rows when the read fails.
  Future<void> refresh() =>
      state is SuppliersListLoaded ? _reload() : load();

  Future<void> _reload() async {
    final before = state;
    if (before is SuppliersListInitial) return;
    if (before is! SuppliersListLoaded) return load();

    final read = beginRead();
    final result = await _getSuppliers();
    if (isStale(read)) return;
    await result.fold(
      (_) async {
        // This read replaced the one that was fetching balances.
        final current = state;
        if (current is SuppliersListLoaded) {
          await _loadBalances(current.allItems, read);
        }
      },
      (suppliers) => _show(suppliers, read),
    );
  }

  Future<void> _show(List<SupplierModel> suppliers, int read) async {
    final current = state;
    final shown = <String, String?>{
      if (current is SuppliersListLoaded)
        for (final r in current.allItems) r.supplier.id: r.balance,
    };
    final rows = [
      for (final s in newestFirst(suppliers, (s) => s.id))
        SupplierListRow(
          supplier: s,
          balance: shown[s.id],
          balanceLoading: shown[s.id] == null,
        ),
    ];
    emit(
      SuppliersListState.loaded(
        allItems: rows,
        filteredItems: _filter(rows, _search),
        searchQuery: _search,
        balanceFilter: _balanceFilter,
        balanceSort: _balanceSort,
      ),
    );
    await _loadBalances(rows, read);
  }

  /// The id of the new supplier on top of the list, if any.
  String? get newestCreatedId {
    final current = state;
    if (current is! SuppliersListLoaded) return null;
    return createdOnTop(current.filteredItems, (r) => r.supplier.id);
  }

  Future<void> _loadBalances(List<SupplierListRow> rows, int read) async {
    final branchId = sl.isRegistered<BranchSelectorCubit>()
        ? sl<BranchSelectorCubit>().state.selectedBranchId
        : null;
    final balances = <String, String?>{};
    await Future.wait(
      rows.map((row) async {
        final result = await _getBalance(row.supplier.id, branchId: branchId);
        balances[row.supplier.id] = result.fold((_) => null, (b) => b.balance);
      }),
    );
    if (isStale(read)) return;
    final current = state;
    if (current is! SuppliersListLoaded) return;
    final updated = [
      for (final row in current.allItems)
        balances.containsKey(row.supplier.id)
            ? row.copyWith(
                balanceLoading: false,
                balance: balances[row.supplier.id] ?? row.balance ?? '—',
              )
            : row,
    ];
    emit(
      current.copyWith(
        allItems: updated,
        filteredItems: _filter(updated, _search),
      ),
    );
  }

  Future<void> onBranchChanged(String? branchId) async {
    final current = state;
    if (current is! SuppliersListLoaded) return;
    // Balances of the other branch must not stay on screen if the read fails.
    final rows = [
      for (final r in current.allItems)
        r.copyWith(balance: null, balanceLoading: true),
    ];
    final read = beginRead();
    emit(
      current.copyWith(
        allItems: rows,
        filteredItems: _filter(rows, _search),
      ),
    );
    await _loadBalances(rows, read);
  }

  void search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _search = query.isEmpty ? null : query;
      forgetCreated();
      final current = state;
      if (current is SuppliersListLoaded) {
        emit(
          current.copyWith(
            searchQuery: _search,
            filteredItems: _filter(current.allItems, _search),
          ),
        );
      }
    });
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
    if (current is SuppliersListLoaded) {
      emit(
        current.copyWith(
          balanceFilter: _balanceFilter,
          balanceSort: _balanceSort,
          filteredItems: _filter(current.allItems, _search),
        ),
      );
    }
  }

  /// A supplier just created is shown whatever the search and filters say,
  /// until the user changes them.
  List<SupplierListRow> _filter(List<SupplierListRow> items, String? query) {
    final q = (query ?? '').toLowerCase();
    final matching = items
        .where(
          (row) =>
              isNewlyCreated(row.supplier.id) ||
              ((q.isEmpty ||
                      row.supplier.name.toLowerCase().contains(q) ||
                      (row.supplier.phone?.toLowerCase().contains(q) ??
                          false) ||
                      (row.supplier.email?.toLowerCase().contains(q) ??
                          false)) &&
                  _balanceFilter.matches(listBalance(row.balance))),
        )
        .toList();
    return _balanceSort.apply(
      matching,
      (row) => listBalance(row.balance),
      _balanceFilter,
    );
  }

  Future<bool> toggleActive(String id, bool isActive) async {
    final current = state;
    if (current is! SuppliersListLoaded) return false;

    final index = current.allItems.indexWhere((r) => r.supplier.id == id);
    if (index < 0) return false;

    final row = current.allItems[index];
    final updatedSupplier = row.supplier.copyWith(isActive: isActive);
    final updatedRow = row.copyWith(supplier: updatedSupplier);
    final allItems = [...current.allItems];
    allItems[index] = updatedRow;
    emit(
      current.copyWith(
        allItems: allItems,
        filteredItems: _filter(allItems, _search),
      ),
    );

    final result = await _updateSupplier(id, {'is_active': isActive});
    return result.fold(
      (failure) {
        final restored = [...allItems];
        restored[index] = row;
        emit(
          current.copyWith(
            allItems: restored,
            filteredItems: _filter(restored, _search),
          ),
        );
        emit(SuppliersListState.error(failure.message));
        return false;
      },
      (_) => true,
    );
  }

  Future<bool> deleteSupplier(String id) async {
    final current = state;
    if (current is! SuppliersListLoaded) return false;

    final index = current.allItems.indexWhere((r) => r.supplier.id == id);
    if (index < 0) return false;

    final removed = current.allItems[index];
    final allItems = [...current.allItems]..removeAt(index);
    emit(
      current.copyWith(
        allItems: allItems,
        filteredItems: _filter(allItems, _search),
      ),
    );

    final result = await _deleteSupplier(id);
    return result.fold(
      (failure) {
        final restored = [...allItems];
        restored.insert(index, removed);
        emit(
          current.copyWith(
            allItems: restored,
            filteredItems: _filter(restored, _search),
          ),
        );
        emit(SuppliersListState.error(failure.message));
        return false;
      },
      (_) => true,
    );
  }

  Future<SupplierModel?> createQuick({
    required String name,
    String? phone,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    };
    final result = await _createSupplier(body);
    return result.fold(
      (failure) {
        emit(SuppliersListState.error(failure.message));
        return null;
      },
      (supplier) {
        markCreated(supplier.id);
        final current = state;
        if (current is SuppliersListLoaded) {
          final newRow = SupplierListRow(
            supplier: supplier,
            balanceLoading: true,
          );
          final allItems = [
            newRow,
            ...current.allItems.where((r) => r.supplier.id != supplier.id),
          ];
          final read = beginRead();
          emit(
            current.copyWith(
              allItems: allItems,
              filteredItems: _filter(allItems, _search),
            ),
          );
          unawaited(_loadBalances(allItems, read));
        }
        return supplier;
      },
    );
  }
}
