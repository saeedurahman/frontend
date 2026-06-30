import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/branches/domain/usecases/branches_usecases.dart';
import 'package:frantend/features/roles/domain/usecases/roles_usecases.dart';
import 'package:frantend/features/users/domain/usecases/users_usecases.dart';
import 'package:frantend/features/users/presentation/cubit/user_form_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserFormCubit extends Cubit<UserFormState> {
  UserFormCubit({
    required GetUserUseCase getUserUseCase,
    required CreateUserUseCase createUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required ReplaceUserRolesUseCase replaceUserRolesUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required ResetUserPinUseCase resetUserPinUseCase,
    required GetRolesUseCase getRolesUseCase,
    required BranchesUseCases branchesUseCases,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getUser = getUserUseCase,
        _createUser = createUserUseCase,
        _updateUser = updateUserUseCase,
        _replaceRoles = replaceUserRolesUseCase,
        _deleteUser = deleteUserUseCase,
        _resetPin = resetUserPinUseCase,
        _getRoles = getRolesUseCase,
        _branches = branchesUseCases,
        _authLocal = authLocalDataSource,
        super(const UserFormState());

  final GetUserUseCase _getUser;
  final CreateUserUseCase _createUser;
  final UpdateUserUseCase _updateUser;
  final ReplaceUserRolesUseCase _replaceRoles;
  final DeleteUserUseCase _deleteUser;
  final ResetUserPinUseCase _resetPin;
  final GetRolesUseCase _getRoles;
  final BranchesUseCases _branches;
  final AuthLocalDataSource _authLocal;

  Future<void> initCreate() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canCreateUsers(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(state.copyWith(errors: {'_general': 'Access denied'}));
      return;
    }

    emit(const UserFormState(mode: 'create', isLoading: true));
    await _loadPickers();
    emit(
      state.copyWith(
        mode: 'create',
        isLoading: false,
        canUpdateProfile: true,
        canEditRoles: UserRoleUtils.canManageUserRoles(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        ),
      ),
    );
  }

  Future<void> loadForEdit(String userId) async {
    final user = await _authLocal.getCachedUser();
    final canUpdate = UserRoleUtils.canUpdateUsers(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );
    final canEditRoles = UserRoleUtils.canManageUserRoles(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );
    final canDelete = UserRoleUtils.canDeleteUsers(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );

    if (!canUpdate && !UserRoleUtils.canViewUsers(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        )) {
      emit(state.copyWith(errors: {'_general': 'Access denied'}));
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        mode: 'edit',
        userId: userId,
        errors: {},
        saveWarning: null,
        canUpdateProfile: canUpdate,
        canEditRoles: canEditRoles,
        canDelete: canDelete,
      ),
    );

    await _loadPickers();

    final result = await _getUser(userId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errors: {'_general': failure.message},
        ),
      ),
      (staff) {
        final roleIds = staff.roles.map((r) => r.id).toList();
        emit(
          UserFormState(
            mode: 'edit',
            userId: staff.id,
            fullName: staff.fullName,
            phone: staff.phone ?? '',
            branchId: staff.branchId,
            isActive: staff.isActive,
            originalFullName: staff.fullName,
            originalBranchId: staff.branchId,
            originalIsActive: staff.isActive,
            selectedRoleIds: roleIds,
            originalRoleIds: roleIds,
            availableRoles: state.availableRoles,
            branches: state.branches,
            canUpdateProfile: canUpdate,
            canEditRoles: canEditRoles,
            canDelete: canDelete,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> _loadPickers() async {
    final rolesResult = await _getRoles();
    final branchesResult = await _branches.getBranches();

    rolesResult.fold(
      (failure) => emit(
        state.copyWith(errors: {'_general': failure.message}),
      ),
      (roles) => emit(state.copyWith(availableRoles: roles)),
    );

    branchesResult.fold(
      (_) {},
      (branches) => emit(state.copyWith(branches: branches)),
    );
  }

  void clearSaveWarning() => emit(state.copyWith(saveWarning: null));

  void updateFullName(String value) =>
      emit(state.copyWith(fullName: value, errors: {}, saveWarning: null));

  void updatePhone(String value) =>
      emit(state.copyWith(phone: value, errors: {}, saveWarning: null));

  void updatePassword(String value) =>
      emit(state.copyWith(password: value, errors: {}, saveWarning: null));

  void updateBranchId(String? value) =>
      emit(state.copyWith(branchId: value, errors: {}, saveWarning: null));

  void toggleRole(String roleId, bool selected) {
    final ids = [...state.selectedRoleIds];
    if (selected) {
      if (!ids.contains(roleId)) ids.add(roleId);
    } else {
      ids.remove(roleId);
    }
    emit(state.copyWith(selectedRoleIds: ids, errors: {}, saveWarning: null));
  }

  Map<String, String> _validateCreate() {
    final errors = <String, String>{};
    if (state.fullName.trim().isEmpty) {
      errors['fullName'] = 'Full name is required';
    }
    if (state.phone.trim().isEmpty) {
      errors['phone'] = 'Phone is required';
    }
    if (state.password.trim().length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }
    if (state.selectedRoleIds.isEmpty) {
      errors['roles'] = 'Select at least one role';
    }
    return errors;
  }

  Map<String, String> _validateEdit() {
    final errors = <String, String>{};
    if (state.canUpdateProfile && state.profileDirty) {
      if (state.fullName.trim().isEmpty) {
        errors['fullName'] = 'Full name is required';
      }
    }
    if (state.canEditRoles && state.rolesDirty) {
      if (state.selectedRoleIds.isEmpty) {
        errors['roles'] = 'Select at least one role';
      }
    }
    return errors;
  }

  Future<bool> submit() async {
    if (state.isEdit) {
      return _submitEdit();
    }
    return _submitCreate();
  }

  Future<bool> _submitCreate() async {
    final errors = _validateCreate();
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return false;
    }

    emit(state.copyWith(isSaving: true, errors: {}, saveWarning: null));
    final result = await _createUser(
      fullName: state.fullName.trim(),
      phone: state.phone.trim(),
      password: state.password,
      branchId: state.branchId,
      roleIds: state.selectedRoleIds,
    );

    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errors: {'_general': failure.message}));
        return false;
      },
      (_) {
        emit(state.copyWith(isSaving: false));
        return true;
      },
    );
  }

  Future<bool> _submitEdit() async {
    final errors = _validateEdit();
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return false;
    }

    if (!state.canSave) return false;

    emit(state.copyWith(isSaving: true, errors: {}, saveWarning: null));

    var profileSaved = false;

    if (state.profileDirty && state.canUpdateProfile) {
      final result = await _updateUser(
        id: state.userId!,
        fullName: state.fullName.trim(),
        branchId: state.branchId,
        isActive: state.isActive,
      );
      final failed = result.fold(
        (failure) {
          emit(
            state.copyWith(
              isSaving: false,
              errors: {'_general': failure.message},
            ),
          );
          return true;
        },
        (updated) {
          profileSaved = true;
          emit(
            state.copyWith(
              originalFullName: updated.fullName,
              originalBranchId: updated.branchId,
              originalIsActive: updated.isActive,
              fullName: updated.fullName,
              branchId: updated.branchId,
              isActive: updated.isActive,
            ),
          );
          return false;
        },
      );
      if (failed) return false;
    }

    if (state.rolesDirty && state.canEditRoles) {
      final result = await _replaceRoles(
        id: state.userId!,
        roleIds: state.selectedRoleIds,
      );
      return result.fold(
        (failure) {
          if (profileSaved) {
            emit(
              state.copyWith(
                isSaving: false,
                saveWarning: failure.message,
              ),
            );
          } else {
            emit(
              state.copyWith(
                isSaving: false,
                errors: {'_roles': failure.message},
              ),
            );
          }
          return false;
        },
        (updated) {
          final roleIds = updated.roles.map((r) => r.id).toList();
          emit(
            state.copyWith(
              isSaving: false,
              selectedRoleIds: roleIds,
              originalRoleIds: roleIds,
              saveWarning: null,
            ),
          );
          return true;
        },
      );
    }

    emit(state.copyWith(isSaving: false));
    return true;
  }

  Future<bool> toggleActive() async {
    if (!state.isEdit || !state.canUpdateProfile || state.isTogglingActive) {
      return false;
    }

    final next = !state.isActive;
    emit(state.copyWith(isTogglingActive: true, errors: {}, saveWarning: null));

    final result = await _updateUser(
      id: state.userId!,
      isActive: next,
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isTogglingActive: false,
            errors: {'_general': failure.message},
          ),
        );
        return false;
      },
      (updated) {
        emit(
          state.copyWith(
            isActive: updated.isActive,
            originalIsActive: updated.isActive,
            isTogglingActive: false,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> resetPin(String pinCode) async {
    if (!state.isEdit || !state.canUpdateProfile || state.userId == null) {
      return false;
    }

    emit(state.copyWith(isResettingPin: true, errors: {}));
    final result = await _resetPin(id: state.userId!, pinCode: pinCode);
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isResettingPin: false,
            errors: {'_pin': failure.message},
          ),
        );
        return false;
      },
      (_) {
        emit(state.copyWith(isResettingPin: false));
        return true;
      },
    );
  }

  Future<bool> deleteUser() async {
    if (!state.isEdit || !state.canDelete || state.userId == null) {
      return false;
    }

    emit(state.copyWith(isDeleting: true));
    final result = await _deleteUser(state.userId!);
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isDeleting: false,
            errors: {'_general': failure.message},
          ),
        );
        return false;
      },
      (_) => true,
    );
  }
}
