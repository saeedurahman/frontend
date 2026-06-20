// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goods_receipt_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GoodsReceiptLineItem {
  PurchaseLineModel get line => throw _privateConstructorUsedError;
  String get qtyReceived => throw _privateConstructorUsedError;
  String get costPerUnit => throw _privateConstructorUsedError;
  String get batchNumber => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;

  /// Create a copy of GoodsReceiptLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoodsReceiptLineItemCopyWith<GoodsReceiptLineItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsReceiptLineItemCopyWith<$Res> {
  factory $GoodsReceiptLineItemCopyWith(
    GoodsReceiptLineItem value,
    $Res Function(GoodsReceiptLineItem) then,
  ) = _$GoodsReceiptLineItemCopyWithImpl<$Res, GoodsReceiptLineItem>;
  @useResult
  $Res call({
    PurchaseLineModel line,
    String qtyReceived,
    String costPerUnit,
    String batchNumber,
    DateTime? expiryDate,
  });

  $PurchaseLineModelCopyWith<$Res> get line;
}

/// @nodoc
class _$GoodsReceiptLineItemCopyWithImpl<
  $Res,
  $Val extends GoodsReceiptLineItem
>
    implements $GoodsReceiptLineItemCopyWith<$Res> {
  _$GoodsReceiptLineItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoodsReceiptLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? line = null,
    Object? qtyReceived = null,
    Object? costPerUnit = null,
    Object? batchNumber = null,
    Object? expiryDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            line: null == line
                ? _value.line
                : line // ignore: cast_nullable_to_non_nullable
                      as PurchaseLineModel,
            qtyReceived: null == qtyReceived
                ? _value.qtyReceived
                : qtyReceived // ignore: cast_nullable_to_non_nullable
                      as String,
            costPerUnit: null == costPerUnit
                ? _value.costPerUnit
                : costPerUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            batchNumber: null == batchNumber
                ? _value.batchNumber
                : batchNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of GoodsReceiptLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseLineModelCopyWith<$Res> get line {
    return $PurchaseLineModelCopyWith<$Res>(_value.line, (value) {
      return _then(_value.copyWith(line: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GoodsReceiptLineItemImplCopyWith<$Res>
    implements $GoodsReceiptLineItemCopyWith<$Res> {
  factory _$$GoodsReceiptLineItemImplCopyWith(
    _$GoodsReceiptLineItemImpl value,
    $Res Function(_$GoodsReceiptLineItemImpl) then,
  ) = __$$GoodsReceiptLineItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PurchaseLineModel line,
    String qtyReceived,
    String costPerUnit,
    String batchNumber,
    DateTime? expiryDate,
  });

  @override
  $PurchaseLineModelCopyWith<$Res> get line;
}

/// @nodoc
class __$$GoodsReceiptLineItemImplCopyWithImpl<$Res>
    extends _$GoodsReceiptLineItemCopyWithImpl<$Res, _$GoodsReceiptLineItemImpl>
    implements _$$GoodsReceiptLineItemImplCopyWith<$Res> {
  __$$GoodsReceiptLineItemImplCopyWithImpl(
    _$GoodsReceiptLineItemImpl _value,
    $Res Function(_$GoodsReceiptLineItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GoodsReceiptLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? line = null,
    Object? qtyReceived = null,
    Object? costPerUnit = null,
    Object? batchNumber = null,
    Object? expiryDate = freezed,
  }) {
    return _then(
      _$GoodsReceiptLineItemImpl(
        line: null == line
            ? _value.line
            : line // ignore: cast_nullable_to_non_nullable
                  as PurchaseLineModel,
        qtyReceived: null == qtyReceived
            ? _value.qtyReceived
            : qtyReceived // ignore: cast_nullable_to_non_nullable
                  as String,
        costPerUnit: null == costPerUnit
            ? _value.costPerUnit
            : costPerUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        batchNumber: null == batchNumber
            ? _value.batchNumber
            : batchNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$GoodsReceiptLineItemImpl extends _GoodsReceiptLineItem {
  const _$GoodsReceiptLineItemImpl({
    required this.line,
    this.qtyReceived = '',
    this.costPerUnit = '',
    this.batchNumber = '',
    this.expiryDate,
  }) : super._();

  @override
  final PurchaseLineModel line;
  @override
  @JsonKey()
  final String qtyReceived;
  @override
  @JsonKey()
  final String costPerUnit;
  @override
  @JsonKey()
  final String batchNumber;
  @override
  final DateTime? expiryDate;

  @override
  String toString() {
    return 'GoodsReceiptLineItem(line: $line, qtyReceived: $qtyReceived, costPerUnit: $costPerUnit, batchNumber: $batchNumber, expiryDate: $expiryDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoodsReceiptLineItemImpl &&
            (identical(other.line, line) || other.line == line) &&
            (identical(other.qtyReceived, qtyReceived) ||
                other.qtyReceived == qtyReceived) &&
            (identical(other.costPerUnit, costPerUnit) ||
                other.costPerUnit == costPerUnit) &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    line,
    qtyReceived,
    costPerUnit,
    batchNumber,
    expiryDate,
  );

  /// Create a copy of GoodsReceiptLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoodsReceiptLineItemImplCopyWith<_$GoodsReceiptLineItemImpl>
  get copyWith =>
      __$$GoodsReceiptLineItemImplCopyWithImpl<_$GoodsReceiptLineItemImpl>(
        this,
        _$identity,
      );
}

abstract class _GoodsReceiptLineItem extends GoodsReceiptLineItem {
  const factory _GoodsReceiptLineItem({
    required final PurchaseLineModel line,
    final String qtyReceived,
    final String costPerUnit,
    final String batchNumber,
    final DateTime? expiryDate,
  }) = _$GoodsReceiptLineItemImpl;
  const _GoodsReceiptLineItem._() : super._();

  @override
  PurchaseLineModel get line;
  @override
  String get qtyReceived;
  @override
  String get costPerUnit;
  @override
  String get batchNumber;
  @override
  DateTime? get expiryDate;

  /// Create a copy of GoodsReceiptLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoodsReceiptLineItemImplCopyWith<_$GoodsReceiptLineItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GoodsReceiptState {
  String? get branchId => throw _privateConstructorUsedError;
  PurchaseOrderModel? get order => throw _privateConstructorUsedError;
  List<GoodsReceiptLineItem> get lines => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;
  String get supplierInvoiceNo => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  Map<String, String> get errors => throw _privateConstructorUsedError;

  /// Create a copy of GoodsReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoodsReceiptStateCopyWith<GoodsReceiptState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsReceiptStateCopyWith<$Res> {
  factory $GoodsReceiptStateCopyWith(
    GoodsReceiptState value,
    $Res Function(GoodsReceiptState) then,
  ) = _$GoodsReceiptStateCopyWithImpl<$Res, GoodsReceiptState>;
  @useResult
  $Res call({
    String? branchId,
    PurchaseOrderModel? order,
    List<GoodsReceiptLineItem> lines,
    DateTime? receivedAt,
    String supplierInvoiceNo,
    String notes,
    bool isLoading,
    bool isSubmitting,
    Map<String, String> errors,
  });

  $PurchaseOrderModelCopyWith<$Res>? get order;
}

/// @nodoc
class _$GoodsReceiptStateCopyWithImpl<$Res, $Val extends GoodsReceiptState>
    implements $GoodsReceiptStateCopyWith<$Res> {
  _$GoodsReceiptStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoodsReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = freezed,
    Object? order = freezed,
    Object? lines = null,
    Object? receivedAt = freezed,
    Object? supplierInvoiceNo = null,
    Object? notes = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errors = null,
  }) {
    return _then(
      _value.copyWith(
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as PurchaseOrderModel?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<GoodsReceiptLineItem>,
            receivedAt: freezed == receivedAt
                ? _value.receivedAt
                : receivedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            supplierInvoiceNo: null == supplierInvoiceNo
                ? _value.supplierInvoiceNo
                : supplierInvoiceNo // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }

  /// Create a copy of GoodsReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseOrderModelCopyWith<$Res>? get order {
    if (_value.order == null) {
      return null;
    }

    return $PurchaseOrderModelCopyWith<$Res>(_value.order!, (value) {
      return _then(_value.copyWith(order: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GoodsReceiptStateImplCopyWith<$Res>
    implements $GoodsReceiptStateCopyWith<$Res> {
  factory _$$GoodsReceiptStateImplCopyWith(
    _$GoodsReceiptStateImpl value,
    $Res Function(_$GoodsReceiptStateImpl) then,
  ) = __$$GoodsReceiptStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? branchId,
    PurchaseOrderModel? order,
    List<GoodsReceiptLineItem> lines,
    DateTime? receivedAt,
    String supplierInvoiceNo,
    String notes,
    bool isLoading,
    bool isSubmitting,
    Map<String, String> errors,
  });

  @override
  $PurchaseOrderModelCopyWith<$Res>? get order;
}

/// @nodoc
class __$$GoodsReceiptStateImplCopyWithImpl<$Res>
    extends _$GoodsReceiptStateCopyWithImpl<$Res, _$GoodsReceiptStateImpl>
    implements _$$GoodsReceiptStateImplCopyWith<$Res> {
  __$$GoodsReceiptStateImplCopyWithImpl(
    _$GoodsReceiptStateImpl _value,
    $Res Function(_$GoodsReceiptStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GoodsReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = freezed,
    Object? order = freezed,
    Object? lines = null,
    Object? receivedAt = freezed,
    Object? supplierInvoiceNo = null,
    Object? notes = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? errors = null,
  }) {
    return _then(
      _$GoodsReceiptStateImpl(
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        order: freezed == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as PurchaseOrderModel?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<GoodsReceiptLineItem>,
        receivedAt: freezed == receivedAt
            ? _value.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        supplierInvoiceNo: null == supplierInvoiceNo
            ? _value.supplierInvoiceNo
            : supplierInvoiceNo // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc

class _$GoodsReceiptStateImpl implements _GoodsReceiptState {
  const _$GoodsReceiptStateImpl({
    this.branchId,
    this.order,
    final List<GoodsReceiptLineItem> lines = const [],
    this.receivedAt,
    this.supplierInvoiceNo = '',
    this.notes = '',
    this.isLoading = false,
    this.isSubmitting = false,
    final Map<String, String> errors = const {},
  }) : _lines = lines,
       _errors = errors;

  @override
  final String? branchId;
  @override
  final PurchaseOrderModel? order;
  final List<GoodsReceiptLineItem> _lines;
  @override
  @JsonKey()
  List<GoodsReceiptLineItem> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  final DateTime? receivedAt;
  @override
  @JsonKey()
  final String supplierInvoiceNo;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSubmitting;
  final Map<String, String> _errors;
  @override
  @JsonKey()
  Map<String, String> get errors {
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_errors);
  }

  @override
  String toString() {
    return 'GoodsReceiptState(branchId: $branchId, order: $order, lines: $lines, receivedAt: $receivedAt, supplierInvoiceNo: $supplierInvoiceNo, notes: $notes, isLoading: $isLoading, isSubmitting: $isSubmitting, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoodsReceiptStateImpl &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.supplierInvoiceNo, supplierInvoiceNo) ||
                other.supplierInvoiceNo == supplierInvoiceNo) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    branchId,
    order,
    const DeepCollectionEquality().hash(_lines),
    receivedAt,
    supplierInvoiceNo,
    notes,
    isLoading,
    isSubmitting,
    const DeepCollectionEquality().hash(_errors),
  );

  /// Create a copy of GoodsReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoodsReceiptStateImplCopyWith<_$GoodsReceiptStateImpl> get copyWith =>
      __$$GoodsReceiptStateImplCopyWithImpl<_$GoodsReceiptStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GoodsReceiptState implements GoodsReceiptState {
  const factory _GoodsReceiptState({
    final String? branchId,
    final PurchaseOrderModel? order,
    final List<GoodsReceiptLineItem> lines,
    final DateTime? receivedAt,
    final String supplierInvoiceNo,
    final String notes,
    final bool isLoading,
    final bool isSubmitting,
    final Map<String, String> errors,
  }) = _$GoodsReceiptStateImpl;

  @override
  String? get branchId;
  @override
  PurchaseOrderModel? get order;
  @override
  List<GoodsReceiptLineItem> get lines;
  @override
  DateTime? get receivedAt;
  @override
  String get supplierInvoiceNo;
  @override
  String get notes;
  @override
  bool get isLoading;
  @override
  bool get isSubmitting;
  @override
  Map<String, String> get errors;

  /// Create a copy of GoodsReceiptState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoodsReceiptStateImplCopyWith<_$GoodsReceiptStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
