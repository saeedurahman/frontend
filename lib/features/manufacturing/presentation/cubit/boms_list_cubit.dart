import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';
import 'package:frantend/features/manufacturing/domain/usecases/manufacturing_usecases.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/boms_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class BomsListCubit extends Cubit<BomsListState>
    with AutoRefresh<BomsListState> {
  BomsListCubit({
    required ListBomsUseCase listBomsUseCase,
    required DeleteBomUseCase deleteBomUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _listBoms = listBomsUseCase,
        _deleteBom = deleteBomUseCase,
        _authLocal = authLocalDataSource,
        super(const BomsListState.initial()) {
    watchData({DataTopic.manufacturing}, _readQuietly);
  }

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

  Future<void> load() => _read(quiet: false);

  /// Reads the recipes again behind the rows on screen.
  Future<void> _readQuietly() async {
    if (state is BomsListLoaded) await _read(quiet: true);
  }

  /// The id of a new recipe on top of the list, for the table's reset token.
  String? get newestCreatedId {
    final current = state;
    if (current is! BomsListLoaded) return null;
    return createdOnTop(current.filteredBoms, (bom) => bom.id);
  }

  Future<void> _read({required bool quiet}) async {
    final read = beginRead();
    if (!quiet) emit(const BomsListState.loading());

    final user = await _authLocal.getCachedUser();
    final canManage = UserRoleUtils.canManageBom(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );

    final result = await _listBoms();
    if (isStale(read)) return;
    result.fold(
      (failure) {
        if (!quiet) emit(BomsListState.error(failure.message));
      },
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
    final matching = boms.where((bom) {
      // A new recipe stays in sight until the filter or search is changed.
      if (isNewlyCreated(bom.id)) return true;
      if (_activeOnlyFilter && !bom.isActive) return false;
      if (query.isEmpty) return true;
      return bom.name.toLowerCase().contains(query) ||
          bom.productName.toLowerCase().contains(query);
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return newestFirst(matching, (bom) => bom.id);
  }

  void setActiveOnlyFilter(bool value) {
    _activeOnlyFilter = value;
    forgetCreated();
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
    forgetCreated();
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
        refresh();
        return null;
      },
    );
  }

  Future<void> refresh() =>
      state is BomsListLoaded ? _read(quiet: true) : load();
}
