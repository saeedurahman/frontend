/// Words shared by the khata screens.
///
/// The app keeps feature text as plain English in one class per area (see
/// `KhataText`), so everything can be translated in one pass.
abstract final class KhataUiText {
  static const toReceive = 'To receive';
  static const toReceiveHint = 'Customers owe you';
  static const toPay = 'To pay';
  static const toPayHint = 'You owe suppliers';

  static String customerCount(int n) => n == 1 ? '1 customer' : '$n customers';
  static String supplierCount(int n) => n == 1 ? '1 supplier' : '$n suppliers';

  static const allBuckets = 'All';
  static String bucketLabel(String range) => '$range days';

  static String oldestBill(String days) => 'Oldest bill $days';
  static String remindedAgo(String when) => 'Reminded $when';
  static const neverReminded = 'Not reminded yet';
  static String promised(String day) => 'Promised $day';
  static String promisePassed(String day) => 'Promise passed: $day';

  static String asOf(String time) => 'Offline · as of $time';
  static const offlineShort = 'Offline';
  static const retry = 'Try again';
  static const cancel = 'Cancel';
  static const save = 'Save';
  static const close = 'Close';
  static const somethingWrong = "That didn't work";
}

/// The khata hub screen.
abstract final class HubText {
  static const title = 'Khata';
  static const subtitle = 'Who owes you, and who you owe';
  static const tabCustomers = 'Customers owe me';
  static const tabSuppliers = 'I owe suppliers';

  static const searchHint = 'Search name or phone  (Ctrl+F)';
  static const clearSearch = 'Clear search';
  static const sortLabel = 'Sort';
  static const sortAmount = 'Amount';
  static const sortOldest = 'Oldest';
  static const sortName = 'Name';
  static const refresh = 'Refresh';

  static const remind = 'Remind on WhatsApp';
  static const recordPayment = 'Record payment';
  static const paySupplier = 'Pay supplier';
  static const statement = 'Statement';
  static const addPromise = 'Add promise';
  static const moreActions = 'More actions';

  static const emptyCustomersTitle = 'Nobody owes you money';
  static const emptyCustomersBody =
      'When you sell on credit or give udhaar, the customer shows up here.';
  static const emptySuppliersTitle = 'You are all paid up';
  static const emptySuppliersBody =
      'When you buy on credit, the supplier shows up here.';
  static const emptyFilterTitle = 'Nothing matches';
  static const emptyFilterBody = 'Try another name or show all ages.';
  static const clearFilters = 'Clear filters';

  static const offlineNoCopy =
      'This list has not been opened on this device yet. Connect to the '
      'internet once to see it here, even offline.';
  static const loadingMore = 'Loading more…';
  static const loadMoreFailed = "Couldn't load more";
  static const paymentNeedsAccount =
      "Couldn't open this account. Open the customer to record the payment.";
  static const openingAccount = 'Opening the account…';

  static String shownOf(int shown, int total) =>
      shown >= total ? '$total shown' : '$shown of $total shown';
}

/// The promise and note dialogs, and the party page timeline.
abstract final class FollowupText {
  static const promiseTitle = 'Promise to pay';
  static const promiseHelp = 'When did they say they will pay?';
  static const promiseDate = 'Promised date';
  static const pickDate = 'Pick a date';
  static const tomorrow = 'Tomorrow';
  static const inAWeek = 'In 1 week';
  static const inAMonth = 'In 1 month';
  static const amountOptional = 'Amount (optional)';
  static const noteOptional = 'Note (optional)';
  static const savePromise = 'Save promise';
  static const promiseSaved = 'Promise saved';
  static const dateRequired = 'Pick the promised date';
  static const amountInvalid = 'Enter a valid amount, or leave it empty';

  static const noteTitle = 'Add a note';
  static const noteLabel = 'Note';
  static const noteRequired = 'Write the note first';
  static const saveNote = 'Save note';
  static const noteSaved = 'Note saved';

  static const savedOffline =
      'Saved on this device. It will be sent when you are online.';
}
