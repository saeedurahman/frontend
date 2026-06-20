import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_model.freezed.dart';
part 'unit_model.g.dart';

@freezed
class UnitModel with _$UnitModel {
  const factory UnitModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    required String symbol,
    @JsonKey(name: 'is_base_unit') @Default(false) bool isBaseUnit,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _UnitModel;

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);
}

@freezed
class UnitConversionModel with _$UnitConversionModel {
  const factory UnitConversionModel({
    required String id,
    @JsonKey(name: 'from_unit_id') required String fromUnitId,
    @JsonKey(name: 'to_unit_id') required String toUnitId,
    @JsonKey(name: 'conversion_factor') required String conversionFactor,
  }) = _UnitConversionModel;

  factory UnitConversionModel.fromJson(Map<String, dynamic> json) =>
      _$UnitConversionModelFromJson(json);
}
