import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/roles/data/models/role_model.dart';

part 'roles_list_state.freezed.dart';

@Freezed()
sealed class RolesListState with _$RolesListState {
  const factory RolesListState.initial() = RolesListInitial;

  const factory RolesListState.loading() = RolesListLoading;

  const factory RolesListState.loaded({
    required List<RoleModel> roles,
  }) = RolesListLoaded;

  const factory RolesListState.accessDenied() = RolesListAccessDenied;

  const factory RolesListState.error(String message) = RolesListError;
}
