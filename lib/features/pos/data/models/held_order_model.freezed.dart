// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'held_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HeldOrderModel {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<CartItemModel> get cartItems => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  String? get customerName => throw _privateConstructorUsedError;
  String? get cartDiscountType => throw _privateConstructorUsedError;
  Decimal? get cartDiscountValue => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  Decimal get totalAmount => throw _privateConstructorUsedError;

  /// Create a copy of HeldOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeldOrderModelCopyWith<HeldOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeldOrderModelCopyWith<$Res> {
  factory $HeldOrderModelCopyWith(
    HeldOrderModel value,
    $Res Function(HeldOrderModel) then,
  ) = _$HeldOrderModelCopyWithImpl<$Res, HeldOrderModel>;
  @useResult
  $Res call({
    String id,
    String label,
    DateTime createdAt,
    List<CartItemModel> cartItems,
    String? customerId,
    String? customerName,
    String? cartDiscountType,
    Decimal? cartDiscountValue,
    int itemCount,
    Decimal totalAmount,
  });
}

/// @nodoc
class _$HeldOrderModelCopyWithImpl<$Res, $Val extends HeldOrderModel>
    implements $HeldOrderModelCopyWith<$Res> {
  _$HeldOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeldOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? createdAt = null,
    Object? cartItems = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? cartDiscountType = freezed,
    Object? cartDiscountValue = freezed,
    Object? itemCount = null,
    Object? totalAmount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            cartItems: null == cartItems
                ? _value.cartItems
                : cartItems // ignore: cast_nullable_to_non_nullable
                      as List<CartItemModel>,
            customerId: freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            cartDiscountType: freezed == cartDiscountType
                ? _value.cartDiscountType
                : cartDiscountType // ignore: cast_nullable_to_non_nullable
                      as String?,
            cartDiscountValue: freezed == cartDiscountValue
                ? _value.cartDiscountValue
                : cartDiscountValue // ignore: cast_nullable_to_non_nullable
                      as Decimal?,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as Decimal,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HeldOrderModelImplCopyWith<$Res>
    implements $HeldOrderModelCopyWith<$Res> {
  factory _$$HeldOrderModelImplCopyWith(
    _$HeldOrderModelImpl value,
    $Res Function(_$HeldOrderModelImpl) then,
  ) = __$$HeldOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String label,
    DateTime createdAt,
    List<CartItemModel> cartItems,
    String? customerId,
    String? customerName,
    String? cartDiscountType,
    Decimal? cartDiscountValue,
    int itemCount,
    Decimal totalAmount,
  });
}

/// @nodoc
class __$$HeldOrderModelImplCopyWithImpl<$Res>
    extends _$HeldOrderModelCopyWithImpl<$Res, _$HeldOrderModelImpl>
    implements _$$HeldOrderModelImplCopyWith<$Res> {
  __$$HeldOrderModelImplCopyWithImpl(
    _$HeldOrderModelImpl _value,
    $Res Function(_$HeldOrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HeldOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? createdAt = null,
    Object? cartItems = null,
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? cartDiscountType = freezed,
    Object? cartDiscountValue = freezed,
    Object? itemCount = null,
    Object? totalAmount = null,
  }) {
    return _then(
      _$HeldOrderModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        cartItems: null == cartItems
            ? _value._cartItems
            : cartItems // ignore: cast_nullable_to_non_nullable
                  as List<CartItemModel>,
        customerId: freezed == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        cartDiscountType: freezed == cartDiscountType
            ? _value.cartDiscountType
            : cartDiscountType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cartDiscountValue: freezed == cartDiscountValue
            ? _value.cartDiscountValue
            : cartDiscountValue // ignore: cast_nullable_to_non_nullable
                  as Decimal?,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as Decimal,
      ),
    );
  }
}

/// @nodoc

class _$HeldOrderModelImpl implements _HeldOrderModel {
  const _$HeldOrderModelImpl({
    required this.id,
    required this.label,
    required this.createdAt,
    required final List<CartItemModel> cartItems,
    this.customerId,
    this.customerName,
    this.cartDiscountType,
    this.cartDiscountValue,
    required this.itemCount,
    required this.totalAmount,
  }) : _cartItems = cartItems;

  @override
  final String id;
  @override
  final String label;
  @override
  final DateTime createdAt;
  final List<CartItemModel> _cartItems;
  @override
  List<CartItemModel> get cartItems {
    if (_cartItems is EqualUnmodifiableListView) return _cartItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cartItems);
  }

  @override
  final String? customerId;
  @override
  final String? customerName;
  @override
  final String? cartDiscountType;
  @override
  final Decimal? cartDiscountValue;
  @override
  final int itemCount;
  @override
  final Decimal totalAmount;

  @override
  String toString() {
    return 'HeldOrderModel(id: $id, label: $label, createdAt: $createdAt, cartItems: $cartItems, customerId: $customerId, customerName: $customerName, cartDiscountType: $cartDiscountType, cartDiscountValue: $cartDiscountValue, itemCount: $itemCount, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeldOrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other._cartItems,
              _cartItems,
            ) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.cartDiscountType, cartDiscountType) ||
                other.cartDiscountType == cartDiscountType) &&
            (identical(other.cartDiscountValue, cartDiscountValue) ||
                other.cartDiscountValue == cartDiscountValue) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    createdAt,
    const DeepCollectionEquality().hash(_cartItems),
    customerId,
    customerName,
    cartDiscountType,
    cartDiscountValue,
    itemCount,
    totalAmount,
  );

  /// Create a copy of HeldOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeldOrderModelImplCopyWith<_$HeldOrderModelImpl> get copyWith =>
      __$$HeldOrderModelImplCopyWithImpl<_$HeldOrderModelImpl>(
        this,
        _$identity,
      );
}

abstract class _HeldOrderModel implements HeldOrderModel {
  const factory _HeldOrderModel({
    required final String id,
    required final String label,
    required final DateTime createdAt,
    required final List<CartItemModel> cartItems,
    final String? customerId,
    final String? customerName,
    final String? cartDiscountType,
    final Decimal? cartDiscountValue,
    required final int itemCount,
    required final Decimal totalAmount,
  }) = _$HeldOrderModelImpl;

  @override
  String get id;
  @override
  String get label;
  @override
  DateTime get createdAt;
  @override
  List<CartItemModel> get cartItems;
  @override
  String? get customerId;
  @override
  String? get customerName;
  @override
  String? get cartDiscountType;
  @override
  Decimal? get cartDiscountValue;
  @override
  int get itemCount;
  @override
  Decimal get totalAmount;

  /// Create a copy of HeldOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeldOrderModelImplCopyWith<_$HeldOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
