import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SuppliersListCubit extends Cubit<SuppliersListState> {
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
        super(const SuppliersListState.initial());

  final GetSuppliersUseCase _getSuppliers;
  final GetSupplierBalanceUseCase _getBalance;
  final UpdateSupplierUseCase _updateSupplier;
  final DeleteSupplierUseCase _deleteSupplier;
  final CreateSupplierUseCase _createSupplier;

  Timer? _searchDebounce;
  String? _search;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> load() async {
    emit(const SuppliersListState.loading());

    final result = await _getSuppliers();
    await result.fold(
      (failure) async => emit(SuppliersListState.error(failure.message)),
      (suppliers) async {
        final rows = suppliers
            .map((s) => SupplierListRow(supplier: s, balanceLoading: true))
            .toList();
        emit(
          SuppliersListState.loaded(
            allItems: rows,
            filteredItems: _filter(rows, _search),
            searchQuery: _search,
          ),
        );
        await _loadBalances(rows);
      },
    );
  }

  Future<void> _loadBalances(List<SupplierListRow> rows) async {
    final futures = rows.map((row) async {
      final result = await _getBalance(row.supplier.id);
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
    if (current is SuppliersListLoaded) {
      emit(
        current.copyWith(
          allItems: updated,
          filteredItems: _filter(updated, _search),
        ),
      );
    }
  }

  void search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _search = query.isEmpty ? null : query;
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

  List<SupplierListRow> _filter(List<SupplierListRow> items, String? query) {
    if (query == null || query.isEmpty) return items;
    final q = query.toLowerCase();
    return items
        .where(
          (row) =>
              row.supplier.name.toLowerCase().contains(q) ||
              (row.supplier.phone?.toLowerCase().contains(q) ?? false) ||
              (row.supplier.email?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  Future<void> refresh() => load();

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
        allItems[index] = row;
        emit(
          current.copyWith(
            allItems: allItems,
            filteredItems: _filter(allItems, _search),
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
        final current = state;
        if (current is SuppliersListLoaded) {
          final newRow = SupplierListRow(
            supplier: supplier,
            balanceLoading: true,
          );
          final allItems = [...current.allItems, newRow];
          emit(
            current.copyWith(
              allItems: allItems,
              filteredItems: _filter(allItems, _search),
            ),
          );
          _loadBalances(allItems);
        }
        return supplier;
      },
    );
  }
}
