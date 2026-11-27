// WhatsApp reminders and statement texts: the number, the link, the template
// and the preview window.
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/message_template.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/reminder_text.dart';
import 'package:frantend/features/khata/domain/whatsapp_link.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_message_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_message_dialog.dart';

import '../helpers/khata_p1_fakes.dart';

MessageRequest _request({
  String? phone = '0300-1234567',
  MessageKind kind = MessageKind.reminder,
  PartyType type = PartyType.customer,
}) =>
    MessageRequest(
      partyType: type,
      partyId: 'c1',
      name: 'Ahmed Khan',
      phone: phone,
      kind: kind,
    );

class _Harness {
  _Harness(this.repo, this.launcher);

  final FakeKhataRepository repo;
  final FakeLauncher launcher;
  bool? result;

  Uri get url => launcher.launched.single;
}

Future<_Harness> _open(
  WidgetTester tester, {
  MessageRequest? request,
  FakeKhataRepository? repo,
  FakeLauncher? launcher,
  List<String>? keys,
  Size size = const Size(1280, 900),
}) async {
  final harness =
      _Harness(repo ?? FakeKhataRepository(), launcher ?? FakeLauncher());
  await pumpKhata(
    tester,
    Builder(
      builder: (context) => TextButton(
        onPressed: () async {
          harness.result = await showKhataMessageDialog(
            context,
            request ?? _request(),
            repository: harness.repo,
            launcher: harness.launcher,
          );
        },
        child: const Text('open'),
      ),
    ),
    user: keys == null ? null : userWith(keys),
    size: size,
  );
  await tester.tap(find.text('open'));
  await settle(tester, 8);
  return harness;
}

String _text(WidgetTester tester) => tester
    .widget<TextField>(find.byKey(const Key('message-text')))
    .controller!
    .text;

Future<void> _tap(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await settle(tester, 4);
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await settle(tester, 8);
}

