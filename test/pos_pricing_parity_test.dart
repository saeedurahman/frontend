import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/domain/utils/pos_calculations.dart';
import 'package:frantend/features/pos/domain/utils/pos_sale_request_builder.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';

const _branchId = '00000000-0000-4000-8000-000000000001';

CartItemModel _item({
  required String productId,
  required Decimal qty,
  required Decimal unitPrice,
  Decimal? discountPct,
  Decimal? discountAmount,
  Decimal? taxRate,
}) {
  return CartItemModel(
    productId: productId,
    productName: 'Product $productId',
    unitPrice: unitPrice,
    qty: qty,
    itemDiscountPct: discountPct,
    itemDiscountAmount: discountAmount,
    taxRate: taxRate,
  );
}

bool _withinTolerance(Decimal a, Decimal b, [Decimal? tolerance]) {
  final tol = tolerance ?? Decimal.parse('0.01');
  final diff = (a - b).abs();
  return diff <= tol;
}

Map<String, Decimal> _previewTotalsFromBuiltLines({
  required List<CartItemModel> items,
  String? cartDiscountType,
  Decimal? cartDiscountValue,
}) {
  final discountValue = cartDiscountValue ?? Decimal.zero;
  final builtLines = PosCalculations.buildSaleLines(
    items: items,
    cartDiscountType: cartDiscountType,
    cartDiscountValue: discountValue,
  );
  final lineAmounts = builtLines.map((line) {
    return PricingEngine.calculateLineTotal(
      qty: Decimal.parse('${line['qty']}'),
      unitPrice: Decimal.parse('${line['unit_price']}'),
      discountPct: Decimal.parse('${line['discount_pct']}'),
      discountAmount: Decimal.parse('${line['discount_amount']}'),
      taxRate: Decimal.parse('${line['tax_rate']}'),
    );
  }).toList();
  return PricingEngine.calculateSaleTotals(lineAmounts);
}

