import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/sales/domain/usecases/sales_usecases.dart';
import 'package:frantend/features/sales/presentation/cubit/sale_detail_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaleDetailCubit extends Cubit<SaleDetailState> {
  SaleDetailCubit({
    required GetSaleByIdUseCase getSaleByIdUseCase,
    required CancelSaleUseCase cancelSaleUseCase,
    required GetCustomerUseCase getCustomerUseCase,
  })  : _getSale = getSaleByIdUseCase,
        _cancelSale = cancelSaleUseCase,
        _getCustomer = getCustomerUseCase,
        super(const SaleDetailState.initial());

  final GetSaleByIdUseCase _getSale;
  final CancelSaleUseCase _cancelSale;
  final GetCustomerUseCase _getCustomer;

  Future<void> load(String saleId) async {
    emit(const SaleDetailState.loading());

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
        emit(SaleDetailState.loaded(sale: sale, customer: customer));
      },
    );
  }

  Future<bool> cancelSale() async {
    final current = state;
    if (current is! SaleDetailLoaded) return false;

    emit(current.copyWith(isCancelling: true));

    final result = await _cancelSale(current.sale.id);
    return result.fold(
      (failure) {
        emit(current.copyWith(isCancelling: false));
        emit(SaleDetailState.error(failure.message));
        return false;
      },
      (sale) {
        emit(SaleDetailState.loaded(
          sale: sale,
          customer: current.customer,
        ));
        return true;
      },
    );
  }
}
