import 'package:decimal/decimal.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

/// A return, shaped like a sale so the one receipt pipeline can draw it
/// (titled "Return", numbered with the return number). Prices and the
/// "prices include tax" mode come from the original sale's own snapshot
/// when this device has it.
abstract final class ReturnReceiptMapper {
  static Future<SaleResponseModel> toSale(SaleReturnResponseModel item) async {
    final store = sl.isRegistered<SyncStore>() ? sl<SyncStore>() : null;

    var inclusive = TaxSettingsHolder.current.inclusive;
    String? taxLabel = TaxSettingsHolder.current.label;
    final original = (store == null || item.saleId == null) ? null : await store.sale(item.saleId!);
    if (original != null) {
      inclusive = original['tax_inclusive'] == 1 || original['tax_inclusive'] == true;
      taxLabel = original['tax_label'] as String? ?? taxLabel;
    }

    var subtotal = Decimal.zero;
    var tax = Decimal.zero;
    final lines = <Map<String, dynamic>>[];
    for (final line in item.lines) {
      final qty = Decimal.tryParse(line.qty) ?? Decimal.zero;
      final price = Decimal.tryParse(line.unitPrice) ?? Decimal.zero;
      final lineTax = Decimal.tryParse(line.taxAmount) ?? Decimal.zero;
      final net = inclusive ? (qty * price - lineTax) : qty * price;
      final total = inclusive ? qty * price : qty * price + lineTax;
      subtotal += net;
      tax += lineTax;
      final product = store == null ? null : await store.entity('product', line.productId);
      final variation = line.variationId == null || store == null
          ? null
          : await store.entity('product_variation', line.variationId!);
      lines.add({
        'id': line.id,
        'product_id': line.productId,
        'variation_id': line.variationId,
        'qty': line.qty,
        'unit_price': line.unitPrice,
        'tax_amount': line.taxAmount,
        'net_amount': DecimalUtils.format(net),
        'line_total': DecimalUtils.format(total),
        'product_name': product?['name'] ?? 'Item',
        'variation_name': variation?['name'],
      });
    }
    final total = subtotal + tax;
    var refunded = Decimal.zero;
    for (final p in item.payments) {
      refunded += Decimal.tryParse(p.amount) ?? Decimal.zero;
    }
    return SaleResponseModel.fromJson({
      'id': item.id,
      'sale_number': item.returnNumber,
      'client_receipt_no': item.returnNumber,
      'branch_id': item.branchId,
      'customer_id': item.customerId,
      'sale_type': 'return',
      'sale_status': 'completed',
      'subtotal': DecimalUtils.format(subtotal),
      'total_discount': '0',
      'total_tax': DecimalUtils.format(tax),
      'net_amount': DecimalUtils.format(subtotal),
      'rounding_amount': '0',
      'tax_inclusive': inclusive,
      'tax_label': taxLabel,
      'total_amount': DecimalUtils.format(total),
      'total_paid': DecimalUtils.format(refunded),
      'sold_at': item.returnedAt ?? item.createdAt,
      'created_at': item.createdAt,
      'lines': lines,
      'payments': [
        for (final p in item.payments)
          {'id': p.id, 'payment_method': p.paymentMethod, 'amount': p.amount},
      ],
      'offline': false,
    });
  }
}
