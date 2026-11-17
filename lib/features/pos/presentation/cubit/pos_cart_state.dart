part of 'pos_state.dart';

@freezed
abstract class PosCartState with _$PosCartState {
  const PosCartState._();

  const factory PosCartState({
    @Default([]) List<CartItemModel> cartItems,
    @Default([]) List<TaxRateModel> taxRates,
    TaxRateModel? defaultTaxRate,
    CustomerModel? selectedCustomer,
    String? cartDiscountType,
    String? cartDiscountValue,
    String? cartNote,
    @Default([]) List<HeldOrderModel> heldOrders,
    @Default(false) bool isHoldingSale,
    @Default(false) bool isSubmittingSale,
    @Default(false) bool isFiringTab,
    @Default(false) bool isRequestingBill,
    String? selectedDiscountSchemeId,
    @Default([]) List<DiscountSchemeModel> discountSchemes,
    SalePricePreviewModel? pricePreview,
    @Default(false) bool isLoadingPricePreview,
    String? pricePreviewError,

    /// Bumped when the business's tax or price settings change, so every
    /// widget showing prices rebuilds at once.
    @Default(0) int taxRevision,
  }) = _PosCartState;

  Decimal get cartDiscountDecimal =>
      Decimal.tryParse(cartDiscountValue ?? '') ?? Decimal.zero;

  bool get hasActiveScheme => selectedDiscountSchemeId != null;

  DiscountSchemeModel? get selectedDiscountScheme {
    if (selectedDiscountSchemeId == null) return null;
    for (final scheme in discountSchemes) {
      if (scheme.id == selectedDiscountSchemeId) return scheme;
    }
    return null;
  }

  PosSaleTotals get authoritativeTotals =>
      PosCalculations.computeAuthoritativeTotals(
        items: cartItems,
        cartDiscountType: cartDiscountType,
        cartDiscountValue: cartDiscountDecimal,
      );

  Decimal get subtotal => authoritativeTotals.subtotal;

  Decimal get totalDiscount => authoritativeTotals.totalDiscount;

  Decimal get totalTax => authoritativeTotals.totalTax;

  Decimal get grandTotal => authoritativeTotals.totalAmount;

  bool get canProceedToPayment =>
      cartItems.isNotEmpty &&
      (!hasActiveScheme ||
          (!isLoadingPricePreview &&
              pricePreview != null &&
              pricePreviewError == null));

  Decimal get displaySubtotal => hasActiveScheme && pricePreview != null
      ? pricePreview!.subtotalDecimal
      : subtotal;

  Decimal get displayTotalDiscount => hasActiveScheme && pricePreview != null
      ? pricePreview!.totalDiscountDecimal
      : totalDiscount;

  Decimal get displayTotalTax =>
      hasActiveScheme && pricePreview != null ? pricePreview!.totalTaxDecimal : totalTax;

  Decimal get displayGrandTotal => hasActiveScheme && pricePreview != null
      ? pricePreview!.totalAmountDecimal
      : grandTotal;

  /// Signed rounding of the grand total ("Rounding -0.04"); zero when off.
  Decimal get displayRounding => hasActiveScheme && pricePreview != null
      ? pricePreview!.roundingAmountDecimal
      : authoritativeTotals.roundingAmount;

  /// Tax of the cart by rate for the summary lines.
  List<TaxGroup> get displayTaxGroups {
    final tax = TaxSettingsHolder.current;
    final preview = pricePreview;
    if (hasActiveScheme && preview != null) {
      return TaxGroup.group([
        for (final l in preview.lines)
          (
            rate: Decimal.tryParse(l.taxRate) ?? Decimal.zero,
            net: Decimal.tryParse(l.netAmount ?? '') ?? Decimal.zero,
            tax: Decimal.tryParse(l.taxAmount) ?? Decimal.zero,
          ),
      ], label: tax.label);
    }
    return PosCalculations.computeTaxGroups(
      items: cartItems,
      cartDiscountType: cartDiscountType,
      cartDiscountValue: cartDiscountDecimal,
    );
  }
}
