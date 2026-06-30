import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/database/daos/held_orders_dao.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/core/utils/uuid_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/cart_line_modifier_model.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/domain/utils/dine_in_cart_mapper.dart';
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

class PosCubitBase extends Cubit<PosState> {
  PosCubitBase({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
    required LookupBarcodeUseCase lookupBarcodeUseCase,
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
    required AuthLocalDataSource authLocalDataSource,
    required NetworkInfo networkInfo,
    required HeldOrdersDao heldOrdersDao,
  })  : _getProducts = getProductsUseCase,
        _getCategories = getCategoriesUseCase,
        _getProductById = getProductByIdUseCase,
        _lookupBarcode = lookupBarcodeUseCase,
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
        _authLocal = authLocalDataSource,
        _networkInfo = networkInfo,
        _heldOrdersDao = heldOrdersDao,
        super(const PosState());

  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;
  final GetProductByIdUseCase _getProductById;
  final LookupBarcodeUseCase _lookupBarcode;
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
  final AuthLocalDataSource _authLocal;
  final NetworkInfo _networkInfo;
  final HeldOrdersDao _heldOrdersDao;

  Timer? _searchDebounce;
  Timer? _previewDebounce;
  bool skipDineInDelegation = false;

  void _safeEmit(PosState newState) {
    if (isClosed) return;
    emit(newState);
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    _previewDebounce?.cancel();
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
    required super.lookupBarcodeUseCase,
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
    required super.authLocalDataSource,
    required super.networkInfo,
    required super.heldOrdersDao,
  });
}
