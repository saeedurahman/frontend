import 'package:frantend/features/khata/data/models/khata_p1_models.dart';

/// The khata parts of a customer's or supplier's own page.
abstract final class PartyText {
  static const accountTab = 'Account';
  static const billsTab = 'Pending bills';
  static const followupsTab = 'Reminders & notes';

  static const remind = 'Remind on WhatsApp';
  static const remindHint = 'Write a WhatsApp reminder';
  static const statement = 'Statement';
  static const statementHint = 'See, share or print the statement';

  // Pending bills
  static const billsTitle = 'Pending bills';
  static String billsCount(int n) => n == 1 ? '1 bill' : '$n bills';
  static String billsTerms(int days) =>
      'Due $days ${days == 1 ? 'day' : 'days'} after the bill';
  static const total = 'Total';
  static const paid = 'Paid';
  static const remaining = 'Remaining';
  static String overdue(String days) => 'Overdue $days';
  static const showAll = 'Show all';
  static const showLess = 'Show less';
  static String advanceHeld(String amount) => 'Advance held: $amount';
  static const noBills = 'No pending bills';
  static const noBillsHint = 'Everything on this account is paid.';
  static const billsUnavailable = "The bills couldn't be loaded";

  static String documentLabel(String type) => switch (type) {
        'sale' => 'Sale',
        'grn' => 'Goods received',
        'expense' => 'Expense',
        'opening_balance' => 'Opening balance',
        'udhaar_given' => 'Udhaar',
        'manual_payable' => 'Goods on credit',
        'adjustment' => 'Adjustment',
        _ => 'Bill',
      };

  // Promise
  static const promiseTitle = 'Promise to pay';
  static const addPromise = 'Add promise';
  static const noPromise = 'No promise noted.';
  static const promiseDatePassed = 'The date has passed';
  static const promiseToday = 'Due today';
  static String promiseAmount(String amount) => 'Amount: $amount';

  // Timeline
  static const timelineTitle = 'Reminders & notes';
  static const addNote = 'Add note';
  static const noFollowups = 'Nothing yet';
  static const noFollowupsHint =
      'Reminders, promises and notes show here.';
  static const waiting = 'Waiting to sync';
  static const refused = 'Not accepted: see Sync';

  static String followupTitle(
    FollowupKind kind, {
    String? channel,
    String? day,
    String? amount,
  }) =>
      switch (kind) {
        FollowupKind.reminder => switch (channel) {
            'whatsapp' => 'Reminder sent on WhatsApp',
            'sms' => 'Reminder sent by SMS',
            'call' => 'Reminded by phone',
            _ => 'Reminder sent',
          },
        FollowupKind.promise => [
            'Promised to pay',
            if (day != null) 'on $day',
            if (amount != null) '· $amount',
          ].join(' '),
        FollowupKind.note => 'Note',
      };
}
