import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';

part 'stock_movements_state.freezed.dart';

@freezed
class StockMovementRow with _$StockMovementRow {
  const factory StockMovementRow({
    required StockMovementModel movement,
    required double runningBalance,
  }) = _StockMovementRow;
}

@Freezed()
sealed class StockMovementsState with _$StockMovementsState {
  const factory StockMovementsState.initial() = StockMovementsInitial;

  const factory StockMovementsState.loading() = StockMovementsLoading;

  const factory StockMovementsState.loaded({
    required List<StockMovementRow> rows,
    required int total,
    required int skip,
    required int limit,
    String? productId,
    String? branchId,
    @Default(false) bool isLoadingMore,
  }) = StockMovementsLoaded;

  const factory StockMovementsState.error(String message) = StockMovementsError;
}
