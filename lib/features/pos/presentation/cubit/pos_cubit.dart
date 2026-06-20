import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/core/utils/uuid_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
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
    required GetActiveShiftUseCase getActiveShiftUseCase,
    required OpenShiftUseCase openShiftUseCase,
    required GetShiftSummaryUseCase getShiftSummaryUseCase,
    required GetRegistersUseCase getRegistersUseCase,
    required CreateRegisterUseCase createRegisterUseCase,
    required GetStockBalanceUseCase getStockBalanceUseCase,
    required AuthLocalDataSource authLocalDataSource,
    required NetworkInfo networkInfo,
  })  : _getProducts = getProductsUseCase,
        _getCategories = getCategoriesUseCase,
        _getProductById = getProductByIdUseCase,
        _lookupBarcode = lookupBarcodeUseCase,
        _getProductPrice = getProductPriceUseCase,
        _createSale = createSaleUseCase,
        _getActiveShift = getActiveShiftUseCase,
        _openShift = openShiftUseCase,
        _getShiftSummary = getShiftSummaryUseCase,
        _getRegisters = getRegistersUseCase,
        _createRegister = createRegisterUseCase,
        _getStockBalance = getStockBalanceUseCase,
        _authLocal = authLocalDataSource,
        _networkInfo = networkInfo,
        super(const PosState());

  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;
  final GetProductByIdUseCase _getProductById;
  final LookupBarcodeUseCase _lookupBarcode;
  final GetProductPriceUseCase _getProductPrice;
  final CreateSaleUseCase _createSale;
  final GetActiveShiftUseCase _getActiveShift;
  final OpenShiftUseCase _openShift;
  final GetShiftSummaryUseCase _getShiftSummary;
  final GetRegistersUseCase _getRegisters;
  final CreateRegisterUseCase _createRegister;
  final GetStockBalanceUseCase _getStockBalance;
  final AuthLocalDataSource _authLocal;
  final NetworkInfo _networkInfo;

  Timer? _searchDebounce;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    final offline = !await _networkInfo.isConnected;
    emit(state.copyWith(
      cashierName: user?.name ?? 'Cashier',
      branchId: user?.branchId,
      businessName: user?.businessName,
      isOffline: offline,
    ));
    await Future.wait([
      _loadProducts(),
      _loadCategories(),
      checkActiveShift(),
    ]);
  }

  Future<void> _loadProducts() async {
    emit(state.copyWith(isLoadingProducts: true, productsError: null));
    final result = await _getProducts(isActive: true, limit: 200);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingProducts: false,
        productsError: failure.message,
      )),
      (page) => emit(state.copyWith(
        isLoadingProducts: false,
        products: page.items,
      )),
    );
  }

  Future<void> _loadCategories() async {
    final result = await _getCategories();
    result.fold(
      (_) {},
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  Future<void> checkActiveShift() async {
    emit(state.copyWith(isCheckingShift: true, registersError: null));
    final branchId = state.branchId;

    if (branchId == null) {
      emit(state.copyWith(
        isCheckingShift: false,
        registersError: 'Branch not configured for your account. Please re-login.',
      ));
      return;
    }

    final registersResult = await _getRegisters(branchId: branchId);
    await registersResult.fold(
      (failure) async {
        emit(state.copyWith(
          isCheckingShift: false,
          registersError: failure.message,
        ));
      },
      (registers) async {
        if (registers.isEmpty) {
          emit(state.copyWith(
            registers: registers,
            isCheckingShift: false,
            activeShift: null,
            registersError: null,
          ));
          return;
        }

        final registerId = state.selectedRegisterId ?? registers.first.id;
        emit(state.copyWith(
          registers: registers,
          selectedRegisterId: registerId,
        ));

        final shiftResult = await _getActiveShift(registerId);
        shiftResult.fold(
          (failure) => emit(state.copyWith(
            isCheckingShift: false,
            registersError: failure.message,
          )),
          (shift) async {
            ShiftSummaryModel? summary;
            if (shift != null) {
              final summaryResult = await _getShiftSummary(shift.id);
              summaryResult.fold((_) {}, (s) => summary = s);
            }
            emit(state.copyWith(
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

    emit(state.copyWith(isCreatingRegister: true, registersError: null));
    final result = await _createRegister({
      'name': name,
      'branch_id': branchId,
    });

    return result.fold(
      (failure) {
        emit(state.copyWith(
          isCreatingRegister: false,
          registersError: failure.message,
        ));
        return false;
      },
      (register) {
        emit(state.copyWith(
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
    result.fold((_) {}, (summary) {
      emit(state.copyWith(shiftSummary: summary));
    });
  }

  Future<bool> openShift(Decimal openingFloat, String? notes) async {
    final registerId = state.selectedRegisterId;
    if (registerId == null) return false;

    emit(state.copyWith(isOpeningShift: true));
    final result = await _openShift({
      'cash_register_id': registerId,
      'opening_float': DecimalUtils.format(openingFloat),
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });

    return result.fold(
      (_) {
        emit(state.copyWith(isOpeningShift: false));
        return false;
      },
      (shift) {
        emit(state.copyWith(
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
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      emit(state.copyWith(productSearchQuery: query));
    });
  }

  void setSearchQueryImmediate(String query) {
    emit(state.copyWith(productSearchQuery: query));
  }

  Future<bool> lookupBarcode(String barcode) async {
    final result = await _lookupBarcode(barcode);
    return result.fold(
      (_) => false,
      (product) async {
        final outcome = await _addProductModelToCart(product);
        return outcome.result == AddToCartResult.added;
      },
    );
  }

  Future<ProductListItemModel?> getListItemByBarcode(String barcode) async {
    final result = await _lookupBarcode(barcode);
    return result.fold((_) => null, _toListItem);
  }

  ProductListItemModel _toListItem(ProductModel product) {
    final cache = {...state.productDetailsCache, product.id: product};
    emit(state.copyWith(productDetailsCache: cache));
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
    ProductModel? details = state.productDetailsCache[product.id];
    if (details == null ||
        (details.variations.length > 1 && variationId == null)) {
      final result = await _getProductById(product.id);
      result.fold((_) {}, (p) {
        details = p;
        final cache = {...state.productDetailsCache, product.id: p};
        emit(state.copyWith(productDetailsCache: cache));
      });
    }

    details ??= state.productDetailsCache[product.id];
    if (details != null && details!.variations.length > 1 && variationId == null) {
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
      await priceResult.fold((_) {}, (p) {
        if (p != null && p > Decimal.zero) {
          resolvedPrice = p;
          emit(state.copyWith(
            priceCache: {...state.priceCache, priceKey: p.toString()},
          ));
        }
      });
    }

    final needsManualPrice =
        resolvedPrice == null || resolvedPrice! <= Decimal.zero;
    if (needsManualPrice) {
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
      emit(state.copyWith(
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

    if (availableStock != null && availableStock! < requestedQty) {
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
      emit(state.copyWith(cartItems: items));
    } else {
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
      );
      emit(state.copyWith(cartItems: [...state.cartItems, newItem]));
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
    return result.fold((_) => null, (product) {
      emit(state.copyWith(
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
    emit(state.copyWith(
      cartItems: [],
      selectedCustomer: null,
      cartDiscountType: null,
      cartDiscountValue: null,
      cartNote: null,
    ));
  }

  Future<SaleResponseModel> submitSale(List<PaymentLineModel> payments) async {
    if (state.cartItems.isEmpty) {
      throw Exception('Cart is empty');
    }

    final branchId = state.branchId;
    if (branchId == null) {
      throw Exception('Branch not configured');
    }

    emit(state.copyWith(isSubmittingSale: true));

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
      return result.fold(
        (failure) => throw Exception(failure.message),
        (sale) {
          clearCart();
          emit(state.copyWith(isSubmittingSale: false));
          refreshShiftSummary();
          return sale;
        },
      );
    } catch (e) {
      emit(state.copyWith(isSubmittingSale: false));
      rethrow;
    }
  }

  Decimal? getDisplayPrice(String productId, {String? variationId}) {
    final key = variationId != null ? '$productId:$variationId' : productId;
    final raw = state.priceCache[key];
    if (raw == null) return null;
    return Decimal.tryParse(raw);
  }
}
