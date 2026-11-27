/// How a statement words its figures, a mirror of the server's
/// `statement_view.py`, so the screen reads like the PDF and the public page.
library;

import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/text/statement_text.dart';
import 'package:intl/intl.dart';

abstract final class StatementWording {
  /// A statement is read by the other party: our own words ("drawer",
  /// "owner_pocket") stay inside.
  static const _sources = {
    'drawer': 'Cash',
    'owner_pocket': 'Cash',
    'cash': 'Cash',
    'bank': 'Bank transfer',
    'bank_transfer': 'Bank transfer',
    'easypaisa': 'Easypaisa',
    'jazzcash': 'JazzCash',
    'cheque': 'Cheque',
    'card': 'Card',
    'wallet': 'Wallet',
    'upi': 'UPI',
    'credit': 'Credit',
    'other': 'Other',
  };

  /// How money was paid; empty when the line is not a payment.
  static String source(String? value) =>
      value == null || value.isEmpty ? '' : _sources[value] ?? 'Other';

  static final _day = DateFormat('dd MMM yyyy', 'en_US');
  static final _moment = DateFormat('dd MMM yyyy hh:mm a', 'en_US');

  static String day(DateTime? date) => date == null ? '' : _day.format(date);

  static String generated(DateTime moment) =>
      StatementText.generated(_moment.format(moment.toLocal()));

  /// A bare figure, for the arithmetic of an item line.
  static String figure(Decimal value) =>
      formatMoneyNumber(value, hideZeroDecimals: false);

  /// A unit price: two decimals, more when a purchase cost needs them.
  static String price(Decimal value) {
    final parts = value.abs().toString().split('.');
    final whole = formatMoneyNumber(
      Decimal.parse(parts.first),
      hideZeroDecimals: true,
    );
    final fraction = (parts.length > 1 ? parts[1] : '').padRight(2, '0');
    return '${value < Decimal.zero ? '-' : ''}$whole.$fraction';
  }

  /// Money on its own: "Rs. 1,234.50", "-Rs. 17.00".
  static String money(String currency, Decimal value) => value < Decimal.zero
      ? '-$currency ${figure(-value)}'
      : '$currency ${figure(value)}';

  /// A running amount due; money held in advance is marked "adv".
  static String balance(String currency, Decimal due) => due < Decimal.zero
      ? '${money(currency, -due)} ${StatementText.advanceSuffix}'
      : money(currency, due);

  /// "Payment received: for May (Cash, Ref 12) - REVERSED".
  static String details(StatementRow row) {
    final out = StringBuffer(row.typeLabel);
    if (row.description != null) out.write(': ${row.description}');
    final paidBy = source(row.paymentSource);
    final extra = [
      if (paidBy.isNotEmpty) paidBy,
      if (row.reference != null) StatementText.reference(row.reference!),
    ];
    if (extra.isNotEmpty) out.write(' (${extra.join(', ')})');
    if (row.reversed) out.write(' - ${StatementText.reversed}');
    return '$out';
  }

  /// "detol x 1 @ 100.00 + GST 17.00 = 117.00": the figures add up as printed.
  static String item(StatementItem item) {
    var name = item.name;
    const placeholder = ' (Default)';
    if (name.endsWith(placeholder)) {
      name = name.substring(0, name.length - placeholder.length);
    }
    final out = StringBuffer('$name x ${item.qty} @ ${price(item.unitPrice)}');
    if (item.discount != Decimal.zero) {
      out.write(' - ${StatementText.discount} ${figure(item.discount)}');
    }
    final rounding = item.rounding;
    if (rounding != Decimal.zero) {
      out.write(
        ' ${rounding > Decimal.zero ? '+' : '-'} '
        '${StatementText.rounding} ${figure(rounding.abs())}',
      );
    }
    if (item.tax != Decimal.zero) {
      final tax = '${item.taxLabel ?? StatementText.tax} ${figure(item.tax)}';
      out.write(
        item.taxInclusive ? ' (${StatementText.included} $tax)' : ' + $tax',
      );
    }
    out.write(' = ${figure(item.lineTotal)}');
    return '$out';
  }
}
