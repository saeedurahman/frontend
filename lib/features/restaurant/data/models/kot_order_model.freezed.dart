// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kot_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KotOrderLineModel _$KotOrderLineModelFromJson(Map<String, dynamic> json) {
  return _KotOrderLineModel.fromJson(json);
}

/// @nodoc
mixin _$KotOrderLineModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'kot_order_id')
  String get kotOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_line_id')
  String? get saleLineId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'variation_id')
  String? get variationId => throw _privateConstructorUsedError;
  String get qty => throw _privateConstructorUsedError;
  @JsonKey(name: 'modifiers_json')
  List<dynamic> get modifiersJson => throw _privateConstructorUsedError;
  @JsonKey(name: 'kitchen_notes')
  String? get kitchenNotes => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this KotOrderLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KotOrderLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KotOrderLineModelCopyWith<KotOrderLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KotOrderLineModelCopyWith<$Res> {
  factory $KotOrderLineModelCopyWith(
    KotOrderLineModel value,
    $Res Function(KotOrderLineModel) then,
  ) = _$KotOrderLineModelCopyWithImpl<$Res, KotOrderLineModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'kot_order_id') String kotOrderId,
    @JsonKey(name: 'sale_line_id') String? saleLineId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'product_name') String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    String qty,
    @JsonKey(name: 'modifiers_json') List<dynamic> modifiersJson,
    @JsonKey(name: 'kitchen_notes') String? kitchenNotes,
    String status,
  });
}

/// @nodoc
class _$KotOrderLineModelCopyWithImpl<$Res, $Val extends KotOrderLineModel>
    implements $KotOrderLineModelCopyWith<$Res> {
  _$KotOrderLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KotOrderLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? kotOrderId = null,
    Object? saleLineId = freezed,
    Object? productId = null,
    Object? productName = null,
    Object? variationId = freezed,
    Object? qty = null,
    Object? modifiersJson = null,
    Object? kitchenNotes = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            kotOrderId: null == kotOrderId
                ? _value.kotOrderId
                : kotOrderId // ignore: cast_nullable_to_non_nullable
                      as String,
            saleLineId: freezed == saleLineId
                ? _value.saleLineId
                : saleLineId // ignore: cast_nullable_to_non_nullable
                      as String?,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            variationId: freezed == variationId
                ? _value.variationId
                : variationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as String,
            modifiersJson: null == modifiersJson
                ? _value.modifiersJson
                : modifiersJson // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>,
            kitchenNotes: freezed == kitchenNotes
                ? _value.kitchenNotes
                : kitchenNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KotOrderLineModelImplCopyWith<$Res>
    implements $KotOrderLineModelCopyWith<$Res> {
  factory _$$KotOrderLineModelImplCopyWith(
    _$KotOrderLineModelImpl value,
    $Res Function(_$KotOrderLineModelImpl) then,
  ) = __$$KotOrderLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'kot_order_id') String kotOrderId,
    @JsonKey(name: 'sale_line_id') String? saleLineId,
    @JsonKey(name: 'product_id') String productId,
    @JsonKey(name: 'product_name') String productName,
    @JsonKey(name: 'variation_id') String? variationId,
    String qty,
    @JsonKey(name: 'modifiers_json') List<dynamic> modifiersJson,
    @JsonKey(name: 'kitchen_notes') String? kitchenNotes,
    String status,
  });
}

