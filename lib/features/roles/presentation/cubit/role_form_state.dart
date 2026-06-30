import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/roles/data/models/permission_model.dart';

part 'role_form_state.freezed.dart';

@freezed
class RoleFormState with _$RoleFormState {
  const factory RoleFormState({
    @Default('create') String mode,
    String? roleId,
    @Default('') String name,
    @Default('') String description,
    @Default(false) bool isSystem,
    PermissionsCatalogModel? catalog,
    @Default([]) List<String> selectedPermissionKeys,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool isDeleting,
    @Default(false) bool accessDenied,
    @Default({}) Map<String, String> errors,
  }) = _RoleFormState;
}
