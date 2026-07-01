import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/accounting/data/models/journal_line_model.dart';

part 'journal_entry_model.freezed.dart';
part 'journal_entry_model.g.dart';

@freezed
class JournalEntryModel with _$JournalEntryModel {
  const factory JournalEntryModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'entry_number') required String entryNumber,
    required String status,
    @JsonKey(name: 'entry_date') required String entryDate,
    String? description,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'posted_at') String? postedAt,
    @Default([]) List<JournalLineModel> lines,
    @JsonKey(name: 'total_debit') required String totalDebit,
    @JsonKey(name: 'total_credit') required String totalCredit,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
  }) = _JournalEntryModel;

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryModelFromJson(json);
}
