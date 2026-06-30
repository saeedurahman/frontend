import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/domain/usecases/sales_usecases.dart';
import 'package:frantend/features/sales/presentation/cubit/sale_detail_state.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:frantend/features/sales/presentation/utils/sale_product_enrichment.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaleDetailCubit extends Cubit<SaleDetailState> {
  SaleDetailCubit({
    required GetSaleByIdUseCase getSaleByIdUseCase,
    required CancelSaleUseCase cancelSaleUseCase,
    required VoidSaleUseCase voidSaleUseCase,
    required GetCustomerUseCase getCustomerUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
    required GetRegisterShiftByIdUseCase getRegisterShiftByIdUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getSale = getSaleByIdUseCase,
        _cancelSale = cancelSaleUseCase,
        _voidSale = voidSaleUseCase,
        _getCustomer = getCustomerUseCase,
        _getProductById = getProductByIdUseCase,
        _getRegisterShift = getRegisterShiftByIdUseCase,
        _authLocal = authLocalDataSource,
        super(const SaleDetailState.initial());

  final GetSaleByIdUseCase _getSale;
  final CancelSaleUseCase _cancelSale;
  final VoidSaleUseCase _voidSale;
  final GetCustomerUseCase _getCustomer;
  final GetProductByIdUseCase _getProductById;
  final GetRegisterShiftByIdUseCase _getRegisterShift;
  final AuthLocalDataSource _authLocal;

  Future<void> load(String saleId) async {
    emit(const SaleDetailState.loading());

    final user = await _authLocal.getCachedUser();
    final permissionKeys = user?.permissionKeys ?? const [];
    final canCancelSales = UserRoleUtils.canCancelSales(
      role: user?.role,
      permissionKeys: permissionKeys,
    );
    final canCreateReturn = UserRoleUtils.canCreateReturns(
      role: user?.role,
      permissionKeys: permissionKeys,
    );

    final result = await _getSale(saleId);
    await result.fold(
      (failure) async => emit(SaleDetailState.error(failure.message)),
      (sale) async {
        var customer = sale.customer;
        final customerId = sale.customerId;
        if (customer == null && customerId != null) {
          final customerResult = await _getCustomer(customerId);
          customerResult.fold((_) {}, (c) => customer = c);
        }
        final enrichedSale = await SaleProductEnrichment.enrichSale(
          sale,
          _getProductById.call,
        );

        final registerShiftOpen = canCancelSales
            ? await _resolveRegisterShiftOpen(enrichedSale)
            : null;

        emit(
          SaleDetailState.loaded(
            sale: enrichedSale,
            customer: customer,
            registerShiftOpen: registerShiftOpen,
            canCancelSales: canCancelSales,
            canCreateReturn: canCreateReturn,
          ),
        );
      },
    );
  }

  Future<bool?> _resolveRegisterShiftOpen(
    SaleResponseModel sale,
  ) async {
    if (!SaleStatus.isVoidCandidate(sale)) return null;

    final shiftId = sale.registerShiftId;
    if (shiftId == null || shiftId.trim().isEmpty) return null;

    final shiftResult = await _getRegisterShift(shiftId);
    return shiftResult.fold(
      (_) => null,
      (shift) => shift.status == 'open',
    );
  }

  Future<bool> cancelSale() async {
    final current = state;
    if (current is! SaleDetailLoaded || !current.canCancelSales) return false;

    emit(current.copyWith(isCancelling: true));

    final result = await _cancelSale(current.sale.id);
    return result.fold(
      (failure) {
        emit(current.copyWith(isCancelling: false));
        emit(SaleDetailState.error(failure.message));
        return false;
      },
      (sale) {
        emit(
          SaleDetailState.loaded(
            sale: sale,
            customer: current.customer,
            registerShiftOpen: false,
            canCancelSales: current.canCancelSales,
            canCreateReturn: current.canCreateReturn,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> voidSale() async {
    final current = state;
    if (current is! SaleDetailLoaded || !current.canVoid) return false;

    emit(current.copyWith(isVoiding: true));

    final result = await _voidSale(current.sale.id);
    return result.fold(
      (failure) {
        emit(current.copyWith(isVoiding: false));
        emit(SaleDetailState.error(failure.message));
        return false;
      },
      (sale) async {
        emit(
          SaleDetailState.loaded(
            sale: sale,
            customer: current.customer,
            registerShiftOpen: false,
            canCancelSales: current.canCancelSales,
            canCreateReturn: current.canCreateReturn,
          ),
        );
        return true;
      },
    );
  }
}
