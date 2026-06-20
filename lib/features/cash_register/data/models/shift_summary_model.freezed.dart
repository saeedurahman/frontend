// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShiftSummaryModel _$ShiftSummaryModelFromJson(Map<String, dynamic> json) {
  return _ShiftSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$ShiftSummaryModel {
  @JsonKey(name: 'shift_id')
  String? get shiftId => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'opening_float')
  String get openingFloat => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cash_sales')
  String get totalCashSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_card_sales')
  String get totalCardSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_wallet_sales')
  String get totalWalletSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_other_sales')
  String get totalOtherSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_returns')
  String get totalReturns => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cash_in')
  String get totalCashIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cash_out')
  String get totalCashOut => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses')
  String get totalExpenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'expected_cash')
  String get expectedCash => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_cash')
  String? get actualCash => throw _privateConstructorUsedError;
  @JsonKey(name: 'cash_difference')
  String? get cashDifference => throw _privateConstructorUsedError;

  /// Serializes this ShiftSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftSummaryModelCopyWith<ShiftSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftSummaryModelCopyWith<$Res> {
  factory $ShiftSummaryModelCopyWith(
    ShiftSummaryModel value,
    $Res Function(ShiftSummaryModel) then,
  ) = _$ShiftSummaryModelCopyWithImpl<$Res, ShiftSummaryModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'shift_id') String? shiftId,
    String? status,
    @JsonKey(name: 'opening_float') String openingFloat,
    @JsonKey(name: 'total_cash_sales') String totalCashSales,
    @JsonKey(name: 'total_card_sales') String totalCardSales,
    @JsonKey(name: 'total_wallet_sales') String totalWalletSales,
    @JsonKey(name: 'total_other_sales') String totalOtherSales,
    @JsonKey(name: 'total_returns') String totalReturns,
    @JsonKey(name: 'total_cash_in') String totalCashIn,
    @JsonKey(name: 'total_cash_out') String totalCashOut,
    @JsonKey(name: 'total_expenses') String totalExpenses,
    @JsonKey(name: 'expected_cash') String expectedCash,
    @JsonKey(name: 'actual_cash') String? actualCash,
    @JsonKey(name: 'cash_difference') String? cashDifference,
  });
}

/// @nodoc
class _$ShiftSummaryModelCopyWithImpl<$Res, $Val extends ShiftSummaryModel>
    implements $ShiftSummaryModelCopyWith<$Res> {
  _$ShiftSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = freezed,
    Object? status = freezed,
    Object? openingFloat = null,
    Object? totalCashSales = null,
    Object? totalCardSales = null,
    Object? totalWalletSales = null,
    Object? totalOtherSales = null,
    Object? totalReturns = null,
    Object? totalCashIn = null,
    Object? totalCashOut = null,
    Object? totalExpenses = null,
    Object? expectedCash = null,
    Object? actualCash = freezed,
    Object? cashDifference = freezed,
  }) {
    return _then(
      _value.copyWith(
            shiftId: freezed == shiftId
                ? _value.shiftId
                : shiftId // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            openingFloat: null == openingFloat
                ? _value.openingFloat
                : openingFloat // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCashSales: null == totalCashSales
                ? _value.totalCashSales
                : totalCashSales // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCardSales: null == totalCardSales
                ? _value.totalCardSales
                : totalCardSales // ignore: cast_nullable_to_non_nullable
                      as String,
            totalWalletSales: null == totalWalletSales
                ? _value.totalWalletSales
                : totalWalletSales // ignore: cast_nullable_to_non_nullable
                      as String,
            totalOtherSales: null == totalOtherSales
                ? _value.totalOtherSales
                : totalOtherSales // ignore: cast_nullable_to_non_nullable
                      as String,
            totalReturns: null == totalReturns
                ? _value.totalReturns
                : totalReturns // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCashIn: null == totalCashIn
                ? _value.totalCashIn
                : totalCashIn // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCashOut: null == totalCashOut
                ? _value.totalCashOut
                : totalCashOut // ignore: cast_nullable_to_non_nullable
                      as String,
            totalExpenses: null == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as String,
            expectedCash: null == expectedCash
                ? _value.expectedCash
                : expectedCash // ignore: cast_nullable_to_non_nullable
                      as String,
            actualCash: freezed == actualCash
                ? _value.actualCash
                : actualCash // ignore: cast_nullable_to_non_nullable
                      as String?,
            cashDifference: freezed == cashDifference
                ? _value.cashDifference
                : cashDifference // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShiftSummaryModelImplCopyWith<$Res>
    implements $ShiftSummaryModelCopyWith<$Res> {
  factory _$$ShiftSummaryModelImplCopyWith(
    _$ShiftSummaryModelImpl value,
    $Res Function(_$ShiftSummaryModelImpl) then,
  ) = __$$ShiftSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'shift_id') String? shiftId,
    String? status,
    @JsonKey(name: 'opening_float') String openingFloat,
    @JsonKey(name: 'total_cash_sales') String totalCashSales,
    @JsonKey(name: 'total_card_sales') String totalCardSales,
    @JsonKey(name: 'total_wallet_sales') String totalWalletSales,
    @JsonKey(name: 'total_other_sales') String totalOtherSales,
    @JsonKey(name: 'total_returns') String totalReturns,
    @JsonKey(name: 'total_cash_in') String totalCashIn,
    @JsonKey(name: 'total_cash_out') String totalCashOut,
    @JsonKey(name: 'total_expenses') String totalExpenses,
    @JsonKey(name: 'expected_cash') String expectedCash,
    @JsonKey(name: 'actual_cash') String? actualCash,
    @JsonKey(name: 'cash_difference') String? cashDifference,
  });
}

