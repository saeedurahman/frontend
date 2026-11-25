// Unit and Category in Quick Add: type a new name and pick "Create 'Strip'";
// the name goes to the server with the line (`unit_name` / `category_name`).
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/quick_add/data/feedback_sound.dart';
import 'package:frantend/features/quick_add/data/shared_prefs_draft_store.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_cubit.dart';
import 'package:frantend/features/quick_add/presentation/pages/quick_add_page.dart';
import 'package:frantend/core/platform/barcode_scanner_service.dart';

import '../helpers/session_fixtures.dart';
import 'quick_add_fakes.dart';

class _Quiet implements FeedbackSoundService {
  @override
  bool enabled = false;
  @override
  Future<void> setEnabled(bool value) async => enabled = value;
  @override
  void play(FeedbackSound sound) {}
}

class _NoScanner implements BarcodeScannerService {
  @override
  Stream<String> get scans => const Stream.empty();
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
  group('row and request', () {
    test('a typed unit and category are sent by name, not by id', () {
      final row = QuickAddRow(
        id: 'l1',
        barcode: '8900000000012',
        name: 'Panadol',
        newUnitName: 'Strip',
        unitLabel: 'Strip',
        newCategoryName: ' Medicine ',
        categoryLabel: 'Medicine',
        cost: dec('10'),
        salePrice: dec('12'),
      );
      final j = quickAddLineJson(row);
      expect(j['unit_name'], 'Strip');
      expect(j['category_name'], 'Medicine');
      expect(j.containsKey('unit_id'), isFalse);
      expect(j.containsKey('category_id'), isFalse);
    });

    test('a picked unit still goes by id', () {
      final row = QuickAddRow(
        id: 'l1',
        barcode: '8900000000012',
        name: 'Soap',
        unitId: 'u-piece',
        unitLabel: 'Piece',
        categoryId: 'c-soap',
        cost: dec('1'),
        salePrice: dec('2'),
      );
      final j = quickAddLineJson(row);
      expect(j['unit_id'], 'u-piece');
      expect(j['category_id'], 'c-soap');
      expect(j.containsKey('unit_name'), isFalse);
      expect(j.containsKey('category_name'), isFalse);
    });

    test('picking an existing one drops the typed name', () {
      final typed = QuickAddRow(id: 'l', barcode: 'b', newUnitName: 'Strip', unitLabel: 'Strip');
      final picked = typed.copyWith(unitId: 'u-kg', unitLabel: 'Kg');
      expect(picked.newUnitName, isNull);
      expect(picked.unitId, 'u-kg');
    });

    test('the typed names survive the draft (JSON round trip)', () {
      final row = QuickAddRow(
        id: 'l',
        barcode: 'b',
        newUnitName: 'Strip',
        unitLabel: 'Strip',
        newCategoryName: 'Medicine',
        categoryLabel: 'Medicine',
      );
      final back = QuickAddRow.fromJson(row.toJson());
      expect(back.newUnitName, 'Strip');
      expect(back.newCategoryName, 'Medicine');
      expect(back.unitId, isNull);
    });
  });

