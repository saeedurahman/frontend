import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_role_model.freezed.dart';
part 'staff_role_model.g.dart';

@freezed
class StaffRoleModel with _$StaffRoleModel {
  const factory StaffRoleModel({
    required String id,
    required String name,
  }) = _StaffRoleModel;

  factory StaffRoleModel.fromJson(Map<String, dynamic> json) =>
      _$StaffRoleModelFromJson(json);
}
