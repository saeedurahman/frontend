abstract final class RouteNames {
  // Root
  static const String root = '/';

  // Public
  static const String landing = '/landing';
  static const String login = '/login';
  static const String pinLogin = '/login/pin';
  static const String register = '/register';
  static const String registerStep1 = '/register/step1';
  static const String registerStep2 = '/register/step2';
  static const String registerStep3 = '/register/step3';
  static const String registerStep4 = '/register/step4';
  static const String registerSuccess = '/register/success';

  // Protected
  static const String dashboard = '/dashboard';
  static const String pos = '/pos';
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String productNew = '/products/new';
  static const String inventory = '/inventory';
  static const String manufacturing = '/manufacturing';
  static const String manufacturingProductionNew = '/manufacturing/new';
  static const String manufacturingProductionDetail = '/manufacturing/:orderId';
  static String manufacturingProductionDetailPath(String id) => '/manufacturing/$id';

  static const String manufacturingBoms = '/manufacturing/boms';
  static const String manufacturingBomNew = '/manufacturing/boms/new';
  static const String manufacturingBomDetail = '/manufacturing/boms/:bomId';
  static String manufacturingBomDetailPath(String id) => '/manufacturing/boms/$id';

  static const String purchases = '/purchases';
  static const String purchaseOrderNew = '/purchases/new';
  static const String purchaseOrderDetail = '/purchases/:id';
  static const String purchaseOrderReceive = '/purchases/:id/receive';
  static const String stockMovements = '/inventory/movements/:productId';
  static const String sales = '/sales';
  static String saleDetailPath(String id) => '/sales/$id';
  static const String saleDetail = '/sales/:id';
  static String saleReturnPath(String id) => '/sales/$id/return';
  static const String saleReturn = '/sales/:id/return';
  static const String returns = '/returns';
  static String returnDetailPath(String id) => '/returns/$id';
  static const String returnDetail = '/returns/:id';
  static const String restaurantTables = '/restaurant/tables';
  static const String kitchen = '/kitchen';
  static const String customers = '/customers';
  static const String customerNew = '/customers/new';
  static const String customerEdit = '/customers/:id/edit';
  static String customerDetail(String id) => '/customers/$id';
  static const String suppliers = '/suppliers';
  static const String supplierNew = '/suppliers/new';
  static const String supplierEdit = '/suppliers/:id/edit';
  static const String expenses = '/expenses';
  static const String expenseNew = '/expenses/new';
  static const String expenseDetail = '/expenses/:id';
  static const String expenseEdit = '/expenses/:id/edit';
  static String expenseDetailPath(String id) => '/expenses/$id';
  static String expenseEditPath(String id) => '/expenses/$id/edit';
  static const String cashRegister = '/cash-register';
  static const String shiftHistory = '/cash-register/history';
  static String shiftDetailPath(String shiftId) => '/cash-register/history/$shiftId';
  static const String closeShift = '/cash-register/close';
  static const String shifts = '/cash-register/shifts';
  static const String analytics = '/analytics';
  static const String reports = '/reports';
  static const String accounting = '/accounting';
  static const String accountingJournalNew = '/accounting/new';
  static const String accountingJournalDetail = '/accounting/:entryId';
  static const String accountingJournalEdit = '/accounting/:entryId/edit';
  static String accountingJournalDetailPath(String id) => '/accounting/$id';
  static String accountingJournalEditPath(String id) => '/accounting/$id/edit';

  static const String accountingCoaList = '/accounting/coa';
  static const String accountingCoaNew = '/accounting/coa/new';
  static const String accountingCoaDetail = '/accounting/coa/:accountId';
  static String accountingCoaDetailPath(String id) => '/accounting/coa/$id';

  static const String settings = '/settings';
  static const String settingsBusiness = '/settings/business';
  static const String settingsReceipt = '/settings/receipt';
  static const String settingsTax = '/settings/tax';
  static const String settingsRoles = '/settings/roles';
  static const String settingsRoleNew = '/settings/roles/new';
  static String settingsRoleEditPath(String id) => '/settings/roles/$id/edit';
  static const String staff = '/staff';
  static const String staffNew = '/staff/new';
  static String staffEditPath(String id) => '/staff/$id/edit';
  static const String notifications = '/notifications';
  static const String auditLogs = '/audit-logs';
}
