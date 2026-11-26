import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/roles/domain/usecases/roles_usecases.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class RolesListCubit extends Cubit<RolesListState>
    with AutoRefresh<RolesListState> {
  RolesListCubit({
    required GetRolesUseCase getRolesUseCase,
    required DeleteRoleUseCase deleteRoleUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getRoles = getRolesUseCase,
        _deleteRole = deleteRoleUseCase,
        _authLocal = authLocalDataSource,
        super(const RolesListState.initial()) {
    watchData(const {DataTopic.roles}, _reload);
  }

  final GetRolesUseCase _getRoles;
  final DeleteRoleUseCase _deleteRole;
  final AuthLocalDataSource _authLocal;

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canManageRoles(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const RolesListState.accessDenied());
      return;
    }
    await load();
  }

  Future<void> load() async {
    final read = beginRead();
    emit(const RolesListState.loading());
    final result = await _getRoles();
    if (isStale(read)) return;
    result.fold(
      (failure) => emit(RolesListState.error(failure.message)),
      (roles) => emit(
        RolesListState.loaded(roles: newestFirst(roles, (r) => r.id)),
      ),
    );
  }

  /// Reads the list again without a spinner.
  Future<void> refresh() =>
      state is RolesListLoaded ? _reload() : load();

  Future<void> _reload() async {
    final current = state;
    if (current is RolesListInitial || current is RolesListAccessDenied) return;
    if (current is! RolesListLoaded) return load();
    final read = beginRead();
    final result = await _getRoles();
    if (isStale(read)) return;
    result.fold(
      (_) {},
      (roles) => emit(
        RolesListState.loaded(roles: newestFirst(roles, (r) => r.id)),
      ),
    );
  }

  /// The id of the new role on top of the list, if any.
  String? get newestCreatedId {
    final current = state;
    if (current is! RolesListLoaded) return null;
    return createdOnTop(current.roles, (r) => r.id);
  }

  Future<bool> deleteRole(String id) async {
    final current = state;
    if (current is! RolesListLoaded) return false;

    final index = current.roles.indexWhere((r) => r.id == id);
    if (index < 0) return false;

    final removed = current.roles[index];
    final updated = [...current.roles]..removeAt(index);
    emit(RolesListState.loaded(roles: updated));

    final result = await _deleteRole(id);
    return result.fold(
      (failure) {
        final restored = [...updated];
        restored.insert(index, removed);
        emit(RolesListState.loaded(roles: restored));
        emit(RolesListState.error(failure.message));
        return false;
      },
      (_) => true,
    );
  }
}
