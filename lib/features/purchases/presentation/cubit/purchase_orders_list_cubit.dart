import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_state.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class PurchaseOrdersListCubit extends Cubit<PurchaseOrdersListState>
    with AutoRefresh<PurchaseOrdersListState> {
  PurchaseOrdersListCubit({
    required GetPurchaseOrdersUseCase getPurchaseOrdersUseCase,
    required GetSuppliersUseCase getSuppliersUseCase,
  })  : _getOrders = getPurchaseOrdersUseCase,
        _getSuppliers = getSuppliersUseCase,
        super(const PurchaseOrdersListState.initial()) {
    watchData(const {DataTopic.purchases, DataTopic.suppliers}, _reload);
  }

  final GetPurchaseOrdersUseCase _getOrders;
  final GetSuppliersUseCase _getSuppliers;

  String? _statusFilter;
  String? _supplierFilter;

  Future<void> load() => _read(quiet: false);

  /// [quiet]: no spinner, and the orders on screen stay when the read fails.
  Future<void> _read({required bool quiet}) async {
    final read = beginRead();
    if (!quiet) emit(const PurchaseOrdersListState.loading());

    final ordersResult = await _getOrders();
    final suppliersResult = await _getSuppliers();
    if (isStale(read)) return;

    void fail(String message) {
      if (!quiet) emit(PurchaseOrdersListState.error(message));
    }

    ordersResult.fold(
      (failure) => fail(failure.message),
      (orders) {
        suppliersResult.fold(
          (failure) => fail(failure.message),
          (suppliers) {
            final all = newestFirst(orders, (o) => o.id);
            emit(
              PurchaseOrdersListState.loaded(
                allOrders: all,
                filteredOrders: _filter(all),
                suppliers: suppliers,
                statusFilter: _statusFilter,
                supplierFilter: _supplierFilter,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _reload() async {
    final current = state;
    if (current is PurchaseOrdersListInitial) return;
    await _read(quiet: current is PurchaseOrdersListLoaded);
  }

  /// The id of the new order on top of the list, if any.
  String? get newestCreatedId {
    final current = state;
    if (current is! PurchaseOrdersListLoaded) return null;
    return createdOnTop(current.filteredOrders, (o) => o.id);
  }

  List<PurchaseOrderModel> _filter(List<PurchaseOrderModel> orders) {
    return orders.where((order) {
      // A new order is shown whatever the filters say, until they change.
      if (isNewlyCreated(order.id)) return true;
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
    forgetCreated();
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
    forgetCreated();
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

  Future<void> refresh() => _read(quiet: state is PurchaseOrdersListLoaded);
}