void main() {
  group('no-scheme authoritative totals', () {
    test('line discount uses max(pct, amount) not sum', () {
      final items = [
        _item(
          productId: 'a',
          qty: Decimal.fromInt(2),
          unitPrice: Decimal.fromInt(100),
          discountPct: Decimal.fromInt(10),
          discountAmount: Decimal.fromInt(25),
        ),
      ];

      final totals = PosCalculations.computeAuthoritativeTotals(
        items: items,
        cartDiscountType: null,
        cartDiscountValue: Decimal.zero,
      );

      expect(totals.subtotal, Decimal.parse('200.00'));
      expect(totals.totalDiscount, Decimal.parse('25.00'));
      expect(totals.totalAmount, Decimal.parse('175.00'));
    });

    test('fixed cart discount distributes pro-rata across lines', () {
      final items = [
        _item(
          productId: 'a',
          qty: Decimal.fromInt(2),
          unitPrice: Decimal.fromInt(100),
        ),
        _item(
          productId: 'b',
          qty: Decimal.one,
          unitPrice: Decimal.fromInt(50),
        ),
      ];

      final totals = PosCalculations.computeAuthoritativeTotals(
        items: items,
        cartDiscountType: 'fixed',
        cartDiscountValue: Decimal.fromInt(50),
      );

      expect(totals.subtotal, Decimal.parse('250.00'));
      expect(totals.totalDiscount, Decimal.parse('50.00'));
      expect(totals.totalAmount, Decimal.parse('200.00'));
    });

    test('percentage cart discount with tax matches backend order of operations', () {
      final items = [
        _item(
          productId: 'a',
          qty: Decimal.fromInt(2),
          unitPrice: Decimal.fromInt(100),
          taxRate: Decimal.parse('15'),
        ),
        _item(
          productId: 'b',
          qty: Decimal.one,
          unitPrice: Decimal.fromInt(50),
          taxRate: Decimal.parse('15'),
        ),
      ];

      final totals = PosCalculations.computeAuthoritativeTotals(
        items: items,
        cartDiscountType: 'percentage',
        cartDiscountValue: Decimal.fromInt(10),
      );

      expect(totals.subtotal, Decimal.parse('250.00'));
      expect(totals.totalDiscount, Decimal.parse('25.00'));
      expect(totals.totalTax, Decimal.parse('33.75'));
      expect(totals.totalAmount, Decimal.parse('258.75'));
    });
  });

  group('no-scheme parity: client getters vs built-line pricing engine', () {
    final scenarios = <Map<String, dynamic>>[
      {
        'name': 'simple single line',
        'items': [
          _item(
            productId: 'a',
            qty: Decimal.fromInt(1),
            unitPrice: Decimal.parse('99.99'),
          ),
        ],
      },
      {
        'name': 'pct vs amount max',
        'items': [
          _item(
            productId: 'a',
            qty: Decimal.fromInt(3),
            unitPrice: Decimal.parse('45.50'),
            discountPct: Decimal.parse('5'),
            discountAmount: Decimal.parse('8'),
          ),
        ],
      },
      {
        'name': 'fixed cart + line tax',
        'items': [
          _item(
            productId: 'a',
            qty: Decimal.fromInt(2),
            unitPrice: Decimal.fromInt(100),
            taxRate: Decimal.parse('17'),
          ),
          _item(
            productId: 'b',
            qty: Decimal.parse('1.5'),
            unitPrice: Decimal.parse('40'),
            discountAmount: Decimal.parse('5'),
            taxRate: Decimal.parse('17'),
          ),
        ],
        'cartDiscountType': 'fixed',
        'cartDiscountValue': Decimal.parse('12.50'),
      },
      {
        'name': 'percentage cart + mixed line discounts',
        'items': [
          _item(
            productId: 'a',
            qty: Decimal.fromInt(2),
            unitPrice: Decimal.fromInt(100),
            discountPct: Decimal.fromInt(5),
            taxRate: Decimal.parse('15'),
          ),
          _item(
            productId: 'b',
            qty: Decimal.one,
            unitPrice: Decimal.fromInt(50),
            taxRate: Decimal.parse('15'),
          ),
        ],
        'cartDiscountType': 'percentage',
        'cartDiscountValue': Decimal.parse('7.5'),
      },
    ];

    for (final scenario in scenarios) {
      test('${scenario['name']}', () {
        final items = scenario['items'] as List<CartItemModel>;
        final cartDiscountType = scenario['cartDiscountType'] as String?;
        final cartDiscountValue =
            scenario['cartDiscountValue'] as Decimal? ?? Decimal.zero;

        final client = PosCalculations.computeAuthoritativeTotals(
          items: items,
          cartDiscountType: cartDiscountType,
          cartDiscountValue: cartDiscountValue,
        );

        final engine = _previewTotalsFromBuiltLines(
          items: items,
          cartDiscountType: cartDiscountType,
          cartDiscountValue: cartDiscountValue,
        );

        expect(
          _withinTolerance(client.subtotal, engine['subtotal']!),
          isTrue,
          reason: 'subtotal diverged',
        );
        expect(
          _withinTolerance(client.totalDiscount, engine['total_discount']!),
          isTrue,
          reason: 'total_discount diverged',
        );
        expect(
          _withinTolerance(client.totalTax, engine['total_tax']!),
          isTrue,
          reason: 'total_tax diverged',
        );
        expect(
          _withinTolerance(client.totalAmount, engine['total_amount']!),
          isTrue,
          reason: 'total_amount diverged',
        );
      });
    }
  });

  group('no-scheme parity vs POST /sales/price-preview', () {
    final integration = Platform.environment['INTEGRATION_TEST'] == 'true';
    final apiBase =
        Platform.environment['API_BASE'] ?? 'http://127.0.0.1:8000/api/v1';
    final token = Platform.environment['TEST_ACCESS_TOKEN'];
    final branchId = Platform.environment['TEST_BRANCH_ID'] ?? _branchId;
    final productA = Platform.environment['TEST_PRODUCT_A'];
    final productB = Platform.environment['TEST_PRODUCT_B'];

    test(
      'preview API totals match client authoritative totals within 0.01',
      () async {
        expect(token, isNotNull, reason: 'TEST_ACCESS_TOKEN required');
        expect(productA, isNotNull, reason: 'TEST_PRODUCT_A required');
        expect(productB, isNotNull, reason: 'TEST_PRODUCT_B required');

        final items = [
          _item(
            productId: productA!,
            qty: Decimal.fromInt(2),
            unitPrice: Decimal.fromInt(100),
            discountPct: Decimal.fromInt(10),
            discountAmount: Decimal.fromInt(5),
            taxRate: Decimal.parse('15'),
          ),
          _item(
            productId: productB!,
            qty: Decimal.one,
            unitPrice: Decimal.fromInt(50),
            taxRate: Decimal.parse('15'),
          ),
        ];

        final client = PosCalculations.computeAuthoritativeTotals(
          items: items,
          cartDiscountType: 'percentage',
          cartDiscountValue: Decimal.parse('5'),
        );

        final body = PosSaleRequestBuilder.buildBody(
          branchId: branchId,
          items: items,
          cartDiscountType: 'percentage',
          cartDiscountValue: Decimal.parse('5'),
        );

        final dio = Dio(
          BaseOptions(
            baseUrl: apiBase,
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        final response = await dio.post<Map<String, dynamic>>(
          '/sales/price-preview',
          data: body,
        );

        final preview = response.data!;
        final apiSubtotal = Decimal.parse('${preview['subtotal']}');
        final apiDiscount = Decimal.parse('${preview['total_discount']}');
        final apiTax = Decimal.parse('${preview['total_tax']}');
        final apiTotal = Decimal.parse('${preview['total_amount']}');

        expect(
          _withinTolerance(client.subtotal, apiSubtotal),
          isTrue,
          reason: 'subtotal client=${client.subtotal} api=$apiSubtotal',
        );
        expect(
          _withinTolerance(client.totalDiscount, apiDiscount),
          isTrue,
          reason:
              'total_discount client=${client.totalDiscount} api=$apiDiscount',
        );
        expect(
          _withinTolerance(client.totalTax, apiTax),
          isTrue,
          reason: 'total_tax client=${client.totalTax} api=$apiTax',
        );
        expect(
          _withinTolerance(client.totalAmount, apiTotal),
          isTrue,
          reason: 'total_amount client=${client.totalAmount} api=$apiTotal',
        );
      },
      skip: integration && token != null && productA != null && productB != null
          ? false
          : 'Set INTEGRATION_TEST=true, TEST_ACCESS_TOKEN, TEST_PRODUCT_A, TEST_PRODUCT_B',
    );
  });
}
