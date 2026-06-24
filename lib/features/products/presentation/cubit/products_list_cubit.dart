import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductsListCubit extends Cubit<ProductsListState> {
  ProductsListCubit({
    required GetProductsUseCase getProductsUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required GetProductByBarcodeUseCase getProductByBarcodeUseCase,
  })  : _getProducts = getProductsUseCase,
        _deleteProduct = deleteProductUseCase,
        _updateProduct = updateProductUseCase,
        _getProductByBarcode = getProductByBarcodeUseCase,
        super(const ProductsListState.initial());

  final GetProductsUseCase _getProducts;
  final DeleteProductUseCase _deleteProduct;
  final UpdateProductUseCase _updateProduct;
  final GetProductByBarcodeUseCase _getProductByBarcode;

  static const _defaultPageSize = 10;
  int _pageSize = _defaultPageSize;
  Timer? _searchDebounce;

  String? _search;
  String? _categoryId;
  String? _brandId;
  bool? _isActive;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> loadProducts({bool reset = true}) async {
    if (reset) {
      emit(const ProductsListState.loading());
    } else {
      final current = state;
      if (current is ProductsListLoaded) {
        emit(current.copyWith(isLoadingMore: true));
      }
    }

    final skip = reset
        ? 0
        : switch (state) {
            ProductsListLoaded(:final skip, :final limit) => skip + limit,
            _ => 0,
          };

    final result = await _getProducts(
      categoryId: _categoryId,
      brandId: _brandId,
      isActive: _isActive,
      search: _search,
      skip: skip,
      limit: _pageSize,
    );

    result.fold(
      (failure) => emit(ProductsListState.error(failure.message)),
      (page) {
        if (!reset && state is ProductsListLoaded) {
          final prev = state as ProductsListLoaded;
          emit(
            ProductsListState.loaded(
              items: [...prev.items, ...page.items],
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              currentSearch: _search,
              currentCategoryId: _categoryId,
              currentBrandId: _brandId,
              currentIsActive: _isActive,
            ),
          );
        } else {
          emit(
            ProductsListState.loaded(
              items: page.items,
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              currentSearch: _search,
              currentCategoryId: _categoryId,
              currentBrandId: _brandId,
              currentIsActive: _isActive,
            ),
          );
        }
      },
    );
  }

  int get pageSize => _pageSize;

  int currentPage(ProductsListLoaded state) => (state.skip ~/ state.limit) + 1;

  int totalPages(ProductsListLoaded state) {
    if (state.total == 0) return 1;
    return (state.total / state.limit).ceil();
  }

  Future<void> setPageSize(int size) async {
    if (size < 1 || _pageSize == size) return;
    _pageSize = size;
    await loadProducts();
  }

  Future<void> goToPage(int page) async {
    final current = state;
    if (current is! ProductsListLoaded) return;
    final totalPages = this.totalPages(current);
    final target = page.clamp(1, totalPages);
    if (target == currentPage(current)) return;

    emit(const ProductsListState.loading());
    final skip = (target - 1) * _pageSize;
    final result = await _getProducts(
      categoryId: _categoryId,
      brandId: _brandId,
      isActive: _isActive,
      search: _search,
      skip: skip,
      limit: _pageSize,
    );

    result.fold(
      (failure) => emit(ProductsListState.error(failure.message)),
      (page) => emit(
        ProductsListState.loaded(
          items: page.items,
          total: page.total,
          skip: page.skip,
          limit: page.limit,
          currentSearch: _search,
          currentCategoryId: _categoryId,
          currentBrandId: _brandId,
          currentIsActive: _isActive,
        ),
      ),
    );
  }

  void search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _search = query.isEmpty ? null : query;
      loadProducts();
    });
  }

  Future<String?> lookupBarcode(String barcode) async {
    final result = await _getProductByBarcode(barcode);
    return result.fold((_) => null, (product) => product.id);
  }

  void filterByCategory(String? categoryId) {
    _categoryId = categoryId;
    loadProducts();
  }

  void filterByBrand(String? brandId) {
    _brandId = brandId;
    loadProducts();
  }

  void filterByActiveStatus(bool? isActive) {
    _isActive = isActive;
    loadProducts();
  }

  void clearFilters() {
    _search = null;
    _categoryId = null;
    _brandId = null;
    _isActive = null;
    loadProducts();
  }

  bool get hasActiveFilters =>
      _search != null ||
      _categoryId != null ||
      _brandId != null ||
      _isActive != null;

  Future<void> loadMore() async {
    final current = state;
    if (current is! ProductsListLoaded) return;
    if (current.isLoadingMore) return;
    if (current.items.length >= current.total) return;
    await loadProducts(reset: false);
  }

  Future<void> refresh() => loadProducts();

  Future<bool> deleteProduct(String id) async {
    final current = state;
    if (current is! ProductsListLoaded) return false;

    final index = current.items.indexWhere((p) => p.id == id);
    if (index < 0) return false;
    final removed = current.items[index];
    final updatedItems = [...current.items]..removeAt(index);

    emit(
      current.copyWith(
        items: updatedItems,
        total: current.total - 1,
      ),
    );

    final result = await _deleteProduct(id);
    return result.fold(
      (failure) {
        final items = [...updatedItems];
        items.insert(index, removed);
        emit(current.copyWith(items: items, total: current.total));
        emit(ProductsListState.error(failure.message));
        return false;
      },
      (_) => true,
    );
  }

  Future<bool> toggleActive(String id, bool isActive) async {
    final current = state;
    if (current is! ProductsListLoaded) return false;

    final index = current.items.indexWhere((p) => p.id == id);
    if (index < 0) return false;

    final item = current.items[index];
    final updated = item.copyWith(isActive: isActive);
    final items = [...current.items];
    items[index] = updated;
    emit(current.copyWith(items: items));

    final result = await _updateProduct(id, {'is_active': isActive});
    return result.fold(
      (failure) {
        items[index] = item;
        emit(current.copyWith(items: items));
        return false;
      },
      (_) => true,
    );
  }
}
