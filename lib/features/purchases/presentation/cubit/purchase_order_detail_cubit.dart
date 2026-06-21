import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_detail_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PurchaseOrderDetailCubit extends Cubit<PurchaseOrderDetailState> {
  PurchaseOrderDetailCubit({
    required GetPurchaseOrderUseCase getPurchaseOrderUseCase,
    required UpdatePurchaseOrderStatusUseCase updatePurchaseOrderStatusUseCase,
  })  : _getOrder = getPurchaseOrderUseCase,
        _updateStatus = updatePurchaseOrderStatusUseCase,
        super(const PurchaseOrderDetailState.initial());

  final GetPurchaseOrderUseCase _getOrder;
  final UpdatePurchaseOrderStatusUseCase _updateStatus;

  Future<void> load(String orderId) async {
    emit(const PurchaseOrderDetailState.loading());

    final result = await _getOrder(orderId);
    result.fold(
      (failure) => emit(PurchaseOrderDetailState.error(failure.message)),
      (order) => emit(PurchaseOrderDetailState.loaded(order: order)),
    );
  }

  Future<String?> updateStatus(String status) async {
    final current = state;
    if (current is! PurchaseOrderDetailLoaded) return 'Not loaded';

    emit(current.copyWith(isUpdating: true));
    final result = await _updateStatus(current.order.id, status);

    return result.fold(
      (failure) {
        emit(current.copyWith(isUpdating: false));
        return failure.message;
      },
      (order) {
        emit(PurchaseOrderDetailState.loaded(order: order));
        return null;
      },
    );
  }

  Future<void> refresh() async {
    final current = state;
    if (current is PurchaseOrderDetailLoaded) {
      await load(current.order.id);
    }
  }
}
