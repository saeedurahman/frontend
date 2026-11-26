/// Every sentence the credit (khata) screens show, in one place.
///
/// The app keeps feature text as plain English (see `UserErrorMessage`); keeping
/// the khata wording here means it can be reviewed and translated in one go.
/// Wording rule: short, simple, no accounting words.
abstract final class KhataText {
  // Pay supplier
  static const paySupplierTitle = 'Pay supplier';
  static const payNow = 'Pay now';
  static const amountLabel = 'How much are you paying?';
  static const sourceQuestion = 'Where is the money coming from?';
  static const referenceHint = 'Slip, cheque or transaction number';
  static const noteHint = 'Note (optional)';
  static const dateLabel = 'Payment date';
  static const youOweNow = 'You owe this supplier';
  static const afterPayment = 'After this payment';
  static const nothingOwed = 'You owe nothing right now';
  static const payFull = 'Pay full';
  static const payHalf = 'Half';
  static const advanceTitle = 'This is more than you owe';
  static String advanceBody(String amount) =>
      'The extra $amount will be kept as an advance with this supplier. '
      'It will be taken off their next bill.';
  static const needsShiftTitle = 'Open your shift first';
  static const needsShiftBody =
      'Money from the cash drawer needs an open shift, so the till counts '
      'stay right. Open a shift, or pick another place the money came from.';
  static const openShift = 'Open shift';
  static const openingShift = 'Opening shift…';
  static const offlineTitle = 'You are offline';
  static const offlineBody =
      'Supplier payments need the internet so nothing is paid twice. '
      'Your entry is kept. Pay when you are back online.';
  static const paymentDone = 'Payment done';
  static const paidTo = 'Paid to';
  static const share = 'Share on WhatsApp';
  static const print = 'Print';
  static const done = 'Done';
  static const checkingShift = 'Checking your shift…';
  static const enterAmount = 'Enter an amount';
  static const tooManyDecimals = 'Use at most 2 digits after the point';
  static const futureDate = "The date can't be in the future";
  static const noPermissionToPay = "You can't pay suppliers";

  // Paid now (goods receipt, quick add)
  static const paidNowTitle = 'Paid now';
  static const paidNowNone = 'None (credit)';
  static const paidNowHalf = 'Half';
  static const paidNowFull = 'Full';
  static String onCredit(String amount) => 'On credit: $amount';
  static const paidMoreThanTotal = "You can't pay more than the bill total";
  static const otherAmountHint = 'Other amount';
  static const goodsReceived = 'Goods received';
  static String goodsReceivedPaid(String paid, String credit) =>
      'Goods received. Paid $paid now, $credit on credit.';
  static String goodsReceivedPaidFull(String paid) =>
      'Goods received. Paid $paid now. Nothing left on credit.';

  // Ledger
  static const ledgerTitle = 'Supplier account';
  static const reversedTag = 'Reversed';
  static const reversalTag = 'Reversal';
  static const advanceTag = 'Advance';
  static String youOwe(String amount) => 'You owe $amount';
  static String youHaveAdvance(String amount) => 'Advance paid $amount';
  static const settled = 'All settled';
  static const exportLedger = 'Export account';
  static const noEntries = 'No entries yet';
  static const noEntriesInRange = 'Nothing in these dates';
  static const clearDates = 'Clear dates';
  static const runningBalance = 'Balance';
  static const whatHappened = 'What happened';
  static const paidFrom = 'Paid from';
  static const expenseOnCredit = 'Expense on credit';

  // Balance column: words instead of a minus sign.
  static String balanceWeOwe(String amount) => '$amount we owe';
  static String balanceTheyOwe(String amount) => '$amount they owe';
  static String balanceAdvance(String amount) => '$amount advance';
  static const balanceSettled = 'Settled';

  // Amount column: what the number was.
  static const amountGoods = 'Goods';
  static const amountExpense = 'Expense';
  static const amountSale = 'Sale';
  static const amountPaid = 'Paid';
  static const amountReceived = 'Received';
  static const amountReversed = 'Reversed';
  static const amountReturned = 'Returned';
  static const amountAdded = 'Added';
  static const amountReduced = 'Reduced';
  static const offlineLedger =
      'The account list needs the internet. Connect and try again.';

