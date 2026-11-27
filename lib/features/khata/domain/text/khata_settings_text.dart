import 'package:frantend/features/khata/domain/message_template.dart';

/// Settings > Payment details and Settings > Khata messages.
abstract final class KhataSettingsText {
  // Shared
  static const saved = 'Saved';
  static const saving = 'Saving...';
  static const save = 'Save changes';
  static const cancel = 'Cancel';
  static const retry = 'Try again';
  static const loadFailed = 'Could not load the settings';
  static const offline =
      'You are offline. Connect to the internet and try again.';
  static const noPermission = 'Your account is not allowed to change this';

  // Payment details
  static const paymentsTitle = 'Payment details';
  static const paymentsSubtitle =
      'Shown on statements and in WhatsApp messages, so customers know how to '
      'pay you. The first one is listed first.';
  static const add = 'Add payment method';
  static String limit(int max) => 'You can add up to $max payment methods';
  static const emptyTitle = 'Tell customers how to pay you';
  static const emptyMessage =
      'Add your bank account, Easypaisa, JazzCash or cheque instructions.';
  static const addTitle = 'Add payment method';
  static const editTitle = 'Edit payment method';
  static const kind = 'Type';
  static const accountTitle = 'Account title';
  static const chequeTitle = 'Cheque payable to';
  static const accountNumber = 'Account number or IBAN';
  static const mobileNumber = 'Mobile account number';
  static const bankName = 'Bank name (optional)';
  static const note = 'Note (optional)';
  static const titleRequired = 'Enter the name on the account';
  static const numberRequired = 'Enter the account number';
  static const done = 'Save';
  static const edit = 'Edit';
  static const remove = 'Remove';
  static const moveUp = 'Move up';
  static const moveDown = 'Move down';
  static const drag = 'Drag to reorder';
  static String removeTitle(String name) => 'Remove "$name"?';
  static const removeMessage =
      'It will no longer appear on statements or messages.';

  // Khata messages
  static const messagesTitle = 'Khata messages';
  static const messagesSubtitle =
      'The words sent on WhatsApp to customers. Suppliers get a fixed, '
      'polite message.';
  static const reminderTab = 'Reminder';
  static const statementTab = 'Statement';
  static const templateLabel = 'Message';
  static const variablesHint =
      'Tap to add. Each one is filled in when the message is sent.';
  static const reset = 'Reset to default';
  static const preview = 'Preview';
  static const previewHint = 'With a sample customer';
  static const choices = 'Statements and terms';
  static const showItems = 'Show items in statements';
  static const showItemsHint =
      'List what was bought under each bill on detailed statements';
  static const terms = 'Days customers get to pay';
  static const termsHint =
      '0 means a bill is due the day it is made. Used for overdue days.';
  static const termsInvalid = 'Enter a number from 0 to 3650';
  static const samplePartyName = 'Ali Traders';
  static const sampleBusinessName = 'Your shop';
  static const sampleLink = 'https://example.com/st/sample';
  static const samplePeriod = 'This month';

  static String variable(String name) => switch (name) {
        'party' => 'Customer name',
        'business' => 'Shop name',
        'amount' => 'Amount due',
        'period' => 'Period',
        'opening' => 'Opening balance',
        'charges' => 'Charges',
        'payments' => 'Payments',
        'oldest_bill' => 'Oldest bill',
        'pending_bills' => 'Pending bills',
        'pay_methods' => 'How to pay',
        'link' => 'Statement link',
        'phone' => 'Shop phone',
        _ => name,
      };

  static String problem(TemplateProblem p) => switch (p.kind) {
        TemplateProblemKind.empty =>
          'Write a message, or reset to the default.',
        TemplateProblemKind.tooLong =>
          'Use ${MessageTemplate.maxLength} characters or fewer.',
        TemplateProblemKind.unknownVariable =>
          'Unknown: ${p.unknown.map((v) => '{$v}').join(', ')}. '
              'Use the buttons below the message.',
        TemplateProblemKind.strayBrace => 'Check the { } brackets.',
      };
}
