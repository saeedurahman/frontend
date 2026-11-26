import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_detail_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PurchaseOrderDetailCubit extends Cubit<PurchaseOrderDetailState>
    with AutoRefresh<PurchaseOrderDetailState> {
  PurchaseOrderDetailCubit({
    required GetPurchaseOrderUseCase getPurchaseOrderUseCase,
    required UpdatePurchaseOrderStatusUseCase updatePurchaseOrderStatusUseCase,
  })  : _getOrder = getPurchaseOrderUseCase,
        _updateStatus = updatePurchaseOrderStatusUseCase,
        super(const PurchaseOrderDetailState.initial()) {
    watchData(const {DataTopic.purchases}, _reload);
  }

  final GetPurchaseOrderUseCase _getOrder;
  final UpdatePurchaseOrderStatusUseCase _updateStatus;

  String? _orderId;

  /// A quiet re-read after goods were received or the status changed.
  Future<void> _reload() async {
    final id = _orderId;
    final current = state;
    if (id == null) return;
    if (current is! PurchaseOrderDetailLoaded) return load(id);
    if (current.isUpdating) return;
    final read = beginRead();
    final result = await _getOrder(id);
    if (isStale(read)) return;
    result.fold(
      (_) {},
      (order) => emit(PurchaseOrderDetailState.loaded(order: order)),
    );
  }

  Future<void> load(String orderId) async {
    _orderId = orderId;
    final read = beginRead();
    emit(const PurchaseOrderDetailState.loading());

    final result = await _getOrder(orderId);
    if (isStale(read)) return;
    result.fold(
      (failure) => emit(PurchaseOrderDetailState.error(failure.message)),
      (order) => emit(PurchaseOrderDetailState.loaded(order: order)),
    );
  }

  Future<String?> updateStatus(String status) async {
    final current = state;
    if (current is! PurchaseOrderDetailLoaded) return 'Not loaded';

    beginRead(); // an older read must not undo this change
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
    if (state is PurchaseOrderDetailLoaded) await _reload();
  }
}
