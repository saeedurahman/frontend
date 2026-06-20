import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_setting_model.freezed.dart';
part 'app_setting_model.g.dart';

@freezed
class AppSettingModel with _$AppSettingModel {
  const factory AppSettingModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'setting_key') required String settingKey,
    @JsonKey(name: 'setting_value') required Map<String, dynamic> settingValue,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _AppSettingModel;

  factory AppSettingModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingModelFromJson(json);
}
