import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';

part 'users_list_state.freezed.dart';

@Freezed()
sealed class UsersListState with _$UsersListState {
  const factory UsersListState.initial() = UsersListInitial;

  const factory UsersListState.loading() = UsersListLoading;

  const factory UsersListState.loaded({
    required List<StaffUserModel> users,
    String? roleFilter,
  }) = UsersListLoaded;

  const factory UsersListState.accessDenied() = UsersListAccessDenied;

  const factory UsersListState.error(String message) = UsersListError;
}
