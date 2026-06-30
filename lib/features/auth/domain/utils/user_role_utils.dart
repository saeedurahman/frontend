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
  static const viewReturnsPermission = 'sales.returns.view';
  static const createReturnsPermission = 'sales.returns.create';
  static const cancelSalesPermission = 'sales.cancel';
  static const createSalesPermission = 'sales.create';
  static const viewShiftsPermission = 'shifts.view';
  static const openShiftPermission = 'shifts.open';
  static const closeShiftPermission = 'shifts.close';

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

  /// Analytics / financial reports require manager or owner.
  static bool canViewReports(String? role) =>
      isOwner(role) || isManager(role);
}
