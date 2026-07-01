import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';

/// Suggested account_subtype options per account_type for form dropdowns.
///
/// Backend validates subtype enum only — not type pairing — but this map
/// keeps the UI aligned with the seeded default chart.
const Map<String, List<String>> accountSubtypesByType = {
  AccountType.asset: [
    AccountSubtype.cash,
    AccountSubtype.bank,
    AccountSubtype.accountsReceivable,
    AccountSubtype.inventory,
    AccountSubtype.other,
  ],
  AccountType.liability: [
    AccountSubtype.accountsPayable,
    AccountSubtype.taxPayable,
    AccountSubtype.other,
  ],
  AccountType.equity: [
    AccountSubtype.other,
  ],
  AccountType.income: [
    AccountSubtype.salesRevenue,
    AccountSubtype.other,
  ],
  AccountType.expense: [
    AccountSubtype.cogs,
    AccountSubtype.other,
  ],
};

List<String> subtypesForAccountType(String accountType) =>
    accountSubtypesByType[accountType] ?? const [AccountSubtype.other];

String? defaultSubtypeForType(String accountType) {
  final options = subtypesForAccountType(accountType);
  return options.isEmpty ? null : options.first;
}

bool isSubtypeValidForType(String accountType, String? subtype) {
  if (subtype == null) return true;
  return subtypesForAccountType(accountType).contains(subtype);
}
