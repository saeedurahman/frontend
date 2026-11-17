import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/features/returns/presentation/cubit/process_return_state.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/receipt_share_service.dart';
import 'package:frantend/features/sales/presentation/utils/receipt_totals.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';

Decimal d(String v) => Decimal.parse(v);

/// 2 x Rs. 6 at 17% GST, tax added on top: 12.00 + 2.04 = 14.04.
SaleResponseModel exclusiveSale({
  String rounding = '0',
  String total = '14.04',
  bool? showBreakdown,
}) =>
    SaleResponseModel(
      id: 's1',
      branchId: 'b1',
      saleType: 'pos',
      saleStatus: 'completed',
      saleNumber: 'POS-1',
      subtotal: '12.00',
      totalDiscount: '0',
      totalTax: '2.04',
      netAmount: '12.00',
      exactTotal: '14.04',
      roundingAmount: rounding,
      taxInclusive: false,
      taxLabel: 'GST',
      showTaxBreakdown: showBreakdown,
      totalAmount: total,
      lines: const [
        SaleLineModel(
          id: 'l1',
          productId: 'p1',
          productName: 'Tea',
          qty: '2',
          unitPrice: '6.00',
          taxRate: '17.000',
          taxAmount: '2.04',
          netAmount: '12.00',
          lineTotal: '14.04',
        ),
      ],
    );

