part of 'pos_cubit.dart';

mixin PosCubitDineInMixin on PosCubitBase, PosCubitCartMixin {
  bool get isDineIn => state.dineIn != null;

  DineInTabStatus _tabStatusFromTable(String? tableStatus) {
    if (tableStatus == 'billing') {
      return DineInTabStatus.billRequested;
    }
    return DineInTabStatus.open;
  }

  Future<void> initDineInFromRoute({
    required String tableId,
    String? saleId,
    String? tableNumber,
    String? tableStatus,
  }) async {
    final branchId = state.branchId;
    if (branchId == null) return;

    _safeEmit(state.patch(
      dineIn: PosDineInContext(
        saleId: saleId ?? '',
        tableId: tableId,
        tableLabel: tableNumber ?? 'Table',
        tabStatus: _tabStatusFromTable(tableStatus),
      ),
    ));

    try {
      var resolvedSaleId = saleId;
      if (resolvedSaleId == null || resolvedSaleId.isEmpty) {
        if (tableStatus == 'available') {
          resolvedSaleId = await _openNewTab(
            branchId: branchId,
            tableId: tableId,
          );
        } else {
          resolvedSaleId = await _resolveActiveSaleId(tableId);
        }
      }

      if (resolvedSaleId == null || resolvedSaleId.isEmpty) {
        throw Exception('Could not find an open tab for this table');
      }

      final saleResult = await _getTabSaleUseCase(resolvedSaleId);
      if (isClosed) return;

      await saleResult.fold(
        (failure) async {
          throw Exception(failure.message);
        },
        (sale) async {
          _safeEmit(state.patch(
            dineIn: PosDineInContext(
              saleId: sale.id,
              tableId: tableId,
              tableLabel: tableNumber ?? 'Table ${sale.tableId ?? tableId}',
              tabStatus: _tabStatusFromTable(tableStatus),
            ),
            cartItems: DineInCartMapper.cartItemsFromSale(sale),
            selectedCustomer: sale.customer,
          ));
          _schedulePricePreview();
        },
      );
    } catch (e) {
      _safeEmit(state.patch(
        dineIn: state.dineIn?.copyWith(
          syncError: e.toString().replaceFirst('Exception: ', ''),
        ),
      ));
    }
  }

  Future<String?> _openNewTab({
    required String branchId,
    required String tableId,
  }) async {
    final result = await _openTabUseCase(
      OpenTabRequest(
        branchId: branchId,
        tableId: tableId,
        registerShiftId: state.activeShift?.id,
      ),
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (sale) => sale.id,
    );
  }

  Future<String?> _resolveActiveSaleId(String tableId) async {
    final kotResult = await _getKotOrdersByTableUseCase(tableId);
    return kotResult.fold(
      (_) => null,
      (orders) {
        for (final order in orders) {
          if (order.saleId != null && order.saleId!.isNotEmpty) {
            return order.saleId;
          }
        }
        return null;
      },
    );
  }

  Future<AddToCartOutcome> addToCartDineIn(
    ProductListItemModel product, {
    String? variationId,
    Decimal? manualUnitPrice,
    List<CartLineModifierModel> modifiers = const [],
  }) async {
    final dineIn = state.dineIn;
    if (dineIn == null) {
      return AddToCartOutcome.added;
    }

    final previousItems = List<CartItemModel>.from(state.cartItems);
    skipDineInDelegation = true;
    try {
      final outcome = await addToCart(
        product,
        variationId: variationId,
        manualUnitPrice: manualUnitPrice,
        modifiers: modifiers,
      );

      if (outcome.result != AddToCartResult.added) {
        return outcome;
      }

      final syncedItem = _findChangedCartItem(previousItems, state.cartItems);
      if (syncedItem == null) {
        return AddToCartOutcome.added;
      }

      final previous = previousItems
          .where((item) => item.cartKey == syncedItem.cartKey)
          .toList();
      final syncQty = previous.isEmpty
          ? Decimal.one
          : syncedItem.qty - previous.first.qty;

      final syncError = await _syncLineToTab(syncedItem, syncQty: syncQty);
      if (syncError != null) {
        _safeEmit(state.patch(cartItems: previousItems));
        return AddToCartOutcome(
          result: AddToCartResult.syncFailed,
          message: syncError,
        );
      }

      return AddToCartOutcome.added;
    } finally {
      skipDineInDelegation = false;
    }
  }

  CartItemModel? _findChangedCartItem(
    List<CartItemModel> before,
    List<CartItemModel> after,
  ) {
    if (after.length > before.length) {
      return after.last;
    }

    for (final item in after) {
      final previous = before.where((b) => b.cartKey == item.cartKey).toList();
      if (previous.isEmpty || previous.first.qty != item.qty) {
        return item;
      }
    }
    return null;
  }

  Future<String?> _syncLineToTab(
    CartItemModel item, {
    required Decimal syncQty,
  }) async {
    final dineIn = state.dineIn;
    if (dineIn == null) return null;

    _safeEmit(state.patch(
      dineIn: dineIn.copyWith(isSyncingLine: true, syncError: null),
    ));

    final request = AddTabLinesRequest(
      lines: [
        DineInCartMapper.toTabLineRequest(
          item,
          lineOrder: state.cartItems.length,
          syncQty: syncQty,
        ),
      ],
    );

    final result = await _addTabLinesUseCase(dineIn.saleId, request);
    if (isClosed) return 'Sync cancelled';

    return result.fold(
      (failure) {
        _safeEmit(state.patch(
          dineIn: state.dineIn?.copyWith(
            isSyncingLine: false,
            syncError: failure.message,
          ),
        ));
        return failure.message;
      },
      (sale) {
        final serverLineId = _matchServerLineId(sale, item);
        if (serverLineId != null) {
          final items = state.cartItems.map((cartItem) {
            if (cartItem.cartKey == item.cartKey) {
              return cartItem.copyWith(serverLineId: serverLineId);
            }
            return cartItem;
          }).toList();
          _safeEmit(state.patch(
            cartItems: items,
            dineIn: state.dineIn?.copyWith(
              isSyncingLine: false,
              syncError: null,
            ),
          ));
        } else {
          _safeEmit(state.patch(
            dineIn: state.dineIn?.copyWith(isSyncingLine: false),
          ));
        }
        return null;
      },
    );
  }

  String? _matchServerLineId(SaleResponseModel sale, CartItemModel item) {
    for (final line in sale.lines.reversed) {
      if (line.productId != item.productId) continue;
      if (line.variationId != item.variationId) continue;
      return line.id;
    }
    if (sale.lines.isNotEmpty) {
      return sale.lines.last.id;
    }
    return null;
  }

  Future<void> fireCurrentTab() async {
    final dineIn = state.dineIn;
    if (dineIn == null || state.cartItems.isEmpty) return;

    _safeEmit(state.patch(isFiringTab: true));
    try {
      final result = await _fireTabUseCase(dineIn.saleId);
      if (isClosed) return;

      result.fold(
        (failure) => _safeEmit(state.patch(
          dineIn: state.dineIn?.copyWith(syncError: failure.message),
        )),
        (_) => _safeEmit(state.patch(
          dineIn: state.dineIn?.copyWith(
            tabStatus: DineInTabStatus.fired,
            syncError: null,
          ),
        )),
      );
    } finally {
      if (!isClosed) {
        _safeEmit(state.patch(isFiringTab: false));
      }
    }
  }

  Future<void> requestBillForCurrentTab() async {
    final dineIn = state.dineIn;
    if (dineIn == null) return;

    _safeEmit(state.patch(isRequestingBill: true));
    try {
      final result = await _requestBillUseCase(dineIn.saleId);
      if (isClosed) return;

      result.fold(
        (failure) => _safeEmit(state.patch(
          dineIn: state.dineIn?.copyWith(syncError: failure.message),
        )),
        (_) => _safeEmit(state.patch(
          dineIn: state.dineIn?.copyWith(
            tabStatus: DineInTabStatus.billRequested,
            syncError: null,
          ),
        )),
      );
    } finally {
      if (!isClosed) {
        _safeEmit(state.patch(isRequestingBill: false));
      }
    }
  }

  Future<SaleResponseModel> completeDineInTab(
    List<PaymentLineModel> payments,
  ) async {
    final dineIn = state.dineIn;
    if (dineIn == null) {
      throw Exception('Not in dine-in mode');
    }
    if (state.cartItems.isEmpty) {
      throw Exception('Cart is empty');
    }

    _safeEmit(state.patch(isSubmittingSale: true));
    try {
      final request = CompleteTabRequest(
        registerShiftId: state.activeShift?.id,
        payments: payments
            .map((p) => {
                  'payment_method': p.paymentMethod,
                  'amount': DecimalUtils.format(p.amount),
                  if (p.referenceNo != null && p.referenceNo!.isNotEmpty)
                    'reference_no': p.referenceNo,
                })
            .toList(),
      );

      final result = await _completeTabUseCase(dineIn.saleId, request);
      if (isClosed) {
        throw Exception('Tab completion cancelled');
      }

      return result.fold(
        (failure) => throw Exception(failure.message),
        (sale) {
          clearCart();
          _safeEmit(state.patch(
            isSubmittingSale: false,
            dineIn: null,
          ));
          refreshShiftSummary();
          return sale;
        },
      );
    } catch (e) {
      _safeEmit(state.patch(isSubmittingSale: false));
      rethrow;
    }
  }

  void exitDineIn() {
    clearCart();
    _safeEmit(state.patch(dineIn: null));
  }
}
