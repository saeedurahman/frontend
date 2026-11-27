// The statement screen: periods, detail, the preview and what can be done
// with it.
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/platform/file_share_service.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/statement_period.dart';
import 'package:frantend/features/khata/domain/text/statement_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_statement_cubit.dart';
import 'package:frantend/features/khata/presentation/pages/khata_statement_page.dart';

import '../helpers/khata_p1_fakes.dart';

class _Screen {
  _Screen(this.repo, this.files, this.printer, this.launcher);

  final FakeKhataRepository repo;
  final FakeFiles files;
  final FakePrinter printer;
  final FakeLauncher launcher;
  late KhataStatementCubit cubit;
}

Future<_Screen> _open(
  WidgetTester tester, {
  FakeKhataRepository? repo,
  FakeFiles? files,
  FakePrinter? printer,
  FileShareService? share,
  List<String>? keys,
  Size size = const Size(1366, 900),
}) async {
  final f = files ?? FakeFiles();
  final screen = _Screen(
    repo ?? FakeKhataRepository(),
    f,
    printer ?? FakePrinter(),
    FakeLauncher(),
  );
  await pumpKhata(
    tester,
    KhataStatementPage(
      partyType: PartyType.customer,
      partyId: 'c1',
      repository: screen.repo,
      launcher: screen.launcher,
      createCubit: () => screen.cubit = KhataStatementCubit(
        repository: screen.repo,
        files: f,
        printer: screen.printer,
        share: share ?? DesktopFileShareService(f),
        partyType: PartyType.customer,
        partyId: 'c1',
        branchId: 'b1',
        clock: () => khataNow,
      ),
    ),
    user: keys == null ? null : userWith(keys),
    size: size,
  );
  await settle(tester, 8);
  return screen;
}

Future<void> _tap(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await settle(tester);
}

bool _enabled(WidgetTester tester, String id) =>
    tester
        .widget<ButtonStyleButton>(
          find.byWidgetPredicate((w) => w.key == Key('statement-$id')),
        )
        .onPressed !=
    null;

