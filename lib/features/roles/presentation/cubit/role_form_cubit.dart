import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/roles/data/models/permission_model.dart';
import 'package:frantend/features/roles/domain/usecases/roles_usecases.dart';
import 'package:frantend/features/roles/presentation/cubit/role_form_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class RoleFormCubit extends Cubit<RoleFormState> {
  RoleFormCubit({
    required GetPermissionsCatalogUseCase getPermissionsCatalogUseCase,
    required GetRoleUseCase getRoleUseCase,
    required CreateRoleUseCase createRoleUseCase,
    required UpdateRoleUseCase updateRoleUseCase,
    required AssignRolePermissionsUseCase assignRolePermissionsUseCase,
    required DeleteRoleUseCase deleteRoleUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getCatalog = getPermissionsCatalogUseCase,
        _getRole = getRoleUseCase,
        _createRole = createRoleUseCase,
        _updateRole = updateRoleUseCase,
        _assignPermissions = assignRolePermissionsUseCase,
        _deleteRole = deleteRoleUseCase,
        _authLocal = authLocalDataSource,
        super(const RoleFormState());

  final GetPermissionsCatalogUseCase _getCatalog;
  final GetRoleUseCase _getRole;
  final CreateRoleUseCase _createRole;
  final UpdateRoleUseCase _updateRole;
  final AssignRolePermissionsUseCase _assignPermissions;
  final DeleteRoleUseCase _deleteRole;
  final AuthLocalDataSource _authLocal;

  Future<bool> _ensureCanManageRoles() async {
    final user = await _authLocal.getCachedUser();
    return UserRoleUtils.canManageRoles(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );
  }

  Future<void> initCreate() async {
    if (!await _ensureCanManageRoles()) {
      emit(const RoleFormState(mode: 'create', accessDenied: true));
      return;
    }

    emit(
      const RoleFormState(mode: 'create', isLoading: true),
    );
    final catalogResult = await _getCatalog();
    catalogResult.fold(
      (failure) => emit(
        RoleFormState(
          mode: 'create',
          errors: {'_general': failure.message},
        ),
      ),
      (catalog) => emit(
        RoleFormState(mode: 'create', catalog: catalog),
      ),
    );
  }

  Future<void> loadForEdit(String roleId) async {
    if (!await _ensureCanManageRoles()) {
      emit(const RoleFormState(mode: 'edit', accessDenied: true));
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        mode: 'edit',
        roleId: roleId,
        errors: {},
      ),
    );

    final roleResult = await _getRole(roleId);
    final catalogResult = await _getCatalog();

    PermissionsCatalogModel? catalog;
    catalogResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errors: {'_general': failure.message}));
      },
      (value) => catalog = value,
    );
    if (catalog == null) return;

    roleResult.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errors: {'_general': failure.message}),
      ),
      (role) => emit(
        RoleFormState(
          mode: 'edit',
          roleId: role.id,
          name: role.name,
          description: role.description ?? '',
          isSystem: role.isSystem,
          catalog: catalog,
          selectedPermissionKeys: List<String>.from(role.permissionKeys),
        ),
      ),
    );
  }

  void updateName(String value) => emit(state.copyWith(name: value));

  void updateDescription(String value) =>
      emit(state.copyWith(description: value));

  void togglePermission(String key) {
    final keys = List<String>.from(state.selectedPermissionKeys);
    if (keys.contains(key)) {
      keys.remove(key);
    } else {
      keys.add(key);
    }
    emit(state.copyWith(selectedPermissionKeys: keys));
  }

  void toggleModule(String module, bool selectAll) {
    final catalog = state.catalog;
    if (catalog == null) return;

    PermissionModuleModel? moduleEntry;
    for (final m in catalog.modules) {
      if (m.module == module) {
        moduleEntry = m;
        break;
      }
    }
    if (moduleEntry == null) return;

    final moduleKeys =
        moduleEntry.permissions.map((p) => p.permissionKey).toList();
    final keys = List<String>.from(state.selectedPermissionKeys);

    if (selectAll) {
      for (final key in moduleKeys) {
        if (!keys.contains(key)) keys.add(key);
      }
    } else {
      keys.removeWhere(moduleKeys.contains);
    }

    emit(state.copyWith(selectedPermissionKeys: keys));
  }

  bool isModuleFullySelected(PermissionModuleModel module) {
    if (module.permissions.isEmpty) return false;
    return module.permissions.every(
      (p) => state.selectedPermissionKeys.contains(p.permissionKey),
    );
  }

  bool isModulePartiallySelected(PermissionModuleModel module) {
    final selected = module.permissions
        .where((p) => state.selectedPermissionKeys.contains(p.permissionKey))
        .length;
    return selected > 0 && selected < module.permissions.length;
  }

  bool validate() {
    final errors = <String, String>{};
    if (!state.isSystem && state.name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    }
    emit(state.copyWith(errors: errors));
    return errors.isEmpty;
  }

  Future<String?> submit() async {
    if (!validate()) return 'Validation failed';

    emit(state.copyWith(isSubmitting: true, errors: {}));

    if (state.mode == 'create') {
      final result = await _createRole(
        name: state.name.trim(),
        description: state.description.trim().isEmpty
            ? null
            : state.description.trim(),
        permissionKeys: state.selectedPermissionKeys,
      );
      return result.fold(
        (failure) {
          emit(state.copyWith(isSubmitting: false));
          return failure.message;
        },
        (_) {
          emit(state.copyWith(isSubmitting: false));
          return null;
        },
      );
    }

    final roleId = state.roleId!;
    final updateResult = await _updateRole(
      id: roleId,
      name: state.isSystem ? null : state.name.trim(),
      description: state.description.trim().isEmpty
          ? null
          : state.description.trim(),
    );

    String? updateError;
    updateResult.fold(
      (failure) => updateError = failure.message,
      (_) {},
    );
    if (updateError != null) {
      emit(state.copyWith(isSubmitting: false));
      return updateError;
    }

    final assignResult = await _assignPermissions(
      id: roleId,
      permissionKeys: state.selectedPermissionKeys,
    );

    return assignResult.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false));
        return failure.message;
      },
      (role) {
        emit(
          state.copyWith(
            isSubmitting: false,
            name: role.name,
            description: role.description ?? '',
            selectedPermissionKeys: List<String>.from(role.permissionKeys),
          ),
        );
        return null;
      },
    );
  }

  Future<String?> deleteRole() async {
    final roleId = state.roleId;
    if (roleId == null || state.isSystem) {
      return 'System roles cannot be deleted';
    }

    emit(state.copyWith(isDeleting: true, errors: {}));
    final result = await _deleteRole(roleId);
    return result.fold(
      (failure) {
        emit(state.copyWith(isDeleting: false));
        return failure.message;
      },
      (_) {
        emit(state.copyWith(isDeleting: false));
        return null;
      },
    );
  }
}
