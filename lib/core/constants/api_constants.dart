abstract final class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api/v1',
  );

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String pinLogin = '/auth/pin-login';
  static const String me = '/auth/me';

  // Business
  static const String businesses = '/businesses';
  static const String businessMe = '/business/me';
  static const String branches = '/branches';
  static String branchById(String id) => '/branches/$id';

  // Settings
  static const String settings = '/settings';
  static const String settingsBulk = '/settings/bulk';
  static String settingByKey(String key) => '/settings/$key';

  // Tax rates
  static const String taxRates = '/tax-rates';
  static String taxRateById(String id) => '/tax-rates/$id';

  // Products
  static const String products = '/products';
  static const String categories = '/categories';
  static const String brands = '/brands';
  static const String units = '/units';
  static const String unitConversions = '/units/conversions';
  static const String priceLists = '/prices/lists';

  // Sales
  static const String sales = '/sales';
  static String saleCancel(String id) => '/sales/$id/cancel';
  static String invoiceData(String saleId) => '/invoice/$saleId';
  static String invoiceThermal(String saleId) => '/invoice/$saleId/thermal';
  static const String invoiceExportSales = '/invoice/export/sales';

  // Returns
  static const String returns = '/returns';
  static String returnById(String id) => '/returns/$id';

  // Registers & Shifts
  static const String registers = '/registers';
  static const String shiftsOpen = '/shifts/open';
  static const String shifts = '/shifts';
  static const String shiftsMyActive = '/shifts/my-active';
  static String shiftById(String shiftId) => '/shifts/$shiftId';
  static String shiftClose(String shiftId) => '/shifts/$shiftId/close';

  static String registerActiveShift(String registerId) =>
      '/registers/$registerId/active-shift';

  static String shiftSummary(String shiftId) => '/shifts/$shiftId/summary';

  static String productPrice(String productId) => '/prices/product/$productId';

  // Customers
  static const String customers = '/customers';
  static String customerBalance(String id) => '/customers/$id/balance';
  static String customerLedger(String id) => '/customers/$id/ledger';
  static String customerPayments(String id) => '/customers/$id/payments';

  // Suppliers
  static const String suppliers = '/suppliers';
  static String supplierBalance(String supplierId) =>
      '/supplier-ledger/$supplierId/balance';

  // Purchases
  static const String purchaseOrders = '/purchases/orders';
  static String purchaseOrder(String id) => '/purchases/orders/$id';
  static String purchaseOrderStatus(String id) =>
      '/purchases/orders/$id/status';
  static const String purchaseReceipts = '/purchases/receipts';
  static String purchaseReceipt(String id) => '/purchases/receipts/$id';

  // Expenses
  static const String expenses = '/expenses';
  static const String expenseCategories = '/expenses/categories';
  static String expenseById(String id) => '/expenses/$id';
  static String expenseCategoryById(String id) => '/expenses/categories/$id';
  static String expensePayments(String expenseId) => '/expenses/$expenseId/payments';

  // Stock & Adjustments
  static const String stockBalances = '/stock/balances';
  static const String stockBalance = '/stock/balance';
  static const String stockMovements = '/stock/movements';
  static const String adjustments = '/adjustments';

  // Legacy placeholder (unused)
  static const String inventory = '/inventory';

  // Dashboard
  static const String dashboardSummary = '/dashboard/summary';
  static const String dashboardSalesTrend = '/dashboard/sales-trend';

  // Analytics dashboard
  static const String analyticsDashboard = '/analytics/dashboard';
  static const String analyticsSalesTrend = '/analytics/sales-trend';
  static const String analyticsPaymentBreakdown = '/analytics/payment-breakdown';
  static const String analyticsTopProducts = '/analytics/top-products';
  static const String analyticsRecentTransactions = '/analytics/recent-transactions';
  static const String analyticsInventoryInsights = '/analytics/inventory-insights';
  static const String analyticsSalesSummary = '/analytics/sales-summary';
  static const String analyticsTodayVsYesterday = '/analytics/today-vs-yesterday';
  static const String analyticsCategoryPerformance = '/analytics/category-performance';
  static const String analyticsBranchComparison = '/analytics/branch-comparison';
  static const String analyticsCashierPerformance = '/analytics/cashier-performance';
  static const String analyticsFraudAlerts = '/analytics/fraud-alerts';
  static const String analyticsStockValuation = '/analytics/stock-valuation';
  static const String analyticsCustomerInsights = '/analytics/customer-insights';
  static const String analyticsProfitLoss = '/analytics/profit-loss';
  static const String analyticsExpenseSummary = '/analytics/expense-summary';
  static const String analyticsPeakHours = '/analytics/peak-hours';
  static const String analyticsPeakDays = '/analytics/peak-days';
  static const String analyticsProductMovement = '/analytics/product-movement';
  static const String analyticsDeadStock = '/analytics/dead-stock';
  static const String analyticsTaxSummary = '/analytics/tax-summary';
  static const String analyticsCashInDrawer = '/analytics/cash-in-drawer';
  static const String invoiceExportInventory = '/invoice/export/inventory';

  // Sync
  static const String syncPush = '/sync/push';
  static const String syncPull = '/sync/pull';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsMarkRead = '/notifications/mark-read';
  static const String notificationsMarkAllRead = '/notifications/mark-all-read';
  static const String notificationsCheckAlerts = '/notifications/check-alerts';
  static String notificationById(String id) => '/notifications/$id';

  // Audit logs
  static const String auditLogs = '/audit';
  static String auditRecordHistory(String tableName, String recordId) =>
      '/audit/record/$tableName/$recordId';

  // Roles & permissions
  static const String permissions = '/permissions';
  static const String roles = '/roles';
  static String roleById(String id) => '/roles/$id';
  static String rolePermissions(String id) => '/roles/$id/permissions';

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String tenantHeader = 'X-Tenant-ID';
}
