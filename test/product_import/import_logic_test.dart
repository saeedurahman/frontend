// Models, plain-language copy and the "rows with problems" file.
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/product_import/domain/import_copy.dart';
import 'package:frantend/features/product_import/domain/import_models.dart';
import 'package:frantend/features/product_import/domain/problem_rows_export.dart';

import 'import_fakes.dart';

void main() {
  group('report parsing', () {
    test('reads the server report', () {
      final r = ImportReport.fromJson({
        'dry_run': true,
        'summary': {'total_rows': 24, 'create': 20, 'update': 1, 'unchanged': 1, 'errors': 2, 'warnings': 3},
        'unknown_columns': ['colour'],
        'setup': {
          'missing_units': [
            {'input': 'pkt', 'suggested_name': 'Packet', 'suggested_unit_id': 'u1', 'rows_count': 5},
          ],
          'missing_categories': [
            {'input': 'Stationery', 'rows_count': 4, 'will_create': true},
          ],
          'missing_tax_rates': [
            {'input': 'GST 17%', 'rows_count': 2, 'rate': '17'},
          ],
        },
        'groups': [
          {'code': 'price_missing', 'message': 'Price is missing', 'rows_count': 2, 'sample_rows': [3, 9], 'hint': 'Fill it in'},
        ],
        'warning_groups': [
          {'code': 'barcode_short', 'message': 'Barcode looks short', 'rows_count': 3, 'sample_rows': [4]},
        ],
        'rows': [
          {'row': 3, 'action': 'error', 'name': 'Rice', 'errors': ['Price is missing']},
        ],
        'rows_truncated': true,
        'batch_id': 'batch-1',
      });
      expect(r.summary.create, 20);
      expect(r.summary.writable, 21);
      expect(r.unknownColumns, ['colour']);
      expect(r.setup.units.single.suggestedId, 'u1');
      expect(r.setup.categories.single.willCreate, isTrue);
      expect(r.setup.taxRates.single.rate, '17');
      expect(r.groups.single.sampleRows, [3, 9]);
      expect(r.warningGroups.single.rowsCount, 3);
      expect(r.rowAt(3)!.hasError, isTrue);
      expect(r.rowAt(4), isNull);
      expect(r.rowsTruncated, isTrue);
      expect(r.batchId, 'batch-1');
    });

    test('a bare answer does not crash', () {
      final r = ImportReport.fromJson(const {});
      expect(r.summary.totalRows, 0);
      expect(r.setup.isEmpty, isTrue);
      expect(r.groups, isEmpty);
    });

    test('batch status and undo flag', () {
      final b = ImportBatch.fromJson({
        'id': 'x',
        'filename': 'a.xlsx',
        'source': 'xlsx',
        'status': 'expired',
        'created_count': 3,
        'updated_count': 1,
        'can_undo': false,
        'created_by': {'name': 'Ali'},
        'created_at': '2026-11-20T10:00:00Z',
      });
      expect(b.status, ImportBatchStatus.expired);
      expect(b.canUndo, isFalse);
      expect(b.createdBy, 'Ali');
      expect(b.createdAt, isNotNull);
    });
  });

  group('options on the wire', () {
    test('toFields carries the new import options', () {
      const o = ImportOptions(
        onError: ImportOnError.skip,
        createUnits: true,
        createCategories: false,
        unitMap: {'pkt': 'u1'},
        categoryMap: {'Food': 'c1'},
        branchId: 'br',
      );
      final f = o.toFields(dryRun: true);
      expect(f['dry_run'], true);
      expect(f['on_error'], 'skip');
      expect(f['create_missing_units'], true);
      expect(f['create_missing_categories'], false);
      expect(f['unit_map'], {'pkt': 'u1'});
      expect(f['category_map'], {'Food': 'c1'});
      expect(f['branch_id'], 'br');
    });

    test('file kind comes from the name', () {
      expect(ImportFileKind.fromFileName('A.CSV'), ImportFileKind.csv);
      expect(ImportFileKind.fromFileName('a.xlsx'), ImportFileKind.xlsx);
      expect(ImportFileKind.fromFileName('a.xls'), isNull);
    });
  });

  group('plain words', () {
    test('setup sentence names the new things', () {
      expect(
        ImportCopy.setupSentence(
          unitsToCreate: ['kg', 'ltr', 'pkt', 'pcs'],
          categoriesToCreate: ['Groceries', 'Beverages', 'Stationery'],
          taxRatesToCreate: [],
          createAutomatically: true,
          canCreateTaxRates: false,
        ),
        'Your file uses 4 new units (kg, ltr, pkt, pcs) and 3 new categories (Groceries, Beverages, Stationery). '
        'We will create them for you.',
      );
    });

    test('the sentence changes when creating is off', () {
      final text = ImportCopy.setupSentence(
        unitsToCreate: ['pkt'],
        categoriesToCreate: ['Food'],
        taxRatesToCreate: [],
        createAutomatically: false,
        canCreateTaxRates: false,
      );
      expect(text, contains('We will not create them'));
      expect(text, contains('marked as problems'));
    });

    test('apply button shows the count', () {
      expect(ImportCopy.applyLabel(const ImportSummary(create: 24)), 'Add 24 products');
      expect(ImportCopy.applyLabel(const ImportSummary(create: 1)), 'Add 1 product');
      expect(ImportCopy.applyLabel(const ImportSummary(update: 3)), 'Update 3 products');
      expect(ImportCopy.applyLabel(const ImportSummary(create: 21, update: 3)), 'Add 21, update 3');
      expect(ImportCopy.applyLabel(const ImportSummary()), 'Nothing to import');
    });

    test('result headline', () {
      expect(
        ImportCopy.resultHeadline(const ImportSummary(create: 24, update: 3, errors: 2)),
        '24 added, 3 updated, 2 skipped',
      );
    });

    test('undo refusals are explained', () {
      expect(ImportCopy.undoRefusal('undo_expired', '', const []), contains('24 hours'));
      expect(ImportCopy.undoRefusal('already_undone', '', const []), contains('already undone'));
      final blocked = ImportCopy.undoRefusal(
        'undo_blocked',
        '',
        const [BlockedProduct(name: 'Rice', reasons: ['sale'])],
      );
      expect(blocked, contains('Rice'));
      expect(blocked, contains('Nothing was changed'));
      expect(ImportCopy.undoRefusal('other', 'Server says no', const []), 'Server says no');
    });
  });

  group('rows with problems file', () {
    const csv = 'name,price,unit\n'
        'Rice,100,kg\n'
        'Tea,,pkt\n'
        '"Milk, fresh",abc,ltr\n';

    test('keeps only failing CSV rows, adds a Reason column, quotes properly', () {
      final r = report(
        create: 1,
        errors: 2,
        groups: const [
          ProblemGroup(code: 'price_missing', message: 'Price is missing', rowsCount: 1, sampleRows: [3]),
          ProblemGroup(code: 'price_bad', message: 'Price is not a number', rowsCount: 1, sampleRows: [4]),
        ],
      );
      final out = ProblemRowsExport.build(csvFile(csv), r);
      expect(out.rows, 2);
      expect(out.missing, 0);
      final lines = out.csv.trim().split('\n');
      expect(lines.first, 'name,price,unit,Reason');
      expect(lines[1], 'Tea,,pkt,Price is missing');
      expect(lines[2], '"Milk, fresh",abc,ltr,Price is not a number');
      expect(lines, hasLength(3));
      expect(out.bytes.take(3), [0xEF, 0xBB, 0xBF]);
    });

    test('counts failing rows the report could not name', () {
      final r = report(
        errors: 5,
        groups: const [
          ProblemGroup(code: 'price_missing', message: 'Price is missing', rowsCount: 5, sampleRows: [3]),
        ],
      );
      final out = ProblemRowsExport.build(csvFile(csv), r);
      expect(out.rows, 1);
      expect(out.missing, 4);
    });

    test('an Excel file is listed from the report', () {
      final r = report(
        errors: 1,
        rows: const [
          ImportRow(row: 5, action: 'error', name: 'Tea', sku: 'T1', errors: ['Price is missing']),
        ],
      );
      final file = ImportFile(
        name: 'shop.xlsx',
        bytes: csvFile('x').bytes,
        kind: ImportFileKind.xlsx,
      );
      final out = ProblemRowsExport.build(file, r);
      expect(out.csv, contains('Row,Name,SKU,Barcode,Reason'));
      expect(out.csv, contains('5,Tea,T1,,Price is missing'));
      expect(ProblemRowsExport.fileNameFor(file), 'shop - rows with problems.csv');
    });

    test('CsvTable reads semicolons and line breaks inside quotes', () {
      final t = CsvTable.parse('a;b\n1;"x\ny"\n2;z\n');
      expect(t.header, ['a', 'b']);
      expect(t.recordAtLine(2), ['1', 'x\ny']);
      expect(t.recordAtLine(4), ['2', 'z']);
    });
  });
}
