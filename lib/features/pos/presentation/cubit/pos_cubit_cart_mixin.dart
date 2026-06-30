part of 'pos_cubit.dart';

mixin PosCubitCartMixin on PosCubitBase, PosCubitShiftMixin {
  Future<void> _loadTaxData() async {
    final taxResult = await _getTaxRates();
    final settingsResult = await _getSettings();
    if (isClosed) return;

    taxResult.fold(
      (_) {},
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
        ));
      },
    );
  }

  static String taxDisplayLabel(TaxRateModel rate) =>
      '${rate.name} ${rate.rate}%';

  Future<AddToCartOutcome> addToCart(
    ProductListItemModel product, {
    String? variationId,
    Decimal? manualUnitPrice,
  }) async {
    debugPrint(
      '[POS:Cubit] addToCart "${product.name}" variationId=$variationId '
      'manualPrice=$manualUnitPrice cartSize=${state.cartItems.length}',
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
      final cached = Decimal.tryParse(state.priceCache[priceKey] ?? '');
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

    final unitPrice = manualUnitPrice ?? resolvedPrice!;
    final isManualPrice = manualUnitPrice != null;

    final cartKey = variationId != null
        ? '${product.id}:$variationId'
        : product.id;
    final existingIndex =
        state.cartItems.indexWhere((item) => item.cartKey == cartKey);
    final requestedQty = existingIndex >= 0
        ? state.cartItems[existingIndex].qty + Decimal.one
        : Decimal.one;

    final branchId = state.branchId;
    Decimal? availableStock;
    if (branchId != null) {
      final stockResult = await _getStockBalance(
        branchId: branchId,
        productId: product.id,
        variationId: variationId,
      );
      stockResult.fold((_) {}, (balance) {
        availableStock = Decimal.tryParse(balance.currentQty);
      });
    }

    if (isClosed) return AddToCartOutcome.added;

    if (availableStock != null && availableStock! < requestedQty) {
      debugPrint(
        '[POS:Cubit] addToCart → insufficientStock available=$availableStock requested=$requestedQty',
      );
      final label = variation?.name != null
          ? '${product.name} (${variation!.name})'
          : product.name;
      return AddToCartOutcome(
        result: AddToCartResult.insufficientStock,
        message:
            'Insufficient stock for $label. Available: ${DecimalUtils.format(availableStock!, fractionDigits: 4)}',
      );
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

    return AddToCartOutcome.added;
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

  void selectCustomer(CustomerModel? customer) {
    emit(state.patch(selectedCustomer: customer));
  }

  void clearCart() {
    _safeEmit(state.patch(
      cartItems: [],
      selectedCustomer: null,
      cartDiscountType: null,
      cartDiscountValue: null,
      cartNote: null,
      pricePreview: null,
      pricePreviewError: null,
      isLoadingPricePreview: false,
    ));
  }

  Future<void> loadHeldOrders() async {
    final orders = await _heldOrdersDao.getAllHeldOrders();
    if (isClosed) return;
    _safeEmit(state.patch(heldOrders: orders));
  }

  Future<bool> holdCurrentSale({String? customLabel}) async {
    if (state.cartItems.isEmpty) return false;

    _safeEmit(state.patch(isHoldingSale: true));
    try {
      final orderNumber = state.heldOrders.length + 1;
      final label = customLabel?.trim().isNotEmpty == true
          ? customLabel!.trim()
          : 'Order #$orderNumber';

      final order = HeldOrderModel(
        id: UuidUtils.v4(),
        label: label,
        createdAt: DateTime.now(),
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

      await _heldOrdersDao.saveHeldOrder(order);
      clearCart();
      await loadHeldOrders();
      return true;
    } finally {
      if (!isClosed) {
        _safeEmit(state.patch(isHoldingSale: false));
      }
    }
  }

  Future<bool> resumeHeldOrder(
    String heldOrderId, {
    bool forceOverwrite = false,
  }) async {
    if (state.cartItems.isNotEmpty && !forceOverwrite) return false;

    final held = await _heldOrdersDao.getHeldOrderById(heldOrderId);
    if (held == null) return false;

    final activeTaxIds = state.taxRates.map((t) => t.id).toSet();
    final restoredItems = held.cartItems.map((item) {
      if (item.taxRateId != null && !activeTaxIds.contains(item.taxRateId)) {
        return item.copyWith(clearTax: true);
      }
      return item;
    }).toList();

    CustomerModel? customer;
    if (held.customerId != null) {
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
    return true;
  }

  Future<void> discardHeldOrder(String heldOrderId) async {
    await _heldOrdersDao.deleteHeldOrder(heldOrderId);
    await loadHeldOrders();
  }

  Future<SaleResponseModel> submitSale(List<PaymentLineModel> payments) async {
    if (state.cartItems.isEmpty) {
      throw Exception('Cart is empty');
    }

    final branchId = state.branchId;
    if (branchId == null) {
      throw Exception('Branch not configured');
    }

    _safeEmit(state.patch(isSubmittingSale: true));

    try {
      final saleId = UuidUtils.v4();
      final body = PosSaleRequestBuilder.buildBody(
        saleId: saleId,
        branchId: branchId,
        items: state.cartItems,
        cartDiscountType: state.cartDiscountType,
        cartDiscountValue: state.cartDiscountDecimal,
        discountSchemeId: state.selectedDiscountSchemeId,
        registerShiftId: state.activeShift?.id,
        customerId: state.selectedCustomer?.id,
        notes: state.cartNote,
        payments: payments
            .map((p) => {
                  'payment_method': p.paymentMethod,
                  'amount': DecimalUtils.format(p.amount),
                  if (p.referenceNo != null && p.referenceNo!.isNotEmpty)
                    'reference_no': p.referenceNo,
                })
            .toList(),
      );

      final result = await _createSale(body);
      if (isClosed) {
        throw Exception('Sale submission cancelled');
      }
      return result.fold(
        (failure) => throw Exception(failure.message),
        (sale) {
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
