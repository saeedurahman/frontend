import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entry_form_state.dart';

void main() {
  group('JournalEntryFormState', () {
    test('isEdit when entryId is set', () {
      expect(const JournalEntryFormState().isEdit, isFalse);
      expect(const JournalEntryFormState(entryId: 'e1').isEdit, isTrue);
    });

    test('balanceSummary recomputes from lines', () {
      const state = JournalEntryFormState(
        lines: [
          JournalLineDraft(
            accountId: 'a1',
            side: JournalLineSide.debit,
            amount: '250',
          ),
          JournalLineDraft(
            accountId: 'a2',
            side: JournalLineSide.credit,
            amount: '250',
          ),
        ],
      );

      expect(state.balanceSummary.isBalanced, isTrue);
      expect(state.balanceSummary.canPost, isTrue);
    });

    test('unbalanced lines reflected in summary', () {
      const state = JournalEntryFormState(
        lines: [
          JournalLineDraft(
            accountId: 'a1',
            side: JournalLineSide.debit,
            amount: '300',
          ),
          JournalLineDraft(
            accountId: 'a2',
            side: JournalLineSide.credit,
            amount: '100',
          ),
        ],
      );

      expect(state.balanceSummary.isBalanced, isFalse);
      expect(state.balanceSummary.canPost, isFalse);
    });
  });
}
