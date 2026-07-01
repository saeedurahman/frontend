import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_model.dart';

part 'journal_entry_detail_state.freezed.dart';

@freezed
class JournalEntryDetailState with _$JournalEntryDetailState {
  const factory JournalEntryDetailState({
    JournalEntryModel? entry,
    @Default(false) bool isLoading,
    @Default(false) bool isPosting,
    @Default(false) bool isDeleting,
    @Default(false) bool canCreate,
    @Default(false) bool canPost,
    String? loadError,
  }) = _JournalEntryDetailState;
}
