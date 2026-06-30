part of 'pos_cubit.dart';

mixin PosCubitCatalogMixin on PosCubitBase, PosCubitCartMixin {
  Future<void> _loadProducts() async {
    _safeEmit(state.patch(isLoadingProducts: true, productsError: null));
    final result = await _getProducts(isActive: true, limit: 200);
    if (isClosed) return;
    result.fold(
      (failure) => _safeEmit(state.patch(
        isLoadingProducts: false,
        productsError: failure.message,
      )),
      (page) => _safeEmit(state.patch(
        isLoadingProducts: false,
        products: page.items,
      )),
    );
    await _loadStockBalances();
  }

  Future<void> _loadStockBalances() async {
    final branchId = state.branchId;
    if (branchId == null || state.products.isEmpty) return;

    final result = await _getStockBalances(branchId: branchId);
    if (isClosed) return;

    result.fold((_) {}, (balances) {
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
      _safeEmit(state.patch(stockCache: cache));
    });
  }

  Future<void> _loadCategories() async {
    final result = await _getCategories();
    if (isClosed) return;
    result.fold(
      (_) {},
      (categories) => _safeEmit(state.patch(categories: categories)),
    );
  }

  void selectCategory(String? categoryId) {
    emit(state.patch(selectedCategoryId: categoryId));
  }

  void searchProducts(String query) {
    debugPrint('[POS:Search] searchProducts debounced query="$query"');
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      debugPrint('[POS:Search] applied filter query="$query"');
      _safeEmit(state.patch(productSearchQuery: query));
    });
  }

  void setSearchQueryImmediate(String query) {
    emit(state.patch(productSearchQuery: query));
  }

  Future<bool> lookupBarcode(String barcode) async {
    debugPrint('[POS:Cubit] lookupBarcode "$barcode"');
    final result = await _lookupBarcode(barcode);
    return result.fold(
      (failure) {
        debugPrint('[POS:Cubit] lookupBarcode FAILED: ${failure.message}');
        return false;
      },
      (product) async {
        debugPrint('[POS:Cubit] lookupBarcode OK product="${product.name}"');
        final outcome = await _addProductModelToCart(product);
        debugPrint('[POS:Cubit] lookupBarcode add outcome=${outcome.result}');
        return outcome.result == AddToCartResult.added;
      },
    );
  }

  Future<ProductListItemModel?> getListItemByBarcode(String barcode) async {
    debugPrint('[POS:Cubit] getListItemByBarcode "$barcode"');
    final result = await _lookupBarcode(barcode);
    return result.fold(
      (failure) {
        debugPrint(
          '[POS:Cubit] getListItemByBarcode FAILED: ${failure.message}',
        );
        return null;
      },
      (product) {
        debugPrint(
          '[POS:Cubit] getListItemByBarcode OK product="${product.name}"',
        );
        return _toListItem(product);
      },
    );
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
