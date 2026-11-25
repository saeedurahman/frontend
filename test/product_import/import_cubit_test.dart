// The 3-step import cubit over a fake repository.
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_cubit.dart';
import 'package:frantend/features/product_import/presentation/cubit/product_import_state.dart';

import 'import_fakes.dart';

const _bugSetup = ImportSetup(
  categories: [
    SetupItem(input: 'Groceries', rowsCount: 10, willCreate: true),
    SetupItem(input: 'Beverages', rowsCount: 8, willCreate: true),
  ],
  units: [
    SetupItem(input: 'pkt', suggestedName: 'Packet', suggestedId: 'u-pkt', rowsCount: 5),
  ],
);

void main() {
  late FakeImportRepository repo;
  ProductImportCubit make({bool tax = false}) => ProductImportCubit(repository: repo, canCreateTaxRates: tax);

  setUp(() => repo = FakeImportRepository());
  tearDown(() => repo.dispose());

  test('a good file goes to the review step with a dry run', () async {
    repo.dryRunReport = report(create: 24);
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('name,price\nA,1\n'));

    expect(cubit.state.step, ImportStep.review);
    expect(repo.calls.single.dryRun, isTrue);
    expect(cubit.state.summary.create, 24);
    expect(cubit.state.canApply, isTrue);
    expect(cubit.state.createAutomatically, isTrue);
  });

  test('a suggested unit is preselected and the file is checked again with it', () async {
    repo.reportFor = (o, dry) => report(
          dryRun: dry,
          create: 24,
          setup: o.unitMap.containsKey('pkt') ? const ImportSetup(units: [SetupItem(input: 'pkt', suggestedId: 'u-pkt')]) : _bugSetup,
        );
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));

    expect(cubit.state.unitMap, {'pkt': 'u-pkt'});
    expect(repo.calls.length, 2);
    expect(repo.calls.last.options.unitMap, {'pkt': 'u-pkt'});
    // The list keeps every item ever seen so the choice can be changed back.
    expect(cubit.state.setup.categories.map((e) => e.input), containsAll(['Groceries', 'Beverages']));
  });

  test('mapping an item to an existing one re-checks with the map', () async {
    repo.dryRunReport = report(create: 3, setup: _bugSetup);
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));
    await cubit.mapCategory('Groceries', 'c-groc');

    expect(cubit.state.categoryMap, {'Groceries': 'c-groc'});
    expect(repo.calls.last.options.categoryMap, {'Groceries': 'c-groc'});
    await cubit.mapCategory('Groceries', null);
    expect(cubit.state.categoryMap, isEmpty);
  });

  test('turning auto-create off is sent to the server', () async {
    repo.dryRunReport = report(create: 3, setup: _bugSetup);
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));
    await cubit.setCreateAutomatically(false);

    final o = repo.calls.last.options;
    expect(o.createUnits, isFalse);
    expect(o.createCategories, isFalse);
  });

  test('tax rates are only created for people who may', () async {
    repo.dryRunReport = report(create: 1);
    final a = make();
    addTearDown(a.close);
    await a.start();
    await a.chooseFile(csvFile('x'));
    expect(repo.calls.last.options.createTaxRates, isFalse);

    final b = make(tax: true);
    addTearDown(b.close);
    await b.start();
    await b.chooseFile(csvFile('x'));
    expect(repo.calls.last.options.createTaxRates, isTrue);
  });

  test('"Skip problem rows" is preselected when some rows are fine', () async {
    repo.dryRunReport = report(
      create: 22,
      errors: 2,
      groups: const [ProblemGroup(code: 'price_missing', message: 'Price is missing', rowsCount: 2, sampleRows: [3, 4])],
    );
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));

    expect(cubit.state.onError, ImportOnError.skip);
    expect(cubit.state.canApply, isTrue);
  });

  test('Stop is the default when every row has a problem, and Apply is off', () async {
    repo.dryRunReport = report(errors: 3, groups: const [ProblemGroup(code: 'x', message: 'Bad', rowsCount: 3)]);
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));

    expect(cubit.state.onError, ImportOnError.abort);
    expect(cubit.state.canApply, isFalse);
    expect(cubit.state.applyHint, contains('Every row has a problem'));
  });

  test('choosing Stop with problems turns Apply off; the owner\'s choice sticks', () async {
    repo.dryRunReport = report(create: 5, errors: 1);
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));
    cubit.setOnError(ImportOnError.abort);
    expect(cubit.state.canApply, isFalse);
    expect(cubit.state.applyHint, contains('Skip problem rows'));

    await cubit.setCreateAutomatically(false); // a re-check must not undo the choice
    expect(cubit.state.onError, ImportOnError.abort);
  });

  test('apply sends dry_run false with the options and lands on Done', () async {
    repo.dryRunReport = report(create: 24, setup: _bugSetup);
    repo.applyReport = report(dryRun: false, create: 24, batchId: 'b1');
    repo.batchList = [batch()];
    repo.branch = 'branch-1';
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));
    await cubit.apply();

    final call = repo.calls.last;
    expect(call.dryRun, isFalse);
    expect(call.options.createCategories, isTrue);
    expect(call.options.branchId, 'branch-1');
    expect(cubit.state.step, ImportStep.done);
    expect(cubit.state.applied!.summary.create, 24);
    expect(cubit.state.appliedBatch!.id, 'b1');
    expect(repo.refreshes, 1, reason: 'the catalog is refreshed before the owner leaves');
  });

  test('offline keeps the file and checks again when back online', () async {
    repo.online = false;
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('name\nA\n', name: 'mine.csv'));

    expect(cubit.state.offline, isTrue);
    expect(cubit.state.file!.name, 'mine.csv');
    expect(cubit.state.step, ImportStep.choose);
    expect(repo.calls, isEmpty);

    repo.online = true;
    repo.dryRunReport = report(create: 2);
    await cubit.retry();
    expect(cubit.state.offline, isFalse);
    expect(cubit.state.step, ImportStep.review);
  });

  test('losing the connection during the check keeps the file', () async {
    repo.runFailure = const NetworkFailure();
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));
    expect(cubit.state.offline, isTrue);
    expect(cubit.state.file, isNotNull);
    expect(cubit.state.checking, isFalse);
  });

  test('a 422 with a report still shows the review', () async {
    repo.runFailure = ImportBlockedFailure('Some rows have problems.', report(errors: 2));
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));
    expect(cubit.state.step, ImportStep.review);
    expect(cubit.state.summary.errors, 2);
  });

  test('empty and too-big files are refused in words', () async {
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile(''));
    expect(cubit.state.error, contains('empty'));
    expect(cubit.state.file, isNull);

    await cubit.chooseFile(csvFile('a' * (ProductImportCubit.maxFileBytes + 1)));
    expect(cubit.state.error, contains('too big'));
    expect(repo.calls, isEmpty);
  });

  test('wrong file type is explained', () async {
    final cubit = make();
    addTearDown(cubit.close);
    cubit.rejectFile('old.xls');
    expect(cubit.state.error, contains('old.xls'));
    expect(cubit.state.error, contains('.csv or .xlsx'));
  });

  test('undo calls the endpoint and reloads the list', () async {
    repo.dryRunReport = report(create: 24);
    repo.applyReport = report(dryRun: false, create: 24, batchId: 'b1');
    repo.batchList = [batch()];
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));
    await cubit.apply();
    await cubit.undo('b1');

    expect(repo.undone, ['b1']);
    expect(cubit.state.undoResult!.productsRemoved, 24);
    expect(cubit.state.undoMessage, contains('24 products removed'));
    expect(cubit.state.appliedBatch!.status, ImportBatchStatus.undone);
    expect(repo.refreshes, 2);
  });

  test('a refused undo says why in plain words and reloads the list', () async {
    repo.dryRunReport = report(create: 1);
    repo.applyReport = report(dryRun: false, create: 1, batchId: 'b1');
    repo.batchList = [batch(created: 1)];
    repo.undoFailure = const UndoRefusedFailure(
      'blocked',
      code: 'undo_blocked',
      blocked: [BlockedProduct(name: 'Rice', reasons: ['sale'])],
    );
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    await cubit.chooseFile(csvFile('x'));
    await cubit.apply();
    final loadsBefore = repo.batchLoads;
    await cubit.undo('b1');

    expect(cubit.state.undoResult, isNull);
    expect(cubit.state.undoMessage, contains('Rice'));
    expect(repo.batchLoads, loadsBefore + 1);
  });

  test('the template comes from the server per format', () async {
    final cubit = make();
    addTearDown(cubit.close);
    final t = await cubit.downloadTemplate(ImportFileKind.xlsx);
    expect(t!.fileName, 'products_template.xlsx');
    expect(repo.templates, [ImportFileKind.xlsx]);

    repo.templateFailure = const NetworkFailure();
    expect(await cubit.downloadTemplate(ImportFileKind.csv), isNull);
    expect(cubit.state.offline, isTrue);
  });

  test('going offline and back is followed', () async {
    final cubit = make();
    addTearDown(cubit.close);
    await cubit.start();
    repo.setOnline(false);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.offline, isTrue);
    repo.setOnline(true);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.offline, isFalse);
  });
}
