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
}

@freezed
class CustomerLedgerEntryModel with _$CustomerLedgerEntryModel {
  const factory CustomerLedgerEntryModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'entry_type') required LedgerEntryType entryType,
    required String amount,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'entry_at') String? entryAt,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _CustomerLedgerEntryModel;

  factory CustomerLedgerEntryModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerLedgerEntryModelFromJson(_normalizeJson(json));

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    if (normalized['amount'] != null) {
      normalized['amount'] = ApiJsonUtils.stringValue(normalized['amount']);
    }
    return normalized;
  }
}
