import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_cubit.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/core/tax/tax_settings_store.dart';
import 'package:frantend/features/pos/domain/utils/line_price_breakdown.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';
import 'package:frantend/features/products/presentation/widgets/product_tax_card.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/repositories/settings_repository.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:frantend/features/settings/presentation/cubit/tax_prices_cubit.dart';
import 'package:frantend/features/settings/presentation/pages/tax_prices_page.dart';
import 'package:frantend/shared/widgets/quantity/quantity_calculator_sheet.dart';

Decimal d(String v) => Decimal.parse(v);

class _Settings implements SettingsRepository {
  List<Map<String, dynamic>>? lastBulk;
  Failure? fail;

  @override
  Future<Either<Failure, List<AppSettingModel>>> bulkUpdateSettings(
    List<Map<String, dynamic>> settings,
  ) async {
    if (fail != null) return Left(fail!);
    lastBulk = settings;
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<TaxRateModel>>> getTaxRates() async => Right([
        TaxRateModel(id: 'r17', businessId: 'b', name: 'GST', rate: '17.000'),
        TaxRateModel(id: 'r5', businessId: 'b', name: 'Reduced', rate: '5.000'),
      ]);

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Probe implements ConnectivityProbe {
  _Probe(this.status0);
  final ReachabilityStatus status0;
  @override
  ReachabilityStatus get current => status0;
  @override
  Stream<ReachabilityStatus> get status => const Stream.empty();
  @override
  bool get isReachable => status0 != ReachabilityStatus.offline;
  @override
  Future<ReachabilityStatus> check() async => status0;
  @override
  void start() {}
  @override
  void stop() {}
  @override
  void dispose() {}
}

class _Store extends TaxSettingsStore {
  _Store() : super(_NoCatalog());
  @override
  Future<void> start() async {}
  @override
  Future<void> reload() async {}
}

class _NoCatalog implements LocalCatalog {
  @override
  dynamic noSuchMethod(Invocation invocation) => const Stream<void>.empty();
}

void main() {
  tearDown(() => TaxSettingsHolder.current = TaxSettings.defaults);

  group('quantity popup: breakdown under the total', () {
    Future<void> open(WidgetTester tester, TaxSettings tax) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final config = QuantityCalculatorConfig(
        title: 'Tea',
        unitPrice: d('6'),
        allowDecimal: true,
        lineTotal: (q, p) => (q * p),
        breakdown: (q, p) => LinePriceBreakdown.lines(
          qty: q,
          unitPrice: p,
          taxRate: d('17'),
          tax: tax,
        ),
      );
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => QuantityCalculatorSheet.show(context, config),
            child: const Text('open'),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('qty-key-2')));
      await tester.pump();
    }

    String text(WidgetTester t, int i) =>
        (t.widget(find.byKey(Key('qty-breakdown-$i'))) as Text).data!;

    testWidgets('tax added on top', (tester) async {
      await open(tester, const TaxSettings());
      expect(text(tester, 0), 'Price 6.00 x 2 = 12.00');
      expect(text(tester, 1), 'GST 17%: 2.04');
      expect(text(tester, 2), 'Total 14.04');
    });

    testWidgets('price includes tax', (tester) async {
      await open(tester, const TaxSettings(includeTax: true));
      expect(text(tester, 0), 'Price 6.00 x 2 = 12.00 (includes GST 17%: 1.74)');
      expect(text(tester, 1), 'Total 12.00');
      expect(find.byKey(const Key('qty-breakdown-2')), findsNothing);
    });

    testWidgets('no breakdown when tax is off', (tester) async {
      await open(tester, const TaxSettings(enabled: false));
      expect(find.byKey(const Key('qty-breakdown')), findsNothing);
    });
  });

  group('Tax & Prices screen', () {
    late _Settings repo;
    late _Store store;
    late TaxPricesCubit cubit;

    Future<void> pump(
      WidgetTester tester, {
      ReachabilityStatus net = ReachabilityStatus.online,
      TaxPreviewFetcher? fetcher,
    }) async {
      tester.view.physicalSize = const Size(1000, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      repo = _Settings();
      store = _Store();
      cubit = TaxPricesCubit(
        getTaxRates: GetTaxRatesUseCase(repo),
        bulkUpdate: BulkUpdateSettingsUseCase(repo),
        store: store,
        previewFetcher: fetcher,
      );
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaxPricesPage(cubit: cubit, probe: _Probe(net)),
        ),
      ));
      await tester.pumpAndSettle();
    }

    String example(WidgetTester t) => (t.widget(find.descendant(
          of: find.byKey(const Key('tax-example')),
          matching: find.byType(Column),
        )) as Column)
        .children
        .whereType<Text>()
        .map((e) => e.data)
        .join('|');

    testWidgets('owner-friendly wording is on screen', (tester) async {
      await pump(tester);
      expect(find.text('My business charges tax'), findsOneWidget);
      expect(find.text('Prices include tax'), findsOneWidget);
      expect(find.text('Tax is added on top'), findsOneWidget);
      expect(find.text('Show tax on the receipt'), findsOneWidget);
      expect(find.text('Hide .00 on whole amounts'), findsOneWidget);
      expect(find.text('Nearest Rs. 5'), findsOneWidget);
    });

    testWidgets('the example card follows the choice', (tester) async {
      await pump(tester);
      expect(example(tester), contains('GST 17%: Rs. 17.00'));
      expect(example(tester), contains('Customer pays: Rs. 117.00'));

      await tester.tap(find.byKey(const Key('tax-mode-inclusive')));
      await tester.pumpAndSettle();
      expect(example(tester), contains('Customer pays: Rs. 100.00'));
      expect(example(tester), contains('(includes GST 17%: Rs. 14.53)'));
    });

    testWidgets('the example comes from the server preview when online', (tester) async {
      await pump(
        tester,
        fetcher: ({required price, required qty, required rate, required inclusive}) async =>
            TaxExample(
          price: price,
          rate: rate,
          tax: d('99.00'),
          total: d('199.00'),
          inclusive: inclusive,
          fromServer: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(example(tester), contains('Customer pays: Rs. 199.00'));
    });

    testWidgets('changing the mode asks first: "applies to NEW sales only"', (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(const Key('tax-mode-inclusive')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tax-save')));
      await tester.pumpAndSettle();
      expect(
        find.text('This applies to NEW sales only. Old sales and reports will not change.'),
        findsOneWidget,
      );
      expect(repo.lastBulk, isNull, reason: 'nothing saved before confirming');

      await tester.tap(find.byKey(const Key('tax-warning-cancel')));
      await tester.pumpAndSettle();
      expect(repo.lastBulk, isNull);
      expect(TaxSettingsHolder.current.includeTax, isFalse);

      await tester.tap(find.byKey(const Key('tax-save')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tax-warning-confirm')));
      await tester.pumpAndSettle();
      final sent = {
        for (final s in repo.lastBulk!)
          s['setting_key']: (s['setting_value'] as Map)['value'],
      };
      expect(sent['tax.prices_include_tax'], true);
      expect(sent['tax.enabled'], true);
      expect(sent['tax.rounding_mode'], 'none');
      expect(sent['tax.label'], 'GST');
      expect(sent['ui.hide_zero_decimals'], false);
      // The settings in force changed at once (cart re-prices from this).
      expect(TaxSettingsHolder.current.includeTax, isTrue);
    });

    testWidgets('changing rounding also warns; a cosmetic change saves directly', (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(const Key('tax-hide-zero')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tax-save')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('tax-change-warning')), findsNothing);
      expect(TaxSettingsHolder.current.hideZeroDecimals, isTrue);

      await tester.tap(find.byKey(const Key('tax-rounding-nearest_5')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tax-save')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('tax-change-warning')), findsOneWidget);
    });

    testWidgets('a failed save keeps the old settings and shows the problem', (tester) async {
      await pump(tester);
      repo.fail = const ServerFailure('Not allowed');
      await tester.tap(find.byKey(const Key('tax-hide-zero')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tax-save')));
      await tester.pumpAndSettle();
      expect(find.text('Not allowed'), findsOneWidget);
      expect(TaxSettingsHolder.current.hideZeroDecimals, isFalse);
    });

    testWidgets('an empty tax name cannot be saved', (tester) async {
      await pump(tester);
      await tester.enterText(find.byKey(const Key('tax-label')), '');
      await tester.pumpAndSettle();
      expect(find.text('Please type a name, for example GST'), findsOneWidget);
      await tester.tap(find.byKey(const Key('tax-save')));
      await tester.pumpAndSettle();
      expect(repo.lastBulk, isNull);
    });

    testWidgets('offline: editing is disabled with the friendly notice', (tester) async {
      await pump(tester, net: ReachabilityStatus.offline);
      expect(find.text('Editing needs internet. You can view this offline.'), findsOneWidget);
      final save = tester.widget<FilledButton>(find.byKey(const Key('tax-save')));
      expect(save.onPressed, isNull);
      final sw = tester.widget<SwitchListTile>(find.byKey(const Key('tax-enabled')));
      expect(sw.onChanged, isNull);
    });
  });

  group('product form: Tax section', () {
    ProductFormState formState({String? rateId, bool exempt = false, String? price}) =>
        ProductFormState(taxRateId: rateId, isTaxExempt: exempt, retailUnitPrice: price);

    final rates = [
      TaxRateModel(id: 'r17', businessId: 'b', name: 'GST', rate: '17.000'),
      TaxRateModel(id: 'r5', businessId: 'b', name: 'Reduced', rate: '5.000'),
    ];

    Future<void> pump(WidgetTester tester, ProductFormState state) async {
      tester.view.physicalSize = const Size(900, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            // The cubit is only used by callbacks; none fire in these checks.
            child: ProductTaxCard(state: state, cubit: _NoCubit(), rates: rates),
          ),
        ),
      ));
      await tester.pump();
    }

    testWidgets('default choice says "Use business default" and shows the example', (tester) async {
      TaxSettingsHolder.current = const TaxSettings(defaultRateId: 'r17');
      await pump(tester, formState(price: '6'));
      expect(find.textContaining('Use business default (GST (17%))'), findsOneWidget);
      expect(find.text('Example for Rs. 6.00'), findsOneWidget);
      expect(find.text('Price 6.00 x 1 = 6.00'), findsOneWidget);
      expect(find.text('GST 17%: 1.02'), findsOneWidget);
      expect(find.text('Total 7.02'), findsOneWidget);
    });

    testWidgets('the item\'s own rate is used', (tester) async {
      TaxSettingsHolder.current = const TaxSettings(defaultRateId: 'r17');
      await pump(tester, formState(rateId: 'r5', price: '100'));
      expect(find.text('GST 5%: 5.00'), findsOneWidget);
    });

    testWidgets('tax-free item: switch on, rate disabled, no tax in the example', (tester) async {
      TaxSettingsHolder.current = const TaxSettings(defaultRateId: 'r17');
      await pump(tester, formState(exempt: true, price: '100'));
      expect(find.text('No tax on this item.'), findsOneWidget);
      final sw = tester.widget<SwitchListTile>(find.byKey(const Key('product-tax-exempt')));
      expect(sw.value, isTrue);
      final dd = tester.widget<DropdownButtonFormField<String>>(
          find.byKey(const Key('product-tax-rate')));
      expect(dd.onChanged, isNull);
    });

    testWidgets('inclusive mode shows the tax inside the price', (tester) async {
      TaxSettingsHolder.current =
          const TaxSettings(includeTax: true, defaultRateId: 'r17');
      await pump(tester, formState(price: '6'));
      expect(find.text('Price 6.00 x 1 = 6.00 (includes GST 17%: 0.87)'), findsOneWidget);
    });
  });
}

class _NoCubit implements ProductFormCubit {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
