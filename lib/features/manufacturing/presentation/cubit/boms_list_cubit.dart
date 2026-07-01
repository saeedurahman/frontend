import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';
import 'package:frantend/features/manufacturing/domain/usecases/manufacturing_usecases.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/boms_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class BomsListCubit extends Cubit<BomsListState> {
  BomsListCubit({
    required ListBomsUseCase listBomsUseCase,
    required DeleteBomUseCase deleteBomUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _listBoms = listBomsUseCase,
        _deleteBom = deleteBomUseCase,
        _authLocal = authLocalDataSource,
        super(const BomsListState.initial());

  final ListBomsUseCase _listBoms;
  final DeleteBomUseCase _deleteBom;
  final AuthLocalDataSource _authLocal;

  bool _activeOnlyFilter = false;
  String _searchQuery = '';

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewBom(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const BomsListState.accessDenied());
      return;
    }
    await load();
  }

  Future<void> load() async {
    emit(const BomsListState.loading());

    final user = await _authLocal.getCachedUser();
    final canManage = UserRoleUtils.canManageBom(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );

    final result = await _listBoms();
    result.fold(
      (failure) => emit(BomsListState.error(failure.message)),
      (boms) => emit(
        BomsListState.loaded(
          allBoms: boms,
          filteredBoms: _filter(boms),
          activeOnlyFilter: _activeOnlyFilter,
          searchQuery: _searchQuery,
          canManage: canManage,
        ),
      ),
    );
  }

  List<BomHeaderModel> _filter(List<BomHeaderModel> boms) {
    final query = _searchQuery.trim().toLowerCase();
    return boms.where((bom) {
      if (_activeOnlyFilter && !bom.isActive) return false;
      if (query.isEmpty) return true;
      return bom.name.toLowerCase().contains(query) ||
          bom.productName.toLowerCase().contains(query);
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  void setActiveOnlyFilter(bool value) {
    _activeOnlyFilter = value;
    final current = state;
    if (current is BomsListLoaded) {
      emit(
        current.copyWith(
          activeOnlyFilter: value,
          filteredBoms: _filter(current.allBoms),
        ),
      );
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    final current = state;
    if (current is BomsListLoaded) {
      emit(
        current.copyWith(
          searchQuery: value,
          filteredBoms: _filter(current.allBoms),
        ),
      );
    }
  }

  Future<String?> deleteBom(String id) async {
    final result = await _deleteBom(id);
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
