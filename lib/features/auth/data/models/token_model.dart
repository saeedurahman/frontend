import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
class TokenModel {
  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    this.user,
    this.tenantId,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'token_type')
  final String tokenType;
  final UserModel? user;
  @JsonKey(name: 'tenant_id')
  final String? tenantId;

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
