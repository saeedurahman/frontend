import 'package:frantend/features/auth/domain/entities/business.dart';
import 'package:json_annotation/json_annotation.dart';

part 'business_model.g.dart';

@JsonSerializable()
class BusinessModel {
  const BusinessModel({
    required this.id,
    required this.name,
    required this.type,
    this.address,
    this.phone,
    this.ntn,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessModelFromJson(json);

  final String id;
  final String name;
  final String type;
  final String? address;
  final String? phone;
  final String? ntn;

  Map<String, dynamic> toJson() => _$BusinessModelToJson(this);

  Business toEntity() => Business(
        id: id,
        name: name,
        type: type,
        address: address,
        phone: phone,
        ntn: ntn,
      );
}
