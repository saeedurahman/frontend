import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/reports/data/models/analytics_report_models.dart';
import 'package:frantend/features/reports/presentation/widgets/report_widgets.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';

const _cashierColumns = [
  AppDataTableColumn(label: 'Cashier', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Transactions', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Revenue', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Avg Sale', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Returns', flex: 1, sortable: true),
];

class CashierPerformanceTable extends StatelessWidget {
  const CashierPerformanceTable({super.key, required this.items});

  final List<CashierPerformanceModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<CashierPerformanceModel>(
      columns: _cashierColumns,
      items: items,
      itemId: (item) => item.userId,
      itemLabel: 'cashiers',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _cashierColumns,
          cells: [
            reportTableText(item.userName, fontWeight: FontWeight.w600),
            reportTableText('${item.totalSales}'),
            reportTableText(money(item.totalRevenue)),
            reportTableText(money(item.avgOrderValue)),
            reportTableText('${item.totalReturns}'),
          ],
        );
      },
    );
  }

  static int _sortCompare(
    CashierPerformanceModel a,
    CashierPerformanceModel b,
    int column,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(a.userName.toLowerCase(), b.userName.toLowerCase()),
      1 => compare(a.totalSales, b.totalSales),
      2 => compare(
          reportMoneySortKey(a.totalRevenue),
          reportMoneySortKey(b.totalRevenue),
        ),
      3 => compare(
          reportMoneySortKey(a.avgOrderValue),
          reportMoneySortKey(b.avgOrderValue),
        ),
      4 => compare(a.totalReturns, b.totalReturns),
      _ => 0,
    };
  }
}

const _topProductColumns = [
  AppDataTableColumn(label: '#', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Product', flex: 3, sortable: true),
  AppDataTableColumn(label: 'Units', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Revenue', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Profit', flex: 2, sortable: true),
];

class TopProductsTable extends StatelessWidget {
  const TopProductsTable({super.key, required this.items});

  final List<AnalyticsTopProductModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<AnalyticsTopProductModel>(
      columns: _topProductColumns,
      items: items,
      itemId: (item) => '${item.productId}-${item.rank}',
      itemLabel: 'products',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _topProductColumns,
          cells: [
            reportTableText('${item.rank}'),
            reportTableText(_productLabel(item.productName, item.variationName)),
            reportTableText(item.totalQtySold),
            reportTableText(money(item.totalRevenue)),
            reportTableText(money(item.grossProfit)),
          ],
        );
      },
    );
  }

  static int _sortCompare(
    AnalyticsTopProductModel a,
    AnalyticsTopProductModel b,
    int column,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(a.rank, b.rank),
      1 => compare(
          _productLabel(a.productName, a.variationName).toLowerCase(),
          _productLabel(b.productName, b.variationName).toLowerCase(),
        ),
      2 => compare(
          reportMoneySortKey(a.totalQtySold),
          reportMoneySortKey(b.totalQtySold),
        ),
      3 => compare(
          reportMoneySortKey(a.totalRevenue),
          reportMoneySortKey(b.totalRevenue),
        ),
      4 => compare(
          reportMoneySortKey(a.grossProfit),
          reportMoneySortKey(b.grossProfit),
        ),
      _ => 0,
    };
  }
}

const _categoryColumns = [
  AppDataTableColumn(label: 'Category', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Revenue', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Transactions', flex: 1, sortable: true),
  AppDataTableColumn(label: '% of Total', flex: 1, sortable: true),
];

class CategoryPerformanceTable extends StatelessWidget {
  const CategoryPerformanceTable({super.key, required this.items});

