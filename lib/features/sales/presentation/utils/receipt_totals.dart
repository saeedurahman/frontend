import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/domain/utils/tax_groups.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

/// One row of the receipt's totals block.
class ReceiptTotalLine {
  const ReceiptTotalLine(this.label, this.value);
  final String label;
  final String value;
}

/// What a receipt (print, preview, reprint, WhatsApp/text) shows under the
/// items, built only from the SALE's own snapshot - never today's settings - so
/// an old sale reprints exactly as it was printed.
///
/// Rows: Subtotal, Discount (if any), tax by rate (if the sale shows its
/// breakdown), Rounding (only when not zero), then the grand total.
/// [pricesIncludeTax] drives the single "Prices include tax" note.
class ReceiptTotals {
  const ReceiptTotals({
    required this.lines,
    required this.total,
    required this.pricesIncludeTax,
  });

  final List<ReceiptTotalLine> lines;

  /// Grand total, e.g. "Rs. 14.04".
  final String total;
  final bool pricesIncludeTax;

  static const includesTaxNote = 'Prices include tax';

  static Decimal _d(String? v) => Decimal.tryParse(v ?? '') ?? Decimal.zero;

  static ReceiptTotals fromSale(SaleResponseModel sale) {
    final label = (sale.taxLabel == null || sale.taxLabel!.trim().isEmpty)
        ? 'Tax'
        : sale.taxLabel!;
    final tax = _d(sale.totalTax);
    final discount = _d(sale.totalDiscount);
    final rounding = _d(sale.roundingAmount);
    final inclusive = sale.taxInclusive;
    final hasTax = tax > Decimal.zero;
    // The server tells us whether to show the breakdown; old sales that do not
    // carry the flag keep showing their tax.
    final showBreakdown = sale.showTaxBreakdown ?? true;

    final rows = <ReceiptTotalLine>[
      ReceiptTotalLine('Subtotal', formatPKR(_subtotal(sale))),
      if (discount > Decimal.zero)
        ReceiptTotalLine('Discount', '-${formatPKR(discount)}'),
    ];

    if (hasTax && showBreakdown) {
      final groups = _groups(sale, label);
      if (groups.isEmpty) {
        rows.add(ReceiptTotalLine(
          inclusive ? 'Includes $label' : label,
          formatPKR(tax),
        ));
      } else {
        for (final g in groups) {
          rows.add(ReceiptTotalLine(
            '${inclusive ? 'Includes ' : ''}${g.title(label)}',
            formatPKR(g.tax),
          ));
        }
      }
    } else if (hasTax && !inclusive) {
      // Tax is hidden by the owner but it is in the total: one plain row so
      // the numbers still add up.
      rows.add(ReceiptTotalLine(label, formatPKR(tax)));
    }

    if (rounding != Decimal.zero) {
      rows.add(ReceiptTotalLine('Rounding', formatSignedMoney(rounding)));
    }
    return ReceiptTotals(
      lines: rows,
      total: formatPKR(_d(sale.totalAmount)),
      pricesIncludeTax: inclusive && hasTax,
    );
  }

  static Decimal _subtotal(SaleResponseModel sale) {
    final given = Decimal.tryParse(sale.subtotal ?? '');
    if (given != null) return given;
    return sale.lines.fold<Decimal>(
      Decimal.zero,
      (s, l) => s + (DecimalUtils.parse(l.qty) * DecimalUtils.parse(l.unitPrice)),
    );
  }

  static List<TaxGroup> _groups(SaleResponseModel sale, String label) {
    if (sale.taxBreakdown.isNotEmpty) {
      return TaxGroup.group([
        for (final b in sale.taxBreakdown)
          (rate: _d(b.taxRate), net: _d(b.netAmount), tax: _d(b.taxAmount)),
      ], label: label);
    }
    return TaxGroup.group([
      for (final l in sale.lines)
        (rate: _d(l.taxRate), net: _d(l.netAmount), tax: _d(l.taxAmount)),
    ], label: label);
  }

  /// Plain-text rows (WhatsApp / copied text), "Label: value".
  List<String> textLines() => [
        for (final l in lines) '${l.label}: ${l.value}',
      ];
}
