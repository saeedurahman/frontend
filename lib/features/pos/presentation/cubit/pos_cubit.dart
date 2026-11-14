import 'dart:async';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';
import 'package:frantend/features/pos/domain/errors/pos_errors.dart';
import 'package:frantend/features/pos/presentation/models/held_resume_result.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/core/offline/local_catalog.dart' show EffectivePriceList;
import 'package:frantend/core/offline/offline_policy.dart';
import 'package:frantend/core/sync/sync_store.dart' show PriceChange;
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/domain/utils/dine_in_cart_mapper.dart';
import 'package:frantend/features/pos/domain/utils/pos_perf.dart';
import 'package:frantend/features/pos/domain/utils/pos_sale_request_builder.dart';
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
import 'package:frantend/features/restaurant/data/models/restaurant_requests.dart';
import 'package:frantend/features/restaurant/domain/usecases/restaurant_usecases.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/utils/settings_value_utils.dart';
import 'package:injectable/injectable.dart';

part 'pos_cubit_session_mixin.dart';
part 'pos_cubit_shift_mixin.dart';
part 'pos_cubit_catalog_mixin.dart';
part 'pos_cubit_cart_mixin.dart';
part 'pos_cubit_dine_in_mixin.dart';

const _previewDebounceDuration = Duration(milliseconds: 400);

/// Which price list applies to a customer (none = walk-in), read from the
/// local data.
typedef PosPriceListResolver = Future<EffectivePriceList> Function(
    String? customerId);

class PosCubitBase extends Cubit<PosState> {
  PosCubitBase({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
    required GetProductPriceUseCase getProductPriceUseCase,
    required CreateSaleUseCase createSaleUseCase,
    required GetMyActiveShiftUseCase getMyActiveShiftUseCase,
    required OpenShiftUseCase openShiftUseCase,
    required GetShiftSummaryUseCase getShiftSummaryUseCase,
    required GetRegistersUseCase getRegistersUseCase,
    required CreateRegisterUseCase createRegisterUseCase,
    required GetStockBalanceUseCase getStockBalanceUseCase,
    required GetStockBalancesUseCase getStockBalancesUseCase,
    required GetTaxRatesUseCase getTaxRatesUseCase,
    required GetSettingsUseCase getSettingsUseCase,
    required GetDiscountSchemesUseCase getDiscountSchemesUseCase,
    required PreviewSalePriceUseCase previewSalePriceUseCase,
    required OpenTabUseCase openTabUseCase,
    required AddTabLinesUseCase addTabLinesUseCase,
    required FireTabUseCase fireTabUseCase,
    required RequestTabBillUseCase requestTabBillUseCase,
    required CompleteTabUseCase completeTabUseCase,
    required GetTabSaleUseCase getTabSaleUseCase,
    required GetKotOrdersByTableUseCase getKotOrdersByTableUseCase,
    required ResolvePosSessionUseCase resolvePosSession,
    required HeldOrdersUseCases heldOrdersUseCases,
    required ResolveBarcodeUseCase resolveBarcodeUseCase,
    required SaleAttemptTracker saleAttempts,
    required customers_uc.GetCustomerUseCase getCustomerUseCase,
    required customers_uc.GetCustomerBalanceUseCase getCustomerBalanceUseCase,
    OfflinePolicy? offlinePolicy,
    Stream<PriceChange>? priceChanges,
    PosPriceListResolver? resolvePriceList,
    Stream<void>? stockChanges,
    void Function(Iterable<String> productIds)? warmModifiers,
    bool Function()? askQuantityOnTap,
  })  : _offlinePolicy = offlinePolicy,
        _priceChanges = priceChanges,
        _resolvePriceList = resolvePriceList,
        _stockChanges = stockChanges,
        _warmModifiers = warmModifiers,
        _askQuantityOnTap = askQuantityOnTap,
        _getProducts = getProductsUseCase,
        _getCategories = getCategoriesUseCase,
        _getProductById = getProductByIdUseCase,
        _getProductPrice = getProductPriceUseCase,
        _createSale = createSaleUseCase,
        _getMyActiveShift = getMyActiveShiftUseCase,
        _openShift = openShiftUseCase,
        _getShiftSummary = getShiftSummaryUseCase,
        _getRegisters = getRegistersUseCase,
        _createRegister = createRegisterUseCase,
        _getStockBalance = getStockBalanceUseCase,
        _getStockBalances = getStockBalancesUseCase,
        _getTaxRates = getTaxRatesUseCase,
        _getSettings = getSettingsUseCase,
        _getDiscountSchemes = getDiscountSchemesUseCase,
        _previewSalePrice = previewSalePriceUseCase,
        _openTabUseCase = openTabUseCase,
        _addTabLinesUseCase = addTabLinesUseCase,
        _fireTabUseCase = fireTabUseCase,
        _requestBillUseCase = requestTabBillUseCase,
        _completeTabUseCase = completeTabUseCase,
        _getTabSaleUseCase = getTabSaleUseCase,
        _getKotOrdersByTableUseCase = getKotOrdersByTableUseCase,
        _resolvePosSession = resolvePosSession,
        _heldOrders = heldOrdersUseCases,
        _resolveBarcode = resolveBarcodeUseCase,
        _saleAttempts = saleAttempts,
        _getCustomer = getCustomerUseCase,
        _getCustomerBalance = getCustomerBalanceUseCase,
        super(const PosState());

  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;
  final GetProductByIdUseCase _getProductById;
  final GetProductPriceUseCase _getProductPrice;
  final CreateSaleUseCase _createSale;
  final GetMyActiveShiftUseCase _getMyActiveShift;
  final OpenShiftUseCase _openShift;
  final GetShiftSummaryUseCase _getShiftSummary;
  final GetRegistersUseCase _getRegisters;
  final CreateRegisterUseCase _createRegister;
  final GetStockBalanceUseCase _getStockBalance;
  final GetStockBalancesUseCase _getStockBalances;
  final GetTaxRatesUseCase _getTaxRates;
  final GetSettingsUseCase _getSettings;
  final GetDiscountSchemesUseCase _getDiscountSchemes;
  final PreviewSalePriceUseCase _previewSalePrice;
  final OpenTabUseCase _openTabUseCase;
  final AddTabLinesUseCase _addTabLinesUseCase;
  final FireTabUseCase _fireTabUseCase;
  final RequestTabBillUseCase _requestBillUseCase;
  final CompleteTabUseCase _completeTabUseCase;
  final GetTabSaleUseCase _getTabSaleUseCase;
  final GetKotOrdersByTableUseCase _getKotOrdersByTableUseCase;
  final OfflinePolicy? _offlinePolicy;

