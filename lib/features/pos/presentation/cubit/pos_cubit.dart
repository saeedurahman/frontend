import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/core/utils/uuid_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/domain/utils/pos_calculations.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_state.dart';
import 'package:frantend/features/pos/presentation/models/add_to_cart_outcome.dart';
import 'package:frantend/features/pos/presentation/models/add_to_cart_result.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/utils/settings_value_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class PosCubit extends Cubit<PosState> {
  PosCubit({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
    required LookupBarcodeUseCase lookupBarcodeUseCase,
    required GetProductPriceUseCase getProductPriceUseCase,
    required CreateSaleUseCase createSaleUseCase,
    required GetMyActiveShiftUseCase getMyActiveShiftUseCase,
    required OpenShiftUseCase openShiftUseCase,
    required GetShiftSummaryUseCase getShiftSummaryUseCase,
    required GetRegistersUseCase getRegistersUseCase,
    required CreateRegisterUseCase createRegisterUseCase,
    required GetStockBalanceUseCase getStockBalanceUseCase,
    required GetStockBalancesUseCase getStockBalancesUseCase,
    required GetTaxRatesUseCase getTaxRatesUseCase,
    required GetSettingsUseCase getSettingsUseCase,
    required AuthLocalDataSource authLocalDataSource,
    required NetworkInfo networkInfo,
    required HeldOrdersDao heldOrdersDao,
  })  : _getProducts = getProductsUseCase,
        _getCategories = getCategoriesUseCase,
        _getProductById = getProductByIdUseCase,
        _lookupBarcode = lookupBarcodeUseCase,
        _getProductPrice = getProductPriceUseCase,
        _createSale = createSaleUseCase,
        _getMyActiveShift = getMyActiveShiftUseCase,
        _openShift = openShiftUseCase,
        _getShiftSummary = getShiftSummaryUseCase,
        _getRegisters = getRegistersUseCase,
        _createRegister = createRegisterUseCase,
        _getStockBalance = getStockBalanceUseCase,
        _getStockBalances = getStockBalancesUseCase,
        _getTaxRates = getTaxRatesUseCase,
        _getSettings = getSettingsUseCase,
        _authLocal = authLocalDataSource,
        _networkInfo = networkInfo,
        _heldOrdersDao = heldOrdersDao,
        super(const PosState());

  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;
  final GetProductByIdUseCase _getProductById;
  final LookupBarcodeUseCase _lookupBarcode;
  final GetProductPriceUseCase _getProductPrice;
  final CreateSaleUseCase _createSale;
  final GetMyActiveShiftUseCase _getMyActiveShift;
  final OpenShiftUseCase _openShift;
  final GetShiftSummaryUseCase _getShiftSummary;
  final GetRegistersUseCase _getRegisters;
  final CreateRegisterUseCase _createRegister;
  final GetStockBalanceUseCase _getStockBalance;
  final GetStockBalancesUseCase _getStockBalances;
  final GetTaxRatesUseCase _getTaxRates;
  final GetSettingsUseCase _getSettings;
  final AuthLocalDataSource _authLocal;
  final NetworkInfo _networkInfo;
  final HeldOrdersDao _heldOrdersDao;

  Timer? _searchDebounce;

  void _safeEmit(PosState newState) {
    if (isClosed) return;
    emit(newState);
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    final offline = !await _networkInfo.isConnected;
    if (isClosed) return;
    _safeEmit(state.copyWith(
      cashierName: user?.name ?? 'Cashier',
      branchId: user?.branchId,
      businessName: user?.businessName,
      isOffline: offline,
    ));
    await Future.wait([
      _loadProducts(),
      _loadCategories(),
      _loadTaxData(),
      checkActiveShift(),
      loadHeldOrders(),
    ]);
    await _loadStockBalances();
  }

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
        _safeEmit(state.copyWith(
          taxRates: taxRates.where((t) => t.isActive).toList(),
          defaultTaxRate: defaultRate,
        ));
      },
    );
  }

  static String taxDisplayLabel(TaxRateModel rate) =>
      '${rate.name} ${rate.rate}%';

  Future<void> _loadProducts() async {
    _safeEmit(state.copyWith(isLoadingProducts: true, productsError: null));
    final result = await _getProducts(isActive: true, limit: 200);
    if (isClosed) return;
    result.fold(
      (failure) => _safeEmit(state.copyWith(
        isLoadingProducts: false,
        productsError: failure.message,
      )),
      (page) => _safeEmit(state.copyWith(
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
      _safeEmit(state.copyWith(stockCache: cache));
    });
  }

  Future<void> _loadCategories() async {
    final result = await _getCategories();
    if (isClosed) return;
    result.fold(
      (_) {},
      (categories) => _safeEmit(state.copyWith(categories: categories)),
    );
  }

  Future<void> checkActiveShift() async {
    _safeEmit(state.copyWith(isCheckingShift: true, registersError: null));
    final branchId = state.branchId;

    if (branchId == null) {
      _safeEmit(state.copyWith(
        isCheckingShift: false,
        registersError: 'Branch not configured for your account. Please re-login.',
      ));
      return;
    }

    final registersResult = await _getRegisters(branchId: branchId);
    final shiftResult = await _getMyActiveShift();
    if (isClosed) return;

    await registersResult.fold(
      (Failure failure) async {
        _safeEmit(state.copyWith(
          isCheckingShift: false,
          registersError: failure.message,
        ));
      },
      (List<CashRegisterModel> registers) async {
        await shiftResult.fold(
          (Failure failure) async {
            _safeEmit(state.copyWith(
              registers: registers,
              isCheckingShift: false,
              activeShift: null,
              registersError: failure.message,
            ));
          },
          (RegisterShiftModel? shift) async {
            ShiftSummaryModel? summary;
            if (shift != null) {
              final summaryResult = await _getShiftSummary(shift.id);
              if (isClosed) return;
              summaryResult.fold((_) {}, (s) => summary = s);
            }

            final selectedRegisterId = shift?.cashRegisterId ??
                state.selectedRegisterId ??
                (registers.isNotEmpty ? registers.first.id : null);

            _safeEmit(state.copyWith(
              registers: registers,
              selectedRegisterId: selectedRegisterId,
              activeShift: shift,
              shiftSummary: summary,
              isCheckingShift: false,
              registersError: null,
            ));
          },
        );
      },
    );
  }

  Future<bool> createDefaultRegister({String name = 'Main Counter'}) async {
    final branchId = state.branchId;
    if (branchId == null) return false;

    _safeEmit(state.copyWith(isCreatingRegister: true, registersError: null));
    final result = await _createRegister({
      'name': name,
      'branch_id': branchId,
    });
    if (isClosed) return false;

    return result.fold(
      (failure) {
        _safeEmit(state.copyWith(
          isCreatingRegister: false,
          registersError: failure.message,
        ));
        return false;
      },
      (register) {
        _safeEmit(state.copyWith(
          registers: [register],
          selectedRegisterId: register.id,
          isCreatingRegister: false,
        ));
        return true;
      },
    );
  }

  Future<void> refreshShiftSummary() async {
    final shift = state.activeShift;
    if (shift == null) return;
    final result = await _getShiftSummary(shift.id);
    if (isClosed) return;
    result.fold((_) {}, (summary) {
      _safeEmit(state.copyWith(shiftSummary: summary));
    });
  }

  Future<bool> openShift(Decimal openingFloat, String? notes) async {
    final registerId = state.selectedRegisterId;
    if (registerId == null) return false;

    _safeEmit(state.copyWith(isOpeningShift: true));
    final result = await _openShift({
      'cash_register_id': registerId,
      'opening_float': DecimalUtils.format(openingFloat),
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
    if (isClosed) return false;

    return result.fold(
      (_) {
        _safeEmit(state.copyWith(isOpeningShift: false));
        return false;
      },
      (shift) {
        _safeEmit(state.copyWith(
          activeShift: shift,
          isOpeningShift: false,
          isCheckingShift: false,
        ));
        refreshShiftSummary();
        return true;
      },
    );
  }

  void selectRegister(String registerId) {
    emit(state.copyWith(selectedRegisterId: registerId));
  }

  void selectCategory(String? categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
  }

  void searchProducts(String query) {
    debugPrint('[POS:Search] searchProducts debounced query="$query"');
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      debugPrint('[POS:Search] applied filter query="$query"');
      _safeEmit(state.copyWith(productSearchQuery: query));
    });
  }

  void setSearchQueryImmediate(String query) {
    emit(state.copyWith(productSearchQuery: query));
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
        debugPrint('[POS:Cubit] getListItemByBarcode FAILED: ${failure.message}');
        return null;
      },
      (product) {
        debugPrint('[POS:Cubit] getListItemByBarcode OK product="${product.name}"');
        return _toListItem(product);
      },
    );
  }

  ProductListItemModel _toListItem(ProductModel product) {
    final cache = {...state.productDetailsCache, product.id: product};
    _safeEmit(state.copyWith(productDetailsCache: cache));
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
        _safeEmit(state.copyWith(productDetailsCache: cache));
      });
    }

    details ??= state.productDetailsCache[product.id];
    if (details != null && details!.variations.length > 1 && variationId == null) {
      debugPrint('[POS:Cubit] addToCart → needsVariation (${details!.variations.length} variations)');
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
          _safeEmit(state.copyWith(
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
      _safeEmit(state.copyWith(
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
      debugPrint('[POS:Cubit] addToCart → insufficientStock available=$availableStock requested=$requestedQty');
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
      _safeEmit(state.copyWith(cartItems: items));
      debugPrint('[POS:Cubit] addToCart → QTY INCREASED cartSize=${items.length}');
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
      _safeEmit(state.copyWith(cartItems: items));
      debugPrint('[POS:Cubit] addToCart → ADDED cartSize=${items.length}');
    }

    return AddToCartOutcome.added;
  }

  Future<AddToCartOutcome> _addProductModelToCart(ProductModel product) async {
    final listItem = _toListItem(product);

    if (product.variations.length > 1) {
      return AddToCartOutcome(result: AddToCartResult.needsVariation);
    }
    return addToCart(listItem);
  }

  Future<ProductModel?> getProductDetails(String productId) async {
    if (state.productDetailsCache.containsKey(productId)) {
      return state.productDetailsCache[productId];
    }
    final result = await _getProductById(productId);
    if (isClosed) return null;
    return result.fold((_) => null, (product) {
      _safeEmit(state.copyWith(
        productDetailsCache: {...state.productDetailsCache, productId: product},
      ));
      return product;
    });
  }

  void removeFromCart(int cartIndex) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final items = [...state.cartItems]..removeAt(cartIndex);
    emit(state.copyWith(cartItems: items));
  }

  void updateCartItemQty(int cartIndex, Decimal newQty) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    if (newQty <= Decimal.zero) {
      removeFromCart(cartIndex);
      return;
    }
    final items = [...state.cartItems];
    items[cartIndex] = items[cartIndex].copyWith(qty: newQty);
    emit(state.copyWith(cartItems: items));
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
    emit(state.copyWith(cartItems: items));
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
    emit(state.copyWith(cartItems: items));
  }

  void updateLineNote(int cartIndex, String note) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final items = [...state.cartItems];
    items[cartIndex] = items[cartIndex].copyWith(
      lineNote: note,
      clearLineNote: note.isEmpty,
    );
    emit(state.copyWith(cartItems: items));
  }

  void updateCartItemPrice(int cartIndex, Decimal price) {
    if (cartIndex < 0 || cartIndex >= state.cartItems.length) return;
    final items = [...state.cartItems];
    items[cartIndex] = items[cartIndex].copyWith(
      unitPrice: price,
      priceManual: true,
    );
    emit(state.copyWith(cartItems: items));
  }

  void applyCartDiscount(String type, Decimal value) {
    emit(state.copyWith(
      cartDiscountType: type,
      cartDiscountValue: DecimalUtils.format(value),
    ));
  }

  void removeCartDiscount() {
    emit(state.copyWith(
      cartDiscountType: null,
      cartDiscountValue: null,
    ));
  }

  void selectCustomer(CustomerModel? customer) {
    emit(state.copyWith(selectedCustomer: customer));
  }

  void clearCart() {
    _safeEmit(state.copyWith(
      cartItems: [],
      selectedCustomer: null,
      cartDiscountType: null,
      cartDiscountValue: null,
      cartNote: null,
    ));
  }

  Future<void> loadHeldOrders() async {
    final orders = await _heldOrdersDao.getAllHeldOrders();
    if (isClosed) return;
    _safeEmit(state.copyWith(heldOrders: orders));
  }

  Future<bool> holdCurrentSale({String? customLabel}) async {
    if (state.cartItems.isEmpty) return false;

    _safeEmit(state.copyWith(isHoldingSale: true));
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
        totalAmount: state.grandTotal,
      );

      await _heldOrdersDao.saveHeldOrder(order);
      clearCart();
      await loadHeldOrders();
      return true;
    } finally {
      if (!isClosed) {
        _safeEmit(state.copyWith(isHoldingSale: false));
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

    _safeEmit(state.copyWith(
      cartItems: restoredItems,
      selectedCustomer: customer,
      cartDiscountType: held.cartDiscountType,
      cartDiscountValue: held.cartDiscountValue?.toString(),
    ));

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

    _safeEmit(state.copyWith(isSubmittingSale: true));

    try {
      final lines = PosCalculations.buildSaleLines(
        items: state.cartItems,
        cartDiscountType: state.cartDiscountType,
        cartDiscountValue: state.cartDiscountDecimal,
      );

      final body = <String, dynamic>{
        'id': UuidUtils.v4(),
        'branch_id': branchId,
        'customer_id': state.selectedCustomer?.id,
        'sale_type': 'pos',
        if (state.activeShift != null)
          'register_shift_id': state.activeShift!.id,
        if (state.cartNote != null && state.cartNote!.isNotEmpty)
          'notes': state.cartNote,
        'lines': lines,
        'payments': payments
            .map((p) => {
                  'payment_method': p.paymentMethod,
                  'amount': DecimalUtils.format(p.amount),
                  if (p.referenceNo != null && p.referenceNo!.isNotEmpty)
                    'reference_no': p.referenceNo,
                })
            .toList(),
      };

      final result = await _createSale(body);
      if (isClosed) {
        throw Exception('Sale submission cancelled');
      }
      return result.fold(
        (failure) => throw Exception(failure.message),
        (sale) {
          clearCart();
          _safeEmit(state.copyWith(isSubmittingSale: false));
          refreshShiftSummary();
          return sale;
        },
      );
    } catch (e) {
      _safeEmit(state.copyWith(isSubmittingSale: false));
      rethrow;
    }
  }

  Decimal? getDisplayPrice(String productId, {String? variationId}) {
    final key = variationId != null ? '$productId:$variationId' : productId;
    final raw = state.priceCache[key];
    if (raw == null) return null;
    return Decimal.tryParse(raw);
  }

  String? getDisplayStock(String productId) => state.stockCache[productId];
}
