import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductsListCubit extends Cubit<ProductsListState>
    with AutoRefresh<ProductsListState> {
  ProductsListCubit({
    required GetProductsUseCase getProductsUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required GetProductByBarcodeUseCase getProductByBarcodeUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
  })  : _getProducts = getProductsUseCase,
        _getProduct = getProductByIdUseCase,
        _deleteProduct = deleteProductUseCase,
        _updateProduct = updateProductUseCase,
        _getProductByBarcode = getProductByBarcodeUseCase,
        super(const ProductsListState.initial()) {
    watchData(
      const {DataTopic.products, DataTopic.categories, DataTopic.brands},
      _reload,
    );
  }

  final GetProductsUseCase _getProducts;
  final DeleteProductUseCase _deleteProduct;
  final UpdateProductUseCase _updateProduct;
  final GetProductByBarcodeUseCase _getProductByBarcode;
  final GetProductByIdUseCase _getProduct;

  static const _defaultPageSize = 10;
  static const _maxPage = 200;
  int _pageSize = _defaultPageSize;
  Timer? _searchDebounce;

  String? _search;
  String? _categoryId;
  String? _brandId;
  bool? _isActive;
  bool _needsAttention = false;

  /// Only a product's own id is worth looking up: other writes that touch
  /// products (a sale, a receipt) must not add theirs.
  @override
  bool remembersCreated(DataChange change) =>
      change.topics.contains(DataTopic.products) &&
      !change.topics.contains(DataTopic.sales);

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  /// A quiet re-read after a change: same search, filters and page, no spinner,
  /// and the rows stay when it fails.
  Future<void> _reload() async {
    final current = state;
    if (current is ProductsListInitial) return;
    if (current is! ProductsListLoaded) return loadProducts();
    final read = beginRead();
    // "Load more" shows several pages as one: read that many again.
    final appended = current.items.length > current.limit;
    final from = appended ? 0 : current.skip;
    final wanted = appended ? current.items.length : current.limit;
    // The server gives at most [_maxPage] rows a request.
    final rows = <ProductListItemModel>[];
    var total = 0;
    while (rows.length < wanted) {
      final result = await _getPage(
        skip: from + rows.length,
        limit: (wanted - rows.length).clamp(1, _maxPage),
      );
      if (isStale(read)) return;
      final page = result.fold((_) => null, (p) => p);
      if (page == null) {
        // This read replaced a "load more" in flight.
        final now = state;
        if (now is ProductsListLoaded) {
          emit(now.copyWith(isLoadingMore: false));
        }
        return;
      }
      total = page.total;
      rows.addAll(page.items);
      if (page.items.isEmpty || from + rows.length >= total) break;
    }
    final items = await _withCreated(rows, from);
    if (isStale(read)) return;
    emit(
      ProductsListState.loaded(
        items: items,
        total: total,
        skip: current.skip,
        limit: current.limit,
        currentSearch: _search,
        currentCategoryId: _categoryId,
        currentBrandId: _brandId,
        currentIsActive: _isActive,
      ),
    );
  }

  Future<Either<Failure, PaginatedProductsModel>> _getPage({
    required int skip,
    required int limit,
  }) =>
      _getProducts(
        categoryId: _categoryId,
        brandId: _brandId,
        isActive: _isActive,
        search: _search,
        needsAttention: _needsAttention ? true : null,
        skip: skip,
        limit: limit,
      );

  /// On the first page, a product just created goes on top, even when the
  /// server's order (by name) or the filters would put it out of sight.
  Future<List<ProductListItemModel>> _withCreated(
    List<ProductListItemModel> items,
    int skip,
  ) async {
    if (skip != 0 || createdIds.isEmpty) return items;
    final missing = createdIds.reversed
        .where((id) => !items.any((p) => p.id == id))
        .take(_defaultPageSize);
    final found = <ProductListItemModel>[];
    for (final id in missing) {
      // An id that is not a product simply finds nothing.
      final result = await _getProduct(id);
      result.fold((_) {}, (p) => found.add(_asRow(p)));
    }
    return newestFirst([...items, ...found], (p) => p.id);
  }

  static ProductListItemModel _asRow(ProductModel p) => ProductListItemModel(
        id: p.id,
        businessId: p.businessId,
        name: p.name,
        sku: p.sku,
        productType: p.productType,
        trackingType: p.trackingType,
        isSellable: p.isSellable,
        isPurchasable: p.isPurchasable,
        isActive: p.isActive,
        categoryId: p.category?.id,
        brandId: p.brand?.id,
        imageUrl: p.imageUrl,
        taxRateId: p.taxRateId,
        isTaxExempt: p.isTaxExempt,
        trackExpiry: p.trackExpiry,
        nameSecondary: p.nameSecondary,
        categoryName: p.category?.name,
        brandName: p.brand?.name,
      );

  /// The id of the new product on top of the list, if any.
  String? get newestCreatedId {
    final current = state;
    if (current is! ProductsListLoaded) return null;
    return createdOnTop(current.items, (p) => p.id);
  }

  Future<void> loadProducts({bool reset = true}) async {
    final read = beginRead();
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

    final result = await _getPage(skip: skip, limit: _pageSize);
    if (isStale(read)) return;
    final first = reset
        ? await result.fold(
            (_) async => const <ProductListItemModel>[],
            (page) => _withCreated(page.items, skip),
          )
        : const <ProductListItemModel>[];
    if (isStale(read)) return;

    result.fold(
      (failure) => emit(ProductsListState.error(failure.message)),
      (page) {
        if (!reset && state is ProductsListLoaded) {
          final prev = state as ProductsListLoaded;
          emit(
            ProductsListState.loaded(
              items: [
                ...prev.items,
                ...page.items
                    .where((p) => !prev.items.any((e) => e.id == p.id)),
              ],
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
              items: first,
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

    final read = beginRead();
    forgetCreated();
    emit(const ProductsListState.loading());
    final skip = (target - 1) * _pageSize;
    final result = await _getPage(skip: skip, limit: _pageSize);
    if (isStale(read)) return;

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
      forgetCreated();
      loadProducts();
    });
  }

  Future<String?> lookupBarcode(String barcode) async {
    final result = await _getProductByBarcode(barcode);
    return result.fold((_) => null, (product) => product.id);
  }

  void filterByCategory(String? categoryId) {
    _categoryId = categoryId;
    forgetCreated();
    loadProducts();
  }

  void filterByBrand(String? brandId) {
    _brandId = brandId;
    forgetCreated();
    loadProducts();
  }

  void filterByActiveStatus(bool? isActive) {
    _isActive = isActive;
    forgetCreated();
    loadProducts();
  }

  /// "Needs details": products without a category, a picture or a price.
  bool get needsDetailsOnly => _needsAttention;

  void filterNeedsDetails(bool on) {
    if (_needsAttention == on) return;
    _needsAttention = on;
    forgetCreated();
    loadProducts();
  }

  void clearFilters() {
    _needsAttention = false;
    _search = null;
    _categoryId = null;
    _brandId = null;
    _isActive = null;
    forgetCreated();
    loadProducts();
  }

  bool get hasActiveFilters =>
      _search != null ||
      _categoryId != null ||
      _brandId != null ||
      _needsAttention ||
      _isActive != null;

  Future<void> loadMore() async {
    final current = state;
    if (current is! ProductsListLoaded) return;
    if (current.isLoadingMore) return;
    if (current.items.length >= current.total) return;
    await loadProducts(reset: false);
  }

  Future<void> refresh() =>
      state is ProductsListLoaded ? _reload() : loadProducts();

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
