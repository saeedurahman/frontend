/// The WhatsApp message window.
abstract final class ReminderText {
  static const reminderTitle = 'Send a reminder';
  static const statementTitle = 'Send the statement';
  static const preparing = 'Writing the message…';
  static const messageLabel = 'Message (you can change it)';
  static const resetText = 'Start again';
  static const resetTextHint = 'Throw away your changes';
  static const includeLink = 'Add a link to the full statement';
  static const linkOffline = 'A link needs the internet';
  static const linkNoPermission =
      'Your account is not allowed to create statement links';
  static const creatingLink = 'Creating the link…';
  static String linkExpires(String day) => 'The link works until $day';
  static const linkLinePrefix = 'Statement: ';

  static const phoneLabel = 'Phone number';
  static const phoneHint = 'For example 0300 1234567';
  static const phoneMissing = 'There is no phone number saved. Type it here.';
  static const phoneInvalid = 'This does not look like a phone number';
  static const savePhone = 'Save this number';
  static const phoneNotSaved =
      'You are offline: the number is used for this message only.';

  static const openWhatsApp = 'Open WhatsApp';
  static const openWhatsAppHint = 'Ctrl+Enter';
  static const copyText = 'Copy text';
  static const textCopied = 'Message copied';
  static const emptyMessage = 'The message is empty';
  static const couldNotOpen =
      "WhatsApp couldn't be opened. Copy the message and send it yourself.";
  static const tooLongCopied =
      'The message is long, so it was copied. Paste it in the WhatsApp chat '
      '(Ctrl+V).';

  static const didYouSend = 'Did you send it?';
  static const didYouSendBody =
      'We note the reminder, so you can see when you last asked.';
  static const yesSent = 'Yes, I sent it';
  static const notYet = 'No, go back';
  static const noted = 'Reminder noted';
  static const sentNotNoted =
      'Your account is not allowed to note reminders.';
  static const done = 'Done';

  static const needsInternetOnce =
      'This account has not been loaded on this device yet. Connect to the '
      'internet once to write the message.';
  static const offlineNote =
      'Offline: the amounts are the last ones saved on this device.';
}
