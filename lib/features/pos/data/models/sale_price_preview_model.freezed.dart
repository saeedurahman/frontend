// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_price_preview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalePricePreviewLineModel _$SalePricePreviewLineModelFromJson(
  Map<String, dynamic> json,
) {
  return _SalePricePreviewLineModel.fromJson(json);
}

/// @nodoc
mixin _$SalePricePreviewLineModel {
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  String get qty => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  String get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_order')
  int get lineOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_subtotal')
  String get lineSubtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_pct')
  String get discountPct => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount')
  String get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_rate')
  String get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount')
  String get taxAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_total')
  String get lineTotal => throw _privateConstructorUsedError;

  /// Serializes this SalePricePreviewLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalePricePreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalePricePreviewLineModelCopyWith<SalePricePreviewLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalePricePreviewLineModelCopyWith<$Res> {
  factory $SalePricePreviewLineModelCopyWith(
    SalePricePreviewLineModel value,
    $Res Function(SalePricePreviewLineModel) then,
  ) = _$SalePricePreviewLineModelCopyWithImpl<$Res, SalePricePreviewLineModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    String qty,
    @JsonKey(name: 'unit_price') String unitPrice,
    @JsonKey(name: 'line_order') int lineOrder,
    @JsonKey(name: 'line_subtotal') String lineSubtotal,
    @JsonKey(name: 'discount_pct') String discountPct,
    @JsonKey(name: 'discount_amount') String discountAmount,
    @JsonKey(name: 'tax_rate') String taxRate,
    @JsonKey(name: 'tax_amount') String taxAmount,
    @JsonKey(name: 'line_total') String lineTotal,
  });
}

/// @nodoc
class _$SalePricePreviewLineModelCopyWithImpl<
  $Res,
  $Val extends SalePricePreviewLineModel
>
    implements $SalePricePreviewLineModelCopyWith<$Res> {
  _$SalePricePreviewLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalePricePreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? variationId = freezed,
    Object? qty = null,
    Object? unitPrice = null,
    Object? lineOrder = null,
    Object? lineSubtotal = null,
    Object? discountPct = null,
    Object? discountAmount = null,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? lineTotal = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as String,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as String,
            lineOrder: null == lineOrder
                ? _value.lineOrder
                : lineOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            lineSubtotal: null == lineSubtotal
                ? _value.lineSubtotal
                : lineSubtotal // ignore: cast_nullable_to_non_nullable
                      as String,
            discountPct: null == discountPct
                ? _value.discountPct
                : discountPct // ignore: cast_nullable_to_non_nullable
                      as String,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            taxRate: null == taxRate
                ? _value.taxRate
                : taxRate // ignore: cast_nullable_to_non_nullable
                      as String,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            lineTotal: null == lineTotal
                ? _value.lineTotal
                : lineTotal // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalePricePreviewLineModelImplCopyWith<$Res>
    implements $SalePricePreviewLineModelCopyWith<$Res> {
  factory _$$SalePricePreviewLineModelImplCopyWith(
    _$SalePricePreviewLineModelImpl value,
    $Res Function(_$SalePricePreviewLineModelImpl) then,
  ) = __$$SalePricePreviewLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    String qty,
    @JsonKey(name: 'unit_price') String unitPrice,
    @JsonKey(name: 'line_order') int lineOrder,
    @JsonKey(name: 'line_subtotal') String lineSubtotal,
    @JsonKey(name: 'discount_pct') String discountPct,
    @JsonKey(name: 'discount_amount') String discountAmount,
    @JsonKey(name: 'tax_rate') String taxRate,
    @JsonKey(name: 'tax_amount') String taxAmount,
    @JsonKey(name: 'line_total') String lineTotal,
  });
}

