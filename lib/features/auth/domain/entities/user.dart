import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.businessId,
    this.branchId,
    this.roles = const [],
    this.permissionKeys = const [],
  });

  final String id;
  final String email;
  final String name;
  final String role;
  final String? businessId;
  final String? branchId;
  final List<String> roles;
  final List<String> permissionKeys;

  @override
  List<Object?> get props =>
      [id, email, name, role, businessId, branchId, roles, permissionKeys];
}