  final List<CategoryPerformanceModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<CategoryPerformanceModel>(
      columns: _categoryColumns,
      items: items,
      itemId: (item) => item.categoryId,
      itemLabel: 'categories',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _categoryColumns,
          cells: [
            reportTableText(item.categoryName, fontWeight: FontWeight.w600),
            reportTableText(money(item.totalRevenue)),
            reportTableText('${item.totalTransactions}'),
            reportTableText(pct(item.percentageOfTotal)),
          ],
        );
      },
    );
  }

  static int _sortCompare(
    CategoryPerformanceModel a,
    CategoryPerformanceModel b,
    int column,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          a.categoryName.toLowerCase(),
          b.categoryName.toLowerCase(),
        ),
      1 => compare(
          reportMoneySortKey(a.totalRevenue),
          reportMoneySortKey(b.totalRevenue),
        ),
      2 => compare(a.totalTransactions, b.totalTransactions),
      3 => compare(
          reportMoneySortKey(a.percentageOfTotal),
          reportMoneySortKey(b.percentageOfTotal),
        ),
      _ => 0,
    };
  }
}

const _movementColumns = [
  AppDataTableColumn(label: 'Product', flex: 3, sortable: true),
  AppDataTableColumn(label: 'Category', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Qty Sold', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Revenue', flex: 2, sortable: true),
];

class ProductMovementTable extends StatelessWidget {
  const ProductMovementTable({super.key, required this.items});

  final List<ProductMovementModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<ProductMovementModel>(
      columns: _movementColumns,
      items: items,
      itemId: (item) => item.productId,
      itemLabel: 'products',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _movementColumns,
          cells: [
            reportTableText(_productLabel(item.productName, item.variationName)),
            _MovementCategoryChip(category: item.movementCategory),
            reportTableText(item.totalQtySold),
            reportTableText(money(item.totalRevenue)),
          ],
        );
      },
    );
  }

  static int _sortCompare(
    ProductMovementModel a,
    ProductMovementModel b,
    int column,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          _productLabel(a.productName, a.variationName).toLowerCase(),
          _productLabel(b.productName, b.variationName).toLowerCase(),
        ),
      1 => compare(
          a.movementCategory.toLowerCase(),
          b.movementCategory.toLowerCase(),
        ),
      2 => compare(
          reportMoneySortKey(a.totalQtySold),
          reportMoneySortKey(b.totalQtySold),
        ),
      3 => compare(
          reportMoneySortKey(a.totalRevenue),
          reportMoneySortKey(b.totalRevenue),
        ),
      _ => 0,
    };
  }
}

const _deadStockColumns = [
  AppDataTableColumn(label: 'Product', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Branch', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Qty', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Days Idle', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Stock Value', flex: 2, sortable: true),
];

class DeadStockTable extends StatelessWidget {
  const DeadStockTable({super.key, required this.items});

  final List<DeadStockModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<DeadStockModel>(
      columns: _deadStockColumns,
      items: items,
      itemId: (item) => '${item.productId}-${item.branchId}',
      itemLabel: 'items',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _deadStockColumns,
          cells: [
            reportTableText(item.productName, fontWeight: FontWeight.w600),
            reportTableText(item.branchName),
            reportTableText(item.currentQty),
            reportTableText('${item.daysSinceLastSale}'),
            reportTableText(money(item.stockValue)),
          ],
        );
      },
    );
  }

  static int _sortCompare(DeadStockModel a, DeadStockModel b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(a.productName.toLowerCase(), b.productName.toLowerCase()),
      1 => compare(a.branchName.toLowerCase(), b.branchName.toLowerCase()),
      2 => compare(
          reportMoneySortKey(a.currentQty),
          reportMoneySortKey(b.currentQty),
        ),
      3 => compare(a.daysSinceLastSale, b.daysSinceLastSale),
      4 => compare(
          reportMoneySortKey(a.stockValue),
          reportMoneySortKey(b.stockValue),
        ),
      _ => 0,
    };
  }
}

const _stockValuationColumns = [
  AppDataTableColumn(label: 'Product', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Branch', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Qty', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Avg Cost', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Value', flex: 2, sortable: true),
];

class StockValuationTable extends StatelessWidget {
  const StockValuationTable({super.key, required this.items});

