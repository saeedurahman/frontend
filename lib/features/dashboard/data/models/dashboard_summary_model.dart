class DashboardSummaryModel {
  const DashboardSummaryModel({
    required this.todayRevenue,
    required this.todayTransactions,
    required this.todayProfit,
    required this.todayAvgOrder,
    required this.todayExpenses,
    required this.thisMonthRevenue,
    required this.thisMonthProfit,
    required this.revenueVsYesterdayPct,
    required this.lowStockAlerts,
    required this.outOfStockCount,
    required this.openShifts,
    required this.pendingCustomerReceivables,
    required this.pendingSupplierPayables,
    required this.cashInDrawer,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      todayRevenue: _toDouble(json['today_revenue']),
      todayTransactions: _toInt(json['today_transactions']),
      todayProfit: _toDouble(json['today_profit']),
      todayAvgOrder: _toDouble(json['today_avg_order']),
      todayExpenses: _toDouble(json['today_expenses']),
      thisMonthRevenue: _toDouble(json['this_month_revenue']),
      thisMonthProfit: _toDouble(json['this_month_profit']),
      revenueVsYesterdayPct: _toDouble(json['revenue_vs_yesterday_pct']),
      lowStockAlerts: _toInt(json['low_stock_alerts']),
      outOfStockCount: _toInt(json['out_of_stock_count']),
      openShifts: _toInt(json['open_shifts']),
      pendingCustomerReceivables: _toDouble(
        json['pending_customer_receivables'],
      ),
      pendingSupplierPayables: _toDouble(json['pending_supplier_payables']),
      cashInDrawer: _toDouble(json['cash_in_drawer']),
    );
  }

  final double todayRevenue;
  final int todayTransactions;
  final double todayProfit;
  final double todayAvgOrder;
  final double todayExpenses;
  final double thisMonthRevenue;
  final double thisMonthProfit;
  final double revenueVsYesterdayPct;
  final int lowStockAlerts;
  final int outOfStockCount;
  final int openShifts;
  final double pendingCustomerReceivables;
  final double pendingSupplierPayables;
  final double cashInDrawer;
}

class PaymentBreakdownModel {
  const PaymentBreakdownModel({
    required this.method,
    required this.amount,
  });

  factory PaymentBreakdownModel.fromJson(Map<String, dynamic> json) {
    return PaymentBreakdownModel(
      method: json['payment_method']?.toString() ?? 'unknown',
      amount: _toDouble(json['total_amount'] ?? json['amount']),
    );
  }

  final String method;
  final double amount;
}

class TopProductModel {
  const TopProductModel({
    required this.name,
    required this.unitsSold,
    required this.revenue,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      name: json['product_name']?.toString() ?? 'Unknown',
      unitsSold: _toInt(json['total_qty_sold'] ?? json['units_sold']),
      revenue: _toDouble(json['total_revenue'] ?? json['revenue']),
    );
  }

  final String name;
  final int unitsSold;
  final double revenue;
}

class RecentTransactionModel {
  const RecentTransactionModel({
    required this.invoiceNo,
    required this.customerName,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecentTransactionModel(
      invoiceNo: json['sale_number']?.toString() ??
          json['invoice_no']?.toString() ??
          '-',
      customerName: json['customer_name']?.toString() ?? 'Walk-in',
      status: json['status']?.toString() ?? 'completed',
      totalAmount: _toDouble(json['total_amount']),
      createdAt: DateTime.tryParse(
        json['sold_at']?.toString() ?? json['created_at']?.toString() ?? '',
      ),
    );
  }

  final String invoiceNo;
  final String customerName;
  final String status;
  final double totalAmount;
  final DateTime? createdAt;
}

class InventoryInsightsModel {
  const InventoryInsightsModel({
    required this.lowStockCount,
    required this.outOfStockCount,
  });

  factory InventoryInsightsModel.fromJson(Map<String, dynamic> json) {
    return InventoryInsightsModel(
      lowStockCount: _toInt(
        json['low_stock_count'] ?? json['low_stock_alerts'],
      ),
      outOfStockCount: _toInt(json['out_of_stock_count']),
    );
  }

  final int lowStockCount;
  final int outOfStockCount;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  // API Decimal fields serialize as strings like "12.0000".
  final asDouble = double.tryParse(value.toString());
  if (asDouble != null) return asDouble.round();
  return int.tryParse(value.toString()) ?? 0;
}