void main() {
  group('phone numbers', () {
    test('every common way of writing a Pakistani number', () {
      for (final raw in [
        '0300 1234567',
        '0300-1234567',
        '+92 300 1234567',
        '+92 (0)300 1234567',
        '00923001234567',
        '923001234567',
        '3001234567',
      ]) {
        expect(WhatsAppLink.digits(raw), '923001234567', reason: raw);
      }
    });

    test('another country keeps its own code', () {
      expect(WhatsAppLink.dialCodeFor('ae'), '971');
      expect(WhatsAppLink.digits('050 123 4567', dialCode: '971'),
          '971501234567');
      expect(WhatsAppLink.digits('+44 7700 900123'), '447700900123');
      expect(WhatsAppLink.dialCodeFor(null), '92');
      expect(WhatsAppLink.dialCodeFor('ZZ'), '92');
    });

    test('rubbish is not a number', () {
      for (final raw in [null, '', '  ', 'call me', '12', '+1234567890123456']) {
        expect(WhatsAppLink.digits(raw), isNull, reason: '$raw');
      }
    });
  });

  group('the wa.me link', () {
    test('encodes spaces, new lines, symbols and Urdu', () {
      const message = 'Salam & hello?\nBalance: Rs. 5,000 #1 +2 سلام';
      final url = WhatsAppLink.chat('923001234567', text: message);
      expect(url.host, 'wa.me');
      expect(url.path, '/923001234567');
      final raw = url.toString();
      expect(raw, contains('Salam%20%26%20hello%3F%0ABalance'));
      expect(raw, isNot(contains('+')));
      expect(url.queryParameters.keys, ['text']);
      expect(url.queryParameters['text'], message);
    });

    test('without text it only opens the chat', () {
      expect(
        WhatsAppLink.chat('923001234567').toString(),
        'https://wa.me/923001234567',
      );
    });

    test('knows when a message is too long for a link', () {
      expect(WhatsAppLink.fits(WhatsAppLink.chat('92300', text: 'hi')), isTrue);
      expect(
        WhatsAppLink.fits(WhatsAppLink.chat('92300', text: 'a ' * 900)),
        isFalse,
      );
    });
  });

  group('templates', () {
    test('lines that need a link are left out without one', () {
      const template = 'Hi {party}\n\nStatement: {link}\n\nThanks';
      expect(
        MessageTemplate.render(template, {'party': 'Ali', 'link': ''}),
        'Hi Ali\n\nThanks',
      );
      expect(
        MessageTemplate.render(template, {'party': 'Ali', 'link': 'https://x'}),
        'Hi Ali\n\nStatement: https://x\n\nThanks',
      );
    });

    test('braces inside a value stay text', () {
      expect(
        MessageTemplate.render('{party} owes {amount}', {
          'party': '{amount} Traders',
          'amount': 'Rs. 1',
          'link': '',
        }),
        '{amount} Traders owes Rs. 1',
      );
    });

    test('what cannot be saved', () {
      expect(
        MessageTemplate.check('  ')!.kind,
        TemplateProblemKind.empty,
      );
      expect(
        MessageTemplate.check('x' * 2001)!.kind,
        TemplateProblemKind.tooLong,
      );
      final unknown = MessageTemplate.check('{party} {total} {abc} {total}')!;
      expect(unknown.kind, TemplateProblemKind.unknownVariable);
      expect(unknown.unknown, ['abc', 'total']);
      expect(
        MessageTemplate.check('Hi {party')!.kind,
        TemplateProblemKind.strayBrace,
      );
      for (final t in [
        MessageTemplate.defaultReminder,
        MessageTemplate.defaultStatement,
        MessageTemplate.supplierReminder,
        MessageTemplate.supplierStatement,
      ]) {
        expect(MessageTemplate.check(t), isNull);
      }
    });

    test('money, bills and payment details are filled like the server', () {
      final values = MessageFacts.fromStatement(
        Statement.fromJson(statementJson()),
      ).values();
      expect(values['amount'], 'Rs. 12,500.00');
      expect(values['opening'], 'Rs. 8,000.00');
      expect(values['oldest_bill'], ' (oldest bill: Opening balance, 45 days old)');
      expect(
        values['pending_bills'],
        '- Opening balance (13 Oct 2026): Rs. 6,000.00\n'
        '- INV-0012 (03 Nov 2026): Rs. 6,500.00',
      );
      expect(values['pay_methods'], contains('Meezan Bank'));
      expect(values['pay_methods'], contains('0345-1112223'));
    });

    test('advance, many bills and nothing saved', () {
      final values = MessageFacts(
        partyType: PartyType.customer,
        party: 'Ali',
        business: 'Shop',
        due: dec('-300'),
        bills: [
          for (var i = 0; i < 13; i++)
            (name: 'INV-$i', date: null, remaining: dec('1'), ageDays: 1),
        ],
      ).values();
      expect(values['amount'], 'Rs. 0.00 (advance Rs. 300.00)');
      expect(values['pending_bills'], endsWith('...and 3 more'));
      expect(values['oldest_bill'], contains('1 day old'));
      expect(values['pay_methods'], '');
    });
  });

  group('no payment details saved', () {
    String render(String template, {String pay = '', String link = ''}) =>
        MessageTemplate.render(
          template,
          {'party': 'Ali', 'pay_methods': pay, 'link': link},
        );

    test('the default texts have no empty "Please pay via" block', () {
      for (final template in [
        MessageTemplate.defaultReminder,
        MessageTemplate.defaultStatement,
      ]) {
        final empty = MessageTemplate.render(
          template,
          MessageFacts(
            partyType: PartyType.customer,
            party: 'Ali',
            business: 'Shop',
            due: dec('100'),
          ).values(),
        );
        expect(empty, isNot(contains('Please pay via')));
        expect(empty, isNot(contains('\n\n\n')));
        expect(empty, contains('Thank you'));
        expect(
          render(template, pay: 'Cheque payable to: Shop'),
          contains('Please pay via\nCheque payable to: Shop'),
        );
      }
    });

    // The same two rules as the server.
    test('which heading goes with the section', () {
      expect(render('Hi\n\nPay here\n{pay_methods}\n\nBye'), 'Hi\n\nBye');
      expect(render('Hi\n\nPay here:\n\n{pay_methods}\nBye'), 'Hi\n\nBye');
      expect(
        render('Hi\n\nSee you.\n{pay_methods}\nBye'),
        'Hi\n\nSee you.\nBye',
      );
      expect(
        render('Dear {party}\n{pay_methods}\nBye'),
        'Dear Ali\nBye',
      );
      expect(
        render('Kind words\n\n{pay_methods}\nBye'),
        'Kind words\n\nBye',
      );
      expect(render('Hi\nPay via: {pay_methods}\nBye'), 'Hi\nBye');
    });

    test('payment lines read as on the server', () {
      String line(
        PaymentKind kind, {
        String? number,
        String? bank,
        String? note,
      }) =>
          PaymentInstruction(
            kind: kind,
            title: 'Madina Store',
            accountNumber: number,
            bankName: bank,
            note: note,
          ).line;

      expect(
        line(
          PaymentKind.bank,
          number: 'PK36SCBL0000001123456702',
          bank: 'HBL',
        ),
        'Bank: HBL, Title: Madina Store, IBAN: PK36SCBL0000001123456702',
      );
      expect(
        line(PaymentKind.bank, number: '0012-3456789'),
        'Bank transfer, Title: Madina Store, Account: 0012-3456789',
      );
      expect(
        line(PaymentKind.easypaisa, number: '0300-1234567'),
        'Easypaisa: 0300-1234567, Title: Madina Store',
      );
      expect(
        line(
          PaymentKind.jazzcash,
          number: '0301-1234567',
          note: 'send slip',
        ),
        'JazzCash: 0301-1234567, Title: Madina Store (send slip)',
      );
      expect(line(PaymentKind.cheque), 'Cheque payable to: Madina Store');
    });
  });

  group('the message window', () {
    testWidgets('writes the reminder, opens WhatsApp and notes it',
        (tester) async {
      final h = await _open(tester);
      final text = _text(tester);
      expect(text, contains('Ahmed Khan'));
      expect(text, contains('Madina General Store'));
      expect(text, contains('Rs. 12,500.00'));
      // A reminder starts without a link, so its line is not there.
      expect(text, isNot(contains('Statement:')));
      expect(find.byKey(const Key('message-phone')), findsNothing);

      await _tap(tester, 'message-open-whatsapp');
      expect(h.url.path, '/923001234567');
      expect(h.url.queryParameters['text'], text);
      expect(find.text(ReminderText.didYouSend), findsOneWidget);
      expect(h.repo.followupCalls, isEmpty);

      await _tap(tester, 'message-yes-sent');
      final call = h.repo.followupCalls.single;
      expect(call.kind, FollowupKind.reminder);
      expect(call.channel, 'whatsapp');
      expect(call.message, text);
      expect(find.text(ReminderText.noted), findsOneWidget);
      await tester.tap(find.text(ReminderText.done));
      await settle(tester);
      expect(h.result, isTrue);
    });

    testWidgets('changed text is what gets sent; "not yet" keeps it',
        (tester) async {
      final h = await _open(tester);
      await tester.enterText(
        find.byKey(const Key('message-text')),
        'My own words',
      );
      await tester.pump();
      await _tap(tester, 'message-open-whatsapp');
      expect(h.url.queryParameters['text'], 'My own words');
      await _tap(tester, 'message-not-sent');
      expect(_text(tester), 'My own words');
      expect(h.repo.followupCalls, isEmpty);
      await _tap(tester, 'message-reset');
      expect(_text(tester), contains('friendly reminder'));
    });

    testWidgets('no phone: asks for it, saves it, then opens', (tester) async {
      final h = await _open(tester, request: _request(phone: null));
      expect(find.byKey(const Key('message-phone')), findsOneWidget);
      await _tap(tester, 'message-open-whatsapp');
      expect(h.launcher.launched, isEmpty);
      expect(find.text(ReminderText.phoneMissing), findsWidgets);

      await tester.enterText(find.byKey(const Key('message-phone')), '12');
      await tester.pump();
      await _tap(tester, 'message-save-phone');
      expect(find.text(ReminderText.phoneInvalid), findsOneWidget);
      expect(h.repo.phoneCalls, isEmpty);

      await tester.enterText(
        find.byKey(const Key('message-phone')),
        '0345 7654321',
      );
      await tester.pump();
      await _tap(tester, 'message-save-phone');
      expect(h.repo.phoneCalls.single.phone, '+923457654321');
      expect(find.byKey(const Key('message-phone')), findsNothing);
      await _tap(tester, 'message-open-whatsapp');
      expect(h.url.path, '/923457654321');
    });

    testWidgets('offline: saved figures, no link, number used once',
        (tester) async {
      final repo = FakeKhataRepository()
        ..isOnline = false
        ..offlineSince = DateTime(2026, 11, 27, 8);
      final h = await _open(tester, repo: repo, request: _request(phone: ''));
      expect(find.text(ReminderText.offlineNote), findsOneWidget);
      expect(find.text(ReminderText.linkOffline), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('message-phone')),
        '03001234567',
      );
      await tester.pump();
      await _tap(tester, 'message-save-phone');
      expect(find.text(ReminderText.phoneNotSaved), findsOneWidget);
      await _tap(tester, 'message-open-whatsapp');
      await _tap(tester, 'message-yes-sent');
      expect(h.repo.phoneCalls, isEmpty);
      expect(h.repo.linkCalls, isEmpty);
      expect(h.repo.followupCalls, hasLength(1));
    });

    testWidgets('a statement text carries its link, which can be removed',
        (tester) async {
      final h = await _open(
        tester,
        request: _request(kind: MessageKind.statement),
      );
      expect(_text(tester), contains('https://shop.example/st/abc123'));
      expect(h.repo.linkCalls, hasLength(1));
      await _tap(tester, 'message-include-link');
      expect(_text(tester), isNot(contains('https://')));
      await _tap(tester, 'message-include-link');
      expect(_text(tester), contains('https://shop.example/st/abc123'));
      // The same link is used again.
      expect(h.repo.linkCalls, hasLength(1));
    });

    testWidgets('when the link fails the text goes without it', (tester) async {
      final repo = FakeKhataRepository()
        ..linkFailure = const ServerFailure('Links are not available');
      await _open(
        tester,
        repo: repo,
        request: _request(kind: MessageKind.statement),
      );
      expect(find.text('Links are not available'), findsOneWidget);
      expect(_text(tester), contains('Ahmed Khan'));
      expect(_text(tester), isNot(contains('https://')));
    });

    testWidgets('offline statement: text without link', (tester) async {
      final repo = FakeKhataRepository()
        ..isOnline = false
        ..offlineSince = DateTime(2026, 11, 27, 8);
      await _open(
        tester,
        repo: repo,
        request: _request(kind: MessageKind.statement),
      );
      expect(_text(tester), contains('Rs. 12,500.00'));
      expect(_text(tester), isNot(contains('Full statement:')));
    });

    testWidgets('with only the pending bills saved, a reminder still works',
        (tester) async {
      final repo = FakeKhataRepository()
        ..statementAnswer =
            ((_) => const Left(NetworkFailure('No saved statement')))
        ..bills = openItemsOf([openItem('s1', number: 'INV-9', total: '750')]);
      await _open(tester, repo: repo);
      expect(_text(tester), contains('Rs. 750.00'));
      expect(_text(tester), contains('INV-9'));
    });

    testWidgets('nothing saved at all: says so', (tester) async {
      final repo = FakeKhataRepository()
        ..statementAnswer =
            ((_) => const Left(NetworkFailure('No saved statement')))
        ..billsFailure = const NetworkFailure('No saved bills');
      await _open(tester, repo: repo);
      expect(
        find.byKey(const ValueKey('message-unavailable')),
        findsOneWidget,
      );
    });

    testWidgets('permissions: no link and no note', (tester) async {
      final h = await _open(
        tester,
        keys: [Perm.khataView],
        request: _request(kind: MessageKind.statement),
      );
      expect(find.text(ReminderText.linkNoPermission), findsOneWidget);
      expect(h.repo.linkCalls, isEmpty);
      await _tap(tester, 'message-open-whatsapp');
      await _tap(tester, 'message-yes-sent');
      expect(h.repo.followupCalls, isEmpty);
      expect(find.text(ReminderText.sentNotNoted), findsOneWidget);
    });

    testWidgets('WhatsApp not opening is explained', (tester) async {
      await _open(tester, launcher: FakeLauncher(opens: false));
      await _tap(tester, 'message-open-whatsapp');
      expect(find.text(ReminderText.couldNotOpen), findsOneWidget);
      expect(find.text(ReminderText.didYouSend), findsNothing);
    });

    testWidgets('a very long message is copied and only the chat opens',
        (tester) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      final h = await _open(tester);
      final long = 'word ' * 500;
      await tester.enterText(find.byKey(const Key('message-text')), long);
      await tester.pump();
      await _tap(tester, 'message-open-whatsapp');
      expect(copied, long.trim());
      expect(h.url.toString(), 'https://wa.me/923001234567');
      expect(find.text(ReminderText.tooLongCopied), findsOneWidget);
    });

    testWidgets('a supplier gets the supplier wording', (tester) async {
      await _open(
        tester,
        request: _request(type: PartyType.supplier),
      );
      expect(_text(tester), contains('payable to you'));
    });

    for (final width in [700.0, 1920.0]) {
      testWidgets('fits at ${width.toInt()} px', (tester) async {
        await _open(
          tester,
          size: Size(width, 640),
          request: _request(phone: null),
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
