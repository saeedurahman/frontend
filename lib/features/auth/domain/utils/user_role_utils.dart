/// Role checks for nav gating and feature access.
///
/// Backend roles: `owner`, `manager`, `cashier` (and variants).
class UserRoleUtils {
  UserRoleUtils._();

  static const manageRolesPermission = 'users.roles.manage';

  static String _normalize(String? role) =>
      role?.toLowerCase().trim() ?? '';

  static bool isOwner(String? role) => _normalize(role) == 'owner';

  static bool isManager(String? role) => _normalize(role) == 'manager';

  static bool isCashier(String? role) => _normalize(role) == 'cashier';

  static bool hasPermission(List<String> keys, String permission) =>
      keys.contains(permission);

  /// Manage roles: permission-first, owner fallback for legacy cached sessions.
  static bool canManageRoles({
    String? role,
    List<String> permissionKeys = const [],
  }) {
    if (permissionKeys.isNotEmpty) {
      return hasPermission(permissionKeys, manageRolesPermission);
    }
    return isOwner(role);
  }

  /// Analytics / financial reports require manager or owner.
  static bool canViewReports(String? role) =>
      isOwner(role) || isManager(role);
}
