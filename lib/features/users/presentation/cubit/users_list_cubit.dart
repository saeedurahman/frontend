import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/users/domain/usecases/users_usecases.dart';
import 'package:frantend/features/users/presentation/cubit/users_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class UsersListCubit extends Cubit<UsersListState> {
  UsersListCubit({
    required GetUsersUseCase getUsersUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getUsers = getUsersUseCase,
        _deleteUser = deleteUserUseCase,
        _authLocal = authLocalDataSource,
        super(const UsersListState.initial());

  final GetUsersUseCase _getUsers;
  final DeleteUserUseCase _deleteUser;
  final AuthLocalDataSource _authLocal;

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewUsers(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const UsersListState.accessDenied());
      return;
    }
    await load();
  }

  Future<void> load({String? roleFilter}) async {
    emit(const UsersListState.loading());
    final result = await _getUsers(role: roleFilter);
    result.fold(
      (failure) => emit(UsersListState.error(failure.message)),
      (users) => emit(
        UsersListState.loaded(users: users, roleFilter: roleFilter),
      ),
    );
  }

  Future<void> refresh() async {
    final current = state;
    final filter = current is UsersListLoaded ? current.roleFilter : null;
    await load(roleFilter: filter);
  }

  Future<void> filterByRole(String? role) => load(roleFilter: role);

  Future<bool> deleteUser(String id) async {
    final current = state;
    if (current is! UsersListLoaded) return false;

    final index = current.users.indexWhere((u) => u.id == id);
    if (index < 0) return false;

    final removed = current.users[index];
    final updated = [...current.users]..removeAt(index);
    emit(UsersListState.loaded(users: updated, roleFilter: current.roleFilter));

    final result = await _deleteUser(id);
    return result.fold(
      (failure) {
        final restored = [...updated];
        restored.insert(index, removed);
        emit(
          UsersListState.loaded(
            users: restored,
            roleFilter: current.roleFilter,
          ),
        );
        emit(UsersListState.error(failure.message));
        return false;
      },
      (_) => true,
    );
  }
}
