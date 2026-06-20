import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_register_model.freezed.dart';
part 'cash_register_model.g.dart';

@freezed
class CashRegisterModel with _$CashRegisterModel {
  const factory CashRegisterModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    required String name,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'device_identifier') String? deviceIdentifier,
  }) = _CashRegisterModel;

  factory CashRegisterModel.fromJson(Map<String, dynamic> json) =>
      _$CashRegisterModelFromJson(json);
}
