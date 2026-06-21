import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/inventory/presentation/cubit/inventory_stock_state.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class InventoryStockCubit extends Cubit<InventoryStockState> {
  InventoryStockCubit({
    required GetProductsUseCase getProductsUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
    required GetStockBalancesUseCase getStockBalancesUseCase,
  })  : _getProducts = getProductsUseCase,
        _getProductById = getProductByIdUseCase,
        _getBalances = getStockBalancesUseCase,
        super(const InventoryStockState.initial());

  final GetProductsUseCase _getProducts;
  final GetProductByIdUseCase _getProductById;
  final GetStockBalancesUseCase _getBalances;

  static const _productPageSize = 200;

  Timer? _searchDebounce;
  String? _search;
  String? _categoryFilter;
  bool _lowStockOnly = false;
  bool _outOfStockOnly = false;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> load() async {
    emit(const InventoryStockState.loading());

    final branchId = sl<BranchSelectorCubit>().state.selectedBranchId;
    if (branchId == null) {
      emit(const InventoryStockState.error('Branch not found. Please log in again.'));
      return;
    }

    final productsResult = await _fetchAllProducts();
    final balancesResult = await _getBalances(branchId: branchId);

    await productsResult.fold(
      (failure) async => emit(InventoryStockState.error(failure.message)),
      (products) async {
        await balancesResult.fold(
          (failure) async => emit(InventoryStockState.error(failure.message)),
          (balances) async {
            final productsById = {
              for (final p in products) p.id: p,
            };

            final productDetails = await _loadProductDetails(
              products.map((p) => p.id).toSet(),
            );

            final rows = <StockDisplayRow>[];
            final coveredProductIds = <String>{};

            for (final balance in balances) {
              final product = productsById[balance.productId];
              if (product == null) continue;

              coveredProductIds.add(balance.productId);
              final detail = productDetails[balance.productId];
              String? variationName;
              if (balance.variationId != null && detail != null) {
                for (final v in detail.variations) {
                  if (v.id == balance.variationId) {
                    variationName = v.name;
                    break;
                  }
                }
              }

              rows.add(
                StockDisplayRow(
                  product: product,
                  balance: balance,
                  variationName: variationName,
                  unitName: detail?.baseUnit?.name,
                  minStockLevel: detail?.minStockLevel,
                ),
              );
            }

            for (final product in products) {
              if (coveredProductIds.contains(product.id)) continue;
              final detail = productDetails[product.id];
              rows.add(
                StockDisplayRow(
                  product: product,
                  balance: StockBalanceModel(
                    productId: product.id,
                    branchId: branchId,
                    currentQty: '0',
                  ),
                  unitName: detail?.baseUnit?.name,
                  minStockLevel: detail?.minStockLevel,
                ),
              );
            }

            emit(
              InventoryStockState.loaded(
                allRows: rows,
                filteredRows: _filter(rows),
                branchId: branchId,
                searchQuery: _search,
                categoryFilter: _categoryFilter,
                lowStockOnly: _lowStockOnly,
                outOfStockOnly: _outOfStockOnly,
              ),
            );
          },
        );
      },
    );
  }

  Future<Either<Failure, List<ProductListItemModel>>> _fetchAllProducts() async {
    final all = <ProductListItemModel>[];
    var skip = 0;

    while (true) {
      final result = await _getProducts(skip: skip, limit: _productPageSize);
      Failure? failure;
      var fetched = 0;
      var total = 0;

      result.fold(
        (f) => failure = f,
        (page) {
          fetched = page.items.length;
          total = page.total;
          all.addAll(page.items);
        },
      );

      if (failure != null) return Left(failure!);
      if (fetched == 0 || all.length >= total) break;
      skip += fetched;
    }

    return Right(all);
  }

  Future<Map<String, ProductModel>> _loadProductDetails(Set<String> productIds) async {
    final map = <String, ProductModel>{};
    final futures = productIds.map((id) async {
      final result = await _getProductById(id);
      result.fold((_) => null, (product) => map[id] = product);
    });
    await Future.wait(futures);
    return map;
  }

  void search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _search = query.isEmpty ? null : query;
      _applyFilters();
    });
  }

  void filterByCategory(String? categoryId) {
    _categoryFilter = categoryId;
    _applyFilters();
  }

  void toggleLowStock(bool value) {
    _lowStockOnly = value;
    _applyFilters();
  }

  void toggleOutOfStock(bool value) {
    _outOfStockOnly = value;
    _applyFilters();
  }

  void _applyFilters() {
    final current = state;
    if (current is InventoryStockLoaded) {
      emit(
        current.copyWith(
          searchQuery: _search,
          categoryFilter: _categoryFilter,
          lowStockOnly: _lowStockOnly,
          outOfStockOnly: _outOfStockOnly,
          filteredRows: _filter(current.allRows),
        ),
      );
    }
  }

  List<StockDisplayRow> _filter(List<StockDisplayRow> rows) {
    return rows.where((row) {
      if (_search != null) {
        final q = _search!.toLowerCase();
        final matches = row.product.name.toLowerCase().contains(q) ||
            (row.product.sku?.toLowerCase().contains(q) ?? false) ||
            (row.variationName?.toLowerCase().contains(q) ?? false);
        if (!matches) return false;
      }
      if (_categoryFilter != null && row.product.categoryId != _categoryFilter) {
        return false;
      }
      if (_lowStockOnly && !row.isLowStock) return false;
      if (_outOfStockOnly && !row.isOutOfStock) return false;
      return true;
    }).toList();
  }

  Future<void> refresh() => load();
}