/// @nodoc
class __$$ShiftSummaryModelImplCopyWithImpl<$Res>
    extends _$ShiftSummaryModelCopyWithImpl<$Res, _$ShiftSummaryModelImpl>
    implements _$$ShiftSummaryModelImplCopyWith<$Res> {
  __$$ShiftSummaryModelImplCopyWithImpl(
    _$ShiftSummaryModelImpl _value,
    $Res Function(_$ShiftSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShiftSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = freezed,
    Object? status = freezed,
    Object? openingFloat = null,
    Object? totalCashSales = null,
    Object? totalCardSales = null,
    Object? totalWalletSales = null,
    Object? totalOtherSales = null,
    Object? totalReturns = null,
    Object? totalCashIn = null,
    Object? totalCashOut = null,
    Object? totalExpenses = null,
    Object? expectedCash = null,
    Object? actualCash = freezed,
    Object? cashDifference = freezed,
  }) {
    return _then(
      _$ShiftSummaryModelImpl(
        shiftId: freezed == shiftId
            ? _value.shiftId
            : shiftId // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        openingFloat: null == openingFloat
            ? _value.openingFloat
            : openingFloat // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCashSales: null == totalCashSales
            ? _value.totalCashSales
            : totalCashSales // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCardSales: null == totalCardSales
            ? _value.totalCardSales
            : totalCardSales // ignore: cast_nullable_to_non_nullable
                  as String,
        totalWalletSales: null == totalWalletSales
            ? _value.totalWalletSales
            : totalWalletSales // ignore: cast_nullable_to_non_nullable
                  as String,
        totalOtherSales: null == totalOtherSales
            ? _value.totalOtherSales
            : totalOtherSales // ignore: cast_nullable_to_non_nullable
                  as String,
        totalReturns: null == totalReturns
            ? _value.totalReturns
            : totalReturns // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCashIn: null == totalCashIn
            ? _value.totalCashIn
            : totalCashIn // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCashOut: null == totalCashOut
            ? _value.totalCashOut
            : totalCashOut // ignore: cast_nullable_to_non_nullable
                  as String,
        totalExpenses: null == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as String,
        expectedCash: null == expectedCash
            ? _value.expectedCash
            : expectedCash // ignore: cast_nullable_to_non_nullable
                  as String,
        actualCash: freezed == actualCash
            ? _value.actualCash
            : actualCash // ignore: cast_nullable_to_non_nullable
                  as String?,
        cashDifference: freezed == cashDifference
            ? _value.cashDifference
            : cashDifference // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftSummaryModelImpl extends _ShiftSummaryModel {
  const _$ShiftSummaryModelImpl({
    @JsonKey(name: 'shift_id') this.shiftId,
    this.status,
    @JsonKey(name: 'opening_float') this.openingFloat = '0',
    @JsonKey(name: 'total_cash_sales') this.totalCashSales = '0',
    @JsonKey(name: 'total_card_sales') this.totalCardSales = '0',
    @JsonKey(name: 'total_wallet_sales') this.totalWalletSales = '0',
    @JsonKey(name: 'total_other_sales') this.totalOtherSales = '0',
    @JsonKey(name: 'total_returns') this.totalReturns = '0',
    @JsonKey(name: 'total_cash_in') this.totalCashIn = '0',
    @JsonKey(name: 'total_cash_out') this.totalCashOut = '0',
    @JsonKey(name: 'total_expenses') this.totalExpenses = '0',
    @JsonKey(name: 'expected_cash') this.expectedCash = '0',
    @JsonKey(name: 'actual_cash') this.actualCash,
    @JsonKey(name: 'cash_difference') this.cashDifference,
  }) : super._();

  factory _$ShiftSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftSummaryModelImplFromJson(json);

  @override
  @JsonKey(name: 'shift_id')
  final String? shiftId;
  @override
  final String? status;
  @override
  @JsonKey(name: 'opening_float')
  final String openingFloat;
  @override
  @JsonKey(name: 'total_cash_sales')
  final String totalCashSales;
  @override
  @JsonKey(name: 'total_card_sales')
  final String totalCardSales;
  @override
  @JsonKey(name: 'total_wallet_sales')
  final String totalWalletSales;
  @override
  @JsonKey(name: 'total_other_sales')
  final String totalOtherSales;
  @override
  @JsonKey(name: 'total_returns')
  final String totalReturns;
  @override
  @JsonKey(name: 'total_cash_in')
  final String totalCashIn;
  @override
  @JsonKey(name: 'total_cash_out')
  final String totalCashOut;
  @override
  @JsonKey(name: 'total_expenses')
  final String totalExpenses;
  @override
  @JsonKey(name: 'expected_cash')
  final String expectedCash;
  @override
  @JsonKey(name: 'actual_cash')
  final String? actualCash;
  @override
  @JsonKey(name: 'cash_difference')
  final String? cashDifference;

  @override
  String toString() {
    return 'ShiftSummaryModel(shiftId: $shiftId, status: $status, openingFloat: $openingFloat, totalCashSales: $totalCashSales, totalCardSales: $totalCardSales, totalWalletSales: $totalWalletSales, totalOtherSales: $totalOtherSales, totalReturns: $totalReturns, totalCashIn: $totalCashIn, totalCashOut: $totalCashOut, totalExpenses: $totalExpenses, expectedCash: $expectedCash, actualCash: $actualCash, cashDifference: $cashDifference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftSummaryModelImpl &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.openingFloat, openingFloat) ||
                other.openingFloat == openingFloat) &&
            (identical(other.totalCashSales, totalCashSales) ||
                other.totalCashSales == totalCashSales) &&
            (identical(other.totalCardSales, totalCardSales) ||
                other.totalCardSales == totalCardSales) &&
            (identical(other.totalWalletSales, totalWalletSales) ||
                other.totalWalletSales == totalWalletSales) &&
            (identical(other.totalOtherSales, totalOtherSales) ||
                other.totalOtherSales == totalOtherSales) &&
            (identical(other.totalReturns, totalReturns) ||
                other.totalReturns == totalReturns) &&
            (identical(other.totalCashIn, totalCashIn) ||
                other.totalCashIn == totalCashIn) &&
            (identical(other.totalCashOut, totalCashOut) ||
                other.totalCashOut == totalCashOut) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.expectedCash, expectedCash) ||
                other.expectedCash == expectedCash) &&
            (identical(other.actualCash, actualCash) ||
                other.actualCash == actualCash) &&
            (identical(other.cashDifference, cashDifference) ||
                other.cashDifference == cashDifference));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    shiftId,
    status,
    openingFloat,
    totalCashSales,
    totalCardSales,
    totalWalletSales,
    totalOtherSales,
    totalReturns,
    totalCashIn,
    totalCashOut,
    totalExpenses,
    expectedCash,
    actualCash,
    cashDifference,
  );

  /// Create a copy of ShiftSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftSummaryModelImplCopyWith<_$ShiftSummaryModelImpl> get copyWith =>
      __$$ShiftSummaryModelImplCopyWithImpl<_$ShiftSummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftSummaryModelImplToJson(this);
  }
}

