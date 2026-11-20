import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/platform/barcode_scanner_service.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/quick_add/data/feedback_sound.dart';
import 'package:frantend/features/quick_add/data/shared_prefs_draft_store.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_cubit.dart';
import 'package:frantend/features/quick_add/presentation/pages/quick_add_page.dart';

import '../helpers/session_fixtures.dart';
import 'quick_add_fakes.dart';

class _Sound implements FeedbackSoundService {
  final played = <FeedbackSound>[];

  @override
  bool enabled = true;

  @override
  Future<void> setEnabled(bool value) async => enabled = value;

  @override
  void play(FeedbackSound sound) => played.add(sound);
}

class _Scanner implements BarcodeScannerService {
  final _c = StreamController<String>.broadcast();

  void burst(String code) => _c.add(code);

  @override
  Stream<String> get scans => _c.stream;

  @override
  void start() {}

  @override
  void stop() {}
}

AccessCubit _access(User user) => AccessCubit(
      fetchCurrentUser: () async => user,
      loadCachedUser: () async => user,
    )..apply(user);

void main() {
  late FakeQuickAddRepository repo;
  late MemoryQuickAddDraftStore drafts;
  late QuickAddCubit cubit;
  late _Sound sound;
  late _Scanner scanner;

  // Built inside the test body: a cubit made in setUp lives outside the fake
  // clock zone and its queued scans would not run under pump().
  QuickAddCubit newCubit() => QuickAddCubit(
        repository: repo,
        draftStore: drafts,
        ids: SeqIds(),
        draftDebounce: Duration.zero,
        clock: () => DateTime(2026, 11, 20),
      );

  Finder scanField() => find.byKey(const ValueKey('quick-add-scan-field'));
  Finder cell(String rowId, QuickAddField f) => find.byKey(ValueKey('qa-cell-$rowId-${f.name}'));
  String rowId(int i) => cubit.state.rows[i].id;

  bool hasFocus(WidgetTester t, Finder f) => t.widget<TextField>(f).focusNode!.hasFocus;

  Future<void> pumpPage(
    WidgetTester tester, {
    User? user,
    bool startCubit = true,
  }) async {
    tester.view.physicalSize = const Size(1800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    cubit = newCubit();
    await tester.pumpWidget(
      BlocProvider<AccessCubit>.value(
        value: _access(user ?? makeUser(role: 'owner')),
        child: MaterialApp(
          home: Scaffold(
            body: QuickAddPage(
              cubit: cubit,
              sound: sound,
              scanner: scanner,
              // Pinned: the 400 ms echo window must not depend on how busy the machine is.
              clock: () => DateTime(2026, 11, 20),
            ),
          ),
        ),
      ),
    );
    if (startCubit) {
      unawaited(cubit.start());
      await tester.pump();
      await tester.pump();
    }
  }

  Future<void> typeScan(WidgetTester tester, String code) async {
    await tester.enterText(scanField(), code);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  Future<void> submit(WidgetTester tester, Finder f, String text) async {
    await tester.enterText(f, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  Future<void> key(WidgetTester tester, LogicalKeyboardKey k, {bool ctrl = false}) async {
    if (ctrl) await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(k);
    if (ctrl) await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  setUp(() {
    repo = FakeQuickAddRepository();
    drafts = MemoryQuickAddDraftStore();
    sound = _Sound();
    scanner = _Scanner();
  });


  tearDown(() async {
    await repo.dispose();
  });

  group('layout and scanning', () {
    testWidgets('scan field has the focus; counters, mode switch and columns are shown', (tester) async {
      await pumpPage(tester);
      expect(hasFocus(tester, scanField()), isTrue);
      expect(find.text('Opening stock'), findsOneWidget);
      expect(find.text('Purchase from supplier'), findsOneWidget);
      expect(find.textContaining('Save all'), findsOneWidget);

      await typeScan(tester, barcodeN(1));
      expect(cubit.state.rows, hasLength(1));
      for (final h in ['Barcode', 'Name', 'Qty', 'Cost', 'Sale price']) {
        expect(find.text(h), findsWidgets, reason: h);
      }
    });

    testWidgets('typing a barcode and pressing Enter adds a row and plays the success sound', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      // The same code again within 400 ms is a scanner echo, not a rescan.
      await typeScan(tester, barcodeN(1));
      expect(cubit.state.rows, hasLength(1));
      expect(cubit.state.rows.single.qty, dec('1'));
      expect(sound.played, isNotEmpty);
      expect(sound.played.every((s) => s == FeedbackSound.success), isTrue);
    });

    testWidgets('a bad barcode plays the error sound', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, '%%%');
      expect(cubit.state.rows, isEmpty);
      expect(sound.played.last, FeedbackSound.error);
    });

    testWidgets('a scanner burst while another cell has the focus is scanned once', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      // Focus is on the Name cell of the new row now.
      expect(hasFocus(tester, cell(rowId(0), QuickAddField.name)), isTrue);

      scanner.burst(barcodeN(2));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(cubit.state.rows, hasLength(2));

      // The same burst again within 400 ms is the scanner echo: ignored.
      scanner.burst(barcodeN(2));
      await tester.pump();
      expect(cubit.state.rows, hasLength(2));
      expect(cubit.state.rows.first.qty, dec('1'));
    });
  });

  group('keyboard flow', () {
    testWidgets('Enter walks Name > Cost > Sale price > scan field', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      final id = rowId(0);

      expect(hasFocus(tester, cell(id, QuickAddField.name)), isTrue);
      await submit(tester, cell(id, QuickAddField.name), 'Lux Soap');
      expect(cubit.state.rows.single.name, 'Lux Soap');
      expect(hasFocus(tester, cell(id, QuickAddField.cost)), isTrue);

      await submit(tester, cell(id, QuickAddField.cost), '80');
      expect(cubit.state.rows.single.cost, dec('80'));
      expect(hasFocus(tester, cell(id, QuickAddField.salePrice)), isTrue);
      // The suggestion is already in the cell.
      expect(tester.widget<TextField>(cell(id, QuickAddField.salePrice)).controller!.text, '92');

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(cubit.state.rows.single.salePrice, dec('92'));
      expect(cubit.state.rows.single.salePriceSuggested, isFalse);
      expect(hasFocus(tester, scanField()), isTrue);
    });

    testWidgets('Esc cancels the cell edit and returns to the scan field', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      final id = rowId(0);
      await tester.enterText(cell(id, QuickAddField.name), 'half typed');
      await key(tester, LogicalKeyboardKey.escape);

      expect(cubit.state.rows.single.name, '');
      expect(tester.widget<TextField>(cell(id, QuickAddField.name)).controller!.text, '');
      expect(hasFocus(tester, scanField()), isTrue);
    });

    testWidgets('typed text is applied when the cell loses the focus (Tab / click away)', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      final id = rowId(0);
      await tester.enterText(cell(id, QuickAddField.name), 'Tabbed');
      await key(tester, LogicalKeyboardKey.tab);
      expect(cubit.state.rows.single.name, 'Tabbed');
    });

    testWidgets('Ctrl+Z in the scan field undoes the last scan', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      await key(tester, LogicalKeyboardKey.escape); // back to the scan field
      await typeScan(tester, barcodeN(2));
      await key(tester, LogicalKeyboardKey.escape);
      expect(cubit.state.rows, hasLength(2));

      await key(tester, LogicalKeyboardKey.keyZ, ctrl: true);
      expect(cubit.state.rows, hasLength(1));
      expect(cubit.state.rows.single.barcode, barcodeN(1));
    });

    testWidgets('Delete on a focused row removes it and offers Undo', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      await key(tester, LogicalKeyboardKey.escape);
      await typeScan(tester, barcodeN(2));
      await key(tester, LogicalKeyboardKey.escape);
      expect(hasFocus(tester, scanField()), isTrue);

      // Arrow down from the empty scan field: focus the newest row.
      await key(tester, LogicalKeyboardKey.arrowDown);
      await key(tester, LogicalKeyboardKey.delete);
      expect(cubit.state.rows, hasLength(1));
      expect(cubit.state.rows.single.barcode, barcodeN(1));
      expect(find.widgetWithText(SnackBarAction, 'Undo'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500)); // snack bar slides in
      await tester.tap(find.widgetWithText(SnackBarAction, 'Undo'));
      await tester.pump();
      expect(cubit.state.rows, hasLength(2));
    });

    testWidgets('Ctrl+S saves everything and shows the summary', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      final id = rowId(0);
      await submit(tester, cell(id, QuickAddField.name), 'Lux Soap');
      await submit(tester, cell(id, QuickAddField.cost), '80');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 50));

      await key(tester, LogicalKeyboardKey.keyS, ctrl: true);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(repo.requests, hasLength(1));
      expect(find.byKey(const ValueKey('quick-add-summary')), findsOneWidget);
      expect(find.text('1 added'), findsOneWidget);
      expect(find.text('Add more'), findsOneWidget);
      expect(find.text('Review products'), findsOneWidget);
      // No label printing is offered when there is none.
      expect(find.textContaining('barcode labels'), findsNothing);

      await tester.tap(find.text('Add more'));
      await tester.pumpAndSettle();
      expect(cubit.state.rows, isEmpty);
      expect(hasFocus(tester, scanField()), isTrue);
    });

    testWidgets('Ctrl+S also saves while a cell is being edited (its text is not lost)', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      final id = rowId(0);
      await tester.enterText(cell(id, QuickAddField.name), 'Typed then Ctrl+S');
      await key(tester, LogicalKeyboardKey.keyS, ctrl: true);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(repo.requests, hasLength(1));
      final line = (repo.requests.single.toJson()['lines'] as List).single as Map;
      expect(line['name'], 'Typed then Ctrl+S');
    });
  });

  group('draft', () {
    testWidgets('"Resume your Quick Add draft (3 items)" is offered and resumes', (tester) async {
      drafts.draft = QuickAddDraft(
        mode: QuickAddMode.openingStock,
        seq: 3,
        rows: [
          for (var i = 1; i <= 3; i++)
            QuickAddRow(id: 'r$i', barcode: barcodeN(i), name: 'Item $i', seq: i),
        ],
      );
      await pumpPage(tester);
      await tester.pump();
      expect(find.text('Resume your Quick Add draft (3 items)'), findsOneWidget);

      await tester.tap(find.text('Resume'));
      await tester.pumpAndSettle();
      expect(cubit.state.rows, hasLength(3));
      expect(find.text('Item 3'), findsWidgets);
    });

    testWidgets('"Start fresh" discards the draft', (tester) async {
      drafts.draft = QuickAddDraft(
        mode: QuickAddMode.openingStock,
        rows: [QuickAddRow(id: 'r1', barcode: barcodeN(1), name: 'Item 1', seq: 1)],
      );
      await pumpPage(tester);
      await tester.pump();
      await tester.tap(find.text('Start fresh'));
      await tester.pumpAndSettle();
      expect(cubit.state.rows, isEmpty);
      expect(drafts.draft, isNull);
    });

    testWidgets('leaving with unsaved items asks first; Stay keeps everything', (tester) async {
      tester.view.physicalSize = const Size(1800, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      cubit = newCubit();
      await tester.pumpWidget(
        BlocProvider<AccessCubit>.value(
          value: _access(makeUser(role: 'owner')),
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => Scaffold(
                      body: QuickAddPage(cubit: cubit, sound: sound, scanner: scanner),
                    ),
                  )),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      unawaited(cubit.start());
      await tester.pump();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await typeScan(tester, barcodeN(1));
      await key(tester, LogicalKeyboardKey.escape);

      final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
      unawaited(nav.maybePop());
      await tester.pumpAndSettle();
      expect(find.text('Leave Quick Add?'), findsOneWidget);
      expect(find.textContaining('1 item that is not saved yet'), findsOneWidget);

      await tester.tap(find.text('Stay'));
      await tester.pumpAndSettle();
      expect(scanField(), findsOneWidget);
      expect(cubit.state.rows, hasLength(1));
    });
  });

  group('offline and errors', () {
    testWidgets('offline: Save all shows the friendly notice and keeps the list', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1));
      final id = rowId(0);
      await submit(tester, cell(id, QuickAddField.name), 'Soap');
      await submit(tester, cell(id, QuickAddField.cost), '5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 50));

      repo.setOnline(false);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.textContaining('Save all'));
      await tester.pumpAndSettle();
      expect(repo.requests, isEmpty);
      expect(cubit.state.rows, hasLength(1));
      expect(find.textContaining('Your list is safe'), findsWidgets);
      expect(drafts.draft?.rows, hasLength(1));
    });

    testWidgets('rows with problems are shown in red after Save', (tester) async {
      await pumpPage(tester);
      await typeScan(tester, barcodeN(1)); // no name
      await key(tester, LogicalKeyboardKey.escape);
      await tester.tap(find.textContaining('Save all'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(repo.requests, isEmpty);
      expect(find.textContaining('1 item needs a change'), findsOneWidget);
    });
  });

  group('permissions', () {
    testWidgets('a cashier cannot use Quick Add', (tester) async {
      await pumpPage(tester, user: makeUser(role: 'cashier', keys: cashierKeys));
      expect(find.text('You cannot use Quick Add'), findsOneWidget);
      expect(scanField(), findsNothing);
    });

    testWidgets('products.create alone is not enough: stock needs inventory.adjust', (tester) async {
      await pumpPage(tester, user: makeUser(role: 'staff', keys: [Perm.productsCreate, Perm.productsView]));
      expect(find.text('You cannot use Quick Add'), findsOneWidget);
    });

    testWidgets('a manager can use it', (tester) async {
      await pumpPage(tester, user: makeUser(role: 'manager', keys: managerKeys));
      expect(scanField(), findsOneWidget);
    });

    testWidgets('without inventory.adjust only purchase mode is available', (tester) async {
      await pumpPage(
        tester,
        user: makeUser(role: 'buyer', keys: [
          Perm.productsCreate,
          Perm.purchasesCreate,
          Perm.purchasesReceive,
        ]),
      );
      expect(scanField(), findsOneWidget);
      expect(cubit.state.mode, QuickAddMode.purchase);
    });
  });
}
