// Settings > Payment details and Settings > Khata messages.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_settings.dart';
import 'package:frantend/features/khata/domain/message_template.dart';
import 'package:frantend/features/khata/domain/text/khata_settings_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_messages_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/payment_details_cubit.dart';
import 'package:frantend/features/khata/presentation/pages/khata_messages_page.dart';
import 'package:frantend/features/khata/presentation/pages/payment_details_page.dart';
import 'package:frantend/shared/widgets/sync/offline_aware.dart';

import '../helpers/khata_p1_fakes.dart';

const _bank = PaymentInstruction(
  kind: PaymentKind.bank,
  title: 'Madina General Store',
  accountNumber: 'PK00MEZN0001234567',
  bankName: 'Meezan Bank',
);
const _easypaisa = PaymentInstruction(
  kind: PaymentKind.easypaisa,
  title: 'Saleem',
  accountNumber: '0345-1112223',
);

FakeKhataRepository _repo({
  List<PaymentInstruction> payments = const [],
  String? reminder,
}) =>
    FakeKhataRepository()
      ..settingsValue = KhataSettings(
        businessName: 'Madina General Store',
        paymentInstructions: payments,
        reminderTemplate: reminder ?? MessageTemplate.defaultReminder,
      );

Future<void> _tap(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await settle(tester);
}

