part of 'pos_state.dart';

const _unset = Object();

/// Flat field updates matching the pre-split PosState.copyWith API.
extension PosStateFlatCopy on PosState {
  PosState patch({
    Object? accessDenied = _unset,
    Object? canOpenShift = _unset,
    Object? canCloseShift = _unset,
    Object? cashierName = _unset,
    Object? branchId = _unset,
    Object? businessName = _unset,
    Object? isOffline = _unset,
    Object? dineIn = _unset,
    Object? activeShift = _unset,
    Object? shiftSummary = _unset,
    Object? registers = _unset,
    Object? selectedRegisterId = _unset,
    Object? isCheckingShift = _unset,
    Object? isOpeningShift = _unset,
    Object? isCreatingRegister = _unset,
    Object? registersError = _unset,
    Object? products = _unset,
    Object? categories = _unset,
    Object? selectedCategoryId = _unset,
    Object? productSearchQuery = _unset,
    Object? isLoadingProducts = _unset,
    Object? productsError = _unset,
    Object? priceCache = _unset,
    Object? stockCache = _unset,
    Object? productDetailsCache = _unset,
    Object? cartItems = _unset,
    Object? taxRates = _unset,
    Object? defaultTaxRate = _unset,
    Object? selectedCustomer = _unset,
    Object? cartDiscountType = _unset,
    Object? cartDiscountValue = _unset,
    Object? cartNote = _unset,
    Object? heldOrders = _unset,
    Object? isHoldingSale = _unset,
    Object? isSubmittingSale = _unset,
    Object? isFiringTab = _unset,
    Object? isRequestingBill = _unset,
    Object? selectedDiscountSchemeId = _unset,
    Object? discountSchemes = _unset,
    Object? pricePreview = _unset,
    Object? isLoadingPricePreview = _unset,
    Object? pricePreviewError = _unset,
  }) {
    final newSession = session.copyWith(
      accessDenied: accessDenied == _unset
          ? session.accessDenied
          : accessDenied as bool,
      canOpenShift: canOpenShift == _unset
          ? session.canOpenShift
          : canOpenShift as bool,
      canCloseShift: canCloseShift == _unset
          ? session.canCloseShift
          : canCloseShift as bool,
      cashierName: cashierName == _unset
          ? session.cashierName
          : cashierName as String?,
      branchId: branchId == _unset ? session.branchId : branchId as String?,
      businessName: businessName == _unset
          ? session.businessName
          : businessName as String?,
      isOffline: isOffline == _unset ? session.isOffline : isOffline as bool,
      dineIn: dineIn == _unset
          ? session.dineIn
          : dineIn as PosDineInContext?,
    );

    final newShift = shift.copyWith(
      activeShift: activeShift == _unset
          ? shift.activeShift
          : activeShift as RegisterShiftModel?,
      shiftSummary: shiftSummary == _unset
          ? shift.shiftSummary
          : shiftSummary as ShiftSummaryModel?,
      registers: registers == _unset
          ? shift.registers
          : registers as List<CashRegisterModel>,
      selectedRegisterId: selectedRegisterId == _unset
          ? shift.selectedRegisterId
          : selectedRegisterId as String?,
      isCheckingShift: isCheckingShift == _unset
          ? shift.isCheckingShift
          : isCheckingShift as bool,
      isOpeningShift: isOpeningShift == _unset
          ? shift.isOpeningShift
          : isOpeningShift as bool,
      isCreatingRegister: isCreatingRegister == _unset
          ? shift.isCreatingRegister
          : isCreatingRegister as bool,
      registersError: registersError == _unset
          ? shift.registersError
          : registersError as String?,
    );

    final newCatalog = catalog.copyWith(
      products: products == _unset
          ? catalog.products
          : products as List<ProductListItemModel>,
      categories: categories == _unset
          ? catalog.categories
          : categories as List<CategoryModel>,
      selectedCategoryId: selectedCategoryId == _unset
          ? catalog.selectedCategoryId
          : selectedCategoryId as String?,
      productSearchQuery: productSearchQuery == _unset
          ? catalog.productSearchQuery
          : productSearchQuery as String,
      isLoadingProducts: isLoadingProducts == _unset
          ? catalog.isLoadingProducts
          : isLoadingProducts as bool,
      productsError: productsError == _unset
          ? catalog.productsError
          : productsError as String?,
      priceCache: priceCache == _unset
          ? catalog.priceCache
          : priceCache as Map<String, String>,
      stockCache: stockCache == _unset
          ? catalog.stockCache
          : stockCache as Map<String, String>,
      productDetailsCache: productDetailsCache == _unset
          ? catalog.productDetailsCache
          : productDetailsCache as Map<String, ProductModel>,
    );

    final newCart = cart.copyWith(
      cartItems: cartItems == _unset
          ? cart.cartItems
          : cartItems as List<CartItemModel>,
      taxRates: taxRates == _unset
          ? cart.taxRates
          : taxRates as List<TaxRateModel>,
      defaultTaxRate: defaultTaxRate == _unset
          ? cart.defaultTaxRate
          : defaultTaxRate as TaxRateModel?,
      selectedCustomer: selectedCustomer == _unset
          ? cart.selectedCustomer
          : selectedCustomer as CustomerModel?,
      cartDiscountType: cartDiscountType == _unset
          ? cart.cartDiscountType
          : cartDiscountType as String?,
      cartDiscountValue: cartDiscountValue == _unset
          ? cart.cartDiscountValue
          : cartDiscountValue as String?,
      cartNote: cartNote == _unset ? cart.cartNote : cartNote as String?,
      heldOrders: heldOrders == _unset
          ? cart.heldOrders
          : heldOrders as List<HeldOrderModel>,
      isHoldingSale: isHoldingSale == _unset
          ? cart.isHoldingSale
          : isHoldingSale as bool,
      isSubmittingSale: isSubmittingSale == _unset
          ? cart.isSubmittingSale
          : isSubmittingSale as bool,
      isFiringTab: isFiringTab == _unset
          ? cart.isFiringTab
          : isFiringTab as bool,
      isRequestingBill: isRequestingBill == _unset
          ? cart.isRequestingBill
          : isRequestingBill as bool,
      selectedDiscountSchemeId: selectedDiscountSchemeId == _unset
          ? cart.selectedDiscountSchemeId
          : selectedDiscountSchemeId as String?,
      discountSchemes: discountSchemes == _unset
          ? cart.discountSchemes
          : discountSchemes as List<DiscountSchemeModel>,
      pricePreview: pricePreview == _unset
          ? cart.pricePreview
          : pricePreview as SalePricePreviewModel?,
      isLoadingPricePreview: isLoadingPricePreview == _unset
          ? cart.isLoadingPricePreview
          : isLoadingPricePreview as bool,
      pricePreviewError: pricePreviewError == _unset
          ? cart.pricePreviewError
          : pricePreviewError as String?,
    );

    return PosState(
      session: newSession,
      shift: newShift,
      catalog: newCatalog,
      cart: newCart,
    );
  }
}
