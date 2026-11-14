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
        _warmModifiers?.call(page.items.map((p) => p.id));
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
        _warmModifiers?.call(page.items.map((p) => p.id));
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

  /// Re-derives which price list is in force (the selected customer's list,
  /// else the default list) from the local data.
  Future<void> _refreshPriceContext() async {
    final resolver = _resolvePriceList;
    if (resolver == null) return;
    final customerId = state.selectedCustomer?.id;
    final resolved = await resolver(customerId);
    if (isClosed || customerId != state.selectedCustomer?.id) return;
    final current = state.priceContext;
    if (current.customerId == customerId &&
        current.effectiveListId == resolved.id &&
        current.defaultListId == resolved.defaultId &&
        current.listName == resolved.name) {
      return;
    }
    _safeEmit(state.patch(
      priceContext: current.bumped(
        effectiveListId: resolved.id,
        defaultListId: resolved.defaultId,
        listName: resolved.name,
        customerId: customerId,
      ),
    ));
  }

  /// Background price warm-up so add-to-cart never waits on the network for a
  /// product that is already on screen. Prices are those of the list in
  /// force for the selected customer and are cached under that list.
  Future<void> _prefetchPrices(List<ProductListItemModel> items) async {
    final customerId = state.selectedCustomer?.id;
    final token = priceToken;
    final pending = items
        .where((p) => !state.priceCache.containsKey(priceSlot(p.id, null)))
        .map((p) => p.id)
        .toList();
    const concurrency = 4;
    for (var i = 0; i < pending.length; i += concurrency) {
      if (isClosed) return;
      final batch = pending.skip(i).take(concurrency);
      final results = await Future.wait(
        batch.map((id) async =>
            (id, await _getProductPrice(id, null, customerId: customerId))),
      );
      // The customer (so the list) changed meanwhile: these prices belong to
      // the old list; `refreshPrices` of the change fills the new one.
      if (isClosed ||
          state.selectedCustomer?.id != customerId ||
          priceToken != token) {
        return;
      }
      final cache = {...state.priceCache};
      for (final (id, result) in results) {
        result.fold((_) {}, (price) {
          if (price != null && price > Decimal.zero) {
            cache[priceSlot(id, null, token: token)] = price.toString();
          }
        });
      }
      _safeEmit(state.patch(priceCache: cache));
    }
  }

  /// Re-resolves the prices on screen for the list in force, from the local
  /// data, and emits a new state (also when the values did not change, so the
  /// cards and an open quantity popup re-read them).
  ///
  /// A list price replaces whatever was cached; a product the list no longer
  /// prices loses its entry (a price removed on the server disappears), except
  /// a price typed in by hand for an unpriced product.
  ///
  /// [changes] are the price changes that triggered this: the cached entries
  /// they name (of any list) are dropped, and with product ids only those
  /// products are re-read.
  @override
  Future<void> refreshPrices({List<PriceChange> changes = const []}) async {
    final requestId = ++_priceRefreshId;
    final customerId = state.selectedCustomer?.id;
    final resolver = _resolvePriceList;
    EffectivePriceList? resolved;
    if (resolver != null) {
      resolved = await resolver(customerId);
      if (isClosed || requestId != _priceRefreshId) return;
    }
    final token = resolved != null
        ? PosCubitBase.priceTokenOf(resolved.id, customerId)
        : PosCubitBase.priceTokenOf(null, customerId);

    final wholeList = changes.isEmpty ||
        changes.any((c) => c.productId == null || c.customerId != null);
    final onlyProducts = {
      for (final c in changes)
        if (c.productId != null) c.productId!,
    };

    final keys = <String>{};
    for (final k in state.priceCache.keys) {
      final bar = k.indexOf('|');
      if (k.substring(0, bar) == token) keys.add(k.substring(bar + 1));
    }
    for (final p in state.products) {
      keys.add(p.id);
    }
    if (!wholeList) {
      keys.removeWhere((k) => !onlyProducts.contains(k.split(':').first));
    }

    final fresh = <String, String>{};
    final gone = <String>{};
    for (final key in keys) {
      final split = key.indexOf(':');
      final productId = split < 0 ? key : key.substring(0, split);
      final variationId = split < 0 ? null : key.substring(split + 1);
      final result = await _getProductPrice(
        productId,
        variationId,
        customerId: customerId,
      );
      if (isClosed || requestId != _priceRefreshId) return;
      final slot = '$token|$key';
      var price = result.fold((_) => null, (p) => p);
      if (price != null && price > Decimal.zero) {
        fresh[slot] = price.toString();
      } else if (!_manualPriceSlots.contains(slot)) {
        gone.add(slot);
      }
    }

    final cache = {...state.priceCache}
      ..removeWhere((k, _) => changes.any((c) => _slotMatches(k, c)))
      ..removeWhere((k, _) => gone.contains(k))
      ..addAll(fresh);
    final current = state.priceContext;
    _safeEmit(state.patch(
      priceCache: cache,
      priceContext: resolved == null
          ? current.bumped(keep: true)
          : current.bumped(
              effectiveListId: resolved.id,
              defaultListId: resolved.defaultId,
              listName: resolved.name,
              customerId: customerId,
            ),
    ));
  }

  /// True when the cache entry [slot] holds a price [change] touched.
  static bool _slotMatches(String slot, PriceChange change) {
    final listId = change.priceListId;
    if (listId == null) return false;
    final bar = slot.indexOf('|');
    if (slot.substring(0, bar) != listId) return false;
    final productId = change.productId;
    return productId == null || slot.substring(bar + 1).split(':').first == productId;
  }

  /// A price change from the local data (pull, a price saved on this device).
  /// The changes of one transaction arrive as separate events: they are
  /// merged and handled once.
  void _onPriceChange(PriceChange change) {
    _pendingPriceChanges.add(change);
    if (_priceFlushScheduled) return;
    _priceFlushScheduled = true;
    scheduleMicrotask(_flushPriceChanges);
  }

  void _flushPriceChanges() {
    _priceFlushScheduled = false;
    final changes = _pendingPriceChanges.toList();
    _pendingPriceChanges.clear();
    if (isClosed || changes.isEmpty) return;

    final context = state.priceContext;
    final customerId = state.selectedCustomer?.id;
    // Re-resolve only what this POS shows: the default list (every other
    // list falls back to it) and the list in force. Without a resolver the
    // list in force is unknown, so every change counts.
    final relevant = [
      for (final c in changes)
        if (c.customerId != null
            ? c.customerId == customerId
            : _resolvePriceList == null ||
                c.priceListId == null ||
                c.priceListId == context.defaultListId ||
                c.priceListId == context.effectiveListId)
          c,
    ];
    if (relevant.isNotEmpty) {
      unawaited(refreshPrices(changes: changes));
      return;
    }
    // A list this POS is not showing: just forget what was cached for it, so
    // it is read afresh when a customer of that list is selected.
    final cache = {...state.priceCache}
      ..removeWhere((k, _) => changes.any((c) => _slotMatches(k, c)));
    if (cache.length != state.priceCache.length) {
      _safeEmit(state.patch(priceCache: cache));
    }
  }

  /// Reads the balances of the branch from the local data: pulled stock
  /// minus what this device sold that the pulled stock does not include yet.
  /// The latest request wins, so overlapping refreshes cannot go backwards.
  Future<void> _loadStockBalances() async {
    final branchId = state.branchId;
    if (branchId == null) return;

    final requestId = ++_stockRequestId;
    final result = await _getStockBalances(branchId: branchId);
    if (isClosed || requestId != _stockRequestId) return;

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

  /// Runs on every local stock change and right after a sale is saved.
  @override
  Future<void> refreshStock() => _loadStockBalances();

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
    try {
      final fresh = await _resolveBarcode.refresh(
        barcode: barcode,
        tenantKey: _tenantKey,
        productId: productId,
      );
      if (isClosed || fresh == null) return;
      _safeEmit(state.patch(
        productDetailsCache: {...state.productDetailsCache, fresh.id: fresh},
      ));
    } catch (_) {
      // Best effort: the scan already used the copy it had.
    }
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

  /// Price shown for the product now: the one of the list in force for the
  /// selected customer (the default list with no customer).
  Decimal? getDisplayPrice(String productId, {String? variationId}) {
    final raw = state.priceCache[priceSlot(productId, variationId)];
    if (raw == null) return null;
    return Decimal.tryParse(raw);
  }

  /// Name of the list in force when it is not the default one ("Wholesale"),
  /// else null.
  String? get specialPriceListName =>
      state.priceContext.isSpecial ? state.priceContext.listName : null;

  String? getDisplayStock(String productId) => state.stockCache[productId];
}