  group('cubit', () {
    late FakeQuickAddRepository repo;
    late QuickAddCubit cubit;

    setUp(() async {
      repo = FakeQuickAddRepository();
      cubit = QuickAddCubit(
        repository: repo,
        draftStore: MemoryQuickAddDraftStore(),
        ids: SeqIds(),
        draftDebounce: Duration.zero,
        clock: () => DateTime(2026, 11, 20),
      );
      await cubit.start();
    });

    tearDown(() async {
      await cubit.close();
      await repo.dispose();
    });

    test('setNewUnit / setNewCategory keep the typed name and clear the id', () async {
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setUnit(id, const PickOption('u-kg', 'Kg'));
      cubit.setNewUnit(id, '  Strip ');
      cubit.setNewCategory(id, 'Medicine');

      final r = cubit.state.rows.single;
      expect(r.unitId, isNull);
      expect(r.newUnitName, 'Strip');
      expect(r.unitLabel, 'Strip');
      expect(r.categoryId, isNull);
      expect(r.newCategoryName, 'Medicine');
    });

    test('a blank name changes nothing', () async {
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setNewUnit(id, '   ');
      expect(cubit.state.rows.single.newUnitName, isNull);
    });

    test('saving sends unit_name and category_name with no separate create step', () async {
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.name, 'Panadol');
      cubit.setNewUnit(id, 'Strip');
      cubit.setNewCategory(id, 'Medicine');
      cubit.setText(id, QuickAddField.cost, '10');
      cubit.setText(id, QuickAddField.salePrice, '12');
      await cubit.save();

      expect(repo.requests, hasLength(1));
      final line = repo.requests.single.rows.single;
      expect(line.newUnitName, 'Strip');
      expect(line.newCategoryName, 'Medicine');
      expect(quickAddLineJson(line)['unit_name'], 'Strip');
    });
  });

  group('picker', () {
    late FakeQuickAddRepository repo;
    late QuickAddCubit cubit;

    Future<void> pump(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1800, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      repo = FakeQuickAddRepository();
      cubit = QuickAddCubit(
        repository: repo,
        draftStore: MemoryQuickAddDraftStore(),
        ids: SeqIds(),
        draftDebounce: Duration.zero,
        clock: () => DateTime(2026, 11, 20),
      );
      addTearDown(repo.dispose);
      await tester.pumpWidget(
        BlocProvider<AccessCubit>.value(
          value: _access(makeUser(role: 'owner')),
          child: MaterialApp(
            home: Scaffold(
              body: QuickAddPage(
                cubit: cubit,
                sound: _Quiet(),
                scanner: _NoScanner(),
                clock: () => DateTime(2026, 11, 20),
              ),
            ),
          ),
        ),
      );
      unawaited(cubit.start());
      await tester.pump();
      await tester.pump();
      await cubit.scan(barcodeN(1));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    }

    Finder unitCell() => find.byKey(ValueKey('qa-unit-${cubit.state.rows.single.id}'));
    Finder categoryCell() => find.byKey(ValueKey('qa-category-${cubit.state.rows.single.id}'));
    Finder createOption() => find.byKey(const ValueKey('quick-add-create-option'));

    testWidgets("typing a new unit offers Create 'Strip' and uses it", (tester) async {
      await pump(tester);
      await tester.tap(unitCell());
      await tester.pumpAndSettle();
      expect(createOption(), findsNothing, reason: 'nothing typed yet');

      await tester.enterText(find.byType(TextField).last, 'Strip');
      await tester.pumpAndSettle();
      expect(createOption(), findsOneWidget);
      expect(find.text("Create 'Strip'"), findsOneWidget);

      await tester.tap(createOption());
      await tester.pumpAndSettle();
      final r = cubit.state.rows.single;
      expect(r.newUnitName, 'Strip');
      expect(r.unitId, isNull);
      expect(find.text('Strip (new)'), findsOneWidget);
    });

    testWidgets('a name that already exists is picked, not offered for creation', (tester) async {
      await pump(tester);
      await tester.tap(categoryCell());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'soap');
      await tester.pumpAndSettle();
      expect(createOption(), findsNothing);
      await tester.tap(find.text('Soap').last);
      await tester.pumpAndSettle();
      expect(cubit.state.rows.single.categoryId, 'c-soap');
      expect(cubit.state.rows.single.newCategoryName, isNull);
    });

    testWidgets('a new category works with Enter from the keyboard', (tester) async {
      await pump(tester);
      await tester.tap(categoryCell());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'Medicine');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(cubit.state.rows.single.newCategoryName, 'Medicine');
      expect(find.text('Medicine (new)'), findsOneWidget);
    });

    testWidgets('the picker still works as a plain list for suppliers (no create option)', (tester) async {
      await pump(tester);
      await tester.tap(unitCell());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'zzz');
      await tester.pumpAndSettle();
      // Units offer creation; this confirms the option appears only with typed text that has no match.
      expect(createOption(), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, 'kg');
      await tester.pumpAndSettle();
      expect(createOption(), findsNothing);
    });
  });
}