/// @nodoc
class __$$SalePricePreviewLineModelImplCopyWithImpl<$Res>
    extends
        _$SalePricePreviewLineModelCopyWithImpl<
          $Res,
          _$SalePricePreviewLineModelImpl
        >
    implements _$$SalePricePreviewLineModelImplCopyWith<$Res> {
  __$$SalePricePreviewLineModelImplCopyWithImpl(
    _$SalePricePreviewLineModelImpl _value,
    $Res Function(_$SalePricePreviewLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalePricePreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? variationId = freezed,
    Object? qty = null,
    Object? unitPrice = null,
    Object? lineOrder = null,
    Object? lineSubtotal = null,
    Object? discountPct = null,
    Object? discountAmount = null,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? lineTotal = null,
  }) {
    return _then(
      _$SalePricePreviewLineModelImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as String,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as String,
        lineOrder: null == lineOrder
            ? _value.lineOrder
            : lineOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        lineSubtotal: null == lineSubtotal
            ? _value.lineSubtotal
            : lineSubtotal // ignore: cast_nullable_to_non_nullable
                  as String,
        discountPct: null == discountPct
            ? _value.discountPct
            : discountPct // ignore: cast_nullable_to_non_nullable
                  as String,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        taxRate: null == taxRate
            ? _value.taxRate
            : taxRate // ignore: cast_nullable_to_non_nullable
                  as String,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        lineTotal: null == lineTotal
            ? _value.lineTotal
            : lineTotal // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalePricePreviewLineModelImpl implements _SalePricePreviewLineModel {
  const _$SalePricePreviewLineModelImpl({
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'variation_id') this.variationId,
    required this.qty,
    @JsonKey(name: 'unit_price') required this.unitPrice,
    @JsonKey(name: 'line_order') this.lineOrder = 0,
    @JsonKey(name: 'line_subtotal') required this.lineSubtotal,
    @JsonKey(name: 'discount_pct') this.discountPct = '0',
    @JsonKey(name: 'discount_amount') this.discountAmount = '0',
    @JsonKey(name: 'tax_rate') this.taxRate = '0',
    @JsonKey(name: 'tax_amount') this.taxAmount = '0',
    @JsonKey(name: 'line_total') required this.lineTotal,
  });

  factory _$SalePricePreviewLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalePricePreviewLineModelImplFromJson(json);

  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  final String qty;
  @override
  @JsonKey(name: 'unit_price')
  final String unitPrice;
  @override
  @JsonKey(name: 'line_order')
  final int lineOrder;
  @override
  @JsonKey(name: 'line_subtotal')
  final String lineSubtotal;
  @override
  @JsonKey(name: 'discount_pct')
  final String discountPct;
  @override
  @JsonKey(name: 'discount_amount')
  final String discountAmount;
  @override
  @JsonKey(name: 'tax_rate')
  final String taxRate;
  @override
  @JsonKey(name: 'tax_amount')
  final String taxAmount;
  @override
  @JsonKey(name: 'line_total')
  final String lineTotal;

  @override
  String toString() {
    return 'SalePricePreviewLineModel(productId: $productId, variationId: $variationId, qty: $qty, unitPrice: $unitPrice, lineOrder: $lineOrder, lineSubtotal: $lineSubtotal, discountPct: $discountPct, discountAmount: $discountAmount, taxRate: $taxRate, taxAmount: $taxAmount, lineTotal: $lineTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalePricePreviewLineModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.lineOrder, lineOrder) ||
                other.lineOrder == lineOrder) &&
            (identical(other.lineSubtotal, lineSubtotal) ||
                other.lineSubtotal == lineSubtotal) &&
            (identical(other.discountPct, discountPct) ||
                other.discountPct == discountPct) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    variationId,
    qty,
    unitPrice,
    lineOrder,
    lineSubtotal,
    discountPct,
    discountAmount,
    taxRate,
    taxAmount,
    lineTotal,
  );

  /// Create a copy of SalePricePreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalePricePreviewLineModelImplCopyWith<_$SalePricePreviewLineModelImpl>
  get copyWith =>
      __$$SalePricePreviewLineModelImplCopyWithImpl<
        _$SalePricePreviewLineModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalePricePreviewLineModelImplToJson(this);
  }
}

