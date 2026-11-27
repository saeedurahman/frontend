import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_ledger_entry_model.freezed.dart';
part 'customer_ledger_entry_model.g.dart';

enum LedgerEntryType {
  sale,
  payment,
  @JsonValue('return_')
  return_,
  @JsonValue('opening_balance')
  openingBalance,
  adjustment,
  refund,
  // A payment that was undone: a new row that references the original.
  reversal,
  // An explicit data fix posted by the owner's tools.
  correction,
}

@freezed
abstract class CustomerLedgerEntryModel with _$CustomerLedgerEntryModel {
  const factory CustomerLedgerEntryModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'entry_type', unknownEnumValue: LedgerEntryType.adjustment)
    required LedgerEntryType entryType,
    required String amount,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'entry_at') String? entryAt,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'payment_source') String? paymentSource,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'register_shift_id') String? registerShiftId,
    @JsonKey(name: 'reversal_of_id') String? reversalOfId,
    @JsonKey(name: 'reversed_by_id') String? reversedById,
    @JsonKey(name: 'reversed_at') String? reversedAt,
    @JsonKey(name: 'is_reversed') @Default(false) bool isReversed,
    @JsonKey(name: 'is_reversal') @Default(false) bool isReversal,
    @JsonKey(name: 'running_balance') String? runningBalance,
    // "opening" or "manual" for entries written by hand; null otherwise.
    String? source,
    @JsonKey(name: 'manual_kind') String? manualKind,
  }) = _CustomerLedgerEntryModel;

  factory CustomerLedgerEntryModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerLedgerEntryModelFromJson(_normalizeJson(json));

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    for (final key in ['amount', 'running_balance']) {
      if (normalized[key] != null) {
        normalized[key] = ApiJsonUtils.stringValue(normalized[key]);
      }
    }
    return normalized;
  }
}
