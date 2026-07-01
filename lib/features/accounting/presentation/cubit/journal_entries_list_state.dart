import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';

part 'journal_entries_list_state.freezed.dart';

@Freezed()
sealed class JournalEntriesListState with _$JournalEntriesListState {
  const factory JournalEntriesListState.initial() = JournalEntriesListInitial;

  const factory JournalEntriesListState.loading() = JournalEntriesListLoading;

  const factory JournalEntriesListState.loaded({
    required List<JournalEntryListModel> entries,
    String? statusFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
    @Default(false) bool canCreate,
  }) = JournalEntriesListLoaded;

  const factory JournalEntriesListState.error(String message) =
      JournalEntriesListError;

  const factory JournalEntriesListState.accessDenied() =
      JournalEntriesListAccessDenied;
}