abstract class _SalePricePreviewLineModel implements SalePricePreviewLineModel {
  const factory _SalePricePreviewLineModel({
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'variation_id') final String? variationId,
    required final String qty,
    @JsonKey(name: 'unit_price') required final String unitPrice,
    @JsonKey(name: 'line_order') final int lineOrder,
    @JsonKey(name: 'line_subtotal') required final String lineSubtotal,
    @JsonKey(name: 'discount_pct') final String discountPct,
    @JsonKey(name: 'discount_amount') final String discountAmount,
    @JsonKey(name: 'tax_rate') final String taxRate,
    @JsonKey(name: 'tax_amount') final String taxAmount,
    @JsonKey(name: 'line_total') required final String lineTotal,
  }) = _$SalePricePreviewLineModelImpl;

  factory _SalePricePreviewLineModel.fromJson(Map<String, dynamic> json) =
      _$SalePricePreviewLineModelImpl.fromJson;

  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  String get qty;
  @override
  @JsonKey(name: 'unit_price')
  String get unitPrice;
  @override
  @JsonKey(name: 'line_order')
  int get lineOrder;
  @override
  @JsonKey(name: 'line_subtotal')
  String get lineSubtotal;
  @override
  @JsonKey(name: 'discount_pct')
  String get discountPct;
  @override
  @JsonKey(name: 'discount_amount')
  String get discountAmount;
  @override
  @JsonKey(name: 'tax_rate')
  String get taxRate;
  @override
  @JsonKey(name: 'tax_amount')
  String get taxAmount;
  @override
  @JsonKey(name: 'line_total')
  String get lineTotal;

  /// Create a copy of SalePricePreviewLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalePricePreviewLineModelImplCopyWith<_$SalePricePreviewLineModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SalePricePreviewModel _$SalePricePreviewModelFromJson(
  Map<String, dynamic> json,
) {
  return _SalePricePreviewModel.fromJson(json);
}

/// @nodoc
mixin _$SalePricePreviewModel {
  @JsonKey(name: 'discount_scheme_id')
  String? get discountSchemeId => throw _privateConstructorUsedError;
  String get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_discount')
  String get totalDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_tax')
  String get totalTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  String get totalAmount => throw _privateConstructorUsedError;
  List<SalePricePreviewLineModel> get lines =>
      throw _privateConstructorUsedError;

  /// Serializes this SalePricePreviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalePricePreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalePricePreviewModelCopyWith<SalePricePreviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalePricePreviewModelCopyWith<$Res> {
  factory $SalePricePreviewModelCopyWith(
    SalePricePreviewModel value,
    $Res Function(SalePricePreviewModel) then,
  ) = _$SalePricePreviewModelCopyWithImpl<$Res, SalePricePreviewModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'discount_scheme_id') String? discountSchemeId,
    String subtotal,
    @JsonKey(name: 'total_discount') String totalDiscount,
    @JsonKey(name: 'total_tax') String totalTax,
    @JsonKey(name: 'total_amount') String totalAmount,
    List<SalePricePreviewLineModel> lines,
  });
}

/// @nodoc
class _$SalePricePreviewModelCopyWithImpl<
  $Res,
  $Val extends SalePricePreviewModel
>
    implements $SalePricePreviewModelCopyWith<$Res> {
  _$SalePricePreviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalePricePreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountSchemeId = freezed,
    Object? subtotal = null,
    Object? totalDiscount = null,
    Object? totalTax = null,
    Object? totalAmount = null,
    Object? lines = null,
  }) {
    return _then(
      _value.copyWith(
            discountSchemeId: freezed == discountSchemeId
                ? _value.discountSchemeId
                : discountSchemeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as String,
            totalDiscount: null == totalDiscount
                ? _value.totalDiscount
                : totalDiscount // ignore: cast_nullable_to_non_nullable
                      as String,
            totalTax: null == totalTax
                ? _value.totalTax
                : totalTax // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<SalePricePreviewLineModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SalePricePreviewModelImplCopyWith<$Res>
    implements $SalePricePreviewModelCopyWith<$Res> {
  factory _$$SalePricePreviewModelImplCopyWith(
    _$SalePricePreviewModelImpl value,
    $Res Function(_$SalePricePreviewModelImpl) then,
  ) = __$$SalePricePreviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'discount_scheme_id') String? discountSchemeId,
    String subtotal,
    @JsonKey(name: 'total_discount') String totalDiscount,
    @JsonKey(name: 'total_tax') String totalTax,
    @JsonKey(name: 'total_amount') String totalAmount,
    List<SalePricePreviewLineModel> lines,
  });
}

