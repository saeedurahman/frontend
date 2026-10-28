import 'package:equatable/equatable.dart';

/// What the signed-in user may do. The one place permission checks are made.
///
/// The owner is detected explicitly (role name). An empty permission list
/// never makes anybody an owner: a non-owner with no keys can do nothing.
class UserAccess extends Equatable {
  const UserAccess({
    this.role,
    this.roles = const [],
    this.permissionKeys = const [],
  });

  /// Nobody signed in / nothing granted.
  static const none = UserAccess();

  final String? role;
  final List<String> roles;
  final List<String> permissionKeys;

  static String _normalize(String? value) => value?.toLowerCase().trim() ?? '';

  bool get isOwner =>
      _normalize(role) == 'owner' || roles.any((r) => _normalize(r) == 'owner');

  bool can(String permission) =>
      isOwner || permissionKeys.contains(permission);

  bool canAny(Iterable<String> permissions) => permissions.any(can);

  bool canAll(Iterable<String> permissions) => permissions.every(can);

  @override
  List<Object?> get props => [role, roles, permissionKeys];
}
