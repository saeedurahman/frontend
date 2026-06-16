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
  static const String branches = '/branches';

  // Products
  static const String products = '/products';

  // Sales
  static const String sales = '/sales';

  // Customers
  static const String customers = '/customers';

  // Inventory
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

  // Sync
  static const String syncPush = '/sync/push';
  static const String syncPull = '/sync/pull';

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String tenantHeader = 'X-Tenant-ID';
}