void main() {
  group('periods', () {
    ({DateTime? from, DateTime? to}) range(
      StatementPeriod p, [
      DateTime? now,
    ]) =>
        p.range(now ?? khataNow);

    test('the dates each chip asks for', () {
      expect(range(StatementPeriod.thisMonth),
          (from: DateTime(2026, 11), to: null));
      expect(range(StatementPeriod.lastMonth),
          (from: DateTime(2026, 10), to: DateTime(2026, 10, 31)));
      expect(range(StatementPeriod.last3Months),
          (from: DateTime(2026, 9), to: null));
      expect(range(StatementPeriod.thisYear),
          (from: DateTime(2026), to: null));
      expect(range(StatementPeriod.all), (from: null, to: null));
    });

    test('across a new year', () {
      final january = DateTime(2027, 1, 15);
      expect(range(StatementPeriod.lastMonth, january),
          (from: DateTime(2026, 12), to: DateTime(2026, 12, 31)));
      expect(range(StatementPeriod.last3Months, january),
          (from: DateTime(2026, 11), to: null));
    });

    test('custom: an end of today is left to the server', () {
      expect(
        StatementPeriod.custom.range(
          khataNow,
          customFrom: DateTime(2026, 11, 1),
          customTo: DateTime(2026, 11, 27),
        ),
        (from: DateTime(2026, 11, 1), to: null),
      );
      expect(
        StatementPeriod.custom
            .range(
              khataNow,
              customFrom: DateTime(2026, 11, 1),
              customTo: DateTime(2026, 11, 10),
            )
            .to,
        DateTime(2026, 11, 10),
      );
    });
  });

  testWidgets('shows this month, as paper, for the branch', (tester) async {
    final s = await _open(tester);
    final call = s.repo.statementCalls.single;
    expect(call.from, DateTime(2026, 11));
    expect(call.to, isNull);
    expect(call.detail, 'summary');
    expect(call.branchId, 'b1');
    expect(find.byKey(const Key('statement-header')), findsOneWidget);
    expect(find.text('Madina General Store'), findsWidgets);
    expect(find.textContaining('Ahmed Khan'), findsWidgets);
    expect(find.byKey(const ValueKey('statement-row-r1')), findsOneWidget);
    expect(find.textContaining('12,500'), findsWidgets);
    expect(find.text('Basmati rice 5kg'), findsNothing);
  });

  testWidgets('every chip loads its period', (tester) async {
    final s = await _open(tester);
    for (final p in [
      StatementPeriod.lastMonth,
      StatementPeriod.last3Months,
      StatementPeriod.thisYear,
      StatementPeriod.all,
      StatementPeriod.thisMonth,
    ]) {
      await _tap(tester, ValueKey('period-${p.name}'));
      final call = s.repo.statementCalls.last;
      final expected = p.range(khataNow);
      expect(call.from, expected.from, reason: p.name);
      expect(call.to, expected.to, reason: p.name);
    }
    final calls = s.repo.statementCalls.length;
    await _tap(tester, const ValueKey('period-thisMonth'));
    expect(s.repo.statementCalls, hasLength(calls));
  });

  testWidgets('custom asks for the dates', (tester) async {
    final s = await _open(tester);
    await _tap(tester, const ValueKey('period-custom'));
    expect(find.text(StatementText.pickDates), findsOneWidget);
    // Cancelled: nothing changes.
    await tester.tap(find.byTooltip('Close'));
    await settle(tester);
    expect(s.cubit.state.period, StatementPeriod.thisMonth);
    await s.cubit.setPeriod(
      StatementPeriod.custom,
      from: DateTime(2026, 10, 5),
      to: DateTime(2026, 10, 20),
    );
    await settle(tester);
    expect(find.byKey(const Key('statement-custom-dates')), findsOneWidget);
    expect(s.repo.statementCalls.last.from, DateTime(2026, 10, 5));
    expect(s.repo.statementCalls.last.to, DateTime(2026, 10, 20));
  });

  testWidgets('detailed shows the items', (tester) async {
    final s = await _open(tester);
    await tester.tap(find.text(StatementText.detailed));
    await settle(tester);
    expect(s.repo.statementCalls.last.detail, 'detailed');
    expect(find.textContaining('Basmati rice 5kg'), findsOneWidget);
    await tester.tap(find.text(StatementText.summary));
    await settle(tester);
    expect(find.textContaining('Basmati rice 5kg'), findsNothing);
  });

  group('the same words as the PDF', () {
    Map<String, dynamic> body() => statementJson(detail: 'detailed')
      ..['rows'] = [
        {
          'id': 'r1',
          'date': '2026-11-03',
          'document_number': 'INV-0012',
          'type_label': 'Credit sale',
          'debit': '327.60',
          'credit': '0.00',
          'amount_due': '14500.00',
          'items': [
            {
              'name': 'detol (Default)',
              'qty': '1',
              'unit_price': '100.00',
              'tax_amount': '17.00',
              'tax_label': 'GST',
              'tax_inclusive': false,
              'line_total': '117.00',
            },
            {
              'name': 'soap',
              'qty': '2',
              'unit_price': '100.00',
              'discount': '20.00',
              'tax_amount': '30.60',
              'tax_label': 'GST',
              'line_total': '210.60',
            },
            {
              'name': 'oil',
              'qty': '1',
              'unit_price': '117.00',
              'tax_amount': '17.00',
              'tax_label': 'GST',
              'tax_inclusive': true,
              'line_total': '117.00',
            },
            {
              'name': 'wire',
              'qty': '3',
              'unit_price': '0.3333',
              'rounding': '0.01',
              'line_total': '1.01',
            },
          ],
        },
        {
          'id': 'r2',
          'date': '2026-11-20',
          'type_label': 'Payment received',
          'description': 'for May',
          'payment_source': 'drawer',
          'reference': '12',
          'reversed': true,
          'debit': '0.00',
          'credit': '2000.00',
          'amount_due': '-300.00',
        },
      ];

    Future<void> open(WidgetTester tester, Map<String, dynamic> json) async {
      await _open(
        tester,
        repo: FakeKhataRepository()..statementAnswer = (_) => Right(json),
        size: const Size(1366, 2400),
      );
    }

    testWidgets('cash, item lines with tax, no "Default"', (tester) async {
      await open(tester, body());
      for (final text in [
        'detol x 1 @ 100.00 + GST 17.00 = 117.00',
        'soap x 2 @ 100.00 - discount 20.00 + GST 30.60 = 210.60',
        'oil x 1 @ 117.00 (incl. GST 17.00) = 117.00',
        'wire x 3 @ 0.3333 + rounding 0.01 = 1.01',
        'Payment received: for May (Cash, Ref 12) - REVERSED',
        'Period: 01 Nov 2026 - 27 Nov 2026',
        'Phone: 0300-1234567',
        '03 Nov 2026',
        'Rs. 327.60',
        'Rs. 300.00 adv',
        'Age (days)',
        'Total pending',
        'Rs. 12,500.00',
        StatementText.oldestFirst,
      ]) {
        expect(find.text(text), findsWidgets, reason: text);
      }
      expect(find.textContaining('Default'), findsNothing);
      expect(find.textContaining('drawer'), findsNothing);
      expect(find.textContaining('Generated '), findsOneWidget);
      expect(find.text(StatementText.payVia), findsOneWidget);
      expect(
        find.textContaining('Bank: Meezan Bank, Title: Madina General Store'),
        findsOneWidget,
      );
    });

    testWidgets('no payment details: no "Please pay via" block',
        (tester) async {
      await open(tester, body()..['payment_instructions'] = <Object>[]);
      expect(find.text(StatementText.payVia), findsNothing);
    });

    testWidgets('nothing open: says so, and shows an advance', (tester) async {
      await open(
        tester,
        body()
          ..['open_items'] = <Object>[]
          ..['advance_amount'] = '300.00',
      );
      expect(find.text(StatementText.noBills), findsOneWidget);
      expect(find.text('Advance held: Rs. 300.00'), findsOneWidget);
      expect(find.text(StatementText.totalPending), findsNothing);
    });

    testWidgets('long figures fit a narrow window', (tester) async {
      final json = body();
      (json['rows'] as List).cast<Map<String, dynamic>>().first
        ..['debit'] = '123456789.00'
        ..['amount_due'] = '-123456789.00';
      for (final width in [700.0, 800.0, 1100.0]) {
        await _open(
          tester,
          repo: FakeKhataRepository()..statementAnswer = (_) => Right(json),
          size: Size(width, 2400),
        );
        expect(tester.takeException(), isNull, reason: '$width');
      }
    });
  });

  testWidgets('save asks where, and offers the folder', (tester) async {
    final s = await _open(tester);
    await _tap(tester, const Key('statement-save'));
    expect(s.files.saved.single.name,
        'Statement - Ahmed Khan - 2026-11-27.pdf');
    expect(find.textContaining('Saved to'), findsOneWidget);
    await tester.tap(find.text(StatementText.openFolder));
    await settle(tester);
    expect(s.files.opened, [s.files.chosen]);
    // The same PDF serves the next action.
    await _tap(tester, const Key('statement-print'));
    expect(s.repo.pdfCalls, 1);
    expect(s.printer.jobs.single.paper, 'a4');
    expect(s.printer.jobs.single.dialog, isTrue);
    // Another period needs a new one.
    await _tap(tester, const ValueKey('period-all'));
    await _tap(tester, const Key('statement-print'));
    expect(s.repo.pdfCalls, 2);
  });

  testWidgets('a cancelled save says nothing', (tester) async {
    final s = await _open(tester, files: FakeFiles()..chosen = null);
    await _tap(tester, const Key('statement-save'));
    expect(s.files.saved, isEmpty);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('Ctrl+S saves and Ctrl+P prints', (tester) async {
    final s = await _open(tester);
    Future<void> shortcut(LogicalKeyboardKey key) async {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(key);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await settle(tester);
    }

    await shortcut(LogicalKeyboardKey.keyS);
    await shortcut(LogicalKeyboardKey.keyP);
    expect(s.files.saved, hasLength(1));
    expect(s.printer.jobs, hasLength(1));
  });

  testWidgets('on a computer, share saves the file and shows the folder',
      (tester) async {
    final s = await _open(tester);
    expect(find.byKey(const Key('statement-attach-hint')), findsOneWidget);
    expect(find.text(StatementText.attachHint), findsOneWidget);
    await _tap(tester, const Key('statement-share'));
    expect(s.files.saved, hasLength(1));
    expect(s.files.opened.single, startsWith(r'C:\Downloads'));
    expect(find.textContaining('Attach it in your WhatsApp chat'),
        findsOneWidget);
  });

  testWidgets('on a phone, share hands the file to another app',
      (tester) async {
    final phone = FakePhoneShare();
    final s = await _open(tester, share: phone);
    expect(find.byKey(const Key('statement-attach-hint')), findsNothing);
    await _tap(tester, const Key('statement-share'));
    expect(phone.shared.single, endsWith('.pdf'));
    expect(s.files.saved, isEmpty);
    expect(find.text(StatementText.sharedDone), findsOneWidget);
  });

  testWidgets('copy link puts it on the clipboard', (tester) async {
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
    final repo = FakeKhataRepository()
      ..linkFailure = const NetworkFailure('Connection lost');
    final s = await _open(tester, repo: repo);
    await _tap(tester, const Key('statement-copy-link'));
    expect(find.text('Connection lost'), findsOneWidget);
    repo.linkFailure = null;
    await _tap(tester, const Key('statement-copy-link'));
    expect(copied, 'https://shop.example/st/abc123');
    expect(find.textContaining('Link copied'), findsOneWidget);
    // The lost request is repeated with its key.
    expect(s.repo.linkCalls[0].key, s.repo.linkCalls[1].key);
    expect(s.repo.linkCalls[1].call.from, DateTime(2026, 11));
  });

  testWidgets('WhatsApp message and message with link', (tester) async {
    final s = await _open(tester);
    await _tap(tester, const Key('statement-whatsapp'));
    await settle(tester, 8);
    expect(find.byKey(const Key('message-text')), findsOneWidget);
    expect(s.repo.linkCalls, isEmpty);
    await tester.tap(find.byTooltip('Close'));
    await settle(tester);
    await _tap(tester, const Key('statement-whatsapp-link'));
    await settle(tester, 8);
    expect(s.repo.linkCalls, hasLength(1));
    expect(find.textContaining('https://shop.example/st/abc123'),
        findsOneWidget);
  });

  testWidgets('a PDF that is too big explains what to do', (tester) async {
    final repo = FakeKhataRepository()
      ..pdfFailure =
          const ServerFailure('too large', 'statement_too_large');
    await _open(tester, repo: repo);
    await _tap(tester, const Key('statement-save'));
    expect(
      find.textContaining(StatementText.tooLongTitle),
      findsOneWidget,
    );
  });

  testWidgets('too long to build: one tap back to this month',
      (tester) async {
    final repo = FakeKhataRepository();
    repo.statementAnswer = (call) => call.from == null
        ? const Left(ServerFailure('too large', 'statement_too_large'))
        : Right(statementJson(detail: call.detail));
    final s = await _open(tester, repo: repo);
    await _tap(tester, const ValueKey('period-all'));
    expect(find.byKey(const Key('statement-problem')), findsOneWidget);
    expect(find.text(StatementText.tooLongTitle), findsOneWidget);
    expect(_enabled(tester, 'save'), isFalse);
    await tester.tap(find.text(StatementText.showThisMonth));
    await settle(tester);
    expect(s.cubit.state.period, StatementPeriod.thisMonth);
    expect(find.byKey(const Key('statement-header')), findsOneWidget);
  });

  testWidgets('offline shows the saved statement; only the text can go',
      (tester) async {
    final repo = FakeKhataRepository()
      ..isOnline = false
      ..offlineSince = DateTime(2026, 11, 27, 8);
    await _open(tester, repo: repo);
    expect(find.byKey(const Key('statement-header')), findsOneWidget);
    expect(
      find.text(StatementText.offlineCopy('01 Nov 2026 - 27 Nov 2026')),
      findsOneWidget,
    );
    for (final id in ['share', 'save', 'print', 'whatsapp-link', 'copy-link']) {
      expect(_enabled(tester, id), isFalse, reason: id);
    }
    expect(_enabled(tester, 'whatsapp'), isTrue);
    expect(find.byTooltip(StatementText.needsInternet), findsWidgets);
  });

  testWidgets('offline with nothing saved says so', (tester) async {
    final repo = FakeKhataRepository()
      ..isOnline = false
      ..statementAnswer =
          ((_) => const Left(NetworkFailure('You are offline')));
    await _open(tester, repo: repo);
    expect(find.text(StatementText.offlineTitle), findsOneWidget);
    expect(find.text(StatementText.offlineMessage), findsOneWidget);
  });

  testWidgets('links need khata.statement.create', (tester) async {
    await _open(tester, keys: [Perm.khataView]);
    expect(_enabled(tester, 'save'), isTrue);
    expect(_enabled(tester, 'whatsapp-link'), isFalse);
    expect(_enabled(tester, 'copy-link'), isFalse);
    expect(find.byTooltip(StatementText.noLinkPermission), findsNWidgets(2));
  });

  testWidgets('another branch never shows the old figures', (tester) async {
    final s = await _open(tester);
    s.cubit.onBranchChanged('b2');
    await settle(tester);
    expect(s.repo.statementCalls.last.branchId, 'b2');
  });

  for (final width in [700.0, 900.0, 1099.0, 1100.0, 1366.0, 1920.0]) {
    testWidgets('no overflow at ${width.toInt()} px, summary and detailed',
        (tester) async {
      final repo = FakeKhataRepository()
        ..statementAnswer = (call) => Right(
              statementJson(
                detail: call.detail,
                party: 'Muhammad Abdullah Khan Yousafzai and Sons Traders',
                closing: '987654321.55',
              ),
            );
      final s = await _open(tester, repo: repo, size: Size(width, 700));
      expect(tester.takeException(), isNull);
      await s.cubit.setDetail(StatementDetail.detailed);
      await settle(tester);
      for (var i = 0; i < 6; i++) {
        await tester.drag(
          find.byKey(const Key('statement-scroll')),
          const Offset(0, -500),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
      }
    });
  }
}
