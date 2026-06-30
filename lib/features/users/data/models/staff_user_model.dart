import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/users/data/models/staff_role_model.dart';

part 'staff_user_model.freezed.dart';
part 'staff_user_model.g.dart';

@freezed
class StaffUserModel with _$StaffUserModel {
  const factory StaffUserModel({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    String? phone,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'branch_name') String? branchName,
    @Default([]) List<StaffRoleModel> roles,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'last_login_at') String? lastLoginAt,
  }) = _StaffUserModel;

  factory StaffUserModel.fromJson(Map<String, dynamic> json) =>
      _$StaffUserModelFromJson(json);
}
