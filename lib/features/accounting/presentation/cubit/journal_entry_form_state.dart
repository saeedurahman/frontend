import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';

part 'journal_entry_form_state.freezed.dart';

@freezed
class JournalEntryFormState with _$JournalEntryFormState {
  const JournalEntryFormState._();

  const factory JournalEntryFormState({
    String? entryId,
    @Default('') String entryDate,
    @Default('') String description,
    @Default([]) List<JournalLineDraft> lines,
    @Default([]) List<ChartOfAccountModel> accounts,
    @Default(false) bool canEdit,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool isDeleting,
    @Default({}) Map<String, String> errors,
  }) = _JournalEntryFormState;

  bool get isEdit => entryId != null;

  JournalBalanceSummary get balanceSummary => computeJournalBalance(lines);
}
