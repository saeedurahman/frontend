import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry_list_model.freezed.dart';
part 'journal_entry_list_model.g.dart';

@freezed
class JournalEntryListModel with _$JournalEntryListModel {
  const factory JournalEntryListModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'entry_number') required String entryNumber,
    required String status,
    @JsonKey(name: 'entry_date') required String entryDate,
    String? description,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'posted_at') String? postedAt,
    @JsonKey(name: 'total_debit') required String totalDebit,
    @JsonKey(name: 'total_credit') required String totalCredit,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _JournalEntryListModel;

  factory JournalEntryListModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryListModelFromJson(json);
}

/// Journal entry lifecycle statuses from backend.
abstract final class JournalEntryStatus {
  static const draft = 'draft';
  static const posted = 'posted';
}