  // Reverse a payment
  static const reversePayment = 'Reverse payment';
  static const reverseTitle = 'Reverse this payment?';
  static const reverseExplain =
      'The money will be returned in the books; the original entry stays visible.';
  static const reasonLabel = 'Why are you reversing it?';
  static const reasonRequired = 'Please write a reason (at least 3 letters)';
  static const reverseConfirm = 'Reverse payment';
  static const reversed = 'Payment reversed';
  static const needsShiftToReverse =
      'This payment was taken from a drawer whose shift is closed. '
      'Open a shift first, then reverse it.';
  static const alreadyReversed = 'This payment was already reversed.';
  static const notAPayment = 'Only payments can be reversed.';

  // Lines saved on this device and not on the server yet
  static const waitingToSyncTag = 'Waiting to sync';
  static const syncNeedsAttentionTag = 'Needs attention';

  // Customer cash payment
  static const customerCashNeedsShiftTitle = 'Open shift first';
  static const customerCashNeedsShiftBody =
      'Cash you receive goes into the drawer. Open a shift first so it is '
      'counted, or take this payment by another method.';

  static const branchMissing =
      'Your branch is not set. Please sign in again.';
  static const offlineReverse =
      'Reversing a payment needs the internet so it is not done twice. '
      'Connect and try again.';

  // Credit at the till
  static const creditBlockedTitle = 'Credit limit reached';
  static String creditBlockedBody({
    required String limit,
    required String owed,
    required String available,
    required String needed,
  }) =>
      'This customer can owe up to $limit. They owe $owed now, so only '
      '$available is left, but this sale needs $needed on credit.';
  static const creditBlockedNoNumbers =
      'This sale is over the customer\'s credit limit.';
  static const allowAnyway = 'Allow anyway';
  static const creditBlockedNoOverride =
      'Ask the owner or a manager to allow this, or take more money now.';
  static const balanceOwes = 'Owes';
  static const creditLimitLabel = 'Limit';
  static const creditLeftLabel = 'Available';
  static const noLimit = 'No limit';

  // Under-paid sales
  static const underpaidNoCustomer =
      'The payment is less than the bill. Take the full amount, or pick a '
      'customer so the rest goes on their account.';
  static const underpaidNeedsCustomer =
      'Pick a customer to put the rest on credit.';
  static const underpaidWithCustomer =
      'The payment is less than the bill. Take the full amount, or add '
      'Credit (Udhaar) for the rest.';
  static String paymentsDoNotMatch(String paid, String due) =>
      'The payments add up to $paid but the bill is $due. They must match.';
  static const underpaidFlagTitle = 'Sold for less than the bill';
  static const underpaidFlagExplain =
      'This sale was made offline and less money was taken than the bill, with '
      'no customer to put the rest on. Check what was really collected and fix '
      'the books.';

  // Dashboard
  static const receivableHint = 'Customers owe you';
  static const payableHint = 'You owe suppliers';

  // Shift
  static const supplierPaymentsFromDrawer = 'Supplier payments from the drawer';
  static const drawerPaymentsCounted =
      'Already counted in Cash Out and Expected Cash above. Payments from the '
      'bank, wallets or your pocket do not touch the drawer.';
  static String supplierPaymentLine(String? supplier, String? note) {
    final who = (supplier == null || supplier.isEmpty) ? 'Supplier' : supplier;
    final tail = (note == null || note.isEmpty) ? '' : ' · $note';
    return 'Paid to $who$tail';
  }

  /// Plain words for backend error codes on payments / reversals.
  ///
  /// The supplier-payment endpoint answers "no open shift" with a plain text
  /// `detail` and no code, so the message is checked too.
  static String? forCode(String? code, [String? message]) {
    final byCode = _byCode(code);
    if (byCode != null) return byCode;
    if (message != null && message.toLowerCase().contains('no open shift')) {
      return needsShiftBody;
    }
    return null;
  }

  static String? _byCode(String? code) => switch (code) {
        'no_open_shift' => needsShiftBody,
        'open_shift_required_to_reverse' => needsShiftToReverse,
        'payment_already_reversed' => alreadyReversed,
        'not_a_reversible_payment' => notAPayment,
        'paid_at_in_future' => futureDate,
        'payment_exceeds_receipt_total' => paidMoreThanTotal,
        _ => null,
      };
}