/// @nodoc
class __$$KotOrderLineModelImplCopyWithImpl<$Res>
    extends _$KotOrderLineModelCopyWithImpl<$Res, _$KotOrderLineModelImpl>
    implements _$$KotOrderLineModelImplCopyWith<$Res> {
  __$$KotOrderLineModelImplCopyWithImpl(
    _$KotOrderLineModelImpl _value,
    $Res Function(_$KotOrderLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KotOrderLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? kotOrderId = null,
    Object? saleLineId = freezed,
    Object? productId = null,
    Object? productName = null,
    Object? variationId = freezed,
    Object? qty = null,
    Object? modifiersJson = null,
    Object? kitchenNotes = freezed,
    Object? status = null,
  }) {
    return _then(
      _$KotOrderLineModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        kotOrderId: null == kotOrderId
            ? _value.kotOrderId
            : kotOrderId // ignore: cast_nullable_to_non_nullable
                  as String,
        saleLineId: freezed == saleLineId
            ? _value.saleLineId
            : saleLineId // ignore: cast_nullable_to_non_nullable
                  as String?,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        variationId: freezed == variationId
            ? _value.variationId
            : variationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as String,
        modifiersJson: null == modifiersJson
            ? _value._modifiersJson
            : modifiersJson // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>,
        kitchenNotes: freezed == kitchenNotes
            ? _value.kitchenNotes
            : kitchenNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KotOrderLineModelImpl implements _KotOrderLineModel {
  const _$KotOrderLineModelImpl({
    required this.id,
    @JsonKey(name: 'kot_order_id') required this.kotOrderId,
    @JsonKey(name: 'sale_line_id') this.saleLineId,
    @JsonKey(name: 'product_id') required this.productId,
    @JsonKey(name: 'product_name') required this.productName,
    @JsonKey(name: 'variation_id') this.variationId,
    required this.qty,
    @JsonKey(name: 'modifiers_json')
    final List<dynamic> modifiersJson = const [],
    @JsonKey(name: 'kitchen_notes') this.kitchenNotes,
    required this.status,
  }) : _modifiersJson = modifiersJson;

  factory _$KotOrderLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KotOrderLineModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'kot_order_id')
  final String kotOrderId;
  @override
  @JsonKey(name: 'sale_line_id')
  final String? saleLineId;
  @override
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'variation_id')
  final String? variationId;
  @override
  final String qty;
  final List<dynamic> _modifiersJson;
  @override
  @JsonKey(name: 'modifiers_json')
  List<dynamic> get modifiersJson {
    if (_modifiersJson is EqualUnmodifiableListView) return _modifiersJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_modifiersJson);
  }

  @override
  @JsonKey(name: 'kitchen_notes')
  final String? kitchenNotes;
  @override
  final String status;

  @override
  String toString() {
    return 'KotOrderLineModel(id: $id, kotOrderId: $kotOrderId, saleLineId: $saleLineId, productId: $productId, productName: $productName, variationId: $variationId, qty: $qty, modifiersJson: $modifiersJson, kitchenNotes: $kitchenNotes, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KotOrderLineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.kotOrderId, kotOrderId) ||
                other.kotOrderId == kotOrderId) &&
            (identical(other.saleLineId, saleLineId) ||
                other.saleLineId == saleLineId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.variationId, variationId) ||
                other.variationId == variationId) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            const DeepCollectionEquality().equals(
              other._modifiersJson,
              _modifiersJson,
            ) &&
            (identical(other.kitchenNotes, kitchenNotes) ||
                other.kitchenNotes == kitchenNotes) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    kotOrderId,
    saleLineId,
    productId,
    productName,
    variationId,
    qty,
    const DeepCollectionEquality().hash(_modifiersJson),
    kitchenNotes,
    status,
  );

  /// Create a copy of KotOrderLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KotOrderLineModelImplCopyWith<_$KotOrderLineModelImpl> get copyWith =>
      __$$KotOrderLineModelImplCopyWithImpl<_$KotOrderLineModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KotOrderLineModelImplToJson(this);
  }
}

abstract class _KotOrderLineModel implements KotOrderLineModel {
  const factory _KotOrderLineModel({
    required final String id,
    @JsonKey(name: 'kot_order_id') required final String kotOrderId,
    @JsonKey(name: 'sale_line_id') final String? saleLineId,
    @JsonKey(name: 'product_id') required final String productId,
    @JsonKey(name: 'product_name') required final String productName,
    @JsonKey(name: 'variation_id') final String? variationId,
    required final String qty,
    @JsonKey(name: 'modifiers_json') final List<dynamic> modifiersJson,
    @JsonKey(name: 'kitchen_notes') final String? kitchenNotes,
    required final String status,
  }) = _$KotOrderLineModelImpl;

  factory _KotOrderLineModel.fromJson(Map<String, dynamic> json) =
      _$KotOrderLineModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'kot_order_id')
  String get kotOrderId;
  @override
  @JsonKey(name: 'sale_line_id')
  String? get saleLineId;
  @override
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'variation_id')
  String? get variationId;
  @override
  String get qty;
  @override
  @JsonKey(name: 'modifiers_json')
  List<dynamic> get modifiersJson;
  @override
  @JsonKey(name: 'kitchen_notes')
  String? get kitchenNotes;
  @override
  String get status;

  /// Create a copy of KotOrderLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KotOrderLineModelImplCopyWith<_$KotOrderLineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KotOrderModel _$KotOrderModelFromJson(Map<String, dynamic> json) {
  return _KotOrderModel.fromJson(json);
}

