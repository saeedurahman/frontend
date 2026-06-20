import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_state.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class PurchaseOrdersListCubit extends Cubit<PurchaseOrdersListState> {
  PurchaseOrdersListCubit({
    required GetPurchaseOrdersUseCase getPurchaseOrdersUseCase,
    required GetSuppliersUseCase getSuppliersUseCase,
  })  : _getOrders = getPurchaseOrdersUseCase,
        _getSuppliers = getSuppliersUseCase,
        super(const PurchaseOrdersListState.initial());

  final GetPurchaseOrdersUseCase _getOrders;
  final GetSuppliersUseCase _getSuppliers;

  String? _statusFilter;
  String? _supplierFilter;

  Future<void> load() async {
    emit(const PurchaseOrdersListState.loading());

    final ordersResult = await _getOrders();
    final suppliersResult = await _getSuppliers();

    ordersResult.fold(
      (failure) => emit(PurchaseOrdersListState.error(failure.message)),
      (orders) {
        suppliersResult.fold(
          (failure) => emit(PurchaseOrdersListState.error(failure.message)),
          (suppliers) => emit(
            PurchaseOrdersListState.loaded(
              allOrders: orders,
              filteredOrders: _filter(orders),
              suppliers: suppliers,
              statusFilter: _statusFilter,
              supplierFilter: _supplierFilter,
            ),
          ),
        );
      },
    );
  }

  List<PurchaseOrderModel> _filter(List<PurchaseOrderModel> orders) {
    return orders.where((order) {
      if (_statusFilter != null && order.status != _statusFilter) {
        return false;
      }
      if (_supplierFilter != null && order.supplierId != _supplierFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  void filterByStatus(String? status) {
    _statusFilter = status;
    final current = state;
    if (current is PurchaseOrdersListLoaded) {
      emit(
        current.copyWith(
          statusFilter: status,
          filteredOrders: _filter(current.allOrders),
        ),
      );
    }
  }

  void filterBySupplier(String? supplierId) {
    _supplierFilter = supplierId;
    final current = state;
    if (current is PurchaseOrdersListLoaded) {
      emit(
        current.copyWith(
          supplierFilter: supplierId,
          filteredOrders: _filter(current.allOrders),
        ),
      );
    }
  }

  Future<void> refresh() => load();
}
