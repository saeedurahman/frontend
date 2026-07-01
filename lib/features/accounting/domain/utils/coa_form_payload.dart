/// Display labels and API payload builders for chart-of-accounts forms.
library;

const accountTypeLabels = <String, String>{
  'asset': 'Asset',
  'liability': 'Liability',
  'equity': 'Equity',
  'income': 'Income',
  'expense': 'Expense',
};

const accountSubtypeLabels = <String, String>{
  'cash': 'Cash',
  'bank': 'Bank',
  'accounts_receivable': 'Accounts Receivable',
  'accounts_payable': 'Accounts Payable',
  'inventory': 'Inventory',
  'cogs': 'Cost of Goods Sold',
  'sales_revenue': 'Sales Revenue',
  'tax_payable': 'Tax Payable',
  'other': 'Other',
};

String formatAccountType(String type) =>
    accountTypeLabels[type] ?? _titleCase(type);

String formatAccountSubtype(String? subtype) {
  if (subtype == null) return '—';
  return accountSubtypeLabels[subtype] ?? _titleCase(subtype);
}

String _titleCase(String value) {
  return value
      .split('_')
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}

Map<String, dynamic> buildCreateCoaPayload({
  required String accountCode,
  required String accountName,
  required String accountType,
  String? accountSubtype,
  String? parentId,
  String? description,
  required bool isActive,
}) {
  return {
    'account_code': accountCode.trim(),
    'account_name': accountName.trim(),
    'account_type': accountType,
    if (accountSubtype != null) 'account_subtype': accountSubtype,
    if (parentId != null) 'parent_id': parentId,
    if (description != null && description.trim().isNotEmpty)
      'description': description.trim(),
    'is_active': isActive,
  };
}

Map<String, dynamic> buildUpdateCoaPayload({
  required String accountCode,
  required String accountName,
  required String accountType,
  String? accountSubtype,
  String? parentId,
  String? description,
  required bool isActive,
  required bool isSystem,
}) {
  return {
    if (!isSystem) 'account_code': accountCode.trim(),
    'account_name': accountName.trim(),
    'account_type': accountType,
    if (accountSubtype != null) 'account_subtype': accountSubtype,
    'parent_id': parentId,
    if (description != null && description.trim().isNotEmpty)
      'description': description.trim()
    else
      'description': null,
    'is_active': isActive,
  };
}