  final List<StockValuationModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<StockValuationModel>(
      columns: _stockValuationColumns,
      items: items,
      itemId: (item) => '${item.productId}-${item.branchId}',
      itemLabel: 'items',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _stockValuationColumns,
          cells: [
            reportTableText(item.productName, fontWeight: FontWeight.w600),
            reportTableText(item.branchName),
            reportTableText(item.currentQty),
            reportTableText(money(item.avgCost)),
            reportTableText(money(item.totalValue)),
          ],
        );
      },
    );
  }

  static int _sortCompare(
    StockValuationModel a,
    StockValuationModel b,
    int column,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(a.productName.toLowerCase(), b.productName.toLowerCase()),
      1 => compare(a.branchName.toLowerCase(), b.branchName.toLowerCase()),
      2 => compare(
          reportMoneySortKey(a.currentQty),
          reportMoneySortKey(b.currentQty),
        ),
      3 => compare(
          reportMoneySortKey(a.avgCost),
          reportMoneySortKey(b.avgCost),
        ),
      4 => compare(
          reportMoneySortKey(a.totalValue),
          reportMoneySortKey(b.totalValue),
        ),
      _ => 0,
    };
  }
}

const _customerColumns = [
  AppDataTableColumn(label: 'Customer', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Purchases', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Total Spent', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Outstanding', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Avg Order', flex: 2, sortable: true),
];

class TopCustomersTable extends StatelessWidget {
  const TopCustomersTable({super.key, required this.items});

  final List<CustomerInsightModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<CustomerInsightModel>(
      columns: _customerColumns,
      items: items,
      itemId: (item) => item.customerId,
      itemLabel: 'customers',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _customerColumns,
          cells: [
            reportTableText(item.customerName, fontWeight: FontWeight.w600),
            reportTableText('${item.totalPurchases}'),
            reportTableText(money(item.totalSpent)),
            reportTableText(money(item.outstandingBalance)),
            reportTableText(money(item.avgOrderValue)),
          ],
        );
      },
    );
  }

  static int _sortCompare(
    CustomerInsightModel a,
    CustomerInsightModel b,
    int column,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          a.customerName.toLowerCase(),
          b.customerName.toLowerCase(),
        ),
      1 => compare(a.totalPurchases, b.totalPurchases),
      2 => compare(
          reportMoneySortKey(a.totalSpent),
          reportMoneySortKey(b.totalSpent),
        ),
      3 => compare(
          reportMoneySortKey(a.outstandingBalance),
          reportMoneySortKey(b.outstandingBalance),
        ),
      4 => compare(
          reportMoneySortKey(a.avgOrderValue),
          reportMoneySortKey(b.avgOrderValue),
        ),
      _ => 0,
    };
  }
}

const _expenseColumns = [
  AppDataTableColumn(label: 'Category', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Amount', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Count', flex: 1, sortable: true),
  AppDataTableColumn(label: '% of Total', flex: 1, sortable: true),
];

class ExpenseSummaryTable extends StatelessWidget {
  const ExpenseSummaryTable({super.key, required this.items});

  final List<ExpenseSummaryModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<ExpenseSummaryModel>(
      columns: _expenseColumns,
      items: items,
      itemId: (item) => item.categoryId,
      itemLabel: 'categories',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _expenseColumns,
          cells: [
            reportTableText(item.categoryName, fontWeight: FontWeight.w600),
            reportTableText(money(item.totalAmount)),
            reportTableText('${item.transactionCount}'),
            reportTableText(pct(item.percentageOfTotal)),
          ],
        );
      },
    );
  }

  static int _sortCompare(
    ExpenseSummaryModel a,
    ExpenseSummaryModel b,
    int column,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          a.categoryName.toLowerCase(),
          b.categoryName.toLowerCase(),
        ),
      1 => compare(
          reportMoneySortKey(a.totalAmount),
          reportMoneySortKey(b.totalAmount),
        ),
      2 => compare(a.transactionCount, b.transactionCount),
      3 => compare(
          reportMoneySortKey(a.percentageOfTotal),
          reportMoneySortKey(b.percentageOfTotal),
        ),
      _ => 0,
    };
  }
}

