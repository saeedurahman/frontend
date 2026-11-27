import 'package:frantend/features/khata/domain/manual_entry.dart';
import 'package:frantend/features/khata/domain/party_type.dart';

/// Opening balances, udhaar, goods on credit and adjustments.
abstract final class EntryText {
  // Opening balance
  static const openingTitle = 'Opening balance';
  static const openingOptional = 'Opening balance (optional)';
  static const addOpening = 'Add opening balance';
  static const saveOpening = 'Save opening balance';
  static const openingSaved = 'Opening balance saved';
  static const openingExists =
      'This account already has an opening balance. Reverse it first, then '
      'add the correct one.';
  static String openingHelp(PartyType type) => type.isCustomer
      ? 'Money that was already owed before you started using the app. Leave '
          'it empty if the customer starts at zero.'
      : 'Money that was already owed before you started using the app. Leave '
          'it empty if the supplier starts at zero.';
  static String directionLabel(OpeningDirection d) => switch (d) {
        OpeningDirection.theyOweUs => 'They owe us',
        OpeningDirection.weOweThem => 'We owe them',
      };
  static const asOf = 'As of';
  static const asOfHelp = 'The balance was this amount on this day';
  static const openingNeedsInternet =
      'An opening balance needs internet. Connect first, or leave the amount '
      'empty and add it later.';
  static const openingOfflineHint = 'Available when you are online';

  // Manual entries
  static const manualMenu = 'Add entry';
  static const manualMenuTooltip =
      'Write money into this account without a sale or payment';
  static const giveUdhaar = 'Give udhaar (no sale)';
  static const goodsOnCredit = 'Goods on credit (manual)';
  static const adjustment = 'Adjustment';

  static String title(ManualKind kind) => switch (kind) {
        ManualKind.udhaarGiven => giveUdhaar,
        ManualKind.goodsOnCredit => goodsOnCredit,
        _ => adjustment,
      };

  static String help(PartyType type, ManualKind kind) => switch (kind) {
        ManualKind.udhaarGiven =>
          'Cash or goods you gave on credit without making a sale. No stock '
              'or cash drawer changes.',
        ManualKind.goodsOnCredit =>
          'Goods or services you took on credit without a goods receipt. No '
              'stock or cash drawer changes.',
        _ => type.isCustomer
            ? 'Correct what this customer owes. No money moves.'
            : 'Correct what you owe this supplier. No money moves.',
      };

  static String increase(PartyType type) =>
      type.isCustomer ? 'They owe more' : 'I owe more';
  static String decrease(PartyType type) =>
      type.isCustomer ? 'They owe less' : 'I owe less';

  static const amount = 'Amount';
  static const note = 'Note (required)';
  static const noteHint = 'Why are you adding this?';
  static const date = 'Date';
  static const today = 'Today';
  static const amountRequired = 'Enter an amount above zero';
  static const noteRequired = 'Write a short note';
  static const save = 'Save entry';
  static const saved = 'Entry saved';

  static const amountInvalid = 'Enter an amount above zero';
  static const offline =
      'This changes the account, so it needs internet. Connect and try again.';

  // Credit limit
  static String creditBody({
    required String limit,
    required String balance,
    required String wouldBe,
  }) =>
      'Credit limit: $limit\nBalance now: $balance\n'
      'After this udhaar: $wouldBe';
  static const creditNoOverride =
      'Ask the owner or a manager to allow this, or give a smaller amount.';

  // Reversal
  static const reverseEntry = 'Reverse entry';
  static const reverseEntryExplain =
      'This adds an opposite line to the account. The original stays visible, '
      'marked as reversed. Nothing is deleted.';
  static const keepEntry = 'Keep entry';
  static const entryReversed = 'Entry reversed';
  static const entryAlreadyReversed = 'This entry was already reversed.';
  static const entryNotReversible = 'This line cannot be reversed here.';

  // Ledger line names
  static const udhaarLine = 'Udhaar given';
  static const goodsLine = 'Goods on credit (manual)';
  static const reversedEntryLine = 'Entry reversed';

  /// Plain words for the server's refusals.
  static String? forCode(String? code) => switch (code) {
        'opening_balance_exists' => openingExists,
        'entry_already_reversed' => entryAlreadyReversed,
        'not_a_reversible_entry' => entryNotReversible,
        'credit_override_forbidden' =>
          'You are not allowed to go over the credit limit. $creditNoOverride',
        _ => null,
      };
}
