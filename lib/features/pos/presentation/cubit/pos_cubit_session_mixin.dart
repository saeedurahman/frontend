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
    final user = await _authLocal.getCachedUser();
    final permissionKeys = user?.permissionKeys ?? const [];
    final canCreate = UserRoleUtils.canCreateSales(
      role: user?.role,
      permissionKeys: permissionKeys,
    );
    final canOpen = UserRoleUtils.canOpenShift(
      role: user?.role,
      permissionKeys: permissionKeys,
    );
    final canClose = UserRoleUtils.canCloseShift(
      role: user?.role,
      permissionKeys: permissionKeys,
    );

    if (!canCreate) {
      if (isClosed) return;
      _safeEmit(
        state.patch(
          accessDenied: true,
          isCheckingShift: false,
          isLoadingProducts: false,
          canOpenShift: canOpen,
          canCloseShift: canClose,
        ),
      );
      return;
    }

    final offline = !await _networkInfo.isConnected;
    if (isClosed) return;
    _safeEmit(state.patch(
      cashierName: user?.name ?? 'Cashier',
      branchId: user?.branchId,
      businessName: user?.businessName,
      isOffline: offline,
      canOpenShift: canOpen,
      canCloseShift: canClose,
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
