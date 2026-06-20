import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';

part 'register_shift_model.freezed.dart';
part 'register_shift_model.g.dart';

@freezed
class RegisterShiftModel with _$RegisterShiftModel {
  const factory RegisterShiftModel({
    required String id,
    @JsonKey(name: 'cash_register_id') required String cashRegisterId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'opened_by') String? openedBy,
    @JsonKey(name: 'closed_by') String? closedBy,
    @JsonKey(name: 'opened_by_name') String? openedByName,
    @JsonKey(name: 'closed_by_name') String? closedByName,
    @JsonKey(name: 'opening_float') @Default('0') String openingFloat,
    @JsonKey(name: 'expected_cash') String? expectedCash,
    @JsonKey(name: 'actual_cash') String? actualCash,
    @JsonKey(name: 'cash_difference') String? cashDifference,
    @JsonKey(name: 'opened_at') String? openedAt,
    @JsonKey(name: 'closed_at') String? closedAt,
    @Default('open') String status,
    String? notes,
    CashRegisterModel? register,
  }) = _RegisterShiftModel;

  factory RegisterShiftModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterShiftModelFromJson(json);
}
