import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/inventory/presentation/cubit/stock_movements_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class StockMovementsCubit extends Cubit<StockMovementsState> {
  StockMovementsCubit({
    required AuthLocalDataSource authLocalDataSource,
    required GetStockMovementsUseCase getStockMovementsUseCase,
  })  : _authLocal = authLocalDataSource,
        _getMovements = getStockMovementsUseCase,
        super(const StockMovementsState.initial());

  final AuthLocalDataSource _authLocal;
  final GetStockMovementsUseCase _getMovements;

  static const _pageSize = 50;
  String? _productId;
  String? _branchId;

  Future<void> load({required String productId, bool reset = true}) async {
    _productId = productId;

    if (reset) {
      emit(const StockMovementsState.loading());
      final user = await _authLocal.getCachedUser();
      _branchId = user?.branchId;
      if (_branchId == null) {
        emit(const StockMovementsState.error('Branch not found. Please log in again.'));
        return;
      }
    } else {
      final current = state;
      if (current is StockMovementsLoaded) {
        emit(current.copyWith(isLoadingMore: true));
      }
    }

    final skip = reset
        ? 0
        : switch (state) {
            StockMovementsLoaded(:final skip, :final limit) => skip + limit,
            _ => 0,
          };

    final result = await _getMovements(
      branchId: _branchId!,
      productId: _productId,
      skip: skip,
      limit: _pageSize,
    );

    result.fold(
      (failure) => emit(StockMovementsState.error(failure.message)),
      (page) {
        final startBalance = !reset && state is StockMovementsLoaded
            ? (state as StockMovementsLoaded).rows.lastOrNull?.runningBalance ?? 0
            : 0.0;
        final newRows = _withRunningBalance(page.items, startBalance: startBalance);
        if (!reset && state is StockMovementsLoaded) {
          final prev = state as StockMovementsLoaded;
          emit(
            StockMovementsState.loaded(
              rows: [...prev.rows, ...newRows],
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              productId: _productId,
              branchId: _branchId,
            ),
          );
        } else {
          emit(
            StockMovementsState.loaded(
              rows: newRows,
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              productId: _productId,
              branchId: _branchId,
            ),
          );
        }
      },
    );
  }

  List<StockMovementRow> _withRunningBalance(
    List<StockMovementModel> items, {
    double startBalance = 0,
  }) {
    final sorted = [...items]
      ..sort((a, b) => a.movementAt.compareTo(b.movementAt));

    var balance = startBalance;
    return sorted.map((movement) {
      final qty = double.tryParse(movement.qty) ?? 0;
      balance += qty;
      return StockMovementRow(movement: movement, runningBalance: balance);
    }).toList();
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! StockMovementsLoaded) return;
    if (current.isLoadingMore) return;
    if (current.rows.length >= current.total) return;
    if (_productId == null) return;
    await load(productId: _productId!, reset: false);
  }

  Future<void> refresh() async {
    if (_productId != null) await load(productId: _productId!);
  }
}
