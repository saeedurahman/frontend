import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';

part 'inventory_stock_state.freezed.dart';

@freezed
class StockDisplayRow with _$StockDisplayRow {
  const StockDisplayRow._();

  const factory StockDisplayRow({
    required ProductListItemModel product,
    required StockBalanceModel balance,
    String? variationName,
    String? unitName,
    String? minStockLevel,
  }) = _StockDisplayRow;

  double get currentQty => double.tryParse(balance.currentQty) ?? 0;

  bool get isLowStock {
    final min = double.tryParse(minStockLevel ?? '') ?? 0;
    if (min <= 0) return false;
    return currentQty > 0 && currentQty <= min;
  }

  bool get isOutOfStock => currentQty <= 0;
}

@Freezed()
sealed class InventoryStockState with _$InventoryStockState {
  const factory InventoryStockState.initial() = InventoryStockInitial;

  const factory InventoryStockState.loading() = InventoryStockLoading;

  const factory InventoryStockState.loaded({
    required List<StockDisplayRow> allRows,
    required List<StockDisplayRow> filteredRows,
    String? branchId,
    String? searchQuery,
    String? categoryFilter,
    @Default(false) bool lowStockOnly,
    @Default(false) bool outOfStockOnly,
  }) = InventoryStockLoaded;

  const factory InventoryStockState.error(String message) = InventoryStockError;
}
