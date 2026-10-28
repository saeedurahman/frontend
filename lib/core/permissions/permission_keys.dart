/// Permission keys as seeded by the backend (`role_permission_seed.py`).
abstract final class Perm {
  // Catalog
  static const productsView = 'products.view';
  static const productsCreate = 'products.create';
  static const productsUpdate = 'products.update';
  static const productsDelete = 'products.delete';
  static const productsManagePrices = 'products.manage_prices';

  // Inventory
  static const inventoryView = 'inventory.view';
  static const inventoryAdjust = 'inventory.adjust';
  static const purchasesView = 'inventory.purchase_orders.view';
  static const purchasesCreate = 'inventory.purchase_orders.create';
  static const purchasesReceive = 'inventory.purchase_orders.receive';
  static const transfersView = 'inventory.transfers.view';
  static const transfersCreate = 'inventory.transfers.create';
  static const transfersReceive = 'inventory.transfers.receive';
  static const wasteView = 'inventory.waste.view';
  static const wasteCreate = 'inventory.waste.create';

  // Sales
  static const salesView = 'sales.view';
  static const salesCreate = 'sales.create';
  static const salesCancel = 'sales.cancel';
  static const salesVoid = 'sales.void';
  static const salesOverrideTax = 'sales.override_tax';
  static const salesApplyDiscount = 'sales.apply_discount';
  static const salesOverridePrice = 'sales.override_price';
  static const returnsView = 'sales.returns.view';
  static const returnsCreate = 'sales.returns.create';
  static const taxManage = 'tax.manage';

  // People
  static const customersView = 'customers.view';
  static const customersCreate = 'customers.create';
  static const customersUpdate = 'customers.update';
  static const suppliersView = 'suppliers.view';
  static const suppliersCreate = 'suppliers.create';
  static const suppliersUpdate = 'suppliers.update';
  static const suppliersLedgerPayment = 'suppliers.ledger.payment';

  // Money
  static const expensesView = 'expenses.view';
  static const expensesCreate = 'expenses.create';
  static const expensesUpdate = 'expenses.update';
  static const expensesDelete = 'expenses.delete';
  static const shiftsView = 'shifts.view';
  static const shiftsOpen = 'shifts.open';
  static const shiftsClose = 'shifts.close';
  static const shiftsManage = 'shifts.manage';

  // Reports / export
  static const reportsView = 'reports.view';
  static const reportsExport = 'reports.export';
  static const reportsFraudAlerts = 'reports.fraud_alerts';

  // Settings / staff / roles
  static const settingsView = 'settings.view';
  static const settingsManage = 'settings.manage';
  static const usersView = 'users.view';
  static const usersCreate = 'users.create';
  static const usersUpdate = 'users.update';
  static const usersDelete = 'users.delete';
  static const rolesManage = 'users.roles.manage';
  static const rolesView = 'roles.view';
  static const notificationsView = 'notifications.view';
  static const notificationsManage = 'notifications.manage';
  static const branchesView = 'branches.view';

  /// The backend currently guards the audit trail with an owner check; the
  /// key is what a role needs once it is delegated.
  static const auditView = 'audit.view';

  // Restaurant
  static const tablesView = 'restaurant.tables.view';
  static const tablesUpdateStatus = 'restaurant.tables.update_status';
  static const floorPlansView = 'restaurant.floor_plans.view';
  static const modifiersView = 'restaurant.modifiers.view';
  static const kotView = 'restaurant.kot.view';
  static const kotUpdateStatus = 'restaurant.kot.update_status';
  static const kotLegacyUpdate = 'restaurant.kot.update';
  static const kotFire = 'restaurant.kot.fire';

  // Manufacturing
  static const bomView = 'manufacturing.bom.view';
  static const bomManage = 'manufacturing.bom.manage';
  static const productionView = 'manufacturing.production.view';
  static const productionCreate = 'manufacturing.production.create';
  static const productionComplete = 'manufacturing.production.complete';
  static const productionCancel = 'manufacturing.production.cancel';

  // Accounting
  static const coaView = 'accounting.coa.view';
  static const coaManage = 'accounting.coa.manage';
  static const journalView = 'accounting.journal.view';
  static const journalCreate = 'accounting.journal.create';
  static const journalPost = 'accounting.journal.post';
}