abstract class _ShiftSummaryModel extends ShiftSummaryModel {
  const factory _ShiftSummaryModel({
    @JsonKey(name: 'shift_id') final String? shiftId,
    final String? status,
    @JsonKey(name: 'opening_float') final String openingFloat,
    @JsonKey(name: 'total_cash_sales') final String totalCashSales,
    @JsonKey(name: 'total_card_sales') final String totalCardSales,
    @JsonKey(name: 'total_wallet_sales') final String totalWalletSales,
    @JsonKey(name: 'total_other_sales') final String totalOtherSales,
    @JsonKey(name: 'total_returns') final String totalReturns,
    @JsonKey(name: 'total_cash_in') final String totalCashIn,
    @JsonKey(name: 'total_cash_out') final String totalCashOut,
    @JsonKey(name: 'total_expenses') final String totalExpenses,
    @JsonKey(name: 'expected_cash') final String expectedCash,
    @JsonKey(name: 'actual_cash') final String? actualCash,
    @JsonKey(name: 'cash_difference') final String? cashDifference,
  }) = _$ShiftSummaryModelImpl;
  const _ShiftSummaryModel._() : super._();

  factory _ShiftSummaryModel.fromJson(Map<String, dynamic> json) =
      _$ShiftSummaryModelImpl.fromJson;

  @override
  @JsonKey(name: 'shift_id')
  String? get shiftId;
  @override
  String? get status;
  @override
  @JsonKey(name: 'opening_float')
  String get openingFloat;
  @override
  @JsonKey(name: 'total_cash_sales')
  String get totalCashSales;
  @override
  @JsonKey(name: 'total_card_sales')
  String get totalCardSales;
  @override
  @JsonKey(name: 'total_wallet_sales')
  String get totalWalletSales;
  @override
  @JsonKey(name: 'total_other_sales')
  String get totalOtherSales;
  @override
  @JsonKey(name: 'total_returns')
  String get totalReturns;
  @override
  @JsonKey(name: 'total_cash_in')
  String get totalCashIn;
  @override
  @JsonKey(name: 'total_cash_out')
  String get totalCashOut;
  @override
  @JsonKey(name: 'total_expenses')
  String get totalExpenses;
  @override
  @JsonKey(name: 'expected_cash')
  String get expectedCash;
  @override
  @JsonKey(name: 'actual_cash')
  String? get actualCash;
  @override
  @JsonKey(name: 'cash_difference')
  String? get cashDifference;

  /// Create a copy of ShiftSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftSummaryModelImplCopyWith<_$ShiftSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
