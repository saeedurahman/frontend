import 'package:freezed_annotation/freezed_annotation.dart';

part 'barcode_model.freezed.dart';
part 'barcode_model.g.dart';

@freezed
class BarcodeModel with _$BarcodeModel {
  const factory BarcodeModel({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    required String barcode,
    @JsonKey(name: 'barcode_type') @Default('EAN13') String barcodeType,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
  }) = _BarcodeModel;

  factory BarcodeModel.fromJson(Map<String, dynamic> json) =>
      _$BarcodeModelFromJson(json);
}
