import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';
import 'package:frantend/features/manufacturing/domain/usecases/manufacturing_usecases.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/production_orders_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductionOrdersListCubit extends Cubit<ProductionOrdersListState> {
  ProductionOrdersListCubit({
    required ListProductionOrdersUseCase listProductionOrdersUseCase,
    required AuthLocalDataSource authLocalDataSource,
    required BranchSelectorCubit branchSelectorCubit,
  })  : _listOrders = listProductionOrdersUseCase,
        _authLocal = authLocalDataSource,
        _branchSelector = branchSelectorCubit,
        super(const ProductionOrdersListState.initial());

  final ListProductionOrdersUseCase _listOrders;
  final AuthLocalDataSource _authLocal;
  final BranchSelectorCubit _branchSelector;

  String? _statusFilter;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewProduction(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const ProductionOrdersListState.accessDenied());
      return;
    }
    await load();
  }

  Future<void> load() async {
    emit(const ProductionOrdersListState.loading());

    final user = await _authLocal.getCachedUser();
    final canCreate = UserRoleUtils.canCreateProduction(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );

    final branchId = _branchSelector.state.selectedBranchId;
    final branchNames = {
      for (final b in _branchSelector.state.availableBranches) b.id: b.name,
    };

    final result = await _listOrders(branchId: branchId);
    result.fold(
      (failure) => emit(ProductionOrdersListState.error(failure.message)),
      (orders) => emit(
        ProductionOrdersListState.loaded(
          allOrders: orders,
          filteredOrders: _filter(orders),
          statusFilter: _statusFilter,
          dateFrom: _dateFrom,
          dateTo: _dateTo,
          canCreate: canCreate,
          branchNames: branchNames,
        ),
      ),
    );
  }

  List<ProductionOrderModel> _filter(List<ProductionOrderModel> orders) {
    return orders.where((order) {
      if (_statusFilter != null && order.status != _statusFilter) {
        return false;
      }
      if (_dateFrom != null || _dateTo != null) {
        final created = DateTime.tryParse(order.createdAt)?.toLocal();
        if (created == null) return true;
        if (_dateFrom != null) {
          final from = DateTime(
            _dateFrom!.year,
            _dateFrom!.month,
            _dateFrom!.day,
          );
          if (created.isBefore(from)) return false;
        }
        if (_dateTo != null) {
          final to = DateTime(
            _dateTo!.year,
            _dateTo!.month,
            _dateTo!.day,
            23,
            59,
            59,
          );
          if (created.isAfter(to)) return false;
        }
      }
      return true;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void filterByStatus(String? status) {
    _statusFilter = status;
    final current = state;
    if (current is ProductionOrdersListLoaded) {
      emit(
        current.copyWith(
          statusFilter: status,
          filteredOrders: _filter(current.allOrders),
        ),
      );
    }
  }

  void setDateRange({DateTime? from, DateTime? to}) {
    _dateFrom = from;
    _dateTo = to;
    final current = state;
    if (current is ProductionOrdersListLoaded) {
      emit(
        current.copyWith(
          dateFrom: from,
          dateTo: to,
          filteredOrders: _filter(current.allOrders),
        ),
      );
    }
  }

  Future<void> refresh() => load();
}