  /// Fires when prices in the local data changed (a pull, or a price saved on
  /// this device), naming the price list; the cubit re-resolves its prices
  /// only when the change concerns the default list or the list in force.
  final Stream<PriceChange>? _priceChanges;
  StreamSubscription<PriceChange>? _priceChangesSub;
  int _priceRefreshId = 0;

  /// Reads the price list in force for a customer from the local data.
  final PosPriceListResolver? _resolvePriceList;

  /// Price changes of one transaction arrive as separate events; they are
  /// merged and handled once.
  final Set<PriceChange> _pendingPriceChanges = {};
  bool _priceFlushScheduled = false;

  /// Prices typed by hand for an unpriced product (kept across refreshes,
  /// unlike list prices that disappear when the list drops them).
  final Set<String> _manualPriceSlots = {};

  /// Fires when the stock in the local data changed (a sale saved on this
  /// device, a pull, a sync result, a return or a void); the cubit then
  /// re-reads the balances, so the grid and the quantity popup follow
  /// without leaving the screen.
  final Stream<void>? _stockChanges;
  StreamSubscription<void>? _stockChangesSub;
  int _stockRequestId = 0;

  /// Background warm-up of the modifier groups of the products on screen
  /// (restaurant businesses); add-to-cart reads them from the device.
  final void Function(Iterable<String> productIds)? _warmModifiers;

  /// Selling below the known stock is a warning, not a block (offline the
  /// counter must never stop a sale over a number that may be stale). Without
  /// a policy the old strict behavior applies.
  bool _allowBelowStock = false;
  bool get allowBelowStock => _allowBelowStock;

