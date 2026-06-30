import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/domain/utils/pos_calculations.dart';
import 'package:frantend/features/pos/domain/utils/pos_sale_totals.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/discount_scheme_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_price_preview_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

part 'pos_session_state.dart';
part 'pos_dine_in_state.dart';
part 'pos_shift_state.dart';
part 'pos_catalog_state.dart';
part 'pos_cart_state.dart';
part 'pos_state_mutators.dart';
part 'pos_state.freezed.dart';

@freezed
class PosState with _$PosState {
  const PosState._();

  const factory PosState({
    @Default(PosSessionState()) PosSessionState session,
    @Default(PosShiftState()) PosShiftState shift,
    @Default(PosCatalogState()) PosCatalogState catalog,
    @Default(PosCartState()) PosCartState cart,
  }) = _PosState;

  // Session
  bool get accessDenied => session.accessDenied;
  bool get canOpenShift => session.canOpenShift;
  bool get canCloseShift => session.canCloseShift;
  String? get cashierName => session.cashierName;
  String? get branchId => session.branchId;
  String? get businessName => session.businessName;
  bool get isOffline => session.isOffline;
  PosDineInContext? get dineIn => session.dineIn;
  bool get isDineIn => session.dineIn != null;

  // Shift
  RegisterShiftModel? get activeShift => shift.activeShift;
  ShiftSummaryModel? get shiftSummary => shift.shiftSummary;
  List<CashRegisterModel> get registers => shift.registers;
  String? get selectedRegisterId => shift.selectedRegisterId;
  bool get isCheckingShift => shift.isCheckingShift;
  bool get isOpeningShift => shift.isOpeningShift;
  bool get isCreatingRegister => shift.isCreatingRegister;
  String? get registersError => shift.registersError;

  // Catalog
  List<ProductListItemModel> get products => catalog.products;
  List<CategoryModel> get categories => catalog.categories;
  String? get selectedCategoryId => catalog.selectedCategoryId;
  String get productSearchQuery => catalog.productSearchQuery;
  bool get isLoadingProducts => catalog.isLoadingProducts;
  String? get productsError => catalog.productsError;
  Map<String, String> get priceCache => catalog.priceCache;
  Map<String, String> get stockCache => catalog.stockCache;
  Map<String, ProductModel> get productDetailsCache =>
      catalog.productDetailsCache;

  // Cart
  List<CartItemModel> get cartItems => cart.cartItems;
  List<TaxRateModel> get taxRates => cart.taxRates;
  TaxRateModel? get defaultTaxRate => cart.defaultTaxRate;
  CustomerModel? get selectedCustomer => cart.selectedCustomer;
  String? get cartDiscountType => cart.cartDiscountType;
  String? get cartDiscountValue => cart.cartDiscountValue;
  String? get cartNote => cart.cartNote;
  List<HeldOrderModel> get heldOrders => cart.heldOrders;
  bool get isHoldingSale => cart.isHoldingSale;
  bool get isSubmittingSale => cart.isSubmittingSale;
  bool get isFiringTab => cart.isFiringTab;
  bool get isRequestingBill => cart.isRequestingBill;
  String? get selectedDiscountSchemeId => cart.selectedDiscountSchemeId;
  List<DiscountSchemeModel> get discountSchemes => cart.discountSchemes;
  SalePricePreviewModel? get pricePreview => cart.pricePreview;
  bool get isLoadingPricePreview => cart.isLoadingPricePreview;
  String? get pricePreviewError => cart.pricePreviewError;

  Decimal get cartDiscountDecimal => cart.cartDiscountDecimal;

  List<ProductListItemModel> get filteredProducts {
    var list = products;
    if (selectedCategoryId != null) {
      list = list.where((p) => p.categoryId == selectedCategoryId).toList();
    }
    if (productSearchQuery.isNotEmpty) {
      final q = productSearchQuery.toLowerCase();
      list = list.where((p) {
        return p.name.toLowerCase().contains(q) ||
            (p.sku?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    return list;
  }

  Decimal get subtotal => cart.subtotal;
  Decimal get totalDiscount => cart.totalDiscount;
  Decimal get totalTax => cart.totalTax;
  Decimal get grandTotal => cart.grandTotal;
  bool get hasActiveScheme => cart.hasActiveScheme;
  bool get canProceedToPayment => cart.canProceedToPayment;
  Decimal get displaySubtotal => cart.displaySubtotal;
  Decimal get displayTotalDiscount => cart.displayTotalDiscount;
  Decimal get displayTotalTax => cart.displayTotalTax;
  Decimal get displayGrandTotal => cart.displayGrandTotal;
  DiscountSchemeModel? get selectedDiscountScheme =>
      cart.selectedDiscountScheme;

  bool get isShiftReady => activeShift != null && !isCheckingShift;
}
