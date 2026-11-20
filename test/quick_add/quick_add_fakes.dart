import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/features/quick_add/domain/barcode_normalizer.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_settings.dart';

Decimal dec(String s) => Decimal.parse(s);

/// A valid EAN-13 from a 12 digit stem (check digit appended).
String ean13(String stem12) {
  assert(stem12.length == 12);
  var sum = 0;
  for (var i = 0; i < 12; i++) {
    final d = int.parse(stem12[i]);
    sum += i.isEven ? d : d * 3;
  }
  return '$stem12${(10 - sum % 10) % 10}';
}

/// `n`th distinct, valid barcode.
String barcodeN(int n) => ean13('890000${n.toString().padLeft(6, '0')}');

class SeqIds extends IdGenerator {
  int _n = 0;

  @override
  String newId() => 'id-${++_n}';
}

class FakeQuickAddRepository implements QuickAddRepository {
  FakeQuickAddRepository({
    QuickAddSettings? settings,
    QuickAddOptions? options,
  })  : currentSettings = settings ?? QuickAddSettings(),
        opts = options ??
            const QuickAddOptions(
              units: [PickOption('u-piece', 'Piece'), PickOption('u-kg', 'Kg')],
              categories: [PickOption('c-soap', 'Soap'), PickOption('c-food', 'Food')],
              suppliers: [PickOption('s-1', 'Ali Traders')],
              defaultUnit: PickOption('u-piece', 'Piece'),
            );

  bool online = true;
  QuickAddSettings currentSettings;
  QuickAddOptions opts;

  /// Products "already in the shop", by canonical barcode.
  final Map<String, KnownProduct> local = {};

  /// What the server's lookup answers, by canonical barcode.
  final Map<String, ProductLookup> remote = {};
  Duration lookupDelay = Duration.zero;
  int lookupCalls = 0;
  int localCalls = 0;

  final List<QuickAddRequest> requests = [];
  final List<String> keys = [];
  final List<(QuickAddRequest, QuickAddResponse)> writes = [];

  /// Answers the next submits; when empty every line succeeds as `created`.
  final List<Either<Failure, QuickAddResponse>> script = [];

  final _settings = StreamController<QuickAddSettings>.broadcast();
  final _online = StreamController<bool>.broadcast();

  @override
  String? branchId = 'branch-1';

  @override
  bool get isOnline => online;

  void setOnline(bool v) {
    online = v;
    _online.add(v);
  }

  void pushSettings(QuickAddSettings s) {
    currentSettings = s;
    _settings.add(s);
  }

  @override
  Stream<bool> get onlineChanges => _online.stream;

  @override
  Future<QuickAddSettings> settings() async => currentSettings;

  @override
  Stream<QuickAddSettings> get settingsChanges => _settings.stream;

  @override
  Future<QuickAddOptions> options() async => opts;

  @override
  Future<KnownProduct?> findLocal(NormalizedBarcode barcode) async {
    localCalls++;
    for (final form in {barcode.canonical, ...barcode.forms}) {
      final p = local[form];
      if (p != null) return p;
    }
    return null;
  }

  @override
  Future<ProductLookup?> lookupRemote(
    NormalizedBarcode barcode, {
    Duration timeout = const Duration(milliseconds: 1500),
  }) async {
    lookupCalls++;
    if (!online) return null;
    if (lookupDelay > Duration.zero) await Future<void>.delayed(lookupDelay);
    return remote[barcode.canonical];
  }

  @override
  Future<Either<Failure, QuickAddResponse>> submit(
    QuickAddRequest request, {
    required String idempotencyKey,
  }) async {
    requests.add(request);
    keys.add(idempotencyKey);
    if (script.isNotEmpty) return script.removeAt(0);
    return Right(allCreated(request));
  }

  @override
  Future<void> writeThrough(QuickAddRequest request, QuickAddResponse response) async {
    writes.add((request, response));
  }

  /// Every line of [request] saved as a new product.
  static QuickAddResponse allCreated(QuickAddRequest request) => QuickAddResponse(
        created: request.rows.length,
        updated: 0,
        failed: 0,
        lines: [
          for (final r in request.rows)
            QuickAddLineResult(
              clientLineId: r.id,
              outcome: LineOutcome.created,
              productId: 'p-${r.id}',
              variationId: 'v-${r.id}',
            ),
        ],
      );

  Future<void> dispose() async {
    await _settings.close();
    await _online.close();
  }
}
