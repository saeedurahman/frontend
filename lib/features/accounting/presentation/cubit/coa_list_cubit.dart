import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/usecases/accounting_usecases.dart';
import 'package:frantend/features/accounting/domain/utils/coa_tree_utils.dart';
import 'package:frantend/features/accounting/presentation/cubit/coa_list_state.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class CoaListCubit extends Cubit<CoaListState> {
  CoaListCubit({
    required ListChartOfAccountsUseCase listChartOfAccountsUseCase,
    required DeleteChartOfAccountUseCase deleteChartOfAccountUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _listCoa = listChartOfAccountsUseCase,
        _deleteCoa = deleteChartOfAccountUseCase,
        _authLocal = authLocalDataSource,
        super(const CoaListState.initial());

  final ListChartOfAccountsUseCase _listCoa;
  final DeleteChartOfAccountUseCase _deleteCoa;
  final AuthLocalDataSource _authLocal;

  bool _activeOnlyFilter = false;
  String _searchQuery = '';

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewCoa(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const CoaListState.accessDenied());
      return;
    }
    await load();
  }

  Future<void> load() async {
    emit(const CoaListState.loading());

    final user = await _authLocal.getCachedUser();
    final canManage = UserRoleUtils.canManageCoa(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );

    final result = await _listCoa(
      activeOnly: _activeOnlyFilter,
      tree: true,
    );
    result.fold(
      (failure) => emit(CoaListState.error(failure.message)),
      (roots) => emit(
        CoaListState.loaded(
          treeRoots: roots,
          filteredNodes: _filter(roots),
          activeOnlyFilter: _activeOnlyFilter,
          searchQuery: _searchQuery,
          canManage: canManage,
        ),
      ),
    );
  }

  List<FlatCoaNode> _filter(List<ChartOfAccountModel> roots) {
    final query = _searchQuery.trim().toLowerCase();
    final flat = flattenCoaTree(roots);
    if (query.isEmpty) return flat;

    return flat.where((node) {
      final account = node.account;
      return account.accountCode.toLowerCase().contains(query) ||
          account.accountName.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> setActiveOnlyFilter(bool value) async {
    _activeOnlyFilter = value;
    await load();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    final current = state;
    if (current is CoaListLoaded) {
      emit(
        current.copyWith(
          searchQuery: value,
          filteredNodes: _filter(current.treeRoots),
        ),
      );
    }
  }

  Future<String?> deleteAccount(String id) async {
    final result = await _deleteCoa(id);
    return result.fold(
      (failure) => failure.message,
      (_) {
        load();
        return null;
      },
    );
  }

  Future<void> refresh() => load();
}
