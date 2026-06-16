import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.businessId,
    this.branchId,
  });

  final String id;
  final String email;
  final String name;
  final String role;
  final String? businessId;
  final String? branchId;

  @override
  List<Object?> get props => [id, email, name, role, businessId, branchId];
}
