/// Role checks for nav gating and feature access.
///
/// Backend roles: `owner`, `manager`, `cashier` (and variants).
class UserRoleUtils {
  UserRoleUtils._();

  static const manageRolesPermission = 'users.roles.manage';
  static const viewUsersPermission = 'users.view';
  static const createUsersPermission = 'users.create';
  static const updateUsersPermission = 'users.update';
  static const deleteUsersPermission = 'users.delete';
  static const managePricesPermission = 'products.manage_prices';
  static const viewReturnsPermission = 'sales.returns.view';
  static const createReturnsPermission = 'sales.returns.create';
  static const cancelSalesPermission = 'sales.cancel';
  static const createSalesPermission = 'sales.create';
  static const viewShiftsPermission = 'shifts.view';
  static const openShiftPermission = 'shifts.open';
  static const closeShiftPermission = 'shifts.close';

  static const viewTablesPermission = 'restaurant.tables.view';
  static const updateTableStatusPermission = 'restaurant.tables.update_status';
  static const viewFloorPlansPermission = 'restaurant.floor_plans.view';
  static const viewModifiersPermission = 'restaurant.modifiers.view';
  static const viewKotPermission = 'restaurant.kot.view';
  static const updateKotPermission = 'restaurant.kot.update_status';
  static const _legacyUpdateKotPermission = 'restaurant.kot.update';
  static const fireKotPermission = 'restaurant.kot.fire';

  static const viewBomPermission = 'manufacturing.bom.view';
  static const manageBomPermission = 'manufacturing.bom.manage';
  static const viewProductionPermission = 'manufacturing.production.view';
  static const createProductionPermission = 'manufacturing.production.create';
  static const completeProductionPermission = 'manufacturing.production.complete';
  static const cancelProductionPermission = 'manufacturing.production.cancel';

  static const viewCoaPermission = 'accounting.coa.view';
  static const manageCoaPermission = 'accounting.coa.manage';
  static const viewJournalPermission = 'accounting.journal.view';
  static const createJournalPermission = 'accounting.journal.create';
  static const postJournalPermission = 'accounting.journal.post';

  static String _normalize(String? role) =>
      role?.toLowerCase().trim() ?? '';

  static bool isOwner(String? role) => _normalize(role) == 'owner';

  static bool isManager(String? role) => _normalize(role) == 'manager';

  static bool isCashier(String? role) => _normalize(role) == 'cashier';

  static bool hasPermission(List<String> keys, String permission) =>
      keys.contains(permission);

  static bool _permissionOrOwnerFallback({
    required String? role,
    required List<String> permissionKeys,
    required String permission,
  }) {
    if (permissionKeys.isNotEmpty) {
      return hasPermission(permissionKeys, permission);
    }
    return isOwner(role);
  }

  /// Manage roles: permission-first, owner fallback for legacy cached sessions.
  static bool canManageRoles({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: manageRolesPermission,
      );

  /// Reassign staff roles (PUT /users/{id}/roles).
  static bool canManageUserRoles({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: manageRolesPermission,
      );

  static bool canViewUsers({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: viewUsersPermission,
      );

  static bool canCreateUsers({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: createUsersPermission,
      );

  static bool canUpdateUsers({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: updateUsersPermission,
      );

  static bool canDeleteUsers({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: deleteUsersPermission,
      );

  /// Retail price on default price list — owner/manager or explicit permission.
  static bool canManagePrices({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      isOwner(role) ||
      isManager(role) ||
      hasPermission(permissionKeys, managePricesPermission);

  static bool canViewReturns({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: viewReturnsPermission,
      );

  static bool canCancelSales({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: cancelSalesPermission,
      );

  static bool canCreateReturns({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: createReturnsPermission,
      );

  static bool canCreateSales({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: createSalesPermission,
      );

  static bool canViewShifts({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: viewShiftsPermission,
      );

  static bool canOpenShift({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: openShiftPermission,
      );

  static bool canCloseShift({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: closeShiftPermission,
      );

  static bool canViewTables({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: viewTablesPermission,
      );

  static bool canViewKot({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: viewKotPermission,
      );

  static bool canUpdateKot({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: updateKotPermission,
      ) ||
      hasPermission(permissionKeys, _legacyUpdateKotPermission);

  /// Kitchen-only staff: KOT access without POS sales.create.
  static bool isKitchenOnlyUser({
    String? role,
    List<String> permissionKeys = const [],
  }) {
    final hasKotAccess = canViewKot(
          role: role,
          permissionKeys: permissionKeys,
        ) ||
        canUpdateKot(
          role: role,
          permissionKeys: permissionKeys,
        );
    return hasKotAccess &&
        !canCreateSales(role: role, permissionKeys: permissionKeys);
  }

  /// Analytics / financial reports require manager or owner.
  static bool canViewReports(String? role) =>
      isOwner(role) || isManager(role);

  static bool canViewBom({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: viewBomPermission,
      );

  static bool canManageBom({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: manageBomPermission,
      );

  static bool canViewProduction({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: viewProductionPermission,
      );

  static bool canCreateProduction({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: createProductionPermission,
      );

  static bool canCompleteProduction({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: completeProductionPermission,
      );

  static bool canCancelProduction({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: cancelProductionPermission,
      );

  /// Sidebar manufacturing section: any manufacturing view permission.
  static bool canAccessManufacturing({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      canViewProduction(role: role, permissionKeys: permissionKeys) ||
      canViewBom(role: role, permissionKeys: permissionKeys);

  static bool canViewCoa({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: viewCoaPermission,
      );

  static bool canManageCoa({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: manageCoaPermission,
      );

  static bool canViewJournal({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: viewJournalPermission,
      );

  static bool canCreateJournal({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: createJournalPermission,
      );

  static bool canPostJournal({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      _permissionOrOwnerFallback(
        role: role,
        permissionKeys: permissionKeys,
        permission: postJournalPermission,
      );

  /// Sidebar accounting section: any accounting view permission.
  static bool canAccessAccounting({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      canViewCoa(role: role, permissionKeys: permissionKeys) ||
      canViewJournal(role: role, permissionKeys: permissionKeys);
}
