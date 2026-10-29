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
    final session = await _resolvePosSession();
    if (isClosed) return;
    final user = session.user;

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
