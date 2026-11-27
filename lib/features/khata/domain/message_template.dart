/// The WhatsApp texts: a template with `{variable}` placeholders.
///
/// A mirror of the server's `khata_templates.py` and `message_values`, so a
/// message reads the same whether the server or this device filled it in.
/// Pure: no widgets, no network.
library;

import 'package:decimal/decimal.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:intl/intl.dart';

abstract final class MessageTemplate {
  static const variables = [
    'party',
    'business',
    'amount',
    'period',
    'opening',
    'charges',
    'payments',
    'oldest_bill',
    'pending_bills',
    'pay_methods',
    'link',
    'phone',
  ];

  static const maxLength = 2000;
  static const maxPendingBills = 10;

  static const defaultStatement =
      'Assalam o Alaikum {party},\n\nAccount statement from {business}\n'
      'Period: {period}\n\nOpening balance: {opening}\nCharges: {charges}\n'
      'Payments received: {payments}\nAmount due now: {amount}\n\n'
      'Pending bills\n{pending_bills}\n\nPlease pay via\n{pay_methods}\n\n'
      'Full statement: {link}\n\nThank you, {business}';

  static const defaultReminder =
      'Assalam o Alaikum {party},\n\nThis is a friendly reminder from '
      '{business}. Your pending balance is {amount}{oldest_bill}.\n\n'
      'Please pay via\n{pay_methods}\n\nStatement: {link}\n\nThank you.';

  /// Messages to a supplier are built in: the saved templates are written for
  /// customers.
  static const supplierStatement =
      'Assalam o Alaikum {party},\n\nAccount statement from {business}\n'
      'Period: {period}\n\nOpening balance: {opening}\nPurchases: {charges}\n'
      'Payments made: {payments}\nAmount we owe now: {amount}\n\n'
      'Pending bills\n{pending_bills}\n\nFull statement: {link}\n\n'
      'Thank you, {business}';

  static const supplierReminder =
      'Assalam o Alaikum {party},\n\nThis is {business}. As per our records '
      'the amount payable to you is {amount}{oldest_bill}. Please confirm it '
      'matches yours.\n\nStatement: {link}\n\nThank you.';

  static final _token = RegExp(r'\{([^{}]*)\}');

  /// Why [template] can't be saved, or null when it can.
  static TemplateProblem? check(String template) {
    if (template.trim().isEmpty) return const TemplateProblem.empty();
    final text = template.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    if (text.length > maxLength) return const TemplateProblem.tooLong();
    final unknown = {
      for (final m in _token.allMatches(text))
        if (!variables.contains(m.group(1))) m.group(1)!,
    }.toList()
      ..sort();
    if (unknown.isNotEmpty) return TemplateProblem.unknown(unknown);
    if (RegExp(r'[{}]').hasMatch(text.replaceAll(_token, ''))) {
      return const TemplateProblem.strayBrace();
    }
    return null;
  }

  static const _payMethods = '{pay_methods}';

  /// A heading ending like this is a sentence of its own (the last two: Urdu
  /// full stop and question mark).
  static const _sentenceEnds = ['.', '!', '?', '\u06d4', '\u061f'];

  /// Without the lines that need `{pay_methods}` and the heading over them.
  ///
  /// A heading is the line above a `{pay_methods}` that stands alone: it has
  /// no variable and does not end a sentence ("Please pay via"). Over a blank
  /// line it must end with a colon.
  static String _withoutPaySection(String text) {
    final lines = text.split('\n');
    final dropped = <int>{};
    for (var i = 0; i < lines.length; i++) {
      if (!lines[i].contains(_payMethods)) continue;
      dropped.add(i);
      if (lines[i].trim() != _payMethods) continue;
      var above = i - 1;
      while (above >= 0 && lines[above].trim().isEmpty) {
        above--;
      }
      if (above < 0) continue;
      final heading = lines[above].trim();
      if (_token.hasMatch(heading) || _sentenceEnds.any(heading.endsWith)) {
        continue;
      }
      if (above == i - 1 || heading.endsWith(':')) {
        dropped.addAll([for (var j = above; j < i; j++) j]);
      }
    }
    return [
      for (var i = 0; i < lines.length; i++)
        if (!dropped.contains(i)) lines[i],
    ].join('\n');
  }

  /// Fills the placeholders. Without payment methods the whole `{pay_methods}`
  /// section is left out; without a link, every line that needs `{link}`.
  /// Values go in once: braces inside a name stay text.
  static String render(String template, Map<String, String> values) {
    var text = template.replaceAll('\r\n', '\n');
    if ((values['pay_methods'] ?? '').isEmpty) text = _withoutPaySection(text);
    if ((values['link'] ?? '').isEmpty) {
      text = text
          .split('\n')
          .where((line) => !line.contains('{link}'))
          .join('\n');
    }
    final filled = text.replaceAllMapped(_token, (m) {
      final name = m.group(1)!;
      return variables.contains(name) ? values[name] ?? '' : m.group(0)!;
    });
    return filled.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
  }
}

