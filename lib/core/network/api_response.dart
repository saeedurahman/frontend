import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  final bool success;
  final T? data;
  final String? message;
  final Map<String, dynamic>? errors;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class PaginatedApiResponse<T> {
  const PaginatedApiResponse({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });

  factory PaginatedApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedApiResponseFromJson(json, fromJsonT);

  final List<T> items;
  final int total;
  final int page;
  @JsonKey(name: 'page_size')
  final int pageSize;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedApiResponseToJson(this, toJsonT);
}
