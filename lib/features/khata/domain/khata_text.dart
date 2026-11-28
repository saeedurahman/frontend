/// Every sentence the credit (khata) screens show, in one place.
///
/// The app keeps feature text as plain English (see `UserErrorMessage`); keeping
/// the khata wording here means it can be reviewed and translated in one go.
/// Wording rule: short, simple, no accounting words.
abstract final class KhataText {
  // Pay supplier
  static const paySupplierTitle = 'Pay supplier';
  static const unnamedSupplier = 'Supplier (name not saved here yet)';
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
      'The payment is saved on this device and sent when you are back online.';
  static const offlineNotSent =
      'Not paid: the server could not be reached. Your entry is kept. Try '
      'again.';
  static const savedTitle = 'Saved on this device';
  static String balanceAfterSync(String amount) =>
      'You will owe $amount once it syncs';
  static const balanceNotSavedYet =
      'What you owe is not saved on this device yet.';
  static const balanceUnknownOffline =
      'The new balance shows after the next sync.';
  static const onlineOnly = 'This needs internet. Connect and try again.';
  static const onlineOnlyCode = 'online_only_operation';
  static const receivingNeedsInternet =
      'Receiving goods needs internet. Your entries are kept on this screen. '
      'Connect, then confirm.';
  static const offlineAccountNote =
      'From the copy on this device: recent history, all branches.';
  static const offlineAllBranches = 'Supplier figures cover all branches';
  static String waitingPayments(String amount) =>
      '$amount paid here is waiting to sync. Bills update after it syncs.';
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

  static const noPaymentMade =
      'No payment made: none of the items was saved with stock. Nothing was '
      'paid to the supplier.';
  static String paymentCapped(String entered, String paid) =>
      'You entered $entered. Only $paid was paid, the total of the items that '
      'were saved.';

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
  static const openingBalance = 'Balance at the start';
  static const closingBalance = 'Balance at the end';
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
  static const amountGoods = 'Goods received';
  static const amountExpense = 'Expense';
  static const amountSale = 'Credit sale';
  static const amountPaid = 'Paid';
  static const amountReceived = 'Received';
  static const amountReversed = 'Reversed';
  static const amountReturned = 'Returned';
  static const amountAdded = 'Added';
  static const amountReduced = 'Reduced';
  /// At the end of an account this device only holds the recent part of.
  static const olderNeedInternet = 'Older entries need internet';
  static const needsInternetValue = 'needs internet';
  static const offlineLedgerAllBranches =
      'Offline: the entries and balance below cover all branches';

  static const offlineLedger =
      'This account is not saved on this device yet. Connect and try again.';

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
  static const shiftNotYours =
      'That shift belongs to someone else. Open your own shift, or choose '
      'another payment method.';

  // Returns
  static const returnNeedsShiftBody =
      'A return is recorded in your open shift. Open a shift, then confirm '
      'the return.';
  static const returnShiftNotYours =
      'That shift belongs to someone else. Check your own shift, then confirm '
      'the return again.';
  static const moneyComesAs = 'How is the money coming in?';

  static const branchMissing =
      'Your branch is not set. Please sign in again.';
  static const offlineReverse =
      'Reversing a payment needs the internet so it is not done twice. '
      'Connect and try again.';

  // Credit at the till
  static const creditBlockedTitle = 'Credit limit reached';
  static String creditBlockedBody({
    required String limit,
    required String balance,
    required String wouldBe,
  }) =>
      'Credit limit: $limit\nBalance now: $balance\n'
      'After this sale: $wouldBe';
  static const creditOverrideForbidden =
      'You are not allowed to sell over the credit limit. Ask the owner or a '
      'manager.';
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
  static const drawerMovements = 'Cash in and out of the drawer';
  static const drawerMovementsCounted =
      'Already counted in Cash In, Cash Out, Expenses and Expected Cash above. '
      'Money moved by bank, wallet, cheque, card or your pocket does not touch '
      'the drawer.';

  /// What one drawer movement was, from the server's `source` and `type`.
  static String movementLine(String source, String type, String? name) {
    final named = name != null && name.isNotEmpty;
    final supplier = named ? name : 'supplier';
    final customer = named ? name : 'customer';
    return switch (source) {
      'supplier_payment' => 'Paid to $supplier',
      'supplier_payment_reversal' => 'Reversal: payment to $supplier',
      'customer_payment' => 'Received from $customer',
      'customer_payment_reversal' => 'Reversal: payment from $customer',
      'expense' => named ? 'Expense · $name' : 'Expense',
      _ => switch (type) {
          'cash_in' => 'Cash added',
          'expense' => 'Expense',
          _ => 'Cash taken out',
        },
    };
  }

  static const noOpenShiftCode = 'no_open_shift';
  static const shiftNotYoursCode = 'shift_not_yours';
  static const creditLimitCode = 'credit_limit_exceeded';

  /// True for the two refusals that mean "this needs your own open shift".
  /// Every screen answers them with the "Open shift first" prompt.
  static bool needsOwnShift(String? code) =>
      code == noOpenShiftCode || code == shiftNotYoursCode;

  /// Plain words for a backend refusal on payments, sales and reversals.
  /// Decided by the code alone; the server's sentence may change.
  static String? forCode(String? code) => switch (code) {
        noOpenShiftCode => needsShiftBody,
        creditLimitCode => creditBlockedNoNumbers,
        'credit_override_forbidden' => creditOverrideForbidden,
        shiftNotYoursCode => shiftNotYours,
        'open_shift_required_to_reverse' => needsShiftToReverse,
        'payment_already_reversed' => alreadyReversed,
        'not_a_reversible_payment' => notAPayment,
        'paid_at_in_future' => futureDate,
        'payment_exceeds_receipt_total' => paidMoreThanTotal,
        onlineOnlyCode => onlineOnly,
        _ => null,
      };
}
