import 'package:frantend/core/utils/api_json_utils.dart';

String _s(dynamic v, {String fallback = '0'}) =>
    ApiJsonUtils.stringValue(v, fallback: fallback);

int _i(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

List<T> _list<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((e) => fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

class SalesSummaryModel {
  const SalesSummaryModel({
    required this.periodStart,
    required this.periodEnd,
    required this.totalRevenue,
    required this.totalCost,
    required this.grossProfit,
    required this.grossMarginPct,
    required this.totalTransactions,
    required this.avgOrderValue,
    required this.totalDiscount,
    required this.totalTax,
    required this.totalReturns,
    required this.netRevenue,
  });

  factory SalesSummaryModel.fromJson(Map<String, dynamic> json) =>
      SalesSummaryModel(
        periodStart: json['period_start']?.toString() ?? '',
        periodEnd: json['period_end']?.toString() ?? '',
        totalRevenue: _s(json['total_revenue']),
        totalCost: _s(json['total_cost']),
        grossProfit: _s(json['gross_profit']),
        grossMarginPct: _s(json['gross_margin_pct']),
        totalTransactions: _i(json['total_transactions']),
        avgOrderValue: _s(json['avg_order_value']),
        totalDiscount: _s(json['total_discount']),
        totalTax: _s(json['total_tax']),
        totalReturns: _s(json['total_returns']),
        netRevenue: _s(json['net_revenue']),
      );

  final String periodStart;
  final String periodEnd;
  final String totalRevenue;
  final String totalCost;
  final String grossProfit;
  final String grossMarginPct;
  final int totalTransactions;
  final String avgOrderValue;
  final String totalDiscount;
  final String totalTax;
  final String totalReturns;
  final String netRevenue;
}

class TodayVsYesterdayModel {
  const TodayVsYesterdayModel({
    required this.todayRevenue,
    required this.yesterdayRevenue,
    required this.revenueChangePct,
    required this.todayTransactions,
    required this.yesterdayTransactions,
    required this.transactionChangePct,
    required this.todayProfit,
    required this.yesterdayProfit,
    required this.profitChangePct,
    required this.todayAvgOrder,
    required this.yesterdayAvgOrder,
  });

  factory TodayVsYesterdayModel.fromJson(Map<String, dynamic> json) =>
      TodayVsYesterdayModel(
        todayRevenue: _s(json['today_revenue']),
        yesterdayRevenue: _s(json['yesterday_revenue']),
        revenueChangePct: _s(json['revenue_change_pct']),
        todayTransactions: _i(json['today_transactions']),
        yesterdayTransactions: _i(json['yesterday_transactions']),
        transactionChangePct: _s(json['transaction_change_pct']),
        todayProfit: _s(json['today_profit']),
        yesterdayProfit: _s(json['yesterday_profit']),
        profitChangePct: _s(json['profit_change_pct']),
        todayAvgOrder: _s(json['today_avg_order']),
        yesterdayAvgOrder: _s(json['yesterday_avg_order']),
      );

  final String todayRevenue;
  final String yesterdayRevenue;
  final String revenueChangePct;
  final int todayTransactions;
  final int yesterdayTransactions;
  final String transactionChangePct;
  final String todayProfit;
  final String yesterdayProfit;
  final String profitChangePct;
  final String todayAvgOrder;
  final String yesterdayAvgOrder;
}

class AnalyticsSalesTrendItemModel {
  const AnalyticsSalesTrendItemModel({
    required this.period,
    required this.revenue,
    required this.transactions,
    required this.avgOrderValue,
  });

  factory AnalyticsSalesTrendItemModel.fromJson(Map<String, dynamic> json) =>
      AnalyticsSalesTrendItemModel(
        period: json['period']?.toString() ?? '',
        revenue: _s(json['revenue']),
        transactions: _i(json['transactions']),
        avgOrderValue: _s(json['avg_order_value']),
      );

  final String period;
  final String revenue;
  final int transactions;
  final String avgOrderValue;
}

class AnalyticsPaymentBreakdownModel {
  const AnalyticsPaymentBreakdownModel({
    required this.paymentMethod,
    required this.totalAmount,
    required this.transactionCount,
    required this.percentage,
  });

  factory AnalyticsPaymentBreakdownModel.fromJson(Map<String, dynamic> json) =>
      AnalyticsPaymentBreakdownModel(
        paymentMethod: json['payment_method']?.toString() ?? 'unknown',
        totalAmount: _s(json['total_amount']),
        transactionCount: _i(json['transaction_count']),
        percentage: _s(json['percentage']),
      );

  final String paymentMethod;
  final String totalAmount;
  final int transactionCount;
  final String percentage;
}

class CashierPerformanceModel {
  const CashierPerformanceModel({
    required this.userId,
    required this.userName,
    required this.totalSales,
    required this.totalRevenue,
    required this.totalReturns,
    required this.totalVoids,
    required this.totalDiscounts,
    required this.avgOrderValue,
    required this.rank,
  });

  factory CashierPerformanceModel.fromJson(Map<String, dynamic> json) =>
      CashierPerformanceModel(
        userId: json['user_id']?.toString() ?? '',
        userName: json['user_name']?.toString() ?? '',
        totalSales: _i(json['total_sales']),
        totalRevenue: _s(json['total_revenue']),
        totalReturns: _i(json['total_returns']),
        totalVoids: _i(json['total_voids']),
        totalDiscounts: _s(json['total_discounts']),
        avgOrderValue: _s(json['avg_order_value']),
        rank: _i(json['rank']),
      );

  final String userId;
  final String userName;
  final int totalSales;
  final String totalRevenue;
  final int totalReturns;
  final int totalVoids;
  final String totalDiscounts;
  final String avgOrderValue;
  final int rank;
}

class BranchComparisonModel {
  const BranchComparisonModel({
    required this.branchId,
    required this.branchName,
    required this.totalRevenue,
    required this.totalTransactions,
    required this.avgOrderValue,
    required this.totalProfit,
  });

  factory BranchComparisonModel.fromJson(Map<String, dynamic> json) =>
      BranchComparisonModel(
        branchId: json['branch_id']?.toString() ?? '',
        branchName: json['branch_name']?.toString() ?? '',
        totalRevenue: _s(json['total_revenue']),
        totalTransactions: _i(json['total_transactions']),
        avgOrderValue: _s(json['avg_order_value']),
        totalProfit: _s(json['total_profit']),
      );

  final String branchId;
  final String branchName;
  final String totalRevenue;
  final int totalTransactions;
  final String avgOrderValue;
  final String totalProfit;
}

class AnalyticsTopProductModel {
  const AnalyticsTopProductModel({
    required this.productId,
    required this.productName,
    this.variationName,
    required this.totalQtySold,
    required this.totalRevenue,
    required this.totalCost,
    required this.grossProfit,
    required this.rank,
  });

  factory AnalyticsTopProductModel.fromJson(Map<String, dynamic> json) =>
      AnalyticsTopProductModel(
        productId: json['product_id']?.toString() ?? '',
        productName: json['product_name']?.toString() ?? '',
        variationName: json['variation_name']?.toString(),
        totalQtySold: _s(json['total_qty_sold']),
        totalRevenue: _s(json['total_revenue']),
        totalCost: _s(json['total_cost']),
        grossProfit: _s(json['gross_profit']),
        rank: _i(json['rank']),
      );

  final String productId;
  final String productName;
  final String? variationName;
  final String totalQtySold;
  final String totalRevenue;
  final String totalCost;
  final String grossProfit;
  final int rank;
}

class CategoryPerformanceModel {
  const CategoryPerformanceModel({
    required this.categoryId,
    required this.categoryName,
    required this.totalRevenue,
    required this.totalTransactions,
    required this.percentageOfTotal,
  });

  factory CategoryPerformanceModel.fromJson(Map<String, dynamic> json) =>
      CategoryPerformanceModel(
        categoryId: json['category_id']?.toString() ?? '',
        categoryName: json['category_name']?.toString() ?? '',
        totalRevenue: _s(json['total_revenue']),
        totalTransactions: _i(json['total_transactions']),
        percentageOfTotal: _s(json['percentage_of_total']),
      );

  final String categoryId;
  final String categoryName;
  final String totalRevenue;
  final int totalTransactions;
  final String percentageOfTotal;
}

class ProductMovementModel {
  const ProductMovementModel({
    required this.productId,
    required this.productName,
    this.variationName,
    required this.totalQtySold,
    required this.totalRevenue,
    this.lastSaleDate,
    this.daysSinceLastSale,
    required this.movementCategory,
  });

  factory ProductMovementModel.fromJson(Map<String, dynamic> json) =>
      ProductMovementModel(
        productId: json['product_id']?.toString() ?? '',
        productName: json['product_name']?.toString() ?? '',
        variationName: json['variation_name']?.toString(),
        totalQtySold: _s(json['total_qty_sold']),
        totalRevenue: _s(json['total_revenue']),
        lastSaleDate: json['last_sale_date']?.toString(),
        daysSinceLastSale: json['days_since_last_sale'] == null
            ? null
            : _i(json['days_since_last_sale']),
        movementCategory: json['movement_category']?.toString() ?? '',
      );

  final String productId;
  final String productName;
  final String? variationName;
  final String totalQtySold;
  final String totalRevenue;
  final String? lastSaleDate;
  final int? daysSinceLastSale;
  final String movementCategory;
}

class DeadStockModel {
  const DeadStockModel({
    required this.productId,
    required this.productName,
    this.variationName,
    required this.branchId,
    required this.branchName,
    required this.currentQty,
    this.lastSaleDate,
    required this.daysSinceLastSale,
    required this.stockValue,
  });

  factory DeadStockModel.fromJson(Map<String, dynamic> json) => DeadStockModel(
        productId: json['product_id']?.toString() ?? '',
        productName: json['product_name']?.toString() ?? '',
        variationName: json['variation_name']?.toString(),
        branchId: json['branch_id']?.toString() ?? '',
        branchName: json['branch_name']?.toString() ?? '',
        currentQty: _s(json['current_qty']),
        lastSaleDate: json['last_sale_date']?.toString(),
        daysSinceLastSale: _i(json['days_since_last_sale']),
        stockValue: _s(json['stock_value']),
      );

  final String productId;
  final String productName;
  final String? variationName;
  final String branchId;
  final String branchName;
  final String currentQty;
  final String? lastSaleDate;
  final int daysSinceLastSale;
  final String stockValue;
}

class StockValuationModel {
  const StockValuationModel({
    required this.productId,
    required this.productName,
    this.variationId,
    this.variationName,
    required this.branchId,
    required this.branchName,
    required this.currentQty,
    required this.avgCost,
    required this.totalValue,
  });

  factory StockValuationModel.fromJson(Map<String, dynamic> json) =>
      StockValuationModel(
        productId: json['product_id']?.toString() ?? '',
        productName: json['product_name']?.toString() ?? '',
        variationId: json['variation_id']?.toString(),
        variationName: json['variation_name']?.toString(),
        branchId: json['branch_id']?.toString() ?? '',
        branchName: json['branch_name']?.toString() ?? '',
        currentQty: _s(json['current_qty']),
        avgCost: _s(json['avg_cost']),
        totalValue: _s(json['total_value']),
      );

  final String productId;
  final String productName;
  final String? variationId;
  final String? variationName;
  final String branchId;
  final String branchName;
  final String currentQty;
  final String avgCost;
  final String totalValue;
}

class InventoryInsightsReportModel {
  const InventoryInsightsReportModel({
    required this.totalProducts,
    required this.totalStockValue,
    required this.lowStockCount,
    required this.outOfStockCount,
  });

  factory InventoryInsightsReportModel.fromJson(Map<String, dynamic> json) =>
      InventoryInsightsReportModel(
        totalProducts: _i(json['total_products']),
        totalStockValue: _s(json['total_stock_value']),
        lowStockCount: _i(json['low_stock_count']),
        outOfStockCount: _i(json['out_of_stock_count']),
      );

  final int totalProducts;
  final String totalStockValue;
  final int lowStockCount;
  final int outOfStockCount;
}

class CustomerInsightModel {
  const CustomerInsightModel({
    required this.customerId,
    required this.customerName,
    this.phone,
    required this.totalPurchases,
    required this.totalSpent,
    required this.outstandingBalance,
    this.lastPurchaseDate,
    required this.avgOrderValue,
    this.daysSinceLastPurchase,
  });

  factory CustomerInsightModel.fromJson(Map<String, dynamic> json) =>
      CustomerInsightModel(
        customerId: json['customer_id']?.toString() ?? '',
        customerName: json['customer_name']?.toString() ?? '',
        phone: json['phone']?.toString(),
        totalPurchases: _i(json['total_purchases']),
        totalSpent: _s(json['total_spent']),
        outstandingBalance: _s(json['outstanding_balance']),
        lastPurchaseDate: json['last_purchase_date']?.toString(),
        avgOrderValue: _s(json['avg_order_value']),
        daysSinceLastPurchase: json['days_since_last_purchase'] == null
            ? null
            : _i(json['days_since_last_purchase']),
      );

  final String customerId;
  final String customerName;
  final String? phone;
  final int totalPurchases;
  final String totalSpent;
  final String outstandingBalance;
  final String? lastPurchaseDate;
  final String avgOrderValue;
  final int? daysSinceLastPurchase;
}

class ProfitLossModel {
  const ProfitLossModel({
    required this.periodStart,
    required this.periodEnd,
    required this.totalRevenue,
    required this.totalCogs,
    required this.grossProfit,
    required this.grossMarginPct,
    required this.totalExpenses,
    required this.netProfit,
    required this.netMarginPct,
    required this.expenseBreakdown,
  });

  factory ProfitLossModel.fromJson(Map<String, dynamic> json) =>
      ProfitLossModel(
        periodStart: json['period_start']?.toString() ?? '',
        periodEnd: json['period_end']?.toString() ?? '',
        totalRevenue: _s(json['total_revenue']),
        totalCogs: _s(json['total_cogs']),
        grossProfit: _s(json['gross_profit']),
        grossMarginPct: _s(json['gross_margin_pct']),
        totalExpenses: _s(json['total_expenses']),
        netProfit: _s(json['net_profit']),
        netMarginPct: _s(json['net_margin_pct']),
        expenseBreakdown: _list(
          json['expense_breakdown'],
          ExpenseSummaryModel.fromJson,
        ),
      );

  final String periodStart;
  final String periodEnd;
  final String totalRevenue;
  final String totalCogs;
  final String grossProfit;
  final String grossMarginPct;
  final String totalExpenses;
  final String netProfit;
  final String netMarginPct;
  final List<ExpenseSummaryModel> expenseBreakdown;
}

class ExpenseSummaryModel {
  const ExpenseSummaryModel({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.transactionCount,
    required this.percentageOfTotal,
  });

  factory ExpenseSummaryModel.fromJson(Map<String, dynamic> json) =>
      ExpenseSummaryModel(
        categoryId: json['category_id']?.toString() ?? '',
        categoryName: json['category_name']?.toString() ?? '',
        totalAmount: _s(json['total_amount']),
        transactionCount: _i(json['transaction_count']),
        percentageOfTotal: _s(json['percentage_of_total']),
      );

  final String categoryId;
  final String categoryName;
  final String totalAmount;
  final int transactionCount;
  final String percentageOfTotal;
}

class TaxByRateModel {
  const TaxByRateModel({
    required this.taxRate,
    required this.totalSalesAmount,
    required this.totalTaxAmount,
    required this.transactionCount,
  });

  factory TaxByRateModel.fromJson(Map<String, dynamic> json) => TaxByRateModel(
        taxRate: _s(json['tax_rate']),
        totalSalesAmount: _s(json['total_sales_amount']),
        totalTaxAmount: _s(json['total_tax_amount']),
        transactionCount: _i(json['transaction_count']),
      );

  final String taxRate;
  final String totalSalesAmount;
  final String totalTaxAmount;
  final int transactionCount;
}

class TaxSummaryModel {
  const TaxSummaryModel({
    required this.periodStart,
    required this.periodEnd,
    required this.totalTaxableSales,
    required this.totalTaxCollected,
    required this.taxByRate,
    required this.totalTaxablePurchases,
    required this.totalTaxPaid,
  });

  factory TaxSummaryModel.fromJson(Map<String, dynamic> json) => TaxSummaryModel(
        periodStart: json['period_start']?.toString() ?? '',
        periodEnd: json['period_end']?.toString() ?? '',
        totalTaxableSales: _s(json['total_taxable_sales']),
        totalTaxCollected: _s(json['total_tax_collected']),
        taxByRate: _list(json['tax_by_rate'], TaxByRateModel.fromJson),
        totalTaxablePurchases: _s(json['total_taxable_purchases']),
        totalTaxPaid: _s(json['total_tax_paid']),
      );

  final String periodStart;
  final String periodEnd;
  final String totalTaxableSales;
  final String totalTaxCollected;
  final List<TaxByRateModel> taxByRate;
  final String totalTaxablePurchases;
  final String totalTaxPaid;
}

class PeakHourModel {
  const PeakHourModel({
    required this.hour,
    required this.hourLabel,
    required this.totalRevenue,
    required this.transactionCount,
    required this.avgOrderValue,
  });

  factory PeakHourModel.fromJson(Map<String, dynamic> json) => PeakHourModel(
        hour: _i(json['hour']),
        hourLabel: json['hour_label']?.toString() ?? '',
        totalRevenue: _s(json['total_revenue']),
        transactionCount: _i(json['transaction_count']),
        avgOrderValue: _s(json['avg_order_value']),
      );

  final int hour;
  final String hourLabel;
  final String totalRevenue;
  final int transactionCount;
  final String avgOrderValue;
}

class PeakDayModel {
  const PeakDayModel({
    required this.dayOfWeek,
    required this.dayName,
    required this.totalRevenue,
    required this.transactionCount,
    required this.avgOrderValue,
  });

  factory PeakDayModel.fromJson(Map<String, dynamic> json) => PeakDayModel(
        dayOfWeek: _i(json['day_of_week']),
        dayName: json['day_name']?.toString() ?? '',
        totalRevenue: _s(json['total_revenue']),
        transactionCount: _i(json['transaction_count']),
        avgOrderValue: _s(json['avg_order_value']),
      );

  final int dayOfWeek;
  final String dayName;
  final String totalRevenue;
  final int transactionCount;
  final String avgOrderValue;
}

class FraudAlertModel {
  const FraudAlertModel({
    required this.alertType,
    required this.userId,
    required this.userName,
    required this.branchId,
    required this.count,
    required this.totalAmount,
    required this.severity,
    required this.description,
  });

  factory FraudAlertModel.fromJson(Map<String, dynamic> json) => FraudAlertModel(
        alertType: json['alert_type']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        userName: json['user_name']?.toString() ?? '',
        branchId: json['branch_id']?.toString() ?? '',
        count: _i(json['count']),
        totalAmount: _s(json['total_amount']),
        severity: json['severity']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
      );

  final String alertType;
  final String userId;
  final String userName;
  final String branchId;
  final int count;
  final String totalAmount;
  final String severity;
  final String description;
}