void main() {
  group('payment details', () {
    Future<PaymentDetailsCubit> open(
      WidgetTester tester,
      FakeKhataRepository repo, {
      List<String>? keys,
      ConnectivityProbe? probe,
      Size size = const Size(1280, 900),
    }) async {
      late PaymentDetailsCubit cubit;
      await pumpKhata(
        tester,
        PaymentDetailsPage(
          createCubit: () => cubit = PaymentDetailsCubit(repo),
          probe: probe,
        ),
        user: keys == null ? null : userWith(keys),
        size: size,
      );
      await settle(tester);
      return cubit;
    }

    List<Object?> sent(FakeKhataRepository repo) =>
        repo.savedSettings.last[KhataSettings.paymentsKey]! as List<Object?>;

    testWidgets('empty, then add a bank account', (tester) async {
      final repo = _repo();
      await open(tester, repo);
      expect(find.byKey(const Key('payments-empty')), findsOneWidget);
      await tester.tap(find.text(KhataSettingsText.add));
      await settle(tester);

      await _tap(tester, const Key('khata-form-submit'));
      expect(find.text(KhataSettingsText.titleRequired), findsOneWidget);
      expect(find.text(KhataSettingsText.numberRequired), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('payment-title')),
        '  Madina Store ',
      );
      await tester.enterText(
        find.byKey(const Key('payment-number')),
        'PK00MEZN1',
      );
      await tester.enterText(find.byKey(const Key('payment-bank')), 'Meezan');
      await _tap(tester, const Key('khata-form-submit'));
      expect(sent(repo), [
        {
          'kind': 'bank',
          'title': 'Madina Store',
          'account_number': 'PK00MEZN1',
          'bank_name': 'Meezan',
        },
      ]);
      expect(find.byKey(const Key('payments-list')), findsOneWidget);
    });

    testWidgets('cheques need no number; wallets have no bank', (tester) async {
      final repo = _repo(payments: [_bank]);
      await open(tester, repo);
      await _tap(tester, const Key('payment-add'));
      await tester.tap(find.text(PaymentKind.cheque.label));
      await settle(tester);
      expect(find.byKey(const Key('payment-number')), findsNothing);
      expect(find.byKey(const Key('payment-bank')), findsOneWidget);
      await tester.tap(find.text(PaymentKind.jazzcash.label));
      await settle(tester);
      expect(find.byKey(const Key('payment-number')), findsOneWidget);
      expect(find.byKey(const Key('payment-bank')), findsNothing);
      await tester.tap(find.text(PaymentKind.cheque.label));
      await settle(tester);
      await tester.enterText(
        find.byKey(const Key('payment-title')),
        'Madina Store',
      );
      await _tap(tester, const Key('khata-form-submit'));
      expect(sent(repo).last, {'kind': 'cheque', 'title': 'Madina Store'});
    });

    testWidgets('reorder, edit and remove save at once', (tester) async {
      final repo = _repo(payments: [_bank, _easypaisa]);
      final cubit = await open(tester, repo);
      List<String> titles() => [for (final i in cubit.state.items) i.title];

      await _tap(tester, const Key('payment-down-0'));
      expect(titles(), ['Saleem', 'Madina General Store']);
      await _tap(tester, const Key('payment-up-1'));
      expect(titles(), ['Madina General Store', 'Saleem']);

      await _tap(tester, const Key('payment-edit-1'));
      await tester.enterText(find.byKey(const Key('payment-title')), 'Saleem K');
      await _tap(tester, const Key('khata-form-submit'));
      expect(titles().last, 'Saleem K');

      await _tap(tester, const Key('payment-remove-0'));
      await tester.tap(find.byKey(const Key('payment-remove-confirm')));
      await settle(tester);
      expect(titles(), ['Saleem K']);
      expect(repo.savedSettings, hasLength(4));
    });

    testWidgets('a refused change is taken back', (tester) async {
      final repo = _repo(payments: [_bank, _easypaisa])
        ..saveFailure = const ServerFailure('Not saved');
      final cubit = await open(tester, repo);
      await _tap(tester, const Key('payment-down-0'));
      expect(cubit.state.items.first.title, 'Madina General Store');
      expect(find.text('Not saved'), findsOneWidget);
    });

    testWidgets('no more than ten', (tester) async {
      final repo = _repo(
        payments: [
          for (var i = 0; i < 10; i++)
            PaymentInstruction(
              kind: PaymentKind.easypaisa,
              title: 'Wallet $i',
              accountNumber: '$i',
            ),
        ],
      );
      await open(tester, repo);
      expect(
        tester
            .widget<ButtonStyleButton>(
              find.byWidgetPredicate((w) => w.key == const Key('payment-add')),
            )
            .onPressed,
        isNull,
      );
      expect(find.byTooltip(KhataSettingsText.limit(10)), findsOneWidget);
    });

    testWidgets('offline: look, do not change', (tester) async {
      await open(
        tester,
        _repo(payments: [_bank]),
        probe: FakeProbe(ReachabilityStatus.offline),
      );
      expect(find.text(OfflineMessages.editingNotice), findsOneWidget);
      expect(find.textContaining('PK00MEZN'), findsOneWidget);
      for (final key in ['payment-edit-0', 'payment-remove-0']) {
        expect(
          tester.widget<IconButton>(find.byKey(Key(key))).onPressed,
          isNull,
        );
      }
    });

    testWidgets('needs settings.manage', (tester) async {
      await open(tester, _repo(payments: [_bank]), keys: [Perm.khataView]);
      expect(
        tester
            .widget<IconButton>(find.byKey(const Key('payment-edit-0')))
            .onPressed,
        isNull,
      );
    });

    testWidgets('a failed load retries', (tester) async {
      final repo = _repo(payments: [_bank])
        ..settingsFailure = const ServerFailure('boom');
      await open(tester, repo);
      expect(find.text(KhataSettingsText.loadFailed), findsOneWidget);
      repo.settingsFailure = null;
      await tester.tap(find.text(KhataSettingsText.retry));
      await settle(tester);
      expect(find.byKey(const Key('payments-list')), findsOneWidget);
    });

    testWidgets('fits at 700 px with long details', (tester) async {
      await open(
        tester,
        _repo(
          payments: [
            PaymentInstruction(
              kind: PaymentKind.bank,
              title: 'A very long account title ' * 3,
              accountNumber: '1234567890' * 5,
              bankName: 'A very long bank name ' * 3,
              note: 'A long note ' * 12,
            ),
          ],
        ),
        size: const Size(700, 600),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('khata messages', () {
    Future<KhataMessagesCubit> open(
      WidgetTester tester,
      FakeKhataRepository repo, {
      List<String>? keys,
      ConnectivityProbe? probe,
      Size size = const Size(1280, 1100),
    }) async {
      late KhataMessagesCubit cubit;
      await pumpKhata(
        tester,
        KhataMessagesPage(
          createCubit: () => cubit = KhataMessagesCubit(repo),
          probe: probe,
        ),
        user: keys == null ? null : userWith(keys),
        size: size,
      );
      await settle(tester);
      return cubit;
    }

    String preview(WidgetTester tester) => tester
        .widget<Text>(find.byKey(const Key('template-preview')))
        .data!;

    bool canSave(WidgetTester tester) =>
        tester
            .widget<FilledButton>(find.byKey(const Key('messages-save')))
            .onPressed !=
        null;

    testWidgets('typing updates the sample preview; save sends the change only',
        (tester) async {
      final repo = _repo(payments: [_bank]);
      await open(tester, repo);
      expect(preview(tester), contains('Ali Traders'));
      expect(preview(tester), contains('Meezan Bank'));
      expect(canSave(tester), isFalse);

      await tester.enterText(
        find.byKey(const Key('template-field')),
        'Salam {party}, {amount} due.',
      );
      await settle(tester);
      expect(preview(tester), 'Salam Ali Traders, Rs. 12,500.00 due.');
      expect(canSave(tester), isTrue);
      await _tap(tester, const Key('messages-save'));
      expect(repo.savedSettings.single, {
        KhataSettings.reminderTemplateKey: 'Salam {party}, {amount} due.',
      });
      expect(find.text(KhataSettingsText.saved), findsOneWidget);
      expect(canSave(tester), isFalse);
    });

    testWidgets('a variable chip goes where the cursor is', (tester) async {
      final repo = _repo(reminder: 'Hi , thanks');
      final cubit = await open(tester, repo);
      final field = tester.widget<TextField>(
        find.byKey(const Key('template-field')),
      );
      field.controller!.selection = const TextSelection.collapsed(offset: 3);
      await _tap(tester, const ValueKey('variable-party'));
      expect(cubit.state.reminder, 'Hi {party}, thanks');
      expect(preview(tester), 'Hi Ali Traders, thanks');
    });

    testWidgets('mistakes are named and cannot be saved', (tester) async {
      await open(tester, _repo());
      await tester.enterText(
        find.byKey(const Key('template-field')),
        'Hi {name}',
      );
      await settle(tester);
      expect(find.textContaining('Unknown: {name}'), findsOneWidget);
      expect(canSave(tester), isFalse);
      await tester.enterText(find.byKey(const Key('template-field')), ' ');
      await settle(tester);
      expect(canSave(tester), isFalse);
    });

    testWidgets('reset brings the default back; tabs keep their own text',
        (tester) async {
      final cubit = await open(tester, _repo(reminder: 'Mine'));
      await tester.tap(find.text(KhataSettingsText.statementTab));
      await settle(tester);
      expect(cubit.state.template, MessageTemplate.defaultStatement);
      await tester.tap(find.text(KhataSettingsText.reminderTab));
      await settle(tester);
      expect(cubit.state.template, 'Mine');
      await _tap(tester, const Key('template-reset'));
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('template-field')))
            .controller!
            .text,
        MessageTemplate.defaultReminder,
      );
    });

    testWidgets('items in statements and days to pay', (tester) async {
      final repo = _repo();
      await open(tester, repo);
      await _tap(tester, const Key('show-items'));
      await tester.enterText(find.byKey(const Key('default-terms')), '4000');
      await settle(tester);
      expect(find.text(KhataSettingsText.termsInvalid), findsOneWidget);
      expect(canSave(tester), isFalse);
      await tester.enterText(find.byKey(const Key('default-terms')), '30');
      await settle(tester);
      // Ctrl+S saves.
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await settle(tester);
      expect(repo.savedSettings.single, {
        KhataSettings.showItemsKey: false,
        KhataSettings.termsKey: 30,
      });
    });

    testWidgets('a refused save keeps the typing', (tester) async {
      final repo = _repo()..saveFailure = const ServerFailure('Not saved');
      final cubit = await open(tester, repo);
      await tester.enterText(find.byKey(const Key('template-field')), 'New');
      await settle(tester);
      await _tap(tester, const Key('messages-save'));
      expect(find.text('Not saved'), findsOneWidget);
      expect(cubit.state.reminder, 'New');
      expect(canSave(tester), isTrue);
    });

    testWidgets('offline nothing can change', (tester) async {
      await open(
        tester,
        _repo(),
        probe: FakeProbe(ReachabilityStatus.offline),
      );
      expect(find.text(OfflineMessages.editingNotice), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('template-field')))
            .enabled,
        isFalse,
      );
    });

    testWidgets('changing needs settings.manage', (tester) async {
      await open(tester, _repo(), keys: [Perm.khataView]);
      expect(
        tester
            .widget<TextField>(find.byKey(const Key('template-field')))
            .enabled,
        isFalse,
      );
    });

    for (final width in [700.0, 899.0, 900.0, 1920.0]) {
      testWidgets('fits at ${width.toInt()} px', (tester) async {
        await open(
          tester,
          _repo(payments: [_bank, _easypaisa]),
          size: Size(width, 700),
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
