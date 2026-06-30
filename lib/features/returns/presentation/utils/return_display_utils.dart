import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';

String formatReturnDate(String? value) {
  if (value == null || value.trim().isEmpty) return '—';
  try {
    return DateFormatter.formatDateTime(DateTime.parse(value));
  } catch (_) {
    return value;
  }
}

String formatReturnAmount(String? amount) {
  if (amount == null || amount.isEmpty) return '—';
  return formatPKR(double.tryParse(amount) ?? 0);
}

Decimal refundTotal(SaleReturnResponseModel item) {
  var total = Decimal.zero;
  for (final payment in item.payments) {
    total += Decimal.tryParse(payment.amount) ?? Decimal.zero;
  }
  return total;
}

String formatRefundTotal(SaleReturnResponseModel item) =>
    formatReturnAmount(DecimalUtils.format(refundTotal(item)));

String refundMethodsLabel(SaleReturnResponseModel item) {
  final methods = item.payments
      .map((p) => p.paymentMethod)
      .where((m) => m.trim().isNotEmpty)
      .toSet()
      .toList();
  if (methods.isEmpty) return '—';
  return methods.join(', ');
}

String lineSubtotal(String qty, String unitPrice, String taxAmount) {
  final q = Decimal.tryParse(qty) ?? Decimal.zero;
  final price = Decimal.tryParse(unitPrice) ?? Decimal.zero;
  final tax = Decimal.tryParse(taxAmount) ?? Decimal.zero;
  return DecimalUtils.format(q * price + tax);
}
