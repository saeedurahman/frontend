/// Role checks for nav gating and feature access.
///
/// Backend roles: `owner`, `manager`, `cashier` (and variants).
class UserRoleUtils {
  UserRoleUtils._();

  static String _normalize(String? role) =>
      role?.toLowerCase().trim() ?? '';

  static bool isOwner(String? role) => _normalize(role) == 'owner';

  static bool isManager(String? role) => _normalize(role) == 'manager';

  static bool isCashier(String? role) => _normalize(role) == 'cashier';

  /// Analytics / financial reports require manager or owner.
  static bool canViewReports(String? role) =>
      isOwner(role) || isManager(role);
}