/// @nodoc
mixin _$KotOrderModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_id')
  String? get saleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'table_id')
  String? get tableId => throw _privateConstructorUsedError;
  @JsonKey(name: 'table_number')
  String? get tableNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'kot_number')
  String get kotNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'fired_at')
  String get firedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ready_at')
  String? get readyAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'served_at')
  String? get servedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<KotOrderLineModel> get lines => throw _privateConstructorUsedError;

  /// Serializes this KotOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KotOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KotOrderModelCopyWith<KotOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KotOrderModelCopyWith<$Res> {
  factory $KotOrderModelCopyWith(
    KotOrderModel value,
    $Res Function(KotOrderModel) then,
  ) = _$KotOrderModelCopyWithImpl<$Res, KotOrderModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'table_id') String? tableId,
    @JsonKey(name: 'table_number') String? tableNumber,
    @JsonKey(name: 'kot_number') String kotNumber,
    String status,
    @JsonKey(name: 'fired_at') String firedAt,
    @JsonKey(name: 'ready_at') String? readyAt,
    @JsonKey(name: 'served_at') String? servedAt,
    String? notes,
    List<KotOrderLineModel> lines,
  });
}

/// @nodoc
class _$KotOrderModelCopyWithImpl<$Res, $Val extends KotOrderModel>
    implements $KotOrderModelCopyWith<$Res> {
  _$KotOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KotOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? saleId = freezed,
    Object? tableId = freezed,
    Object? tableNumber = freezed,
    Object? kotNumber = null,
    Object? status = null,
    Object? firedAt = null,
    Object? readyAt = freezed,
    Object? servedAt = freezed,
    Object? notes = freezed,
    Object? lines = null,
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
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String,
            saleId: freezed == saleId
                ? _value.saleId
                : saleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            tableId: freezed == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                      as String?,
            tableNumber: freezed == tableNumber
                ? _value.tableNumber
                : tableNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            kotNumber: null == kotNumber
                ? _value.kotNumber
                : kotNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            firedAt: null == firedAt
                ? _value.firedAt
                : firedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            readyAt: freezed == readyAt
                ? _value.readyAt
                : readyAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            servedAt: freezed == servedAt
                ? _value.servedAt
                : servedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<KotOrderLineModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KotOrderModelImplCopyWith<$Res>
    implements $KotOrderModelCopyWith<$Res> {
  factory _$$KotOrderModelImplCopyWith(
    _$KotOrderModelImpl value,
    $Res Function(_$KotOrderModelImpl) then,
  ) = __$$KotOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String branchId,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'table_id') String? tableId,
    @JsonKey(name: 'table_number') String? tableNumber,
    @JsonKey(name: 'kot_number') String kotNumber,
    String status,
    @JsonKey(name: 'fired_at') String firedAt,
    @JsonKey(name: 'ready_at') String? readyAt,
    @JsonKey(name: 'served_at') String? servedAt,
    String? notes,
    List<KotOrderLineModel> lines,
  });
}

