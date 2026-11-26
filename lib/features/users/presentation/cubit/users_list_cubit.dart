import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/users/domain/usecases/users_usecases.dart';
import 'package:frantend/features/users/presentation/cubit/users_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class UsersListCubit extends Cubit<UsersListState>
    with AutoRefresh<UsersListState> {
  UsersListCubit({
    required GetUsersUseCase getUsersUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getUsers = getUsersUseCase,
        _deleteUser = deleteUserUseCase,
        _authLocal = authLocalDataSource,
        super(const UsersListState.initial()) {
    watchData(const {DataTopic.users}, _reload);
  }

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
    final read = beginRead();
    emit(const UsersListState.loading());
    final result = await _fetch(roleFilter);
    if (isStale(read)) return;
    result.fold(
      (failure) => emit(UsersListState.error(failure.message)),
      (users) => emit(
        UsersListState.loaded(users: users, roleFilter: roleFilter),
      ),
    );
  }

  /// Reads the list again without a spinner, with the same role filter.
  Future<void> refresh() =>
      state is UsersListLoaded ? _reload() : load();

  Future<void> _reload() async {
    final current = state;
    if (current is UsersListInitial || current is UsersListAccessDenied) return;
    if (current is! UsersListLoaded) return load();
    final read = beginRead();
    final result = await _fetch(current.roleFilter);
    if (isStale(read)) return;
    result.fold(
      (_) {},
      (users) => emit(
        UsersListState.loaded(users: users, roleFilter: current.roleFilter),
      ),
    );
  }

  /// The users of [role], with the ones just created on top (the filter must
  /// not hide them).
  Future<Either<Failure, List<StaffUserModel>>> _fetch(String? role) async {
    final result = await _getUsers(role: role);
    return result.fold(
      (failure) async => Left(failure),
      (users) async {
        var all = users;
        final missing = createdIds.toSet()..removeAll(users.map((u) => u.id));
        if (role != null && missing.isNotEmpty) {
          final everyone = await _getUsers();
          all = [
            ...users,
            ...everyone.fold(
              (_) => const <StaffUserModel>[],
              (list) => list.where((u) => missing.contains(u.id)),
            ),
          ];
        }
        return Right(newestFirst(all, (u) => u.id));
      },
    );
  }

  /// The id of the new user on top of the list, if any.
  String? get newestCreatedId {
    final current = state;
    if (current is! UsersListLoaded) return null;
    return createdOnTop(current.users, (u) => u.id);
  }

  Future<void> filterByRole(String? role) {
    forgetCreated();
    return load(roleFilter: role);
  }

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