  /// `sales.override_price` of the signed-in user (set by `init`).
  bool _canOverridePrice = false;
  bool get canOverridePrice => _canOverridePrice;

  /// Device preference "Ask quantity on product tap"; read on every tap so a
  /// change in Settings applies at once. On when not wired.
  final bool Function()? _askQuantityOnTap;
  bool get askQuantityOnTap => _askQuantityOnTap?.call() ?? true;

  final ResolvePosSessionUseCase _resolvePosSession;
  final HeldOrdersUseCases _heldOrders;
  final ResolveBarcodeUseCase _resolveBarcode;
  final customers_uc.GetCustomerUseCase _getCustomer;
  final customers_uc.GetCustomerBalanceUseCase _getCustomerBalance;

  /// Keeps the sale id stable across retries of the same cart + payments.
  final SaleAttemptTracker _saleAttempts;

  /// Guards against out-of-order catalog responses.
  int _productsRequestId = 0;
  String _loadedProductsQuery = '';
  String? _loadedProductsCategory;
  bool _stockLoaded = false;

  static const productPageSize = 60;

  Timer? _searchDebounce;
  Timer? _previewDebounce;
  bool skipDineInDelegation = false;

  /// Re-reads the stock shown on the cards and in the quantity popup
  /// (implemented by the catalog mixin).
  Future<void> refreshStock() async {}

  /// Re-resolves the prices on screen (implemented by the catalog mixin).
  Future<void> refreshPrices({List<PriceChange> changes = const []}) async {}

  /// Cache owner of a price: the price list in force, or (when it is not
  /// known yet, e.g. right after the customer changed) the customer.
  static String priceTokenOf(String? listId, String? customerId) =>
      listId ?? 'c:${customerId ?? ''}';

  String get priceToken {
    final context = state.priceContext;
    final customerId = state.selectedCustomer?.id;
    return priceTokenOf(
      context.customerId == customerId ? context.effectiveListId : null,
      customerId,
    );
  }

  /// Key of one price in `priceCache`: (price list, product, variation).
  /// Entries of different lists never share a slot.
  String priceSlot(String productId, String? variationId, {String? token}) =>
      '${token ?? priceToken}|'
      '${variationId != null ? '$productId:$variationId' : productId}';

  void _safeEmit(PosState newState) {
    if (isClosed) return;
    emit(newState);
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    _previewDebounce?.cancel();
    unawaited(_priceChangesSub?.cancel());
    unawaited(_stockChangesSub?.cancel());
    return super.close();
  }
}

@injectable
class PosCubit extends PosCubitBase
    with
        PosCubitShiftMixin,
        PosCubitCartMixin,
        PosCubitDineInMixin,
        PosCubitCatalogMixin,
        PosCubitSessionMixin {
  PosCubit({
    required super.getProductsUseCase,
    required super.getCategoriesUseCase,
    required super.getProductByIdUseCase,
    required super.getProductPriceUseCase,
    required super.createSaleUseCase,
    required super.getMyActiveShiftUseCase,
    required super.openShiftUseCase,
    required super.getShiftSummaryUseCase,
    required super.getRegistersUseCase,
    required super.createRegisterUseCase,
    required super.getStockBalanceUseCase,
    required super.getStockBalancesUseCase,
    required super.getTaxRatesUseCase,
    required super.getSettingsUseCase,
    required super.getDiscountSchemesUseCase,
    required super.previewSalePriceUseCase,
    required super.openTabUseCase,
    required super.addTabLinesUseCase,
    required super.fireTabUseCase,
    required super.requestTabBillUseCase,
    required super.completeTabUseCase,
    required super.getTabSaleUseCase,
    required super.getKotOrdersByTableUseCase,
    required super.resolvePosSession,
    required super.heldOrdersUseCases,
    required super.resolveBarcodeUseCase,
    required super.saleAttempts,
    required super.getCustomerUseCase,
    required super.getCustomerBalanceUseCase,
    super.offlinePolicy,
    super.priceChanges,
    super.resolvePriceList,
    super.stockChanges,
    super.warmModifiers,
    super.askQuantityOnTap,
  });
}
