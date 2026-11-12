import 'package:frantend/core/permissions/user_access.dart';

/// Who may act on sync problems (discard items, review flagged sales).
/// The server's `/sync/flags` is owner/manager only; discarding unsent
/// records follows the same rule.
abstract final class SyncAccess {
  static bool _isManager(UserAccess access) {
    String n(String? v) => v?.toLowerCase().trim() ?? '';
    return n(access.role) == 'manager' || access.roles.any((r) => n(r) == 'manager');
  }

  static bool canDiscard(UserAccess access) => access.isOwner || _isManager(access);

  static bool canReviewFlags(UserAccess access) =>
      access.isOwner || _isManager(access);
}
