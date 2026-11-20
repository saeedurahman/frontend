import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/quick_add/data/shared_prefs_draft_store.dart';
import 'package:frantend/features/quick_add/domain/barcode_normalizer.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/domain/quick_add_settings.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_cubit.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_state.dart';

import 'quick_add_fakes.dart';

class _Suggest implements ProductSuggestionProvider {
  _Suggest(this.answer);
  final ProductSuggestion? answer;
  int calls = 0;

  @override
  Future<ProductSuggestion?> suggest(NormalizedBarcode barcode) async {
    calls++;
    return answer;
  }
}

Future<void> settle() => pumpEventQueue();

void main() {
  late FakeQuickAddRepository repo;
  late MemoryQuickAddDraftStore drafts;
  late QuickAddCubit cubit;
  var now = DateTime(2026, 11, 20);

  QuickAddCubit build({ProductSuggestionProvider? suggestions, SeqIds? ids}) => QuickAddCubit(
        repository: repo,
        draftStore: drafts,
        ids: ids ?? SeqIds(),
        suggestions: suggestions ?? const NoProductSuggestions(),
        draftDebounce: Duration.zero,
        clock: () => now,
      );

  setUp(() async {
    now = DateTime(2026, 11, 20);
    repo = FakeQuickAddRepository();
    drafts = MemoryQuickAddDraftStore();
    cubit = build();
    await cubit.start();
  });

  tearDown(() async {
    await cubit.close();
    await repo.dispose();
  });

  KnownProduct soap({String? stock}) => KnownProduct(
        id: 'p-soap',
        name: 'Lux Soap 100g',
        variationId: 'v-soap',
        unitId: 'u-piece',
        unitLabel: 'Piece',
        salePrice: dec('60'),
        costPrice: dec('45'),
        stockOnHand: dec(stock ?? '12'),
      );

  group('scan', () {
    test('unknown barcode becomes a new row on top, focused on Name', () async {
      await cubit.scan(barcodeN(1));
      await settle();

      final s = cubit.state;
      expect(s.rows, hasLength(1));
      final r = s.rows.single;
      expect(r.barcode, barcodeN(1));
      expect(r.isKnown, isFalse);
      expect(r.qty, dec('1'));
      expect(r.unitLabel, 'Piece');
      expect(r.lookupPending, isFalse);
      expect(s.focus.rowId, r.id);
      expect(s.focus.field, QuickAddField.name);
      expect(s.feedback?.tone, ScanTone.success);
      expect(s.highlightRowId, r.id);
    });

    test('newest row is on top', () async {
      await cubit.scan(barcodeN(1));
      await cubit.scan(barcodeN(2));
      await cubit.scan(barcodeN(3));
      expect(cubit.state.rows.map((r) => r.barcode), [barcodeN(3), barcodeN(2), barcodeN(1)]);
    });

    test('a product the shop already has is filled from the local copy, no lookup', () async {
      repo.local[barcodeN(7)] = soap();
      await cubit.scan(barcodeN(7));
      await settle();

      final r = cubit.state.rows.single;
      expect(r.isKnown, isTrue);
      expect(r.name, 'Lux Soap 100g');
      expect(r.salePrice, dec('60'));
      expect(r.currentStock, dec('12'));
      expect(repo.lookupCalls, 0);
      // Opening mode with a known cost: nothing to type, the scan field keeps focus.
      expect(cubit.state.focus.isScan, isTrue);
    });

    test('scanning the same code again adds one to its row, no duplicate row', () async {
      await cubit.scan(barcodeN(1));
      await cubit.scan(barcodeN(2));
      await cubit.scan(barcodeN(1));

      final s = cubit.state;
      expect(s.rows, hasLength(2));
      // The rescanned row moves to the top and pulses.
      expect(s.rows.first.barcode, barcodeN(1));
      expect(s.rows.first.qty, dec('2'));
      expect(s.rows.first.pulse, 1);
      expect(s.highlightRowId, s.rows.first.id);
    });

    test('two quick scans of one code give quantity 2 (scans are handled in order)', () async {
      final a = cubit.scan(barcodeN(5));
      final b = cubit.scan(barcodeN(5));
      await Future.wait([a, b]);
      expect(cubit.state.rows, hasLength(1));
      expect(cubit.state.rows.single.qty, dec('2'));
    });

    test('UPC-A and EAN-13 of the same item are one row', () async {
      // 036000291452 (UPC-A) == 0036000291452 (EAN-13)
      await cubit.scan('036000291452');
      await cubit.scan('0036000291452');
      expect(cubit.state.rows, hasLength(1));
      expect(cubit.state.rows.single.qty, dec('2'));
    });

    test('a wrong check digit adds the row with a warning and does not block', () async {
      final good = barcodeN(9);
      final last = int.parse(good[12]);
      final bad = '${good.substring(0, 12)}${(last + 1) % 10}';
      await cubit.scan(bad);

      final r = cubit.state.rows.single;
      expect(r.barcodeWarning, isTrue);
      expect(cubit.state.feedback?.tone, ScanTone.warning);
      expect(cubit.state.feedback?.message, contains('check digit'));
    });

    test('something that is not a barcode gives an error and no row', () async {
      await cubit.scan('   ');
      expect(cubit.state.rows, isEmpty);
      expect(cubit.state.feedback?.tone, ScanTone.error);
    });

    test('GS1 scan carries batch and expiry onto the row', () async {
      await cubit.scan('(01)${ean13('890000000100').padLeft(14, '0')}(17)270630(10)B77');
      final r = cubit.state.rows.single;
      expect(r.barcode, ean13('890000000100'));
      expect(r.batchNo, 'B77');
      expect(r.expiry, DateTime(2027, 6, 30));
    });

    test('same product, another batch, is its own line', () async {
      final gtin = ean13('890000000100').padLeft(14, '0');
      await cubit.scan('(01)$gtin(17)270630(10)B1');
      await cubit.scan('(01)$gtin(17)270630(10)B2');
      expect(cubit.state.rows, hasLength(2));
      await cubit.scan('(01)$gtin(17)270630(10)B2');
      expect(cubit.state.rows, hasLength(2));
      expect(cubit.state.rows.first.qty, dec('2'));
    });

    test('scans are ignored while a saved draft waits for Resume / Start fresh', () async {
      await cubit.scan(barcodeN(1));
      await cubit.close();

      cubit = build();
      await cubit.start();
      expect(cubit.state.restorable, 1);
      await cubit.scan(barcodeN(2));
      expect(cubit.state.rows, isEmpty);
    });
  });

  group('lookup and suggestions', () {
    test('slow server lookup never blocks the scan; it fills the row when it answers', () async {
      repo.lookupDelay = const Duration(milliseconds: 80);
      repo.remote[barcodeN(1)] = const ProductLookup(
        suggestion: ProductSuggestion(source: 'catalogue', name: 'Sunsilk Shampoo', mrp: null),
      );

      await cubit.scan(barcodeN(1));
      // Row exists immediately, still waiting for the lookup.
      expect(cubit.state.rows.single.lookupPending, isTrue);
      expect(cubit.state.rows.single.name, '');

      await Future<void>.delayed(const Duration(milliseconds: 150));
      await settle();
      final r = cubit.state.rows.single;
      expect(r.lookupPending, isFalse);
      expect(r.name, 'Sunsilk Shampoo');
      expect(r.suggestionSource, 'catalogue');
    });

    test('a late lookup never overwrites what the owner already typed', () async {
      repo.lookupDelay = const Duration(milliseconds: 60);
      repo.remote[barcodeN(1)] = const ProductLookup(
        suggestion: ProductSuggestion(source: 'catalogue', name: 'Server Name', brand: 'Brandy'),
      );
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.name, 'My own name');

      await Future<void>.delayed(const Duration(milliseconds: 120));
      await settle();
      final r = cubit.state.rows.single;
      expect(r.name, 'My own name');
      expect(r.brand, 'Brandy'); // untouched field may still be filled
    });

    test('the server knows the product (another device added it): row becomes known', () async {
      repo.remote[barcodeN(1)] = ProductLookup(product: soap());
      await cubit.scan(barcodeN(1));
      await settle();
      final r = cubit.state.rows.single;
      expect(r.isKnown, isTrue);
      expect(r.productId, 'p-soap');
      expect(r.name, 'Lux Soap 100g');
    });

    test('offline: no lookup is attempted and the row is not left pending', () async {
      repo.setOnline(false);
      await cubit.scan(barcodeN(1));
      await settle();
      expect(repo.lookupCalls, 0);
      expect(cubit.state.rows.single.lookupPending, isFalse);
    });

    test('ProductSuggestionProvider hook fills an unknown barcode', () async {
      await cubit.close();
      final hook = _Suggest(const ProductSuggestion(
        source: 'open_food_facts',
        name: 'Hook Biscuit',
        unitHint: 'Kg',
        categoryHint: 'Food',
        mrp: null,
      ));
      cubit = build(suggestions: hook);
      await cubit.start();
      await cubit.scan(barcodeN(1));
      await settle();

      final r = cubit.state.rows.single;
      expect(hook.calls, 1);
      expect(r.name, 'Hook Biscuit');
      expect(r.unitId, 'u-kg');
      expect(r.categoryId, 'c-food');
      expect(r.suggestionSource, 'open_food_facts');
    });

    test('the default hook returns null: nothing is invented', () async {
      expect(await const NoProductSuggestions().suggest(BarcodeNormalizer.normalize(barcodeN(1))), isNull);
      await cubit.scan(barcodeN(1));
      await settle();
      expect(cubit.state.rows.single.name, '');
    });

    test('cost 80 and margin 15% suggest a price of 92, marked until confirmed', () async {
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.cost, '80');

      var r = cubit.state.rows.single;
      expect(r.salePrice, dec('92'));
      expect(r.salePriceSuggested, isTrue);

      cubit.confirmSuggestedPrice(id);
      r = cubit.state.rows.single;
      expect(r.salePrice, dec('92'));
      expect(r.salePriceSuggested, isFalse);
    });

    test('changing the cost re-suggests, but never replaces a price the owner typed', () async {
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.cost, '80');
      cubit.setText(id, QuickAddField.cost, '100');
      expect(cubit.state.rows.single.salePrice, dec('115'));

      cubit.setText(id, QuickAddField.salePrice, '130');
      cubit.setText(id, QuickAddField.cost, '200');
      final r = cubit.state.rows.single;
      expect(r.salePrice, dec('130'));
      expect(r.salePriceSuggested, isFalse);
    });

    test('MRP wins over cost plus margin', () async {
      await cubit.close();
      final hook = _Suggest(ProductSuggestion(source: 'catalogue', name: 'X', mrp: dec('99')));
      cubit = build(suggestions: hook);
      await cubit.start();
      await cubit.scan(barcodeN(1));
      await settle();
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.cost, '10');
      expect(cubit.state.rows.single.salePrice, dec('99'));
    });

    test('margin and rounding come from the settings', () async {
      repo.pushSettings(QuickAddSettings(defaultMarginPercent: dec('20'), rounding: 'nearest_5'));
      await settle();
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.cost, '80'); // 96 -> 95
      expect(cubit.state.rows.single.salePrice, dec('95'));
    });
  });

  group('keyboard flow', () {
    test('Enter: Name -> Cost -> Sale price -> scan field', () async {
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      expect(cubit.state.focus.field, QuickAddField.name);

      cubit.setText(id, QuickAddField.name, 'Soap');
      cubit.enterPressed(id, QuickAddField.name);
      expect(cubit.state.focus.field, QuickAddField.cost);

      cubit.setText(id, QuickAddField.cost, '80');
      cubit.enterPressed(id, QuickAddField.cost);
      expect(cubit.state.focus.field, QuickAddField.salePrice);

      cubit.enterPressed(id, QuickAddField.salePrice);
      expect(cubit.state.focus.isScan, isTrue);
      // Enter on the price confirmed the suggestion.
      expect(cubit.state.rows.single.salePriceSuggested, isFalse);
    });

    test('with "ask cost" off Enter skips the cost cell', () async {
      repo.pushSettings(QuickAddSettings(askCost: false));
      await settle();
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.name, 'Soap');
      cubit.enterPressed(id, QuickAddField.name);
      expect(cubit.state.focus.field, QuickAddField.salePrice);
    });

    test('a tracked product continues to Batch and Expiry before returning to scan', () async {
      repo.pushSettings(QuickAddSettings(askExpiry: true));
      await settle();
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.name, 'Tablet');
      cubit.setText(id, QuickAddField.cost, '5');
      cubit.enterPressed(id, QuickAddField.salePrice);
      expect(cubit.state.focus.field, QuickAddField.batch);
      cubit.setText(id, QuickAddField.batch, 'B1');
      cubit.enterPressed(id, QuickAddField.batch);
      expect(cubit.state.focus.field, QuickAddField.expiry);
      cubit.setExpiry(id, DateTime(2027, 1, 31));
      cubit.enterPressed(id, QuickAddField.expiry);
      expect(cubit.state.focus.isScan, isTrue);
    });

    test('setExpiryText understands 06/2027 as the end of that month', () async {
      repo.pushSettings(QuickAddSettings(askExpiry: true));
      await settle();
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      final d = cubit.setExpiryText(id, '06/2027');
      expect(d, isNotNull);
      expect(cubit.state.rows.single.expiry, d);
      expect(d!.year, 2027);
      expect(d.month, 6);
    });

    test('a category picked once is the default for the next new rows', () async {
      await cubit.scan(barcodeN(1));
      cubit.setCategory(cubit.state.rows.single.id, const PickOption('c-soap', 'Soap'));
      await cubit.scan(barcodeN(2));
      expect(cubit.state.rows.first.categoryId, 'c-soap');
      expect(cubit.state.rows.first.categoryLabel, 'Soap');
    });

    test('quantity can be edited, totals follow', () async {
      await cubit.scan(barcodeN(1));
      await cubit.scan(barcodeN(2));
      final a = cubit.state.rows.last.id;
      cubit.setText(a, QuickAddField.qty, '10');
      cubit.setText(a, QuickAddField.cost, '3');
      expect(cubit.state.itemCount, 2);
      expect(cubit.state.totalQty, dec('11'));
      expect(cubit.state.totalCost, dec('30'));
    });
  });

  group('undo and delete', () {
    test('Ctrl+Z takes back the last scan (new row)', () async {
      await cubit.scan(barcodeN(1));
      await cubit.scan(barcodeN(2));
      cubit.undo();
      expect(cubit.state.rows.map((r) => r.barcode), [barcodeN(1)]);
      cubit.undo();
      expect(cubit.state.rows, isEmpty);
      expect(cubit.state.canUndo, isFalse);
    });

    test('Ctrl+Z takes back a rescan: quantity and place are restored', () async {
      await cubit.scan(barcodeN(1));
      await cubit.scan(barcodeN(2));
      await cubit.scan(barcodeN(1));
      expect(cubit.state.rows.first.barcode, barcodeN(1));
      cubit.undo();
      expect(cubit.state.rows.map((r) => r.barcode), [barcodeN(2), barcodeN(1)]);
      expect(cubit.state.rows.last.qty, dec('1'));
    });

    test('delete removes the row with an undo toast; undo brings it back in place', () async {
      await cubit.scan(barcodeN(1));
      await cubit.scan(barcodeN(2));
      await cubit.scan(barcodeN(3));
      final middle = cubit.state.rows[1];
      cubit.deleteRow(middle.id);

      expect(cubit.state.rows, hasLength(2));
      expect(cubit.state.undoToast, isNotNull);
      expect(cubit.state.focus.isScan, isTrue);

      cubit.undo();
      expect(cubit.state.rows.map((r) => r.id).toList()[1], middle.id);
      expect(cubit.state.rows, hasLength(3));
    });

    test('undo with nothing to undo does nothing', () {
      cubit.undo();
      expect(cubit.state.rows, isEmpty);
    });
  });

  group('draft', () {
    test('the draft is written after every change', () async {
      await cubit.scan(barcodeN(1));
      expect(drafts.draft?.rows, hasLength(1));
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.name, 'Soap');
      await settle();
      expect(drafts.draft!.rows.single.name, 'Soap');
      cubit.deleteRow(id);
      await settle();
      expect(drafts.draft, isNull); // empty list = no draft
    });

    test('a restart offers "Resume your draft (N items)" and brings the rows back', () async {
      for (var i = 1; i <= 3; i++) {
        await cubit.scan(barcodeN(i));
      }
      final id = cubit.state.rows.first.id;
      cubit.setText(id, QuickAddField.name, 'Soap');
      cubit.setText(id, QuickAddField.cost, '80');
      cubit.setMode(QuickAddMode.purchase);
      cubit.setSupplier('s-1', 'Ali Traders');
      await settle();
      await cubit.close();

      cubit = build();
      await cubit.start();
      expect(cubit.state.restorable, 3);
      expect(cubit.state.rows, isEmpty);

      cubit.resumeDraft();
      final s = cubit.state;
      expect(s.restorable, isNull);
      expect(s.rows, hasLength(3));
      expect(s.rows.first.name, 'Soap');
      expect(s.rows.first.cost, dec('80'));
      expect(s.mode, QuickAddMode.purchase);
      expect(s.supplierId, 's-1');
      expect(s.supplierName, 'Ali Traders');

      // New scans continue after the restored ones.
      await cubit.scan(barcodeN(4));
      expect(cubit.state.rows.first.barcode, barcodeN(4));
      expect(cubit.state.rows, hasLength(4));
    });

    test('"Start fresh" throws the draft away', () async {
      await cubit.scan(barcodeN(1));
      await cubit.close();
      cubit = build();
      await cubit.start();
      expect(cubit.state.restorable, 1);
      await cubit.discardDraft();
      expect(cubit.state.restorable, isNull);
      expect(drafts.draft, isNull);
      await cubit.scan(barcodeN(2));
      expect(cubit.state.rows, hasLength(1));
    });

    test('an un-resumed draft is not overwritten by the screen being closed', () async {
      await cubit.scan(barcodeN(1));
      await cubit.scan(barcodeN(2));
      await cubit.close();
      cubit = build();
      await cubit.start();
      await cubit.close(); // closed without choosing
      expect(drafts.draft?.rows, hasLength(2));
      cubit = build();
      await cubit.start();
    });

    test('the draft is cleared after a successful save', () async {
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.single.id;
      cubit.setText(id, QuickAddField.name, 'Soap');
      expect(drafts.draft, isNotNull);
      await cubit.save();
      expect(cubit.state.rows, isEmpty);
      expect(drafts.draft, isNull);
    });

    test('a damaged draft never blocks the screen', () async {
      expect(QuickAddDraft.fromJson({'mode': 'purchase', 'rows': 'nonsense'}), isNull);
    });
  });

  group('save', () {
    Future<void> addNamed(int n, {String cost = '10'}) async {
      await cubit.scan(barcodeN(n));
      final id = cubit.state.rows.first.id;
      cubit.setText(id, QuickAddField.name, 'Item $n');
      cubit.setText(id, QuickAddField.cost, cost);
    }

    test('sends the lines oldest first and reports "N added"', () async {
      await addNamed(1);
      await addNamed(2);
      await addNamed(3);
      await cubit.save();

      expect(repo.requests, hasLength(1));
      final body = repo.requests.single.toJson();
      expect(body['mode'], 'opening_stock');
      expect(body['supplier_id'], isNull);
      final lines = body['lines'] as List;
      expect(lines.map((l) => (l as Map)['barcode']), [barcodeN(1), barcodeN(2), barcodeN(3)]);
      expect((lines.first as Map)['name'], 'Item 1');
      expect((lines.first as Map)['cost_price'], '10.00');

      final s = cubit.state;
      expect(s.rows, isEmpty);
      expect(s.saving, isFalse);
      expect(s.summary?.created, 3);
      expect(s.summary?.headline, '3 added');
      expect(repo.writes, hasLength(1)); // written through to the local catalog
    });

    test('per-line failures stay on screen with a plain message and the right field', () async {
      await addNamed(1);
      await addNamed(2);
      await addNamed(3);
      final ids = cubit.state.rows.reversed.map((r) => r.id).toList(); // oldest first
      repo.script.add(Right(
        QuickAddResponse(
          created: 1,
          updated: 1,
          failed: 1,
          lines: [
            QuickAddLineResult(clientLineId: ids[0], outcome: LineOutcome.created, productId: 'p1'),
            QuickAddLineResult(clientLineId: ids[1], outcome: LineOutcome.updated, productId: 'p2'),
            QuickAddLineResult(
              clientLineId: ids[2],
              outcome: LineOutcome.failed,
              errorCode: 'invalid_sale_price',
            ),
          ],
        ),
      ));
      await cubit.save();

      final s = cubit.state;
      expect(s.rows, hasLength(1));
      expect(s.rows.single.id, ids[2]);
      expect(s.rows.single.error?.field, QuickAddField.salePrice);
      expect(s.rows.single.error?.message, 'The sale price is not valid.');
      expect(s.summary?.created, 1);
      expect(s.summary?.updated, 1);
      expect(s.summary?.needAttention, 1);
      expect(s.summary?.headline, '1 added, 1 updated, 1 need attention');
      // The failed row is still in the draft.
      expect(drafts.draft?.rows, hasLength(1));
      expect(s.focus.rowId, ids[2]);
    });

    test('a line the server did not answer is kept, never assumed saved', () async {
      await addNamed(1);
      repo.script.add(const Right(QuickAddResponse(created: 0, updated: 0, failed: 0, lines: [])));
      await cubit.save();
      expect(cubit.state.rows, hasLength(1));
      expect(cubit.state.rows.single.error, isNotNull);
    });

    test('summary text reads "42 added, 8 updated, 2 need attention"', () {
      const s = QuickAddSummary(token: 1, created: 42, updated: 8, needAttention: 2);
      expect(s.headline, '42 added, 8 updated, 2 need attention');
    });

    test('save is blocked and rows turn red when a name is missing', () async {
      await cubit.scan(barcodeN(1)); // no name
      await cubit.save();
      expect(repo.requests, isEmpty);
      final r = cubit.state.rows.single;
      expect(r.error?.field, QuickAddField.name);
      expect(cubit.state.banner, contains('1 item needs a change'));
      expect(cubit.state.focus.rowId, r.id);
      expect(cubit.state.focus.field, QuickAddField.name);
    });

    test('an item that expires needs its expiry date before save (inline)', () async {
      repo.pushSettings(QuickAddSettings(askExpiry: true));
      await settle();
      await addNamed(1);
      await cubit.save();
      expect(repo.requests, isEmpty);
      expect(cubit.state.rows.single.error?.field, QuickAddField.expiry);

      final id = cubit.state.rows.single.id;
      cubit.setExpiry(id, DateTime(2020, 1, 1));
      await cubit.save();
      expect(cubit.state.rows.single.error?.message, contains('already passed'));

      cubit.setExpiry(id, DateTime(2027, 1, 31));
      await cubit.save();
      expect(repo.requests, hasLength(1));
    });

    test('the "batch required" setting asks for a batch', () async {
      repo.pushSettings(QuickAddSettings(requireBatch: true));
      await settle();
      await addNamed(1);
      await cubit.save();
      expect(cubit.state.rows.single.error?.field, QuickAddField.batch);
    });

    test('purchase mode needs a supplier and sends it', () async {
      cubit.setMode(QuickAddMode.purchase);
      await addNamed(1);
      await cubit.save();
      expect(repo.requests, isEmpty);
      expect(cubit.state.banner, contains('supplier'));

      cubit.setSupplier('s-1', 'Ali Traders');
      await cubit.save();
      expect(repo.requests, hasLength(1));
      final body = repo.requests.single.toJson();
      expect(body['mode'], 'purchase');
      expect(body['supplier_id'], 's-1');
    });

    test('purchase mode asks what was paid', () async {
      cubit.setMode(QuickAddMode.purchase);
      cubit.setSupplier('s-1', 'Ali Traders');
      await cubit.scan(barcodeN(1));
      cubit.setText(cubit.state.rows.single.id, QuickAddField.name, 'Soap');
      await cubit.save();
      expect(cubit.state.rows.single.error?.field, QuickAddField.cost);
      expect(repo.requests, isEmpty);
    });

    test('offline: friendly notice, nothing sent, the list is kept as a draft', () async {
      await addNamed(1);
      repo.setOnline(false);
      await cubit.save();

      expect(repo.requests, isEmpty);
      expect(cubit.state.rows, hasLength(1));
      expect(cubit.state.banner, contains('offline'));
      expect(cubit.state.banner, contains('safe'));
      expect(drafts.draft?.rows, hasLength(1));
      expect(cubit.state.feedback?.tone, ScanTone.error);

      // Back online: the very same list saves.
      repo.setOnline(true);
      await cubit.save();
      expect(repo.requests, hasLength(1));
      expect(cubit.state.rows, isEmpty);
    });

    test('offline scanning still works (local-first)', () async {
      repo.setOnline(false);
      repo.local[barcodeN(7)] = soap();
      await cubit.scan(barcodeN(7));
      await cubit.scan(barcodeN(8));
      expect(cubit.state.rows, hasLength(2));
    });

    test('Save does nothing on an empty list or while saving', () async {
      await cubit.save();
      expect(repo.requests, isEmpty);
    });
  });

  group('idempotent retry', () {
    Future<void> addNamed(int n) async {
      await cubit.scan(barcodeN(n));
      final id = cubit.state.rows.first.id;
      cubit.setText(id, QuickAddField.name, 'Item $n');
      cubit.setText(id, QuickAddField.cost, '10');
    }

    test('a retry of the same list reuses the Idempotency-Key', () async {
      await addNamed(1);
      repo.script.add(const Left(NetworkFailure()));
      await cubit.save();
      expect(cubit.state.rows, hasLength(1));
      expect(cubit.state.banner, contains('never added twice'));
      expect(cubit.state.online, isFalse);

      repo.setOnline(true);
      await cubit.save();
      expect(repo.keys, hasLength(2));
      expect(repo.keys[0], repo.keys[1]);
      expect(cubit.state.rows, isEmpty);
    });

    test('a changed list gets a new key', () async {
      await addNamed(1);
      repo.script.add(const Left(ServerFailure('boom')));
      await cubit.save();
      expect(cubit.state.banner, 'boom');

      await addNamed(2);
      await cubit.save();
      expect(repo.keys, hasLength(2));
      expect(repo.keys[0], isNot(repo.keys[1]));
    });

    test('the key survives a restart (draft carries it)', () async {
      await addNamed(1);
      repo.script.add(const Left(NetworkFailure()));
      await cubit.save();
      final firstKey = repo.keys.single;
      await cubit.close();

      cubit = build(ids: SeqIds()); // a new generator would give a different id
      await cubit.start();
      cubit.resumeDraft();
      await cubit.save();
      expect(repo.keys.last, firstKey);
    });

    test('the next list after a success gets a fresh key', () async {
      await addNamed(1);
      await cubit.save();
      await addNamed(2);
      await cubit.save();
      expect(repo.keys[0], isNot(repo.keys[1]));
    });

    test('a replayed answer is reported', () async {
      await addNamed(1);
      repo.script.add(Right(
        QuickAddResponse(
          created: 1,
          updated: 0,
          failed: 0,
          replayed: true,
          lines: [
            QuickAddLineResult(
              clientLineId: cubit.state.rows.single.id,
              outcome: LineOutcome.created,
              productId: 'p',
            ),
          ],
        ),
      ));
      await cubit.save();
      expect(cubit.state.summary?.replayed, isTrue);
      expect(cubit.state.summary?.created, 1);
    });

    test('permission and rate-limit failures are explained in plain words', () async {
      await addNamed(1);
      repo.script.add(const Left(PermissionDeniedFailure()));
      await cubit.save();
      expect(cubit.state.banner, contains('permission'));
      repo.script.add(const Left(RateLimitFailure()));
      await cubit.save();
      expect(cubit.state.banner, contains('Too many'));
    });
  });

  group('mode, settings and connectivity', () {
    test('settings changes reach the screen', () async {
      expect(cubit.state.settings.askExpiry, isFalse);
      repo.pushSettings(QuickAddSettings(askExpiry: true));
      await settle();
      expect(cubit.state.settings.askExpiry, isTrue);
      expect(cubit.state.showBatchExpiry, isTrue);
    });

    test('going offline and online updates the screen', () async {
      repo.setOnline(false);
      await settle();
      expect(cubit.state.online, isFalse);
      repo.setOnline(true);
      await settle();
      expect(cubit.state.online, isTrue);
    });

    test('clearAll empties the list and the draft', () async {
      await cubit.scan(barcodeN(1));
      await cubit.clearAll();
      expect(cubit.state.rows, isEmpty);
      expect(drafts.draft, isNull);
    });
  });

  group('performance', () {
    test('100 scans of new items take no network except the capped lookup', () async {
      final sw = Stopwatch()..start();
      for (var i = 1; i <= 100; i++) {
        await cubit.scan(barcodeN(i));
      }
      sw.stop();
      expect(cubit.state.rows, hasLength(100));
      await settle();
      expect(repo.lookupCalls, 100); // one background lookup each, never awaited by the scan
      expect(sw.elapsedMilliseconds, lessThan(3000));
    });
  });
}
