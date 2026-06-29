import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/roles/domain/usecases/roles_usecases.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class RolesListCubit extends Cubit<RolesListState> {
  RolesListCubit({
    required GetRolesUseCase getRolesUseCase,
    required DeleteRoleUseCase deleteRoleUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getRoles = getRolesUseCase,
        _deleteRole = deleteRoleUseCase,
        _authLocal = authLocalDataSource,
        super(const RolesListState.initial());

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
    emit(const RolesListState.loading());
    final result = await _getRoles();
    result.fold(
      (failure) => emit(RolesListState.error(failure.message)),
      (roles) => emit(RolesListState.loaded(roles: roles)),
    );
  }

  Future<void> refresh() => load();

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