/// @nodoc
class __$$SalePricePreviewModelImplCopyWithImpl<$Res>
    extends
        _$SalePricePreviewModelCopyWithImpl<$Res, _$SalePricePreviewModelImpl>
    implements _$$SalePricePreviewModelImplCopyWith<$Res> {
  __$$SalePricePreviewModelImplCopyWithImpl(
    _$SalePricePreviewModelImpl _value,
    $Res Function(_$SalePricePreviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalePricePreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountSchemeId = freezed,
    Object? subtotal = null,
    Object? totalDiscount = null,
    Object? totalTax = null,
    Object? totalAmount = null,
    Object? lines = null,
  }) {
    return _then(
      _$SalePricePreviewModelImpl(
        discountSchemeId: freezed == discountSchemeId
            ? _value.discountSchemeId
            : discountSchemeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as String,
        totalDiscount: null == totalDiscount
            ? _value.totalDiscount
            : totalDiscount // ignore: cast_nullable_to_non_nullable
                  as String,
        totalTax: null == totalTax
            ? _value.totalTax
            : totalTax // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<SalePricePreviewLineModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalePricePreviewModelImpl extends _SalePricePreviewModel {
  const _$SalePricePreviewModelImpl({
    @JsonKey(name: 'discount_scheme_id') this.discountSchemeId,
    required this.subtotal,
    @JsonKey(name: 'total_discount') this.totalDiscount = '0',
    @JsonKey(name: 'total_tax') this.totalTax = '0',
    @JsonKey(name: 'total_amount') required this.totalAmount,
    final List<SalePricePreviewLineModel> lines = const [],
  }) : _lines = lines,
       super._();

  factory _$SalePricePreviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalePricePreviewModelImplFromJson(json);

  @override
  @JsonKey(name: 'discount_scheme_id')
  final String? discountSchemeId;
  @override
  final String subtotal;
  @override
  @JsonKey(name: 'total_discount')
  final String totalDiscount;
  @override
  @JsonKey(name: 'total_tax')
  final String totalTax;
  @override
  @JsonKey(name: 'total_amount')
  final String totalAmount;
  final List<SalePricePreviewLineModel> _lines;
  @override
  @JsonKey()
  List<SalePricePreviewLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'SalePricePreviewModel(discountSchemeId: $discountSchemeId, subtotal: $subtotal, totalDiscount: $totalDiscount, totalTax: $totalTax, totalAmount: $totalAmount, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalePricePreviewModelImpl &&
            (identical(other.discountSchemeId, discountSchemeId) ||
                other.discountSchemeId == discountSchemeId) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.totalDiscount, totalDiscount) ||
                other.totalDiscount == totalDiscount) &&
            (identical(other.totalTax, totalTax) ||
                other.totalTax == totalTax) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    discountSchemeId,
    subtotal,
    totalDiscount,
    totalTax,
    totalAmount,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of SalePricePreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalePricePreviewModelImplCopyWith<_$SalePricePreviewModelImpl>
  get copyWith =>
      __$$SalePricePreviewModelImplCopyWithImpl<_$SalePricePreviewModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalePricePreviewModelImplToJson(this);
  }
}

abstract class _SalePricePreviewModel extends SalePricePreviewModel {
  const factory _SalePricePreviewModel({
    @JsonKey(name: 'discount_scheme_id') final String? discountSchemeId,
    required final String subtotal,
    @JsonKey(name: 'total_discount') final String totalDiscount,
    @JsonKey(name: 'total_tax') final String totalTax,
    @JsonKey(name: 'total_amount') required final String totalAmount,
    final List<SalePricePreviewLineModel> lines,
  }) = _$SalePricePreviewModelImpl;
  const _SalePricePreviewModel._() : super._();

  factory _SalePricePreviewModel.fromJson(Map<String, dynamic> json) =
      _$SalePricePreviewModelImpl.fromJson;

  @override
  @JsonKey(name: 'discount_scheme_id')
  String? get discountSchemeId;
  @override
  String get subtotal;
  @override
  @JsonKey(name: 'total_discount')
  String get totalDiscount;
  @override
  @JsonKey(name: 'total_tax')
  String get totalTax;
  @override
  @JsonKey(name: 'total_amount')
  String get totalAmount;
  @override
  List<SalePricePreviewLineModel> get lines;

  /// Create a copy of SalePricePreviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalePricePreviewModelImplCopyWith<_$SalePricePreviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