enum TemplateProblemKind { empty, tooLong, unknownVariable, strayBrace }

class TemplateProblem {
  const TemplateProblem.empty()
      : kind = TemplateProblemKind.empty,
        unknown = const [];
  const TemplateProblem.tooLong()
      : kind = TemplateProblemKind.tooLong,
        unknown = const [];
  const TemplateProblem.unknown(this.unknown)
      : kind = TemplateProblemKind.unknownVariable;
  const TemplateProblem.strayBrace()
      : kind = TemplateProblemKind.strayBrace,
        unknown = const [];

  final TemplateProblemKind kind;
  final List<String> unknown;
}

/// A bill as a message lists it.
typedef MessageBill = ({
  String name,
  DateTime? date,
  Decimal remaining,
  int ageDays,
});

/// Everything the variables are filled from.
class MessageFacts {
  const MessageFacts({
    required this.partyType,
    required this.party,
    required this.business,
    required this.due,
    this.currency = 'Rs.',
    this.periodLabel = '',
    this.opening,
    this.charges,
    this.payments,
    this.bills = const [],
    this.payMethods = const [],
    this.businessPhone,
  });

  /// From a statement (the fullest source).
  factory MessageFacts.fromStatement(Statement s) => MessageFacts(
        partyType: s.partyType,
        party: s.partyName,
        business: s.businessName,
        currency: s.currency,
        due: s.closingDue,
        periodLabel: s.periodLabel,
        opening: s.openingDue,
        charges: s.charges,
        payments: s.payments,
        bills: [
          for (final o in s.openItems)
            (
              name: o.item.number ?? o.label,
              date: o.item.date,
              remaining: o.item.remaining,
              ageDays: o.item.ageDays,
            ),
        ],
        payMethods: s.paymentInstructions,
        businessPhone: s.businessPhone,
      );

  final PartyType partyType;
  final String party;
  final String business;
  final String currency;

  /// Still to be paid (negative: held in advance).
  final Decimal due;
  final String periodLabel;

  /// Unknown when only the pending bills are on this device.
  final Decimal? opening;
  final Decimal? charges;
  final Decimal? payments;

  /// Oldest first.
  final List<MessageBill> bills;
  final List<PaymentInstruction> payMethods;
  final String? businessPhone;

  /// The server's name for a bill without a number.
  static String documentLabel(String documentType) => switch (documentType) {
        'sale' => 'Credit sale',
        'grn' => 'Goods receipt',
        'expense' => 'Expense bill',
        'opening_balance' => 'Opening balance',
        'udhaar_given' => 'Udhaar given',
        'manual_payable' => 'Goods on credit',
        'adjustment' => 'Adjustment',
        _ => 'Bill',
      };

  static final _money = NumberFormat('#,##0.00', 'en_US');
  static final _day = DateFormat('dd MMM yyyy', 'en_US');

  String _amount(Decimal value) =>
      '$currency ${_money.format(value.abs().toDouble())}';

  Map<String, String> values({String link = ''}) {
    final String amount = due < Decimal.zero
        ? '$currency 0.00 (advance ${_amount(due)})'
        : _amount(due);
    var oldest = '';
    if (bills.isNotEmpty) {
      final first = bills.first;
      oldest = ' (oldest bill: ${first.name}, ${first.ageDays} '
          '${first.ageDays == 1 ? 'day' : 'days'} old)';
    }
    final pending = [
      for (final b in bills.take(MessageTemplate.maxPendingBills))
        '- ${b.name}${b.date == null ? '' : ' (${_day.format(b.date!)})'}: '
            '${_amount(b.remaining)}',
      if (bills.length > MessageTemplate.maxPendingBills)
        '...and ${bills.length - MessageTemplate.maxPendingBills} more',
    ];
    final open = opening;
    final charged = charges;
    final paid = payments;
    return {
      'party': party,
      'business': business,
      'amount': amount,
      'period': periodLabel,
      'opening': open == null
          ? ''
          : open < Decimal.zero
              ? '${_amount(open)} advance'
              : _amount(open),
      'charges': charged == null
          ? ''
          : charged < Decimal.zero
              ? '-${_amount(charged)}'
              : _amount(charged),
      'payments': paid == null ? '' : _amount(paid),
      'oldest_bill': oldest,
      'pending_bills':
          pending.isEmpty ? 'No pending bills' : pending.join('\n'),
      // Empty when none are saved: the template then leaves the section out.
      'pay_methods': payMethods.map((p) => p.line).join('\n'),
      'link': link,
      'phone': businessPhone ?? '',
    };
  }
}
