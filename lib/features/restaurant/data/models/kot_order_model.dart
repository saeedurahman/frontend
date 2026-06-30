import 'package:freezed_annotation/freezed_annotation.dart';

part 'kot_order_model.freezed.dart';
part 'kot_order_model.g.dart';

@freezed
class KotOrderLineModel with _$KotOrderLineModel {
  const factory KotOrderLineModel({
    required String id,
    @JsonKey(name: 'kot_order_id') required String kotOrderId,
    @JsonKey(name: 'sale_line_id') String? saleLineId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    required String qty,
    @JsonKey(name: 'modifiers_json') @Default([]) List<dynamic> modifiersJson,
    @JsonKey(name: 'kitchen_notes') String? kitchenNotes,
    required String status,
  }) = _KotOrderLineModel;

  factory KotOrderLineModel.fromJson(Map<String, dynamic> json) =>
      _$KotOrderLineModelFromJson(json);
}

@freezed
class KotOrderModel with _$KotOrderModel {
  const factory KotOrderModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'table_id') String? tableId,
    @JsonKey(name: 'table_number') String? tableNumber,
    @JsonKey(name: 'kot_number') required String kotNumber,
    required String status,
    @JsonKey(name: 'fired_at') required String firedAt,
    @JsonKey(name: 'ready_at') String? readyAt,
    @JsonKey(name: 'served_at') String? servedAt,
    String? notes,
    @Default([]) List<KotOrderLineModel> lines,
  }) = _KotOrderModel;

  factory KotOrderModel.fromJson(Map<String, dynamic> json) =>
      _$KotOrderModelFromJson(json);
}

@freezed
class FireTabResponseModel with _$FireTabResponseModel {
  const factory FireTabResponseModel({
    required String id,
    @JsonKey(name: 'kot_number') required String kotNumber,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'table_id') String? tableId,
    required String status,
  }) = _FireTabResponseModel;

  factory FireTabResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FireTabResponseModelFromJson(json);
}
