import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/statement_period.dart';

/// The statement screen and the paper preview.
abstract final class StatementText {
  static const title = 'Statement';
  static const back = 'Back';
  static String period(StatementPeriod p) => switch (p) {
        StatementPeriod.thisMonth => 'This month',
        StatementPeriod.lastMonth => 'Last month',
        StatementPeriod.last3Months => 'Last 3 months',
        StatementPeriod.thisYear => 'This year',
        StatementPeriod.custom => 'Custom',
        StatementPeriod.all => 'All',
      };
  static const periodHeading = 'Period';
  static const detailHeading = 'Detail';
  static const summary = 'Summary';
  static const detailed = 'Detailed with items';
  static const pickDates = 'Pick the dates';

  // Actions
  static const sendHeading = 'Send or keep';
  static const sharePdf = 'Share PDF';
  static const savePdf = 'Save PDF';
  static const print = 'Print';
  static const whatsappMessage = 'WhatsApp message';
  static const whatsappLink = 'WhatsApp with link';
  static const copyLink = 'Copy link';
  static const shareHint = 'Save the PDF and open its folder';
  static const shareFileHint = 'Share the PDF with another app';
  static const saveHint = 'Choose where to save the PDF (Ctrl+S)';
  static const printHint = 'Print this statement (Ctrl+P)';
  static const messageHint = 'Send the totals as a WhatsApp message';
  static const linkMessageHint =
      'Send a message with a link that opens the statement';
  static const copyLinkHint = 'Copy a link that opens the statement';
  static const needsInternet = 'Needs internet';
  static const noLinkPermission =
      'Your account is not allowed to create statement links';
  static const attachHint =
      'WhatsApp on a computer cannot attach files from here. Save the PDF, '
      'then attach it in the chat yourself, or send a link.';

  // Results
  static String savedTo(String path) => 'Saved to $path';
  static const openFolder = 'Open folder';
  static String savedToAttach(String path) =>
      'Saved to $path. Attach it in your WhatsApp chat.';
  static const sharedDone = 'Shared';
  static const sentToPrinter = 'Sent to the printer';
  static const notPrinted = 'The statement was not printed';
  static const linkCopied = 'Link copied';
  static String linkCopiedUntil(String day) => 'Link copied. Works until $day.';
  static const saveFailed =
      'The file could not be saved. Choose another folder and try again.';

  // States
  static String offlineCopy(String period) =>
      'You are offline. This is the last statement saved on this device '
      '($period).';
  static const tooLongTitle = 'This statement is too long';
  static const tooLongMessage =
      'Choose a shorter period, or switch to Summary.';
  static const showThisMonth = 'Show this month';
  static const badDatesTitle = 'Check the dates';
  static const badDatesMessage = 'The start date must be before the end date.';
  static const offlineTitle = 'Not available offline';
  static const offlineMessage =
      'No statement is saved on this device yet. Connect to the internet to '
      'build one.';
  static const failedTitle = 'Could not build the statement';
  static const retry = 'Try again';

  // Paper
  static const paperTitle = 'Account Statement';
  static const opening = 'Opening';
  static const charges = 'Charges';
  static const payments = 'Payments';
  static String closingLabel(PartyType type, int sign) => sign == 0
      ? 'Settled'
      : sign > 0
          ? type.isCustomer
              ? 'Amount due'
              : 'Amount we owe'
          : type.isCustomer
              ? 'Your advance'
              : 'Our advance';
  static const advanceSuffix = 'adv';
  static const aging = 'Unpaid by age';
  static String periodLine(String label) => 'Period: $label';
  static const date = 'Date';
  static const document = 'Document';
  static const details = 'Details';
  static const debit = 'Debit';
  static const credit = 'Credit';
  static const balance = 'Balance';
  static const openingRow = 'Opening balance';
  static const closingRow = 'Closing balance';
  static const noRows = 'No entries in this period';
  static const reversed = 'REVERSED';
  static String reference(String number) => 'Ref $number';
  static const discount = 'discount';
  static const rounding = 'rounding';
  static const tax = 'Tax';
  static const included = 'incl.';
  static const pendingBills = 'Pending bills';
  static const billNo = 'Bill no';
  static const total = 'Total';
  static const paid = 'Paid';
  static const remaining = 'Remaining';
  static const age = 'Age (days)';
  static const totalPending = 'Total pending';
  static const oldestFirst = 'Payments are applied to the oldest bill first.';
  static const noBills = 'No pending bills';
  static String advanceHeld(String amount) => 'Advance held: $amount';
  static const payVia = 'Please pay via';
  static String promise(String? amount, String day) => amount == null
      ? 'Payment promised by $day'
      : 'Payment of $amount promised by $day';
  static const poweredBy = 'Powered by PakPOS';
  static String phone(String value) => 'Phone: $value';
  static String taxNumber(String value) => 'NTN: $value';
  static String generated(String when) => 'Generated $when';
  static String statementFor(PartyType type) =>
      type.isCustomer ? 'Customer' : 'Supplier';
}
