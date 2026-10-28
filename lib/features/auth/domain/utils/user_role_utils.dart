import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/permissions/user_access.dart';

/// Permission checks for nav gating and feature access.
///
/// Everything funnels through [can]: permission keys decide, and only an
/// explicit `owner` role bypasses them. An empty key list grants nothing to a
/// non-owner. The named helpers below are one-line aliases kept so call sites
/// read well.
class UserRoleUtils {
  UserRoleUtils._();

  static const manageRolesPermission = Perm.rolesManage;
  static const viewUsersPermission = Perm.usersView;
  static const createUsersPermission = Perm.usersCreate;
  static const updateUsersPermission = Perm.usersUpdate;
  static const deleteUsersPermission = Perm.usersDelete;
  static const managePricesPermission = Perm.productsManagePrices;
  static const viewReturnsPermission = Perm.returnsView;
  static const createReturnsPermission = Perm.returnsCreate;
  static const cancelSalesPermission = Perm.salesCancel;
  static const voidSalesPermission = Perm.salesVoid;
  static const overridePricePermission = Perm.salesOverridePrice;
  static const manageTaxPermission = Perm.taxManage;
  static const manageNotificationsPermission = Perm.notificationsManage;
  static const createSalesPermission = Perm.salesCreate;
  static const viewShiftsPermission = Perm.shiftsView;
  static const openShiftPermission = Perm.shiftsOpen;
  static const closeShiftPermission = Perm.shiftsClose;

  /// True only for an explicit `owner` role.
  static bool isOwner(String? role) => UserAccess(role: role).isOwner;

  /// The single permission check.
  static bool can(
    String permission, {
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      UserAccess(role: role, permissionKeys: permissionKeys).can(permission);

  /// True when any of [permissions] is granted.
  static bool canAny(
    Iterable<String> permissions, {
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      UserAccess(role: role, permissionKeys: permissionKeys)
          .canAny(permissions);

  /// Manage roles (`users.roles.manage`).
  static bool canManageRoles({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.rolesManage, role: role, permissionKeys: permissionKeys);

  /// Reassign staff roles.
  static bool canManageUserRoles({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.rolesManage, role: role, permissionKeys: permissionKeys);

  static bool canViewUsers({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.usersView, role: role, permissionKeys: permissionKeys);

  static bool canCreateUsers({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.usersCreate, role: role, permissionKeys: permissionKeys);

  static bool canUpdateUsers({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.usersUpdate, role: role, permissionKeys: permissionKeys);

  static bool canDeleteUsers({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.usersDelete, role: role, permissionKeys: permissionKeys);

  /// Retail price on the default price list.
  static bool canManagePrices({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.productsManagePrices, role: role, permissionKeys: permissionKeys);

  static bool canViewReturns({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.returnsView, role: role, permissionKeys: permissionKeys);

  /// Void a completed sale. Cancel-only roles cannot void.
  static bool canVoidSales({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.salesVoid, role: role, permissionKeys: permissionKeys);

  /// `/notifications/check-alerts` needs this.
  static bool canManageNotifications({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.notificationsManage, role: role, permissionKeys: permissionKeys);

  static bool canCancelSales({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.salesCancel, role: role, permissionKeys: permissionKeys);

  static bool canCreateReturns({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.returnsCreate, role: role, permissionKeys: permissionKeys);

  static bool canCreateSales({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.salesCreate, role: role, permissionKeys: permissionKeys);

  static bool canViewShifts({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.shiftsView, role: role, permissionKeys: permissionKeys);

  static bool canOpenShift({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.shiftsOpen, role: role, permissionKeys: permissionKeys);

  static bool canCloseShift({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.shiftsClose, role: role, permissionKeys: permissionKeys);

  static bool canViewTables({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.tablesView, role: role, permissionKeys: permissionKeys);

  static bool canViewKot({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.kotView, role: role, permissionKeys: permissionKeys);

  /// Analytics / financial reports.
  static bool canViewReports({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.reportsView, role: role, permissionKeys: permissionKeys);

  static bool canViewAuditLogs({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.auditView, role: role, permissionKeys: permissionKeys);

  static bool canViewBom({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.bomView, role: role, permissionKeys: permissionKeys);

  static bool canManageBom({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.bomManage, role: role, permissionKeys: permissionKeys);

  static bool canViewProduction({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.productionView, role: role, permissionKeys: permissionKeys);

  static bool canCreateProduction({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.productionCreate, role: role, permissionKeys: permissionKeys);

  static bool canCompleteProduction({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.productionComplete, role: role, permissionKeys: permissionKeys);

  static bool canCancelProduction({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.productionCancel, role: role, permissionKeys: permissionKeys);

  static bool canViewCoa({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.coaView, role: role, permissionKeys: permissionKeys);

  static bool canManageCoa({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.coaManage, role: role, permissionKeys: permissionKeys);

  static bool canViewJournal({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.journalView, role: role, permissionKeys: permissionKeys);

  static bool canCreateJournal({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.journalCreate, role: role, permissionKeys: permissionKeys);

  static bool canPostJournal({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      can(Perm.journalPost, role: role, permissionKeys: permissionKeys);

  /// Update a KOT line (the legacy `restaurant.kot.update` key still counts).
  static bool canUpdateKot({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      canAny(
        const [Perm.kotUpdateStatus, Perm.kotLegacyUpdate],
        role: role,
        permissionKeys: permissionKeys,
      );

  /// Change the tax rate of a cart line: price override or tax management.
  static bool canEditLineTax({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      canAny(
        const [Perm.salesOverridePrice, Perm.taxManage, Perm.salesOverrideTax],
        role: role,
        permissionKeys: permissionKeys,
      );

  /// Kitchen-only staff: KOT access without POS sales.create.
  static bool isKitchenOnlyUser({
    String? role,
    List<String> permissionKeys = const [],
  }) {
    final hasKotAccess =
        canViewKot(role: role, permissionKeys: permissionKeys) ||
            canUpdateKot(role: role, permissionKeys: permissionKeys);
    return hasKotAccess &&
        !canCreateSales(role: role, permissionKeys: permissionKeys);
  }

  /// Sidebar manufacturing section: any manufacturing view permission.
  static bool canAccessManufacturing({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      canAny(
        const [Perm.productionView, Perm.bomView],
        role: role,
        permissionKeys: permissionKeys,
      );

  /// Sidebar accounting section: any accounting view permission.
  static bool canAccessAccounting({
    String? role,
    List<String> permissionKeys = const [],
  }) =>
      canAny(
        const [Perm.coaView, Perm.journalView],
        role: role,
        permissionKeys: permissionKeys,
      );
}
