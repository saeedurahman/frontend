import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/domain/utils/pos_calculations.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

part 'pos_state.freezed.dart';

@freezed
class PosState with _$PosState {
  const PosState._();

  const factory PosState({
    RegisterShiftModel? activeShift,
    ShiftSummaryModel? shiftSummary,
    @Default([]) List<CashRegisterModel> registers,
    String? selectedRegisterId,
    @Default(true) bool isCheckingShift,
    @Default(false) bool isOpeningShift,
    @Default(false) bool isCreatingRegister,
    String? registersError,
    @Default([]) List<ProductListItemModel> products,
    @Default([]) List<CategoryModel> categories,
    String? selectedCategoryId,
    @Default('') String productSearchQuery,
    @Default(true) bool isLoadingProducts,
    String? productsError,
    @Default([]) List<CartItemModel> cartItems,
    @Default([]) List<TaxRateModel> taxRates,
    TaxRateModel? defaultTaxRate,
    CustomerModel? selectedCustomer,
    String? cartDiscountType,
    String? cartDiscountValue,
    String? cartNote,
    @Default({}) Map<String, String> priceCache,
    @Default({}) Map<String, String> stockCache,
    @Default({}) Map<String, ProductModel> productDetailsCache,
    @Default(false) bool isSubmittingSale,
    @Default(false) bool isOffline,
    String? cashierName,
    String? branchId,
    String? businessName,
  }) = _PosState;

  Decimal get cartDiscountDecimal =>
      Decimal.tryParse(cartDiscountValue ?? '') ?? Decimal.zero;

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

  Decimal get subtotal => PosCalculations.sumSubtotal(cartItems);

  Decimal get totalItemDiscounts => PosCalculations.sumItemDiscounts(cartItems);

  Decimal get totalCartDiscount => PosCalculations.computeCartDiscountAmount(
        items: cartItems,
        cartDiscountType: cartDiscountType,
        cartDiscountValue: cartDiscountDecimal,
      );

  Decimal get totalDiscount => totalItemDiscounts + totalCartDiscount;

  Decimal get totalTax => PosCalculations.sumTax(cartItems);

  Decimal get grandTotal => PosCalculations.grandTotal(
        cartItems,
        cartDiscount: totalCartDiscount,
      );

  bool get isShiftReady => activeShift != null && !isCheckingShift;
}
