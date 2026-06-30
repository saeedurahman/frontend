import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/roles/data/models/role_model.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';

part 'user_form_state.freezed.dart';

@freezed
class UserFormState with _$UserFormState {
  const UserFormState._();

  const factory UserFormState({
    @Default('create') String mode,
    String? userId,
    @Default('') String fullName,
    @Default('') String phone,
    @Default('') String password,
    String? branchId,
    @Default(true) bool isActive,
    @Default('') String originalFullName,
    String? originalBranchId,
    @Default(true) bool originalIsActive,
    @Default([]) List<String> selectedRoleIds,
    @Default([]) List<String> originalRoleIds,
    @Default([]) List<RoleModel> availableRoles,
    @Default([]) List<BranchModel> branches,
    @Default(false) bool canUpdateProfile,
    @Default(false) bool canEditRoles,
    @Default(false) bool canDelete,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    @Default(false) bool isDeleting,
    @Default(false) bool isTogglingActive,
    @Default(false) bool isResettingPin,
    String? saveWarning,
    @Default({}) Map<String, String> errors,
  }) = _UserFormState;

  bool get isEdit => mode == 'edit';

  bool get profileDirty =>
      fullName.trim() != originalFullName.trim() ||
      branchId != originalBranchId ||
      isActive != originalIsActive;

  bool get rolesDirty =>
      !_roleIdSetsEqual(selectedRoleIds, originalRoleIds);

  bool get canSave {
    if (isSaving) return false;
    if (!isEdit) return true;
    if (canUpdateProfile && profileDirty) return true;
    if (canEditRoles && rolesDirty) return true;
    return false;
  }

  static bool _roleIdSetsEqual(List<String> a, List<String> b) {
    final setA = a.toSet();
    final setB = b.toSet();
    return setA.length == setB.length && setA.containsAll(setB);
  }
}