/// @nodoc
class __$$KotOrderModelImplCopyWithImpl<$Res>
    extends _$KotOrderModelCopyWithImpl<$Res, _$KotOrderModelImpl>
    implements _$$KotOrderModelImplCopyWith<$Res> {
  __$$KotOrderModelImplCopyWithImpl(
    _$KotOrderModelImpl _value,
    $Res Function(_$KotOrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KotOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = null,
    Object? saleId = freezed,
    Object? tableId = freezed,
    Object? tableNumber = freezed,
    Object? kotNumber = null,
    Object? status = null,
    Object? firedAt = null,
    Object? readyAt = freezed,
    Object? servedAt = freezed,
    Object? notes = freezed,
    Object? lines = null,
  }) {
    return _then(
      _$KotOrderModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String,
        saleId: freezed == saleId
            ? _value.saleId
            : saleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        tableId: freezed == tableId
            ? _value.tableId
            : tableId // ignore: cast_nullable_to_non_nullable
                  as String?,
        tableNumber: freezed == tableNumber
            ? _value.tableNumber
            : tableNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        kotNumber: null == kotNumber
            ? _value.kotNumber
            : kotNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        firedAt: null == firedAt
            ? _value.firedAt
            : firedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        readyAt: freezed == readyAt
            ? _value.readyAt
            : readyAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        servedAt: freezed == servedAt
            ? _value.servedAt
            : servedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<KotOrderLineModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KotOrderModelImpl implements _KotOrderModel {
  const _$KotOrderModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') required this.branchId,
    @JsonKey(name: 'sale_id') this.saleId,
    @JsonKey(name: 'table_id') this.tableId,
    @JsonKey(name: 'table_number') this.tableNumber,
    @JsonKey(name: 'kot_number') required this.kotNumber,
    required this.status,
    @JsonKey(name: 'fired_at') required this.firedAt,
    @JsonKey(name: 'ready_at') this.readyAt,
    @JsonKey(name: 'served_at') this.servedAt,
    this.notes,
    final List<KotOrderLineModel> lines = const [],
  }) : _lines = lines;

  factory _$KotOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KotOrderModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String branchId;
  @override
  @JsonKey(name: 'sale_id')
  final String? saleId;
  @override
  @JsonKey(name: 'table_id')
  final String? tableId;
  @override
  @JsonKey(name: 'table_number')
  final String? tableNumber;
  @override
  @JsonKey(name: 'kot_number')
  final String kotNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'fired_at')
  final String firedAt;
  @override
  @JsonKey(name: 'ready_at')
  final String? readyAt;
  @override
  @JsonKey(name: 'served_at')
  final String? servedAt;
  @override
  final String? notes;
  final List<KotOrderLineModel> _lines;
  @override
  @JsonKey()
  List<KotOrderLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'KotOrderModel(id: $id, businessId: $businessId, branchId: $branchId, saleId: $saleId, tableId: $tableId, tableNumber: $tableNumber, kotNumber: $kotNumber, status: $status, firedAt: $firedAt, readyAt: $readyAt, servedAt: $servedAt, notes: $notes, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KotOrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.tableNumber, tableNumber) ||
                other.tableNumber == tableNumber) &&
            (identical(other.kotNumber, kotNumber) ||
                other.kotNumber == kotNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.firedAt, firedAt) || other.firedAt == firedAt) &&
            (identical(other.readyAt, readyAt) || other.readyAt == readyAt) &&
            (identical(other.servedAt, servedAt) ||
                other.servedAt == servedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    branchId,
    saleId,
    tableId,
    tableNumber,
    kotNumber,
    status,
    firedAt,
    readyAt,
    servedAt,
    notes,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of KotOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KotOrderModelImplCopyWith<_$KotOrderModelImpl> get copyWith =>
      __$$KotOrderModelImplCopyWithImpl<_$KotOrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KotOrderModelImplToJson(this);
  }
}

abstract class _KotOrderModel implements KotOrderModel {
  const factory _KotOrderModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') required final String branchId,
    @JsonKey(name: 'sale_id') final String? saleId,
    @JsonKey(name: 'table_id') final String? tableId,
    @JsonKey(name: 'table_number') final String? tableNumber,
    @JsonKey(name: 'kot_number') required final String kotNumber,
    required final String status,
    @JsonKey(name: 'fired_at') required final String firedAt,
    @JsonKey(name: 'ready_at') final String? readyAt,
    @JsonKey(name: 'served_at') final String? servedAt,
    final String? notes,
    final List<KotOrderLineModel> lines,
  }) = _$KotOrderModelImpl;

  factory _KotOrderModel.fromJson(Map<String, dynamic> json) =
      _$KotOrderModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String get branchId;
  @override
  @JsonKey(name: 'sale_id')
  String? get saleId;
  @override
  @JsonKey(name: 'table_id')
  String? get tableId;
  @override
  @JsonKey(name: 'table_number')
  String? get tableNumber;
  @override
  @JsonKey(name: 'kot_number')
  String get kotNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'fired_at')
  String get firedAt;
  @override
  @JsonKey(name: 'ready_at')
  String? get readyAt;
  @override
  @JsonKey(name: 'served_at')
  String? get servedAt;
  @override
  String? get notes;
  @override
  List<KotOrderLineModel> get lines;

  /// Create a copy of KotOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KotOrderModelImplCopyWith<_$KotOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FireTabResponseModel _$FireTabResponseModelFromJson(Map<String, dynamic> json) {
  return _FireTabResponseModel.fromJson(json);
}

