// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount_scheme_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscountSchemeModel _$DiscountSchemeModelFromJson(Map<String, dynamic> json) {
  return _DiscountSchemeModel.fromJson(json);
}

/// @nodoc
mixin _$DiscountSchemeModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_type')
  String get discountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_value')
  String get discountValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_purchase_amount')
  String? get minPurchaseAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_from')
  String? get validFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'valid_to')
  String? get validTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this DiscountSchemeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscountSchemeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscountSchemeModelCopyWith<DiscountSchemeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscountSchemeModelCopyWith<$Res> {
  factory $DiscountSchemeModelCopyWith(
    DiscountSchemeModel value,
    $Res Function(DiscountSchemeModel) then,
  ) = _$DiscountSchemeModelCopyWithImpl<$Res, DiscountSchemeModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    @JsonKey(name: 'discount_type') String discountType,
    @JsonKey(name: 'discount_value') String discountValue,
    @JsonKey(name: 'min_purchase_amount') String? minPurchaseAmount,
    @JsonKey(name: 'valid_from') String? validFrom,
    @JsonKey(name: 'valid_to') String? validTo,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$DiscountSchemeModelCopyWithImpl<$Res, $Val extends DiscountSchemeModel>
    implements $DiscountSchemeModelCopyWith<$Res> {
  _$DiscountSchemeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscountSchemeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? minPurchaseAmount = freezed,
    Object? validFrom = freezed,
    Object? validTo = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            businessId: null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            discountType: null == discountType
                ? _value.discountType
                : discountType // ignore: cast_nullable_to_non_nullable
                      as String,
            discountValue: null == discountValue
                ? _value.discountValue
                : discountValue // ignore: cast_nullable_to_non_nullable
                      as String,
            minPurchaseAmount: freezed == minPurchaseAmount
                ? _value.minPurchaseAmount
                : minPurchaseAmount // ignore: cast_nullable_to_non_nullable
                      as String?,
            validFrom: freezed == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                      as String?,
            validTo: freezed == validTo
                ? _value.validTo
                : validTo // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiscountSchemeModelImplCopyWith<$Res>
    implements $DiscountSchemeModelCopyWith<$Res> {
  factory _$$DiscountSchemeModelImplCopyWith(
    _$DiscountSchemeModelImpl value,
    $Res Function(_$DiscountSchemeModelImpl) then,
  ) = __$$DiscountSchemeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    @JsonKey(name: 'discount_type') String discountType,
    @JsonKey(name: 'discount_value') String discountValue,
    @JsonKey(name: 'min_purchase_amount') String? minPurchaseAmount,
    @JsonKey(name: 'valid_from') String? validFrom,
    @JsonKey(name: 'valid_to') String? validTo,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$DiscountSchemeModelImplCopyWithImpl<$Res>
    extends _$DiscountSchemeModelCopyWithImpl<$Res, _$DiscountSchemeModelImpl>
    implements _$$DiscountSchemeModelImplCopyWith<$Res> {
  __$$DiscountSchemeModelImplCopyWithImpl(
    _$DiscountSchemeModelImpl _value,
    $Res Function(_$DiscountSchemeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscountSchemeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? minPurchaseAmount = freezed,
    Object? validFrom = freezed,
    Object? validTo = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _$DiscountSchemeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        discountType: null == discountType
            ? _value.discountType
            : discountType // ignore: cast_nullable_to_non_nullable
                  as String,
        discountValue: null == discountValue
            ? _value.discountValue
            : discountValue // ignore: cast_nullable_to_non_nullable
                  as String,
        minPurchaseAmount: freezed == minPurchaseAmount
            ? _value.minPurchaseAmount
            : minPurchaseAmount // ignore: cast_nullable_to_non_nullable
                  as String?,
        validFrom: freezed == validFrom
            ? _value.validFrom
            : validFrom // ignore: cast_nullable_to_non_nullable
                  as String?,
        validTo: freezed == validTo
            ? _value.validTo
            : validTo // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscountSchemeModelImpl implements _DiscountSchemeModel {
  const _$DiscountSchemeModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    required this.name,
    @JsonKey(name: 'discount_type') required this.discountType,
    @JsonKey(name: 'discount_value') required this.discountValue,
    @JsonKey(name: 'min_purchase_amount') this.minPurchaseAmount,
    @JsonKey(name: 'valid_from') this.validFrom,
    @JsonKey(name: 'valid_to') this.validTo,
    @JsonKey(name: 'is_active') this.isActive = true,
  });

  factory _$DiscountSchemeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscountSchemeModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  final String name;
  @override
  @JsonKey(name: 'discount_type')
  final String discountType;
  @override
  @JsonKey(name: 'discount_value')
  final String discountValue;
  @override
  @JsonKey(name: 'min_purchase_amount')
  final String? minPurchaseAmount;
  @override
  @JsonKey(name: 'valid_from')
  final String? validFrom;
  @override
  @JsonKey(name: 'valid_to')
  final String? validTo;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'DiscountSchemeModel(id: $id, businessId: $businessId, name: $name, discountType: $discountType, discountValue: $discountValue, minPurchaseAmount: $minPurchaseAmount, validFrom: $validFrom, validTo: $validTo, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscountSchemeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.minPurchaseAmount, minPurchaseAmount) ||
                other.minPurchaseAmount == minPurchaseAmount) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validTo, validTo) || other.validTo == validTo) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    name,
    discountType,
    discountValue,
    minPurchaseAmount,
    validFrom,
    validTo,
    isActive,
  );

  /// Create a copy of DiscountSchemeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscountSchemeModelImplCopyWith<_$DiscountSchemeModelImpl> get copyWith =>
      __$$DiscountSchemeModelImplCopyWithImpl<_$DiscountSchemeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscountSchemeModelImplToJson(this);
  }
}

abstract class _DiscountSchemeModel implements DiscountSchemeModel {
  const factory _DiscountSchemeModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    required final String name,
    @JsonKey(name: 'discount_type') required final String discountType,
    @JsonKey(name: 'discount_value') required final String discountValue,
    @JsonKey(name: 'min_purchase_amount') final String? minPurchaseAmount,
    @JsonKey(name: 'valid_from') final String? validFrom,
    @JsonKey(name: 'valid_to') final String? validTo,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$DiscountSchemeModelImpl;

  factory _DiscountSchemeModel.fromJson(Map<String, dynamic> json) =
      _$DiscountSchemeModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  String get name;
  @override
  @JsonKey(name: 'discount_type')
  String get discountType;
  @override
  @JsonKey(name: 'discount_value')
  String get discountValue;
  @override
  @JsonKey(name: 'min_purchase_amount')
  String? get minPurchaseAmount;
  @override
  @JsonKey(name: 'valid_from')
  String? get validFrom;
  @override
  @JsonKey(name: 'valid_to')
  String? get validTo;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of DiscountSchemeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscountSchemeModelImplCopyWith<_$DiscountSchemeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
