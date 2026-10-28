part of 'pos_cubit.dart';

mixin PosCubitCartMixin on PosCubitBase, PosCubitShiftMixin {
  Future<void> _loadTaxData() async {
    final taxResult = await _getTaxRates();
    // `/settings` is permission-filtered; a missing/forbidden read only means
    // there is no default tax rate to pre-select.
    final settingsResult = await _getSettings();
    if (isClosed) return;

    taxResult.fold(
      (failure) => _safeEmit(state.patch(taxError: failure.message)),
      (taxRates) {
        TaxRateModel? defaultRate;
        settingsResult.fold(
          (_) {},
          (settings) {
            final defaultId = SettingsValueUtils.valueForKey(
              settings,
              SettingKeys.taxDefaultRateId,
            );
            if (defaultId != null) {
              for (final rate in taxRates) {
                if (rate.id == defaultId && rate.isActive) {
                  defaultRate = rate;
                  break;
                }
              }
            }
          },
        );
        _safeEmit(state.patch(
          taxRates: taxRates.where((t) => t.isActive).toList(),
          defaultTaxRate: defaultRate,
          taxError: null,
        ));
      },
    );
  }

  Future<void> retryTaxData() => _loadTaxData();

  static String taxDisplayLabel(TaxRateModel rate) =>
      '${rate.name} ${rate.rate}%';

  Future<AddToCartOutcome> addToCart(
    ProductListItemModel product, {
    String? variationId,
    Decimal? manualUnitPrice,
    List<CartLineModifierModel> modifiers = const [],
  }) async {
    if (!skipDineInDelegation &&
        this is PosCubitDineInMixin &&
        (this as PosCubitDineInMixin).isDineIn) {
      return (this as PosCubitDineInMixin).addToCartDineIn(
        product,
        variationId: variationId,
        manualUnitPrice: manualUnitPrice,
        modifiers: modifiers,
      );
    }

    debugPrint(
      '[POS:Cubit] addToCart "${product.name}" variationId=$variationId '
      'manualPrice=$manualUnitPrice modifiers=${modifiers.length} '
      'cartSize=${state.cartItems.length}',
    );
    ProductModel? details = state.productDetailsCache[product.id];
    if (details == null ||
        (details.variations.length > 1 && variationId == null)) {
      final result = await _getProductById(product.id);
      if (isClosed) return AddToCartOutcome.added;
      result.fold((_) {}, (p) {
        details = p;
        final cache = {...state.productDetailsCache, product.id: p};
        _safeEmit(state.patch(productDetailsCache: cache));
      });
    }

    details ??= state.productDetailsCache[product.id];
    if (details != null &&
        details!.variations.length > 1 &&
        variationId == null) {
      debugPrint(
        '[POS:Cubit] addToCart → needsVariation (${details!.variations.length} variations)',
      );
      return AddToCartOutcome(result: AddToCartResult.needsVariation);
    }

    VariationModel? variation;
    if (variationId != null && details != null) {
      for (final v in details!.variations) {
        if (v.id == variationId) {
          variation = v;
          break;
        }
      }
    } else if (details != null && details!.variations.isNotEmpty) {
      variation = details!.variations.firstWhere(
        (v) => v.isDefault,
        orElse: () => details!.variations.first,
      );
      variationId = variation.id;
    }

    final priceKey = variationId != null
        ? '${product.id}:$variationId'
        : product.id;

    Decimal? resolvedPrice = manualUnitPrice;

    if (resolvedPrice == null) {
      var cached = Decimal.tryParse(state.priceCache[priceKey] ?? '');
      // The background warm-up stores the default price under the product id;
      // it is valid for single-variation products.
      if ((cached == null || cached <= Decimal.zero) &&
          (details?.variations.length ?? 0) <= 1) {
        cached = Decimal.tryParse(state.priceCache[product.id] ?? '');
      }
      if (cached != null && cached > Decimal.zero) {
        resolvedPrice = cached;
      }
    }

    if (resolvedPrice == null) {
      final priceResult = await _getProductPrice(product.id, variationId);
      if (isClosed) return AddToCartOutcome.added;
      await priceResult.fold((_) {}, (p) {
        if (p != null && p > Decimal.zero) {
          resolvedPrice = p;
          _safeEmit(state.patch(
            priceCache: {...state.priceCache, priceKey: p.toString()},
          ));
        }
      });
    }

    final needsManualPrice =
        resolvedPrice == null || resolvedPrice! <= Decimal.zero;
    if (needsManualPrice) {
      debugPrint('[POS:Cubit] addToCart → needsPrice');
      return AddToCartOutcome(
        result: AddToCartResult.needsPrice,
        pendingPrice: PendingPricePrompt(
          product: product,
          variationId: variationId,
          variationName: variation?.name,
          modifiers: modifiers,
        ),
      );
    }

    if (manualUnitPrice != null) {
      _safeEmit(state.patch(
        priceCache: {
          ...state.priceCache,
          priceKey: manualUnitPrice.toString(),
        },
      ));
    }

    final unitPrice =
        (manualUnitPrice ?? resolvedPrice!) + cartModifierTotalPerUnit(modifiers);
    final isManualPrice = manualUnitPrice != null;

    final cartKey = buildCartLineKey(
      productId: product.id,
      variationId: variationId,
      modifiers: modifiers,
    );
    final existingIndex =
        state.cartItems.indexWhere((item) => item.cartKey == cartKey);
    final requestedQty = existingIndex >= 0
        ? state.cartItems[existingIndex].qty + Decimal.one
        : Decimal.one;

    // Stock comes from the branch balances loaded in bulk; the network is only
    // asked when the cache cannot answer or says there is not enough (it may
    // be stale), and then once, before refusing the sale.
    final singleVariation = (details?.variations.length ?? 0) <= 1;
    Decimal? availableStock = singleVariation
        ? Decimal.tryParse(state.stockCache[product.id] ?? '')
        : null;
    var stockVerified = false;
    if (availableStock == null || availableStock < requestedQty) {
      availableStock = await _fetchStock(product.id, variationId);
      stockVerified = true;
    }

    if (isClosed) return AddToCartOutcome.added;

    if (availableStock != null && availableStock < requestedQty) {
      debugPrint(
        '[POS:Cubit] addToCart → insufficientStock available=$availableStock requested=$requestedQty',
      );
      final label = variation?.name != null
          ? '${product.name} (${variation!.name})'
          : product.name;
      return AddToCartOutcome(
        result: AddToCartResult.insufficientStock,
        message:
            'Insufficient stock for $label. Available: ${DecimalUtils.format(availableStock, fractionDigits: 4)}',
      );
    }

    final lowStockWarning = _lowStockWarning(
      product: product,
      details: details,
      available: availableStock,
      requested: requestedQty,
    );
    if (!stockVerified) {
      unawaited(_fetchStock(product.id, variationId));
    }

    if (existingIndex >= 0) {
      final item = state.cartItems[existingIndex];
      final updated = item.copyWith(qty: item.qty + Decimal.one);
      final items = [...state.cartItems];
      items[existingIndex] = updated;
      _safeEmit(state.patch(cartItems: items));
      _schedulePricePreview();
      debugPrint(
        '[POS:Cubit] addToCart → QTY INCREASED cartSize=${items.length}',
      );
    } else {
      final defaultRate = state.defaultTaxRate;
      final newItem = CartItemModel(
        productId: product.id,
        variationId: variationId,
        productName: product.name,
        variationName: variation?.name,
        sku: variation?.sku ?? product.sku,
        unitPrice: unitPrice,
        qty: Decimal.one,
        priceManual: isManualPrice,
        maxAvailableStock: availableStock,
        modifiers: modifiers,
        taxRateId: defaultRate?.id,
        taxRateName:
            defaultRate != null ? taxDisplayLabel(defaultRate) : null,
        taxRate: defaultRate != null
            ? (Decimal.tryParse(defaultRate.rate) ?? Decimal.zero)
            : null,
      );
      final items = [...state.cartItems, newItem];
      _safeEmit(state.patch(cartItems: items));
      _schedulePricePreview();
      debugPrint('[POS:Cubit] addToCart → ADDED cartSize=${items.length}');
    }

    return lowStockWarning == null
        ? AddToCartOutcome.added
        : AddToCartOutcome(
            result: AddToCartResult.added,
            message: lowStockWarning,
          );
  }

  /// Live balance for one product/variation; refreshes the shared cache.
  Future<Decimal?> _fetchStock(String productId, String? variationId) async {
    final branchId = state.branchId;
    if (branchId == null) return null;
    final result = await _getStockBalance(
      branchId: branchId,
      productId: productId,
      variationId: variationId,
    );
    if (isClosed) return null;
    return result.fold((_) => null, (balance) {
      final qty = Decimal.tryParse(balance.currentQty);
      if (qty != null && variationId == null) {
        _safeEmit(state.patch(stockCache: {
          ...state.stockCache,
          productId: DecimalUtils.format(qty, fractionDigits: 4),
        }));
      }
      return qty;
    });
  }

  static final _defaultLowStockThreshold = Decimal.fromInt(5);

  String? _lowStockWarning({
    required ProductListItemModel product,
    required ProductModel? details,
    required Decimal? available,
    required Decimal requested,
  }) {
    if (available == null) return null;
    final min = Decimal.tryParse(details?.minStockLevel ?? '');
    final threshold =
        min != null && min > Decimal.zero ? min : _defaultLowStockThreshold;
    final remaining = available - requested;
    if (remaining > threshold) return null;
    final left = remaining < Decimal.zero ? Decimal.zero : remaining;
    return 'Low stock: ${product.name} - ${DecimalUtils.format(left, fractionDigits: 0)} left after this sale';
  }

  ProductListItemModel _toListItem(ProductModel product) {
    final cache = {...state.productDetailsCache, product.id: product};
    _safeEmit(state.patch(productDetailsCache: cache));
    return ProductListItemModel(
      id: product.id,
      businessId: product.businessId,
      name: product.name,
      sku: product.sku,
      productType: product.productType,
      trackingType: product.trackingType,
      isSellable: product.isSellable,
      isActive: product.isActive,
      categoryId: product.category?.id,
      imageUrl: product.imageUrl,
      categoryName: product.category?.name,
    );
  }

  Future<AddToCartOutcome> _addProductModelToCart(ProductModel product) async {
    final listItem = _toListItem(product);

    if (product.variations.length > 1) {
      return AddToCartOutcome(result: AddToCartResult.needsVariation);
    }
    return addToCart(listItem);
  }

  void removeFromCart(int cartIndex) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final items = [...state.cartItems]..removeAt(cartIndex);
    emit(state.patch(cartItems: items));
    _schedulePricePreview();
  }

  void updateCartItemQty(int cartIndex, Decimal newQty) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    if (newQty <= Decimal.zero) {
      removeFromCart(cartIndex);
      return;
    }
    final items = [...state.cartItems];
    items[cartIndex] = items[cartIndex].copyWith(qty: newQty);
    emit(state.patch(cartItems: items));
    _schedulePricePreview();
  }

  void incrementQty(int cartIndex) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final item = state.cartItems[cartIndex];
    updateCartItemQty(cartIndex, item.qty + Decimal.one);
  }

  void decrementQty(int cartIndex) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final item = state.cartItems[cartIndex];
    updateCartItemQty(cartIndex, item.qty - Decimal.one);
  }

  void updateItemDiscount(
    int cartIndex, {
    Decimal? pct,
    Decimal? amount,
  }) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final items = [...state.cartItems];
    items[cartIndex] = items[cartIndex].copyWith(
      itemDiscountPct: pct ?? items[cartIndex].itemDiscountPct,
      itemDiscountAmount: amount ?? items[cartIndex].itemDiscountAmount,
    );
    emit(state.patch(cartItems: items));
    _schedulePricePreview();
  }

  void updateLineTaxRate(int cartIndex, TaxRateModel? newRate) {
    if (!state.canEditLineTax) return;
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final items = [...state.cartItems];
    if (newRate == null) {
      items[cartIndex] = items[cartIndex].copyWith(clearTax: true);
    } else {
      items[cartIndex] = items[cartIndex].copyWith(
        taxRateId: newRate.id,
        taxRateName: taxDisplayLabel(newRate),
        taxRate: Decimal.tryParse(newRate.rate) ?? Decimal.zero,
      );
    }
    emit(state.patch(cartItems: items));
    _schedulePricePreview();
  }

  void updateLineNote(int cartIndex, String note) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final items = [...state.cartItems];
    items[cartIndex] = items[cartIndex].copyWith(
      lineNote: note,
      clearLineNote: note.isEmpty,
    );
    emit(state.patch(cartItems: items));
    _schedulePricePreview();
  }

  void updateCartItemPrice(int cartIndex, Decimal price) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final items = [...state.cartItems];
    items[cartIndex] = items[cartIndex].copyWith(
      unitPrice: price,
      priceManual: true,
    );
    emit(state.patch(cartItems: items));
    _schedulePricePreview();
  }

  void applyCartDiscount(String type, Decimal value) {
    emit(state.patch(
      cartDiscountType: type,
      cartDiscountValue: DecimalUtils.format(value),
    ));
    _schedulePricePreview();
  }

  void removeCartDiscount() {
    emit(state.patch(
      cartDiscountType: null,
      cartDiscountValue: null,
    ));
    _schedulePricePreview();
  }

  void selectDiscountScheme(String? schemeId) {
    _previewDebounce?.cancel();
    if (schemeId == null) {
      emit(state.patch(
        selectedDiscountSchemeId: null,
        pricePreview: null,
        pricePreviewError: null,
        isLoadingPricePreview: false,
      ));
      return;
    }

    emit(state.patch(
      selectedDiscountSchemeId: schemeId,
      pricePreview: null,
      pricePreviewError: null,
      isLoadingPricePreview: true,
    ));
    _schedulePricePreview();
  }

  Future<void> selectCustomer(CustomerModel? customer) async {
    emit(state.patch(selectedCustomer: customer));
    if (customer != null) await refreshSelectedCustomer();
  }

  /// Loads the customer's real `credit_limit` and ledger balance. The picker
  /// result and resumed held orders only carry a partial record.
  Future<void> refreshSelectedCustomer() async {
    final selected = state.selectedCustomer;
    if (selected == null) return;

    final customerResult = await _getCustomer(selected.id);
    final balanceResult = await _getCustomerBalance(selected.id);
    if (isClosed || state.selectedCustomer?.id != selected.id) return;

    var merged = customerResult.fold((_) => selected, (fresh) => fresh);
    balanceResult.fold(
      (_) {},
      (balance) => merged = merged.copyWith(balance: balance.balance),
    );
    emit(state.patch(selectedCustomer: merged));
  }

  void clearCart() {
    _safeEmit(state.patch(
      cartItems: <CartItemModel>[],
      selectedCustomer: null,
      cartDiscountType: null,
      cartDiscountValue: null,
      cartNote: null,
      pricePreview: null,
      pricePreviewError: null,
      isLoadingPricePreview: false,
    ));
  }

  @visibleForTesting
  void addItemsForTest(List<CartItemModel> items) =>
      _safeEmit(state.patch(cartItems: [...state.cartItems, ...items]));

  HeldOrderScope? get _heldScope {
    final tenantId = state.businessId;
    final branchId = state.branchId;
    final userId = state.userId;
    if (tenantId == null || branchId == null || userId == null) return null;
    return HeldOrderScope(
      tenantId: tenantId,
      branchId: branchId,
      userId: userId,
    );
  }

  /// Held orders of this cashier, at this branch, in this business only.
  Future<void> loadHeldOrders() async {
    final scope = _heldScope;
    final orders = scope == null
        ? const <HeldOrderModel>[]
        : await _heldOrdersDao.getHeldOrdersFor(scope);
    if (isClosed) return;
    _safeEmit(state.patch(heldOrders: orders));
  }

  /// `Order 14:32:05`, or the cashier's own label; a numeric suffix keeps it
  /// unique among the parked orders.
  @visibleForTesting
  static String uniqueHeldLabel(
    String? custom,
    DateTime now,
    Iterable<String> existing,
  ) {
    String two(int v) => v.toString().padLeft(2, '0');
    final trimmed = custom?.trim();
    final base = trimmed != null && trimmed.isNotEmpty
        ? trimmed
        : 'Order ${two(now.hour)}:${two(now.minute)}:${two(now.second)}';
    final taken = existing.map((l) => l.toLowerCase()).toSet();
    if (!taken.contains(base.toLowerCase())) return base;
    var n = 2;
    while (taken.contains('$base ($n)'.toLowerCase())) {
      n++;
    }
    return '$base ($n)';
  }

  Future<bool> holdCurrentSale({String? customLabel}) async {
    if (state.cartItems.isEmpty) return false;
    final scope = _heldScope;
    if (scope == null) return false;

    _safeEmit(state.patch(isHoldingSale: true));
    try {
      final now = DateTime.now();
      final label = uniqueHeldLabel(
        customLabel,
        now,
        state.heldOrders.map((o) => o.label),
      );

      final order = HeldOrderModel(
        id: UuidUtils.v4(),
        label: label,
        createdAt: now,
        cartItems: List<CartItemModel>.from(state.cartItems),
        customerId: state.selectedCustomer?.id,
        customerName: state.selectedCustomer?.name,
        cartDiscountType: state.cartDiscountType,
        cartDiscountValue: state.cartDiscountDecimal > Decimal.zero
            ? state.cartDiscountDecimal
            : null,
        itemCount: state.cartItems.length,
        totalAmount: state.displayGrandTotal,
      );

      await _heldOrdersDao.saveHeldOrder(order, scope: scope);
      clearCart();
      await loadHeldOrders();
      return true;
    } finally {
      if (!isClosed) {
        _safeEmit(state.patch(isHoldingSale: false));
      }
    }
  }

  /// Re-prices a parked order against today's prices and tax table and lists
  /// every change so the cashier is warned before selling it.
  Future<(List<CartItemModel>, List<String>)> _refreshHeldItems(
    List<CartItemModel> items,
  ) async {
    final changes = <String>[];
    final refreshed = <CartItemModel>[];
    var priceLookupFailed = false;

    for (final item in items) {
      var next = item;

      // Tax: always the current tax table, never the parked snapshot.
      if (item.taxRateId != null) {
        TaxRateModel? current;
        for (final rate in state.taxRates) {
          if (rate.id == item.taxRateId) current = rate;
        }
        current ??= state.defaultTaxRate;
        if (current == null) {
          next = next.copyWith(clearTax: true);
          changes.add('${item.productName}: tax rate no longer exists, '
              'tax removed');
        } else {
          final rate = Decimal.tryParse(current.rate) ?? Decimal.zero;
          if (current.id != item.taxRateId || rate != item.effectiveTaxRate) {
            changes.add('${item.productName}: tax '
                '${DecimalUtils.format(item.effectiveTaxRate)}% -> '
                '${DecimalUtils.format(rate)}%');
          }
          next = next.copyWith(
            taxRateId: current.id,
            taxRateName: taxDisplayLabel(current),
            taxRate: rate,
          );
        }
      }

      // Price: re-fetched unless the cashier typed it in by hand.
      if (!item.priceManual) {
        final result = await _getProductPrice(item.productId, item.variationId);
        if (isClosed) return (items, changes);
        result.fold((_) => priceLookupFailed = true, (price) {
          if (price == null || price <= Decimal.zero) return;
          final unit = price + item.modifierTotalPerUnit;
          if (unit != item.unitPrice) {
            changes.add('${item.productName}: price '
                '${DecimalUtils.format(item.unitPrice)} -> '
                '${DecimalUtils.format(unit)}');
            next = next.copyWith(unitPrice: unit);
          }
        });
      }

      refreshed.add(next);
    }

    if (priceLookupFailed) {
      changes.add('Some prices could not be refreshed; the held prices are '
          'kept. Check the total before payment.');
    }
    return (refreshed, changes);
  }

  Future<HeldResumeResult> resumeHeldOrder(
    String heldOrderId, {
    bool forceOverwrite = false,
  }) async {
    if (state.cartItems.isNotEmpty && !forceOverwrite) {
      return HeldResumeResult.notResumed;
    }
    final scope = _heldScope;
    if (scope == null) return HeldResumeResult.notResumed;

    final held = await _heldOrdersDao.getHeldOrderForScope(heldOrderId, scope);
    if (held == null) return HeldResumeResult.notResumed;

    final (restoredItems, changes) = await _refreshHeldItems(held.cartItems);
    if (isClosed) return HeldResumeResult.notResumed;

    CustomerModel? customer;
    if (held.customerId != null) {
      // Placeholder until the real record (credit limit, balance) is loaded.
      customer = CustomerModel(
        id: held.customerId!,
        businessId: '',
        name: held.customerName ?? 'Customer',
      );
    }

    _safeEmit(state.patch(
      cartItems: restoredItems,
      selectedCustomer: customer,
      cartDiscountType: held.cartDiscountType,
      cartDiscountValue: held.cartDiscountValue?.toString(),
    ));
    _schedulePricePreview();

    await _heldOrdersDao.deleteHeldOrder(heldOrderId);
    await loadHeldOrders();
    if (customer != null) await refreshSelectedCustomer();
    return HeldResumeResult(resumed: true, changes: changes);
  }

  Future<void> discardHeldOrder(String heldOrderId) async {
    final scope = _heldScope;
    if (scope == null) return;
    final held = await _heldOrdersDao.getHeldOrderForScope(heldOrderId, scope);
    if (held == null) return;
    await _heldOrdersDao.deleteHeldOrder(heldOrderId);
    await loadHeldOrders();
  }

  /// Payment lines must add up to what is due before anything is sent.
  void _assertPaymentsCoverTotal(List<PaymentLineModel> payments) {
    final paid = payments.fold(Decimal.zero, (sum, p) => sum + p.amount);
    if (paid != state.displayGrandTotal) {
      throw PaymentMismatchException(
        'Payments (${DecimalUtils.format(paid)}) do not match the total '
        '(${DecimalUtils.format(state.displayGrandTotal)}).',
      );
    }
  }

  Future<SaleResponseModel> submitSale(List<PaymentLineModel> payments) async {
    // Hard gate for every path (plain, dine-in, resumed order): no open shift,
    // no sale. The UI also blocks this, but the cubit is the authority.
    if (state.activeShift == null) {
      throw const ShiftRequiredException();
    }

    if (this is PosCubitDineInMixin &&
        (this as PosCubitDineInMixin).isDineIn) {
      return (this as PosCubitDineInMixin).completeDineInTab(payments);
    }

    if (state.cartItems.isEmpty) {
      throw Exception('Cart is empty');
    }

    final branchId = state.branchId;
    if (branchId == null) {
      throw Exception('Branch not configured');
    }
    _assertPaymentsCoverTotal(payments);

    _safeEmit(state.patch(isSubmittingSale: true));

    try {
      final body = PosSaleRequestBuilder.buildBody(
        branchId: branchId,
        items: state.cartItems,
        cartDiscountType: state.cartDiscountType,
        cartDiscountValue: state.cartDiscountDecimal,
        discountSchemeId: state.selectedDiscountSchemeId,
        registerShiftId: state.activeShift?.id,
        customerId: state.selectedCustomer?.id,
        notes: state.cartNote,
        payments: PosSaleRequestBuilder.paymentsJson(payments),
      );

      // Same cart + payments as a failed earlier attempt = the same sale id,
      // so a re-tap can never create a second sale. Anything else is new.
      final fingerprint = jsonEncode(body);
      if (_pendingSaleFingerprint != fingerprint || _pendingSaleId == null) {
        _pendingSaleFingerprint = fingerprint;
        _pendingSaleId = UuidUtils.v4();
      }
      final saleBody = {...body, 'id': _pendingSaleId};

      final result = await _createSale(saleBody);
      if (isClosed) {
        throw Exception('Sale submission cancelled');
      }
      return result.fold(
        (failure) => throw Exception(failure.message),
        (sale) {
          _pendingSaleFingerprint = null;
          _pendingSaleId = null;
          clearCart();
          _safeEmit(state.patch(isSubmittingSale: false));
          refreshShiftSummary();
          return sale;
        },
      );
    } catch (e) {
      _safeEmit(state.patch(isSubmittingSale: false));
      rethrow;
    }
  }

  Future<void> _loadDiscountSchemes() async {
    final result = await _getDiscountSchemes();
    if (isClosed) return;
    result.fold(
      (_) {},
      (schemes) => _safeEmit(state.patch(
        discountSchemes: schemes.where((s) => s.isActive).toList(),
      )),
    );
  }

  void _schedulePricePreview() {
    if (state.selectedDiscountSchemeId == null) return;
    _previewDebounce?.cancel();
    _safeEmit(state.patch(
      isLoadingPricePreview: true,
      pricePreviewError: null,
    ));
    _previewDebounce = Timer(_previewDebounceDuration, () {
      unawaited(_fetchPricePreview());
    });
  }

  Future<void> _fetchPricePreview() async {
    final schemeId = state.selectedDiscountSchemeId;
    if (schemeId == null) return;

    if (state.cartItems.isEmpty) {
      _safeEmit(state.patch(
        pricePreview: null,
        pricePreviewError: null,
        isLoadingPricePreview: false,
      ));
      return;
    }

    final branchId = state.branchId;
    if (branchId == null) {
      _safeEmit(state.patch(
        pricePreview: null,
        pricePreviewError: 'Branch not configured',
        isLoadingPricePreview: false,
      ));
      return;
    }

    final body = PosSaleRequestBuilder.buildBody(
      branchId: branchId,
      items: state.cartItems,
      cartDiscountType: state.cartDiscountType,
      cartDiscountValue: state.cartDiscountDecimal,
      discountSchemeId: schemeId,
      registerShiftId: state.activeShift?.id,
      customerId: state.selectedCustomer?.id,
      notes: state.cartNote,
    );

    final result = await _previewSalePrice(body);
    if (isClosed || state.selectedDiscountSchemeId != schemeId) return;

    result.fold(
      (failure) => _safeEmit(state.patch(
        pricePreview: null,
        pricePreviewError: failure.message,
        isLoadingPricePreview: false,
      )),
      (preview) => _safeEmit(state.patch(
        pricePreview: preview,
        pricePreviewError: null,
        isLoadingPricePreview: false,
      )),
    );
  }
}