const _taxRateColumns = [
  AppDataTableColumn(label: 'Rate %', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Taxable Sales', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Tax Amount', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Count', flex: 1, sortable: true),
];

class TaxByRateTable extends StatelessWidget {
  const TaxByRateTable({super.key, required this.items});

  final List<TaxByRateModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<TaxByRateModel>(
      columns: _taxRateColumns,
      items: items,
      itemId: (item) => item.taxRate,
      itemLabel: 'rates',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _taxRateColumns,
          cells: [
            reportTableText(pct(item.taxRate)),
            reportTableText(money(item.totalSalesAmount)),
            reportTableText(money(item.totalTaxAmount)),
            reportTableText('${item.transactionCount}'),
          ],
        );
      },
    );
  }

  static int _sortCompare(TaxByRateModel a, TaxByRateModel b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          reportMoneySortKey(a.taxRate),
          reportMoneySortKey(b.taxRate),
        ),
      1 => compare(
          reportMoneySortKey(a.totalSalesAmount),
          reportMoneySortKey(b.totalSalesAmount),
        ),
      2 => compare(
          reportMoneySortKey(a.totalTaxAmount),
          reportMoneySortKey(b.totalTaxAmount),
        ),
      3 => compare(a.transactionCount, b.transactionCount),
      _ => 0,
    };
  }
}

const _fraudColumns = [
  AppDataTableColumn(label: 'Severity', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Type', flex: 2, sortable: true),
  AppDataTableColumn(label: 'User', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Count', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Amount', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Description', flex: 3, sortable: true),
];

class FraudAlertsTable extends StatelessWidget {
  const FraudAlertsTable({super.key, required this.items});

  final List<FraudAlertModel> items;

  @override
  Widget build(BuildContext context) {
    return ReportPaginatedTable<FraudAlertModel>(
      columns: _fraudColumns,
      items: items,
      itemId: (item) => '${item.alertType}-${item.userId}-${item.branchId}',
      itemLabel: 'alerts',
      sortCompare: _sortCompare,
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return reportTableRow(
          columns: _fraudColumns,
          cells: [
            _SeverityChip(severity: item.severity),
            reportTableText(item.alertType),
            reportTableText(item.userName),
            reportTableText('${item.count}'),
            reportTableText(money(item.totalAmount)),
            reportTableText(item.description, secondary: true),
          ],
        );
      },
    );
  }

  static int _sortCompare(FraudAlertModel a, FraudAlertModel b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(a.severity.toLowerCase(), b.severity.toLowerCase()),
      1 => compare(a.alertType.toLowerCase(), b.alertType.toLowerCase()),
      2 => compare(a.userName.toLowerCase(), b.userName.toLowerCase()),
      3 => compare(a.count, b.count),
      4 => compare(
          reportMoneySortKey(a.totalAmount),
          reportMoneySortKey(b.totalAmount),
        ),
      5 => compare(
          a.description.toLowerCase(),
          b.description.toLowerCase(),
        ),
      _ => 0,
    };
  }
}

String _productLabel(String name, String? variation) {
  return variation != null ? '$name ($variation)' : name;
}

class _MovementCategoryChip extends StatelessWidget {
  const _MovementCategoryChip({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final label = switch (category.toLowerCase()) {
      'fast' => 'Fast',
      'slow' => 'Slow',
      'dead' => 'Dead',
      _ => category,
    };
    final color = switch (category.toLowerCase()) {
      'fast' => AppColors.success,
      'slow' => AppColors.accent,
      'dead' => AppColors.error,
      _ => AppColors.textSecondary,
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _SeverityChip extends StatelessWidget {
  const _SeverityChip({required this.severity});

  final String severity;

  @override
  Widget build(BuildContext context) {
    final color = switch (severity.toLowerCase()) {
      'high' || 'critical' => AppColors.error,
      'medium' => AppColors.accent,
      _ => AppColors.textSecondary,
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          severity.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
