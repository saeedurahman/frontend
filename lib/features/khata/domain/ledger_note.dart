/// The user's own words on a ledger row.
///
/// How money was paid is in `payment_source` and its number in `reference_no`;
/// the screens word that from those fields. Rows this device received before the
/// server stopped writing it still carry the generated text in `notes`:
///
/// * `Payment received via <source>[ | Ref: <reference>][ | <note>]`
/// * `Reversal of payment: <reason>`
///
/// Only those two shapes are removed (the server does the same when it reads old
/// rows). Anything else is shown as it is.
abstract final class LedgerNote {
  static final _paymentHead = RegExp(
    r'^Payment received via (?:bank_transfer|bank|card|cash|cheque|credit|'
    r'drawer|easypaisa|jazzcash|other|owner_pocket|upi|wallet)(?= \| |$)',
  );
  static const _referencePart = ' | Ref: ';
  static const _reversalHead = 'Reversal of payment:';

  /// [type] is the row's `entry_type`. Very old payments have their reference
  /// only inside the text; it is returned from there.
  static ({String? note, String? reference}) read(
    String type,
    String? notes, {
    String? reference,
  }) {
    var text = (notes ?? '').trim();
    var number = reference;
    if (type == 'reversal' && text.startsWith(_reversalHead)) {
      text = text.substring(_reversalHead.length);
    } else if (type == 'payment') {
      final head = _paymentHead.firstMatch(text);
      if (head != null) {
        var rest = text.substring(head.end);
        if (rest.startsWith(_referencePart)) {
          final after = rest.substring(_referencePart.length);
          if (number == null || number.isEmpty) {
            final end = after.indexOf(' | ');
            number = end < 0 ? after : after.substring(0, end);
            rest = end < 0 ? '' : after.substring(end);
          } else if (after == number || after.startsWith('$number | ')) {
            rest = after.substring(number.length);
          }
        }
        text = rest.startsWith(' | ') ? rest.substring(3) : rest;
      }
    }
    text = text.trim();
    return (note: text.isEmpty ? null : text, reference: number);
  }
}
