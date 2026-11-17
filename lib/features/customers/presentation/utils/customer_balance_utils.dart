import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';

typedef BalanceDisplay = ({String text, bool isOwed});

abstract final class CustomerBalanceUtils {
  static Decimal parseBalance(String? balance) {
    if (balance == null || balance.isEmpty || balance == '—') {
      return Decimal.zero;
    }
    try {
      return DecimalUtils.parse(balance);
    } catch (_) {
      return Decimal.zero;
    }
  }

  static Decimal amountOwed(String? balance) {
    final parsed = parseBalance(balance);
    if (parsed < Decimal.zero) {
      return parsed.abs();
    }
    return Decimal.zero;
  }

  static bool hasOutstanding(String? balance) =>
      parseBalance(balance) < Decimal.zero;

  static BalanceDisplay formatBalanceDisplay(String? balance) {
    final parsed = parseBalance(balance);
    if (parsed < Decimal.zero) {
      return (
        text: formatPKR(parsed.abs()),
        isOwed: true,
      );
    }
    if (parsed > Decimal.zero) {
      return (
        text: formatPKR(parsed),
        isOwed: false,
      );
    }
    return (text: formatPKR(Decimal.zero), isOwed: false);
  }

  static String formatCreditLimit(String? creditLimit) {
    final parsed = parseBalance(creditLimit);
    if (parsed <= Decimal.zero) return 'No limit';
    return formatPKR(parsed);
  }

  static String ledgerEntryTypeLabel(LedgerEntryType type) => switch (type) {
        LedgerEntryType.sale => 'Credit Sale',
        LedgerEntryType.payment => 'Payment Received',
        LedgerEntryType.return_ => 'Return',
        LedgerEntryType.openingBalance => 'Opening Balance',
        LedgerEntryType.adjustment => 'Adjustment',
        LedgerEntryType.refund => 'Refund',
      };
}
