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

    final allowedBranches = user?.branchIds ?? const [];
    String? effectiveBranchId;
    if (sl.isRegistered<BranchSelectorCubit>()) {
      final selected = sl<BranchSelectorCubit>().state.selectedBranchId;
      if (selected != null &&
          (allowedBranches.isEmpty || allowedBranches.contains(selected))) {
        effectiveBranchId = selected;
      }
    }
    effectiveBranchId ??= user?.branchId;
    if (allowedBranches.isNotEmpty) {
      if (effectiveBranchId == null || !allowedBranches.contains(effectiveBranchId)) {
        effectiveBranchId = allowedBranches.first;
      }
    }

    _safeEmit(state.patch(
      cashierName: user?.name ?? 'Cashier',
      branchId: effectiveBranchId,
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
    _taxSettingsSub ??= _taxSettingsChanges?.listen(_onTaxSettingsChanged);
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

  /// Switches the POS branch if allowed. Never allows a branch-limited user
  /// to switch to an unassigned / foreign branch.
  Future<bool> switchBranch(String newBranchId) async {
    final session = await _resolvePosSession();
    final allowedBranches = session.user?.branchIds ?? const [];
    if (allowedBranches.isNotEmpty && !allowedBranches.contains(newBranchId)) {
      return false;
    }
    _safeEmit(state.patch(branchId: newBranchId));
    await checkActiveShift();
    await _loadStockBalances();
    return true;
  }
}