/// Same items, prices already include tax: 12.00, of which 1.74 is GST.
const inclusiveSale = SaleResponseModel(
  id: 's2',
  branchId: 'b1',
  saleType: 'pos',
  saleStatus: 'completed',
  saleNumber: 'POS-2',
  subtotal: '12.00',
  totalDiscount: '0',
  totalTax: '1.74',
  netAmount: '10.26',
  exactTotal: '12.00',
  taxInclusive: true,
  taxLabel: 'GST',
  showTaxBreakdown: true,
  totalAmount: '12.00',
  lines: [
    SaleLineModel(
      id: 'l1',
      productId: 'p1',
      productName: 'Tea',
      qty: '2',
      unitPrice: '6.00',
      taxRate: '17.000',
      taxAmount: '1.74',
      netAmount: '10.26',
      lineTotal: '12.00',
    ),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => TaxSettingsHolder.current = TaxSettings.defaults);

  group('receipt totals (both modes)', () {
    test('tax added on top: subtotal, GST 17%, total', () {
      final t = ReceiptTotals.fromSale(exclusiveSale());
      expect(t.lines.map((l) => '${l.label}|${l.value}'), [
        'Subtotal|Rs. 12.00',
        'GST 17%|Rs. 2.04',
      ]);
      expect(t.total, 'Rs. 14.04');
      expect(t.pricesIncludeTax, isFalse);
    });

    test('prices include tax: "Includes GST 17%" and the one-line note', () {
      final t = ReceiptTotals.fromSale(inclusiveSale);
      expect(t.lines.map((l) => '${l.label}|${l.value}'), [
        'Subtotal|Rs. 12.00',
        'Includes GST 17%|Rs. 1.74',
      ]);
      expect(t.total, 'Rs. 12.00');
      expect(t.pricesIncludeTax, isTrue);
    });

    test('rounding row appears only when it is not zero, signed', () {
      final none = ReceiptTotals.fromSale(exclusiveSale());
      expect(none.lines.any((l) => l.label == 'Rounding'), isFalse);
      final rounded =
          ReceiptTotals.fromSale(exclusiveSale(rounding: '-4.04', total: '10.00'));
      expect(rounded.lines.last.label, 'Rounding');
      expect(rounded.lines.last.value, '-4.04');
      expect(rounded.total, 'Rs. 10.00');
    });

    test('tax is grouped by rate from the sale lines', () {
      final sale = exclusiveSale().copyWith(
        totalTax: '12.04',
        totalAmount: '24.04',
        lines: [
          ...exclusiveSale().lines,
          const SaleLineModel(
            id: 'l2',
            productId: 'p2',
            qty: '1',
            unitPrice: '100',
            taxRate: '10.000',
            taxAmount: '10.00',
            netAmount: '100',
            lineTotal: '110',
          ),
        ],
      );
      final labels = ReceiptTotals.fromSale(sale).lines.map((l) => l.label);
      expect(labels, containsAll(['GST 10%', 'GST 17%']));
    });

    test('server breakdown wins when the sale carries one', () {
      final sale = exclusiveSale().copyWith(taxBreakdown: const [
        SaleTaxBreakdownModel(
          taxLabel: 'GST',
          taxRate: '17.000',
          netAmount: '12.00',
          taxAmount: '2.04',
        ),
      ]);
      expect(
        ReceiptTotals.fromSale(sale).lines.map((l) => l.label),
        contains('GST 17%'),
      );
    });

    test('breakdown hidden by the owner: one plain Tax row keeps the sum honest', () {
      final t = ReceiptTotals.fromSale(exclusiveSale(showBreakdown: false));
      expect(t.lines.any((l) => l.label == 'GST 17%'), isFalse);
      expect(t.lines.any((l) => l.label == 'GST' && l.value == 'Rs. 2.04'), isTrue);
    });

    test('a tax-free sale shows no tax rows and no note', () {
      const sale = SaleResponseModel(
        id: 's3',
        branchId: 'b',
        saleType: 'pos',
        saleStatus: 'completed',
        subtotal: '50',
        totalTax: '0',
        totalAmount: '50',
        taxInclusive: true,
      );
      final t = ReceiptTotals.fromSale(sale);
      expect(t.lines.map((l) => l.label), ['Subtotal']);
      expect(t.pricesIncludeTax, isFalse);
    });

    test('reprint uses the sale snapshot, not today\'s settings', () {
      // The shop later switched to inclusive pricing and rounding...
      TaxSettingsHolder.current =
          const TaxSettings(includeTax: true, roundingMode: 'nearest_10', label: 'VAT');
      // ...but an old exclusive sale still prints as it was made.
      final t = ReceiptTotals.fromSale(exclusiveSale());
      expect(t.lines.map((l) => l.label), ['Subtotal', 'GST 17%']);
      expect(t.total, 'Rs. 14.04');
      expect(t.pricesIncludeTax, isFalse);
    });

    test('an old sale with no snapshot fields still reprints', () {
      const legacy = SaleResponseModel(
        id: 'old',
        branchId: 'b',
        saleType: 'pos',
        saleStatus: 'completed',
        subtotal: '100',
        totalTax: '17',
        totalAmount: '117',
        lines: [
          SaleLineModel(
            id: 'l',
            productId: 'p',
            qty: '1',
            unitPrice: '100',
            taxRate: '17',
            taxAmount: '17',
          ),
        ],
      );
      final t = ReceiptTotals.fromSale(legacy);
      expect(t.total, 'Rs. 117.00');
      expect(t.lines.map((l) => l.label), contains('Tax 17%'));
    });

    test('hide .00 setting applies to receipt money too', () {
      TaxSettingsHolder.current = const TaxSettings(hideZeroDecimals: true);
      final t = ReceiptTotals.fromSale(inclusiveSale);
      expect(t.total, 'Rs. 12');
      expect(t.lines.last.value, 'Rs. 1.74');
    });

    test('line total fallback is not inflated for inclusive prices', () {
      const line = SaleLineModel(
        id: 'l',
        productId: 'p',
        qty: '2',
        unitPrice: '6',
        taxAmount: '1.74',
      );
      expect(SaleCalculations.lineTotal(line, inclusive: true), d('12'));
      expect(SaleCalculations.lineTotal(line), d('13.74'));
    });
  });

  group('plain-text receipt (WhatsApp / copy)', () {
    test('exclusive sale lists the tax and the total', () async {
      final text =
          await ReceiptShareService.buildPlainTextReceipt(exclusiveSale());
      expect(text, contains('Subtotal: Rs. 12.00'));
      expect(text, contains('GST 17%: Rs. 2.04'));
      expect(text, contains('*Total: Rs. 14.04*'));
      expect(text, isNot(contains(ReceiptTotals.includesTaxNote)));
    });

    test('inclusive sale says prices include tax once', () async {
      final text =
          await ReceiptShareService.buildPlainTextReceipt(inclusiveSale);
      expect(text, contains('Includes GST 17%: Rs. 1.74'));
      expect(text, contains('*Total: Rs. 12.00*'));
      expect(
        ReceiptTotals.includesTaxNote.allMatches(text).length,
        1,
      );
    });

    test('rounding appears in the text only when present', () async {
      final text = await ReceiptShareService.buildPlainTextReceipt(
        exclusiveSale(rounding: '-4.04', total: '10.00'),
      );
      expect(text, contains('Rounding: -4.04'));
      expect(text, contains('*Total: Rs. 10.00*'));
    });
  });

  group('returns use the sale snapshot', () {
    ReturnLineFormItem returnLine({
      required String qty,
      required String returnQty,
      String price = '6',
      String tax = '0',
      String discount = '0',
      bool inclusive = false,
    }) =>
        ReturnLineFormItem(
          originalSaleLineId: 'l',
          productId: 'p',
          productName: 'Tea',
          originalQty: qty,
          returnQty: returnQty,
          unitPrice: price,
          originalTaxAmount: tax,
          originalDiscountAmount: discount,
          taxInclusive: inclusive,
        );

    ProcessReturnState state(
      List<ReturnLineFormItem> lines, {
      String mode = 'none',
      bool inclusive = false,
      String total = '14.04',
    }) =>
        ProcessReturnState(
          originalSale: exclusiveSale(total: total).copyWith(
            taxRoundingMode: mode,
            taxInclusive: inclusive,
          ),
          returnLines: lines,
        );

    test('full return refunds exactly the original total (exclusive)', () {
      final s = state([
        returnLine(qty: '2', returnQty: '2', tax: '2.04'),
      ]);
      expect(s.totalReturnAmount, d('14.04'));
    });

    test('partial return prorates net and tax', () {
      final s = state([
        returnLine(qty: '2', returnQty: '1', tax: '2.04'),
      ]);
      expect(s.totalReturnAmount, d('7.02'));
    });

    test('inclusive: tax is already in the price, not added again', () {
      final s = state(
        [returnLine(qty: '2', returnQty: '1', tax: '1.74', inclusive: true)],
        inclusive: true,
      );
      expect(s.totalReturnAmount, d('6.00'));
    });

    test('discount is prorated with the line', () {
      final s = state([
        returnLine(qty: '4', returnQty: '1', price: '25', tax: '0', discount: '10'),
      ]);
      expect(s.totalReturnAmount, d('22.50'));
    });

    test('only the refund TOTAL is rounded, with the sale\'s own mode', () {
      // Two lines of 7.02 each: 14.04 exactly; the sale was rounded to nearest 5.
      final lines = [
        returnLine(qty: '1', returnQty: '1', tax: '1.02'),
        returnLine(qty: '1', returnQty: '1', tax: '1.02'),
      ];
      final partial = state([lines.first], mode: 'nearest_5', total: '15.00');
      expect(partial.totalReturnAmount, d('5.00')); // 7.02 -> 5
      final full = state(lines, mode: 'nearest_5', total: '15.00');
      expect(full.totalReturnAmount, d('15.00')); // 14.04 -> 15 = original total
    });

    test('a full return of a rounded sale equals the original rounded total', () {
      final full = state(
        [returnLine(qty: '3', returnQty: '3', tax: '3.06')], // 18 + 3.06 = 21.06
        mode: 'nearest_5',
        total: '20.00',
      );
      expect(full.totalReturnAmount, d('20.00'));
    });

    test('per-line amounts are only shown, never summed after rounding', () {
      final line = returnLine(qty: '3', returnQty: '1', tax: '3.06');
      expect(line.lineRefundAmount, d('7.02'));
    });
  });
}
