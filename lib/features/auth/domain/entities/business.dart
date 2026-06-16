import 'package:equatable/equatable.dart';

class Business extends Equatable {
  const Business({
    required this.id,
    required this.name,
    required this.type,
    this.address,
    this.phone,
    this.ntn,
  });

  final String id;
  final String name;
  final String type;
  final String? address;
  final String? phone;
  final String? ntn;

  @override
  List<Object?> get props => [id, name, type, address, phone, ntn];
}
