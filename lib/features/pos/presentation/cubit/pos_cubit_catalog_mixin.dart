part of 'pos_cubit.dart';

mixin PosCubitCatalogMixin on PosCubitBase, PosCubitCartMixin {
  /// Loads the first page for the current search/category. Search and category
  /// filtering happen on the server so the catalog scales past one page.
  Future<void> _loadProducts() async {
    final requestId = ++_productsRequestId;
    final query = state.productSearchQuery.trim();
    final categoryId = state.selectedCategoryId;
    _safeEmit(state.patch(isLoadingProducts: true, productsError: null));

    final result = await _getProducts(
      isActive: true,
      search: query.isEmpty ? null : query,
      categoryId: categoryId,
      limit: PosCubitBase.productPageSize,
    );
    if (isClosed || requestId != _productsRequestId) return;

    _loadedProductsQuery = query;
    _loadedProductsCategory = categoryId;
    result.fold(
      (failure) => _safeEmit(state.patch(
        isLoadingProducts: false,
        productsError: failure.message,
      )),
      (page) {
        _safeEmit(state.patch(
          isLoadingProducts: false,
          products: page.items,
          productsTotal: page.total,
          hasMoreProducts: page.items.length < page.total,
        ));
        _fillMissingStock(page.items);
        unawaited(_prefetchPrices(page.items));
      },
    );
    if (!_stockLoaded) await _loadStockBalances();
  }

  /// Infinite scroll: appends the next page.
  Future<void> loadMoreProducts() async {
    if (!state.hasMoreProducts ||
        state.isLoadingMoreProducts ||
        state.isLoadingProducts) {
      return;
    }
    final requestId = _productsRequestId;
    _safeEmit(state.patch(isLoadingMoreProducts: true));

    final query = _loadedProductsQuery;
    final result = await _getProducts(
      isActive: true,
      search: query.isEmpty ? null : query,
      categoryId: _loadedProductsCategory,
      skip: state.products.length,
      limit: PosCubitBase.productPageSize,
    );
    if (isClosed || requestId != _productsRequestId) return;

    result.fold(
      (failure) => _safeEmit(state.patch(
        isLoadingMoreProducts: false,
        productsError: failure.message,
      )),
      (page) {
        final known = state.products.map((p) => p.id).toSet();
        final merged = [
          ...state.products,
          ...page.items.where((p) => !known.contains(p.id)),
        ];
        _safeEmit(state.patch(
          isLoadingMoreProducts: false,
          products: merged,
          productsTotal: page.total,
          hasMoreProducts: page.items.isNotEmpty && merged.length < page.total,
        ));
        _fillMissingStock(page.items);
        unawaited(_prefetchPrices(page.items));
      },
    );
  }

  Future<void> retryProducts() => _loadProducts();

  /// Products without a branch balance row have no stock.
  void _fillMissingStock(List<ProductListItemModel> items) {
    if (!_stockLoaded) return;
    final cache = {...state.stockCache};
    var changed = false;
    for (final product in items) {
      if (!cache.containsKey(product.id)) {
        cache[product.id] = '0';
        changed = true;
      }
    }
    if (changed) _safeEmit(state.patch(stockCache: cache));
  }

  /// Background price warm-up so add-to-cart never waits on the network for a
  /// product that is already on screen.
  Future<void> _prefetchPrices(List<ProductListItemModel> items) async {
    final pending = items
        .where((p) => !state.priceCache.containsKey(p.id))
        .map((p) => p.id)
        .toList();
    const concurrency = 4;
    for (var i = 0; i < pending.length; i += concurrency) {
      if (isClosed) return;
      final batch = pending.skip(i).take(concurrency);
      final results = await Future.wait(
        batch.map((id) async => (id, await _getProductPrice(id, null))),
      );
      if (isClosed) return;
      final cache = {...state.priceCache};
      for (final (id, result) in results) {
        result.fold((_) {}, (price) {
          if (price != null && price > Decimal.zero) {
            cache[id] = price.toString();
          }
        });
      }
      _safeEmit(state.patch(priceCache: cache));
    }
  }

  Future<void> _loadStockBalances() async {
    final branchId = state.branchId;
    if (branchId == null) return;

    final result = await _getStockBalances(branchId: branchId);
    if (isClosed) return;

    result.fold(
      (failure) => _safeEmit(state.patch(stockError: failure.message)),
      (balances) {
        final cache = <String, String>{};
        for (final balance in balances) {
          final existing =
              Decimal.tryParse(cache[balance.productId] ?? '') ?? Decimal.zero;
          final add = Decimal.tryParse(balance.currentQty) ?? Decimal.zero;
          cache[balance.productId] = DecimalUtils.format(
            existing + add,
            fractionDigits: 4,
          );
        }
        for (final product in state.products) {
          cache.putIfAbsent(product.id, () => '0');
        }
        _stockLoaded = true;
        _safeEmit(state.patch(stockCache: cache, stockError: null));
      },
    );
  }

  Future<void> retryStock() => _loadStockBalances();

  Future<void> _loadCategories() async {
    final result = await _getCategories();
    if (isClosed) return;
    result.fold(
      (failure) => _safeEmit(state.patch(categoriesError: failure.message)),
      (categories) => _safeEmit(
        state.patch(categories: categories, categoriesError: null),
      ),
    );
  }

  Future<void> retryCategories() => _loadCategories();

  void selectCategory(String? categoryId) {
    emit(state.patch(selectedCategoryId: categoryId));
    unawaited(_loadProducts());
  }

  void searchProducts(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      _safeEmit(state.patch(productSearchQuery: query));
      if (query.trim() != _loadedProductsQuery) unawaited(_loadProducts());
    });
  }

  /// Updates the text only; the debounced [searchProducts] triggers the
  /// network search. Clearing the box (after a scan) reloads at once.
  void setSearchQueryImmediate(String query) {
    emit(state.patch(productSearchQuery: query));
    if (query.trim().isEmpty && _loadedProductsQuery.isNotEmpty) {
      _searchDebounce?.cancel();
      unawaited(_loadProducts());
    }
  }

  // ── Barcode lookup: memory → local (Drift) cache → server ──────────────

  String get _tenantKey => state.businessId ?? '-';

  /// Resolves a scanned code without a network round trip when possible. A
  /// cached hit is refreshed from the server in the background.
  Future<ProductModel?> resolveBarcode(String barcode) async {
    final resolved = await _resolveBarcode(
      barcode: barcode,
      tenantKey: _tenantKey,
      memory: state.productDetailsCache.values,
    );
    final product = resolved.product;
    if (product != null && resolved.fromCache) {
      unawaited(_refreshBarcodeInBackground(barcode.trim(), product.id));
    }
    return product;
  }

  Future<void> _refreshBarcodeInBackground(
    String barcode,
    String productId,
  ) async {
    final fresh = await _resolveBarcode.refresh(
      barcode: barcode,
      tenantKey: _tenantKey,
      productId: productId,
    );
    if (isClosed || fresh == null) return;
    _safeEmit(state.patch(
      productDetailsCache: {...state.productDetailsCache, fresh.id: fresh},
    ));
  }

  Future<bool> lookupBarcode(String barcode) async {
    final product = await resolveBarcode(barcode);
    if (product == null) return false;
    final outcome = await _addProductModelToCart(product);
    return outcome.result == AddToCartResult.added;
  }

  Future<ProductListItemModel?> getListItemByBarcode(String barcode) async {
    final product = await resolveBarcode(barcode);
    return product == null ? null : _toListItem(product);
  }

  Future<ProductModel?> getProductDetails(String productId) async {
    if (state.productDetailsCache.containsKey(productId)) {
      return state.productDetailsCache[productId];
    }
    final result = await _getProductById(productId);
    if (isClosed) return null;
    return result.fold((_) => null, (product) {
      _safeEmit(state.patch(
        productDetailsCache: {...state.productDetailsCache, productId: product},
      ));
      return product;
    });
  }

  Decimal? getDisplayPrice(String productId, {String? variationId}) {
    final key = variationId != null ? '$productId:$variationId' : productId;
    final raw = state.priceCache[key];
    if (raw == null) return null;
    return Decimal.tryParse(raw);
  }

  String? getDisplayStock(String productId) => state.stockCache[productId];
}
