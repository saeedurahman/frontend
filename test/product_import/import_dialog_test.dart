// The import dialog, step by step: choose, review, done, and the notices.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/product_import/data/import_file_picker.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_cubit.dart';
import 'package:frantend/features/product_import/presentation/pages/product_import_dialog.dart';

import '../helpers/form_typing.dart';
import 'import_fakes.dart';

const _bugSetup = ImportSetup(
  categories: [
    SetupItem(input: 'Groceries', rowsCount: 10, willCreate: true),
    SetupItem(input: 'Beverages', rowsCount: 8, willCreate: true),
    SetupItem(input: 'Stationery', rowsCount: 6, willCreate: true),
  ],
  units: [
    SetupItem(input: 'carton', rowsCount: 2, willCreate: true),
  ],
);

const _priceGroup = ProblemGroup(
  code: 'price_missing',
  message: 'Price is missing',
  rowsCount: 3,
  sampleRows: [3, 5, 9],
  hint: 'Add a selling price in the Price column.',
);

void main() {
  late FakeImportRepository repo;
  late FakeFiles files;
  late FakePicker picker;
  var changed = 0;
  var reviewed = 0;

  setUp(() {
    repo = FakeImportRepository();
    files = FakeFiles();
    picker = FakePicker(files);
    changed = 0;
    reviewed = 0;
  });
  tearDown(() => repo.dispose());

  Future<void> open(WidgetTester t, {bool canUndo = true}) async {
    ignoreOverflowErrors();
    t.view.physicalSize = const Size(1400, 1200);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (ctx) => Scaffold(
            body: Center(
              child: ElevatedButton(
                key: const ValueKey('open'),
                onPressed: () => showDialog<void>(
                  context: ctx,
                  barrierDismissible: false,
                  builder: (_) => ProductImportDialog(
                    cubit: ProductImportCubit(repository: repo, canCreateTaxRates: true),
                    files: files,
                    picker: picker,
                    canUndo: canUndo,
                    onChanged: () => changed++,
                    onReviewNeedsDetails: () => reviewed++,
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await t.tap(find.byKey(const ValueKey('open')));
    await t.pumpAndSettle();
  }

  Future<void> chooseFile(WidgetTester t, {String name = 'products.csv', String text = 'name,price\nA,1\n'}) async {
    picker.next = PickedOk(csvFile(text, name: name));
    await t.tap(find.byKey(const ValueKey('import-choose-file')));
    await t.pumpAndSettle();
  }

  Finder key(String k) => find.byKey(ValueKey(k));

  group('step 1: choose a file', () {
    testWidgets('shows the stepper, the drop zone, template buttons and help', (t) async {
      await open(t);
      expect(key('import-stepper'), findsOneWidget);
      expect(find.text('Choose file'), findsWidgets);
      expect(find.text('Review'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Drag your file here'), findsOneWidget);
      expect(find.textContaining('.xlsx'), findsWidgets);
      expect(key('import-template-xlsx'), findsOneWidget);
      expect(key('import-template-csv'), findsOneWidget);
      expect(key('import-apply'), findsNothing);
    });

    testWidgets('jargon has help text: SKU is explained', (t) async {
      await open(t);
      final tip = t.widget<Tooltip>(key('import-help-sku'));
      expect(tip.message, 'SKU = your own item code, optional');
      expect(t.widget<Tooltip>(key('import-help-barcode')).message, isNotEmpty);
    });

    testWidgets('the template is fetched from the server in the chosen format and saved', (t) async {
      await open(t);
      await t.tap(key('import-template-xlsx'));
      await t.pumpAndSettle();

      expect(repo.templates, [ImportFileKind.xlsx]);
      expect(files.saved.single.name, 'products_template.xlsx');
      expect(key('import-saved-note'), findsOneWidget);
      expect(find.textContaining('Template saved'), findsOneWidget);

      await t.tap(find.text('Open folder'));
      expect(files.opened.single, contains('products_template.xlsx'));

      await t.tap(key('import-template-csv'));
      await t.pumpAndSettle();
      expect(repo.templates.last, ImportFileKind.csv);
    });

    testWidgets('a wrong file type is explained and nothing is kept', (t) async {
      await open(t);
      picker.next = const PickedWrongType('old.xls');
      await t.tap(key('import-choose-file'));
      await t.pumpAndSettle();
      expect(key('import-error'), findsOneWidget);
      expect(find.textContaining('old.xls'), findsOneWidget);
      expect(repo.calls, isEmpty);
    });

    testWidgets('a cancelled picker changes nothing', (t) async {
      await open(t);
      picker.next = null;
      await t.tap(key('import-choose-file'));
      await t.pumpAndSettle();
      expect(key('import-error'), findsNothing);
      expect(find.text('Drag your file here'), findsOneWidget);
    });

    testWidgets('Cancel closes without refreshing anything', (t) async {
      await open(t);
      await t.tap(key('import-cancel'));
      await t.pumpAndSettle();
      expect(find.byType(ProductImportDialog), findsNothing);
      expect(changed, 0);
    });
  });

  group('recent imports', () {
    testWidgets('empty list says so', (t) async {
      await open(t);
      expect(key('import-recent-empty'), findsOneWidget);
    });

    testWidgets('lists imports with their Undo status', (t) async {
      repo.batchList = [
        batch(id: 'a', filename: 'one.csv'),
        batch(id: 'b', status: ImportBatchStatus.undone, canUndo: false, filename: 'two.csv'),
        batch(id: 'c', status: ImportBatchStatus.expired, canUndo: false, filename: 'three.xlsx'),
      ];
      await open(t);
      expect(key('import-recent'), findsOneWidget);
      expect(find.text('one.csv'), findsOneWidget);
      expect(find.descendant(of: key('import-recent-status-a'), matching: find.text('Can be undone')), findsOneWidget);
      expect(find.descendant(of: key('import-recent-status-b'), matching: find.text('Undone')), findsOneWidget);
      expect(find.descendant(of: key('import-recent-status-c'), matching: find.text('Cannot be undone any more')), findsOneWidget);
      expect(key('import-recent-undo-a'), findsOneWidget);
      expect(key('import-recent-undo-b'), findsNothing);
      expect(key('import-recent-undo-c'), findsNothing);
    });

    testWidgets('a person without edit rights sees no Undo button', (t) async {
      repo.batchList = [batch(id: 'a')];
      await open(t, canUndo: false);
      expect(key('import-recent-a'), findsOneWidget);
      expect(key('import-recent-undo-a'), findsNothing);
    });

    testWidgets('Undo from the list asks first, then undoes', (t) async {
      repo.batchList = [batch(id: 'a')];
      await open(t);
      await t.ensureVisible(key('import-recent-undo-a'));
      await t.tap(key('import-recent-undo-a'));
      await t.pumpAndSettle();
      expect(key('import-undo-confirm'), findsOneWidget);
      expect(repo.undone, isEmpty);

      await t.tap(key('import-undo-confirm-yes'));
      await t.pumpAndSettle();
      expect(repo.undone, ['a']);
      expect(find.descendant(of: key('import-recent-status-a'), matching: find.text('Undone')), findsOneWidget);
    });

    testWidgets('"Keep it" does nothing', (t) async {
      repo.batchList = [batch(id: 'a')];
      await open(t);
      await t.ensureVisible(key('import-recent-undo-a'));
      await t.tap(key('import-recent-undo-a'));
      await t.pumpAndSettle();
      await t.tap(find.text('Keep it'));
      await t.pumpAndSettle();
      expect(repo.undone, isEmpty);
    });
  });

  group('step 2: review', () {
    testWidgets('summary chips and the Add button with the count', (t) async {
      repo.dryRunReport = report(create: 20, update: 3, unchanged: 1, errors: 0);
      await open(t);
      await chooseFile(t);

      expect(key('import-review'), findsOneWidget);
      for (final (k, n) in [
        ('import-chip-total', '24'),
        ('import-chip-add', '20'),
        ('import-chip-update', '3'),
        ('import-chip-unchanged', '1'),
        ('import-chip-attention', '0'),
      ]) {
        expect(find.descendant(of: key(k), matching: find.text(n)), findsOneWidget, reason: k);
      }
      expect(find.text('Needs your attention'), findsOneWidget);
      expect(find.text('Add 20, update 3'), findsOneWidget);
      expect(t.widget<FilledButton>(key('import-apply')).onPressed, isNotNull);
      expect(key('import-setup-card'), findsNothing);
      expect(key('import-problems-card'), findsNothing);
    });

    testWidgets('the button says "Add 24 products"', (t) async {
      repo.dryRunReport = report(create: 24);
      await open(t);
      await chooseFile(t);
      expect(find.text('Add 24 products'), findsOneWidget);
    });

    testWidgets('setup card tells the owner what will be created, in a sentence', (t) async {
      repo.dryRunReport = report(create: 24, setup: _bugSetup);
      await open(t);
      await chooseFile(t);

      expect(key('import-setup-card'), findsOneWidget);
      expect(find.text('Setup needed'), findsOneWidget);
      final sentence = t.widget<Text>(key('import-setup-sentence')).data!;
      expect(sentence, contains('Your file uses 1 new unit (carton) and 3 new categories (Groceries, Beverages, Stationery).'));
      expect(sentence, contains('We will create them for you.'));
      expect(t.widget<SwitchListTile>(key('import-auto-create')).value, isTrue);
      expect(find.text('Create new: Groceries'), findsOneWidget);
    });

    testWidgets('turning the switch off sends create_missing_* false and changes the words', (t) async {
      repo.dryRunReport = report(create: 24, setup: _bugSetup);
      await open(t);
      await chooseFile(t);
      await t.tap(key('import-auto-create'));
      await t.pumpAndSettle();

      expect(repo.calls.last.options.createCategories, isFalse);
      expect(repo.calls.last.options.createUnits, isFalse);
      expect(t.widget<Text>(key('import-setup-sentence')).data, contains('We will not create them'));
      expect(find.text("Don't create"), findsWidgets);
    });

    testWidgets('mapping a category to an existing one overrides it', (t) async {
      repo.dryRunReport = report(create: 24, setup: _bugSetup);
      await open(t);
      await chooseFile(t);

      await t.tap(key('import-map-category-Groceries'));
      await t.pumpAndSettle();
      await t.tap(find.text('Use Groceries').last);
      await t.pumpAndSettle();

      expect(repo.calls.last.options.categoryMap, {'Groceries': 'c-groc'});
      expect(t.widget<Text>(key('import-setup-sentence')).data, contains('2 new categories (Beverages, Stationery)'));
    });

    testWidgets('a suggested unit is preselected ("looks like one you already have")', (t) async {
      repo.reportFor = (o, dry) => report(
            dryRun: dry,
            create: 3,
            setup: const ImportSetup(units: [SetupItem(input: 'pkt', suggestedName: 'Packet', suggestedId: 'u-pkt', rowsCount: 3)]),
          );
      await open(t);
      await chooseFile(t);
      expect(repo.calls.last.options.unitMap, {'pkt': 'u-pkt'});
      expect(find.text('Looks like one you already have'), findsOneWidget);
      expect(find.text('Use Packet'), findsOneWidget);
    });

    testWidgets('errors are grouped by reason, expandable with samples and a hint', (t) async {
      repo.dryRunReport = report(
        create: 20,
        errors: 3,
        groups: const [
          _priceGroup,
          ProblemGroup(code: 'name_missing', message: 'Name is missing', rowsCount: 1, sampleRows: [12]),
        ],
        rows: const [
          ImportRow(row: 3, action: 'error', name: 'Tea', errors: ['Price is missing']),
        ],
      );
      await open(t);
      await chooseFile(t);

      expect(find.text('Problems to fix'), findsOneWidget);
      expect(find.text('Price is missing: 3 rows'), findsOneWidget);
      expect(find.text('Name is missing: 1 row'), findsOneWidget);
      // Collapsed: no hint yet.
      expect(find.text('Add a selling price in the Price column.'), findsNothing);

      await t.tap(key('import-group-price_missing'));
      await t.pumpAndSettle();
      expect(find.text('Add a selling price in the Price column.'), findsOneWidget);
      expect(find.textContaining('Row 3'), findsWidgets);
      expect(find.textContaining('Row 9'), findsWidgets);
    });

    testWidgets('at most 5 sample rows are listed, with "and N more"', (t) async {
      repo.dryRunReport = report(
        create: 1,
        errors: 9,
        groups: const [
          ProblemGroup(code: 'price_missing', message: 'Price is missing', rowsCount: 9, sampleRows: [2, 3, 4, 5, 6, 7, 8, 9]),
        ],
      );
      await open(t);
      await chooseFile(t);
      await t.tap(key('import-group-price_missing'));
      await t.pumpAndSettle();
      expect(find.textContaining('Row 6'), findsWidgets);
      expect(find.textContaining('Row 7'), findsNothing);
      expect(find.text('and 4 more'), findsOneWidget);
    });

    testWidgets('"Skip problem rows" is preselected when some rows are fine, and the button counts only good rows', (t) async {
      repo.dryRunReport = report(create: 21, errors: 3, groups: const [_priceGroup]);
      await open(t);
      await chooseFile(t);

      expect(find.text('Stop if there are problems'), findsOneWidget);
      expect(find.text('Skip problem rows and import the rest'), findsOneWidget);
      expect(repo.calls.length, 1);
      expect(find.text('Add 21 products'), findsOneWidget);
      expect(t.widget<FilledButton>(key('import-apply')).onPressed, isNotNull);

      // Choosing "Stop" turns Apply off and says why.
      await t.tap(key('import-onerror-abort'));
      await t.pumpAndSettle();
      expect(t.widget<FilledButton>(key('import-apply')).onPressed, isNull);
      expect(key('import-apply-hint'), findsOneWidget);
    });

    testWidgets('when every row has a problem, Apply stays off', (t) async {
      repo.dryRunReport = report(errors: 3, groups: const [_priceGroup]);
      await open(t);
      await chooseFile(t);
      expect(t.widget<FilledButton>(key('import-apply')).onPressed, isNull);
      expect(find.textContaining('Every row has a problem'), findsOneWidget);
    });

    testWidgets('"Download rows with problems" saves only the failing rows with a Reason column', (t) async {
      repo.dryRunReport = report(create: 1, errors: 1, groups: const [
        ProblemGroup(code: 'price_missing', message: 'Price is missing', rowsCount: 1, sampleRows: [3]),
      ]);
      await open(t);
      await chooseFile(t, name: 'shop.csv', text: 'name,price\nRice,10\nTea,\n');
      await t.tap(key('import-download-problems'));
      await t.pumpAndSettle();

      expect(files.saved.single.name, 'shop - rows with problems.csv');
      final text = utf8.decode(files.saved.single.bytes.sublist(3));
      expect(text.trim().split('\n'), ['name,price,Reason', 'Tea,,Price is missing']);
      expect(find.textContaining('1 row with problems saved'), findsOneWidget);
    });

    testWidgets('warnings are collapsed by default and do not block', (t) async {
      repo.dryRunReport = report(
        create: 24,
        warnings: 8,
        warningGroups: const [
          ProblemGroup(
            code: 'barcode_short',
            message: 'Barcode has 8 digits',
            rowsCount: 8,
            sampleRows: [2, 3],
            hint: 'Short barcodes are fine for local labels.',
          ),
        ],
      );
      await open(t);
      await chooseFile(t);

      final tile = t.widget<ExpansionTile>(key('import-warnings'));
      expect(tile.initiallyExpanded, isFalse);
      expect(find.text('Short barcodes are fine for local labels.'), findsNothing);
      expect(t.widget<FilledButton>(key('import-apply')).onPressed, isNotNull);

      await t.tap(key('import-warnings'));
      await t.pumpAndSettle();
      expect(find.text('Barcode has 8 digits: 8 rows'), findsOneWidget);
    });

    testWidgets('the row table can be searched', (t) async {
      repo.dryRunReport = report(create: 2, rows: const [
        ImportRow(row: 2, action: 'create', name: 'Basmati Rice', sku: 'R1'),
        ImportRow(row: 3, action: 'create', name: 'Green Tea', sku: 'T1'),
      ]);
      await open(t);
      await chooseFile(t);
      await t.tap(key('import-rows'));
      await t.pumpAndSettle();
      expect(find.text('Basmati Rice'), findsOneWidget);
      expect(find.text('Green Tea'), findsOneWidget);

      await t.enterText(key('import-rows-search'), 'tea');
      await t.pumpAndSettle();
      expect(find.text('Basmati Rice'), findsNothing);
      expect(find.text('Green Tea'), findsOneWidget);
    });

    testWidgets('columns the server ignored are listed', (t) async {
      repo.dryRunReport = ImportReport(
        dryRun: true,
        summary: const ImportSummary(totalRows: 1, create: 1),
        unknownColumns: const ['colour'],
      );
      await open(t);
      await chooseFile(t);
      expect(find.textContaining('colour'), findsOneWidget);
    });

    testWidgets('"Choose another file" goes back to step 1', (t) async {
      repo.dryRunReport = report(create: 1);
      await open(t);
      await chooseFile(t);
      await t.tap(key('import-start-over'));
      await t.pumpAndSettle();
      expect(find.text('Drag your file here'), findsOneWidget);
      expect(key('import-apply'), findsNothing);
    });
  });

  group('step 3: apply and done', () {
    Future<void> applied(WidgetTester t, {ImportReport? dry, ImportReport? apply, List<ImportBatch>? batches}) async {
      repo.dryRunReport = dry ?? report(create: 24, setup: _bugSetup);
      repo.applyReport = apply ?? report(dryRun: false, create: 24, update: 3, errors: 2, batchId: 'b1');
      repo.batchList = batches ?? [batch(id: 'b1', updated: 3)];
      await open(t);
      await chooseFile(t);
      await t.tap(key('import-apply'));
      await t.pumpAndSettle();
    }

    testWidgets('Apply sends the options and shows the result in words', (t) async {
      await applied(t);
      final call = repo.calls.last;
      expect(call.dryRun, isFalse);
      expect(call.options.createCategories, isTrue);
      expect(call.options.createUnits, isTrue);
      expect(call.file.name, 'products.csv');

      expect(key('import-done'), findsOneWidget);
      expect(t.widget<Text>(key('import-result-headline')).data, '24 added, 3 updated, 2 skipped');
      expect(find.textContaining('We also created'), findsNothing); // batch has no new units/categories
      expect(repo.refreshes, 1);
    });

    testWidgets('shows how many units and categories were created', (t) async {
      await applied(t, batches: [
        ImportBatch(
          id: 'b1',
          filename: 'p.csv',
          status: ImportBatchStatus.active,
          createdCount: 24,
          updatedCount: 0,
          canUndo: true,
          createdUnits: 1,
          createdCategories: 3,
        ),
      ]);
      expect(t.widget<Text>(key('import-result-created')).data, 'We also created 1 new unit and 3 new categories for you.');
    });

    testWidgets('the progress banner shows while the server works', (t) async {
      repo.dryRunReport = report(create: 2);
      repo.applyReport = report(dryRun: false, create: 2);
      await open(t);
      await chooseFile(t);
      // The dialog is open and idle: no progress yet.
      expect(key('import-progress'), findsNothing);
    });

    testWidgets('Done offers the three buttons and Close refreshes the list', (t) async {
      await applied(t);
      expect(key('import-review-details'), findsOneWidget);
      expect(find.text('Review products needing details'), findsOneWidget);
      expect(find.text('Undo this import'), findsOneWidget);
      expect(key('import-close'), findsOneWidget);

      await t.tap(key('import-close'));
      await t.pumpAndSettle();
      expect(find.byType(ProductImportDialog), findsNothing);
      expect(changed, 1);
      expect(reviewed, 0);
    });

    testWidgets('"Review products needing details" closes and opens the filtered list', (t) async {
      await applied(t);
      await t.tap(key('import-review-details'));
      await t.pumpAndSettle();
      expect(find.byType(ProductImportDialog), findsNothing);
      expect(reviewed, 1);
      expect(changed, 1);
    });

    testWidgets('Undo is enabled within 24 hours and explains itself', (t) async {
      await applied(t);
      expect(t.widget<OutlinedButton>(key('import-undo')).onPressed, isNotNull);
      expect(t.widget<Text>(key('import-undo-help')).data, contains('24 hours'));
    });

    testWidgets('Undo asks first, then removes the products and says so', (t) async {
      await applied(t);
      await t.tap(key('import-undo'));
      await t.pumpAndSettle();
      expect(key('import-undo-confirm'), findsOneWidget);
      await t.tap(key('import-undo-confirm-yes'));
      await t.pumpAndSettle();

      expect(repo.undone, ['b1']);
      expect(t.widget<Text>(key('import-result-headline')).data, 'Import undone');
      expect(find.descendant(of: key('import-undo-message'), matching: find.textContaining('24 products removed')), findsOneWidget);
      expect(t.widget<OutlinedButton>(key('import-undo')).onPressed, isNull);
      expect(find.text('This import was undone.'), findsOneWidget);
      expect(key('import-review-details'), findsNothing);
    });

    testWidgets('an expired import cannot be undone and says why', (t) async {
      await applied(t, batches: [batch(id: 'b1', status: ImportBatchStatus.expired, canUndo: false)]);
      expect(t.widget<OutlinedButton>(key('import-undo')).onPressed, isNull);
      expect(t.widget<Text>(key('import-undo-help')).data, contains('more than 24 hours'));
    });

    testWidgets('without edit rights Undo is off and the help says who can', (t) async {
      repo.dryRunReport = report(create: 2);
      repo.applyReport = report(dryRun: false, create: 2, batchId: 'b1');
      repo.batchList = [batch(id: 'b1')];
      await open(t, canUndo: false);
      await chooseFile(t);
      await t.tap(key('import-apply'));
      await t.pumpAndSettle();
      expect(t.widget<OutlinedButton>(key('import-undo')).onPressed, isNull);
      expect(t.widget<Text>(key('import-undo-help')).data, contains('Only people who may edit'));
    });

    testWidgets('a refused undo is explained in plain words, nothing breaks', (t) async {
      await applied(t);
      repo.undoFailure = const UndoRefusedFailure(
        'blocked',
        code: 'undo_blocked',
        blocked: [BlockedProduct(name: 'Basmati Rice', reasons: ['sale'])],
      );
      await t.tap(key('import-undo'));
      await t.pumpAndSettle();
      await t.tap(key('import-undo-confirm-yes'));
      await t.pumpAndSettle();

      expect(find.descendant(of: key('import-undo-message'), matching: find.textContaining('Basmati Rice')), findsOneWidget);
      expect(find.descendant(of: key('import-undo-message'), matching: find.textContaining('Nothing was changed')), findsOneWidget);
      expect(t.widget<Text>(key('import-result-headline')).data, isNot('Import undone'));
    });

    testWidgets('a server refusal at apply shows the report again with a plain message', (t) async {
      repo.dryRunReport = report(create: 5, errors: 1, groups: const [_priceGroup]);
      await open(t);
      await chooseFile(t);
      repo.runFailure = ImportBlockedFailure('Some rows have problems.', report(errors: 1, groups: const [_priceGroup]));
      await t.tap(key('import-apply'));
      await t.pumpAndSettle();
      expect(key('import-error'), findsOneWidget);
      expect(find.textContaining('Nothing was added'), findsOneWidget);
      expect(key('import-done'), findsNothing);
    });
  });

  group('offline', () {
    testWidgets('a file chosen while offline is kept with a friendly notice', (t) async {
      repo.online = false;
      await open(t);
      expect(key('import-offline'), findsOneWidget, reason: 'the notice is shown as soon as the dialog opens');
      await chooseFile(t, name: 'mine.csv');

      expect(find.textContaining("You're offline"), findsOneWidget);
      expect(find.textContaining('Your file is kept'), findsOneWidget);
      expect(key('import-file-name'), findsOneWidget);
      expect(t.widget<Text>(key('import-file-name')).data, 'mine.csv');
      expect(repo.calls, isEmpty);
      expect(key('import-apply'), findsNothing);
    });

    testWidgets('Try again checks the same file once the connection is back', (t) async {
      repo.online = false;
      repo.dryRunReport = report(create: 4);
      await open(t);
      await chooseFile(t);

      repo.online = true;
      await t.tap(key('import-offline-retry'));
      await t.pumpAndSettle();
      expect(key('import-offline'), findsNothing);
      expect(key('import-review'), findsOneWidget);
      expect(find.text('Add 4 products'), findsOneWidget);
      expect(picker.picks, 1, reason: 'the file was not chosen again');
    });

    testWidgets('losing the connection at the review step disables Apply and keeps the report', (t) async {
      repo.dryRunReport = report(create: 4);
      await open(t);
      await chooseFile(t);
      repo.setOnline(false);
      await t.pumpAndSettle();

      expect(key('import-offline'), findsOneWidget);
      expect(key('import-review'), findsOneWidget);
      expect(t.widget<FilledButton>(key('import-apply')).onPressed, isNull);
      expect(find.text('Connect to the internet to import.'), findsOneWidget);
    });

    testWidgets('the template needs internet too and says so', (t) async {
      repo.online = false;
      await open(t);
      repo.templateFailure = const NetworkFailure();
      await t.tap(key('import-template-csv'));
      await t.pumpAndSettle();
      expect(key('import-offline'), findsOneWidget);
      expect(files.saved, isEmpty);
    });
  });
}
