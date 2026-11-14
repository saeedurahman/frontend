part of 'pos_cubit.dart';

mixin PosCubitSessionMixin
    on PosCubitBase,
        PosCubitShiftMixin,
        PosCubitCartMixin,
        PosCubitCatalogMixin,
        PosCubitDineInMixin {
  Future<void> init({
    String? dineInTableId,
    String? dineInSaleId,
    String? dineInTableNumber,
    String? dineInTableStatus,
  }) async {
    _allowBelowStock = await _offlinePolicy?.allowSellBelowStock() ?? false;
    final session = await _resolvePosSession();
    if (isClosed) return;
    final user = session.user;
    _canOverridePrice = session.canOverridePrice;

    if (!session.canCreateSales) {
      _safeEmit(
        state.patch(
          accessDenied: true,
          isCheckingShift: false,
          isLoadingProducts: false,
          canOpenShift: session.canOpenShift,
          canCloseShift: session.canCloseShift,
        ),
      );
      return;
    }

    _safeEmit(state.patch(
      cashierName: user?.name ?? 'Cashier',
      branchId: user?.branchId,
      businessName: user?.businessName,
      userId: user?.id,
      businessId: user?.businessId,
      canEditLineTax: session.canEditLineTax,
      isOffline: session.isOffline,
      canOpenShift: session.canOpenShift,
      canCloseShift: session.canCloseShift,
    ));
    _priceChangesSub ??= _priceChanges?.listen(_onPriceChange);
    _stockChangesSub ??=
        _stockChanges?.listen((_) => unawaited(refreshStock()));
    await _refreshPriceContext();
    if (isClosed) return;
    await Future.wait([
      _loadProducts(),
      _loadCategories(),
      _loadTaxData(),
      _loadDiscountSchemes(),
      checkActiveShift(),
      loadHeldOrders(),
    ]);
    await _loadStockBalances();

    if (dineInTableId != null && dineInTableId.isNotEmpty) {
      await initDineInFromRoute(
        tableId: dineInTableId,
        saleId: dineInSaleId,
        tableNumber: dineInTableNumber,
        tableStatus: dineInTableStatus,
      );
    }
  }
}