/// @nodoc
mixin _$FireTabResponseModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'kot_number')
  String get kotNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_id')
  String? get saleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'table_id')
  String? get tableId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this FireTabResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FireTabResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FireTabResponseModelCopyWith<FireTabResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FireTabResponseModelCopyWith<$Res> {
  factory $FireTabResponseModelCopyWith(
    FireTabResponseModel value,
    $Res Function(FireTabResponseModel) then,
  ) = _$FireTabResponseModelCopyWithImpl<$Res, FireTabResponseModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'kot_number') String kotNumber,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'table_id') String? tableId,
    String status,
  });
}

/// @nodoc
class _$FireTabResponseModelCopyWithImpl<
  $Res,
  $Val extends FireTabResponseModel
>
    implements $FireTabResponseModelCopyWith<$Res> {
  _$FireTabResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FireTabResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? kotNumber = null,
    Object? saleId = freezed,
    Object? tableId = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            kotNumber: null == kotNumber
                ? _value.kotNumber
                : kotNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            saleId: freezed == saleId
                ? _value.saleId
                : saleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            tableId: freezed == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FireTabResponseModelImplCopyWith<$Res>
    implements $FireTabResponseModelCopyWith<$Res> {
  factory _$$FireTabResponseModelImplCopyWith(
    _$FireTabResponseModelImpl value,
    $Res Function(_$FireTabResponseModelImpl) then,
  ) = __$$FireTabResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'kot_number') String kotNumber,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'table_id') String? tableId,
    String status,
  });
}

/// @nodoc
class __$$FireTabResponseModelImplCopyWithImpl<$Res>
    extends _$FireTabResponseModelCopyWithImpl<$Res, _$FireTabResponseModelImpl>
    implements _$$FireTabResponseModelImplCopyWith<$Res> {
  __$$FireTabResponseModelImplCopyWithImpl(
    _$FireTabResponseModelImpl _value,
    $Res Function(_$FireTabResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FireTabResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? kotNumber = null,
    Object? saleId = freezed,
    Object? tableId = freezed,
    Object? status = null,
  }) {
    return _then(
      _$FireTabResponseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        kotNumber: null == kotNumber
            ? _value.kotNumber
            : kotNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        saleId: freezed == saleId
            ? _value.saleId
            : saleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        tableId: freezed == tableId
            ? _value.tableId
            : tableId // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FireTabResponseModelImpl implements _FireTabResponseModel {
  const _$FireTabResponseModelImpl({
    required this.id,
    @JsonKey(name: 'kot_number') required this.kotNumber,
    @JsonKey(name: 'sale_id') this.saleId,
    @JsonKey(name: 'table_id') this.tableId,
    required this.status,
  });

  factory _$FireTabResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FireTabResponseModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'kot_number')
  final String kotNumber;
  @override
  @JsonKey(name: 'sale_id')
  final String? saleId;
  @override
  @JsonKey(name: 'table_id')
  final String? tableId;
  @override
  final String status;

  @override
  String toString() {
    return 'FireTabResponseModel(id: $id, kotNumber: $kotNumber, saleId: $saleId, tableId: $tableId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FireTabResponseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.kotNumber, kotNumber) ||
                other.kotNumber == kotNumber) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, kotNumber, saleId, tableId, status);

  /// Create a copy of FireTabResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FireTabResponseModelImplCopyWith<_$FireTabResponseModelImpl>
  get copyWith =>
      __$$FireTabResponseModelImplCopyWithImpl<_$FireTabResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FireTabResponseModelImplToJson(this);
  }
}

abstract class _FireTabResponseModel implements FireTabResponseModel {
  const factory _FireTabResponseModel({
    required final String id,
    @JsonKey(name: 'kot_number') required final String kotNumber,
    @JsonKey(name: 'sale_id') final String? saleId,
    @JsonKey(name: 'table_id') final String? tableId,
    required final String status,
  }) = _$FireTabResponseModelImpl;

  factory _FireTabResponseModel.fromJson(Map<String, dynamic> json) =
      _$FireTabResponseModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'kot_number')
  String get kotNumber;
  @override
  @JsonKey(name: 'sale_id')
  String? get saleId;
  @override
  @JsonKey(name: 'table_id')
  String? get tableId;
  @override
  String get status;

  /// Create a copy of FireTabResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FireTabResponseModelImplCopyWith<_$FireTabResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
